//1024 seeds version(8 engines version)
module tf_gen_ctrl#(parameter MM_NUM=4, parameter SEED_NUM=1024, parameter ENGINE_NUM=4)( //seed bank depth is 8, 3-bit addr
input clk,
input rst_n,
input first,
input start,
output load, //output of reg
output vld, //output of reg
output reg en, //control sr tqc_change
output ren,
output wen,
//output en_mem,
output [7:0] addr_r,
output reg [7:0] addr_w,
output reg [1:0] sel_sr,
output reg sel_mm, //tqc_change
output done_row, //finish four rows
output reg done
);
localparam SEED_BANK_DEPTH = SEED_NUM / MM_NUM;// 1024/4=256 //one ctrl controls two sets of tf_engines(2*4=8 engines)
localparam CNT_RANGE = 5; //4+1
localparam TF_NUM_PER_ROW = 1024;
localparam ROW_CYCLE = SEED_NUM/ENGINE_NUM; // 1024/4=256, 

reg [3:0] cnt; //0~7: depends on cycle-num of mm (256/32=8)
reg [$clog2(SEED_BANK_DEPTH)-1:0] seed_cnt; //0~255: depends on seed bank depth (256)
reg cnt_en;
reg vld_r;
reg start_in; //start calculate one row of tf
reg start_dly1, start_dly2, start_dly3, start_dly4, start_dly5; //2 for load[0], 3 for load[1], 4 for load[2], 5 for load[3], 
wire done_tf; //finish calculate all tf
reg done_row_tf; //finish calculate one row of tf
reg [8:0] row_cycle_cnt;
reg [3:0] load_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin row_cycle_cnt <= 9'b0; end
    else if (start && first) begin row_cycle_cnt <= 9'b0; end
    else if (done_row_tf && row_cycle_cnt<=(ROW_CYCLE-1)) row_cycle_cnt <= row_cycle_cnt + 9'd1;
end

assign done_tf = (row_cycle_cnt==(ROW_CYCLE-1)) & vld_r & (seed_cnt==8'd0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin done <= 1'b0; end
    else begin done <= done_tf; end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin start_in <= 1'b0; end
    else if (start) begin start_in <= 1'b1; end
    else start_in <= 1'b0;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin start_dly1 <= 1'b0; start_dly2 <= 1'b0; start_dly3 <= 1'b0; load_r <= 4'b0; end
    else begin
        start_dly1 <= start_in;
        start_dly2 <= start_dly1;
        start_dly3 <= start_dly2;
        start_dly4 <= start_dly3;
        start_dly5 <= start_dly4;
        load_r[0] <= start_dly1;
        load_r[1] <= load_r[0];
        load_r[2] <= load_r[1];
        load_r[3] <= load_r[2];
    end
end
assign load = load_r[0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cnt_en <= 1'b0;
    else if (start_dly2) cnt_en <= 1'b1;
    else if (seed_cnt==(SEED_BANK_DEPTH-1) && cnt==(CNT_RANGE-1) || row_cycle_cnt==ROW_CYCLE) cnt_en <= 1'b0;
    else cnt_en <= cnt_en;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cnt <= 4'd0;
    else if (start_in) cnt <= 4'd0;
    else if (cnt_en) begin
        if (cnt<4'd4) cnt <= cnt + 4'd1;
        else cnt <= 4'd0;
    end
    else cnt <= cnt;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) seed_cnt <= 8'd0;
    else if (start_in) seed_cnt <= 8'd0;
    else if (cnt==(CNT_RANGE-1)) seed_cnt <= seed_cnt + 8'd1;
    else seed_cnt <= seed_cnt;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) vld_r <= 1'b0;
    else if (cnt==(CNT_RANGE-1)) vld_r <= 1'b1;
    else vld_r <= 1'b0;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) done_row_tf <= 1'b0;
    else if (seed_cnt==(SEED_BANK_DEPTH-1) && cnt==(CNT_RANGE-1)) done_row_tf <= 1'b1;
    else done_row_tf <= 1'b0;
end
assign done_row = done_row_tf;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) sel_mm <= 1'b1;
    else if (cnt==4'd0) sel_mm <= 1'b0;
    else sel_mm <= 1'b1;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) en <= 1'b0;
    else if (cnt_en & (cnt!=4'd8)) en <= 1'b1;
    else en <= 1'b0;
end
assign vld = vld_r;

assign wen = vld_r;
assign ren = start_dly1 | start_dly2 | (cnt==(CNT_RANGE-1) & seed_cnt!=(SEED_BANK_DEPTH-1));

//addr_r_mm(seed_cnt could be 1-cycle delay of addr_r); this is addr_r for MM
reg [7:0] addr_r_mm;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) addr_r_mm <= 8'd0;
    else if (start_in) addr_r_mm <= 8'd0;
    else if (cnt==(CNT_RANGE-2)) addr_r_mm <= addr_r_mm + 8'd1;
    else addr_r_mm <= addr_r_mm;
end

//addr_r_seed; this is addr_r for loading seed
reg [7:0] addr_r_seed;
//sel_sr update
localparam CYCLE_DONE_NUM=TF_NUM_PER_ROW/MM_NUM;// 1024/4=256; sel_sr need update after cal one row of tf
wire [7:0] cnt_done_tf; //equ to seed_cnt
assign cnt_done_tf = seed_cnt;
wire sel_sr_update_flag = (cnt_done_tf==(CYCLE_DONE_NUM-1)) & vld_r;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) sel_sr <= 2'd0;
    else if (start_in) sel_sr <= 2'd0;
    else if (sel_sr_update_flag) sel_sr <= sel_sr + 2'd1;
    else sel_sr <= sel_sr;
end

//addr_r_seed
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) addr_r_seed <= 8'd0;
    else if (start && first) addr_r_seed <= 8'd0; //top_start
    else if (sel_sr_update_flag || load_r[0]) addr_r_seed <= addr_r_seed + 8'd1;
    else addr_r_seed <= addr_r_seed;
end

assign addr_r = (start_dly1) ? addr_r_seed:addr_r_mm;

//addr_w is 1-cycle delay of seed_cnt
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) addr_w <= 8'd0;
    else if (start_in) addr_w <= 8'd0;
    else addr_w <= seed_cnt;
end

//assign en_mem = wen | ren;
endmodule
