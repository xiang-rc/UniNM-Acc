module tf_gen_top( //4 engines version; 2024/07/10
    input          clk         ,
    input          rst_n       ,
    input          start       ,
    input          wen         , //write data(seed) to seed_banks
    input          ren         , //read data(tf) in tf_banks
    input  [ 7:0]  addr_r      , //read data(tf) in tf_banks
    input  [ 7:0]  addr_w      , //write data(seed) to seed_banks
    input  [255:0] seed_i_0    ,
    input  [255:0] seed_i_1    ,
    input  [255:0] seed_i_2    ,
    input  [255:0] seed_i_3    ,
    input  [255:0] tf_i_0      ,
    input  [255:0] tf_i_1      ,
    input  [255:0] tf_i_2      ,
    input  [255:0] tf_i_3      ,
    input  [255:0] tf_i_4      ,
    input  [255:0] tf_i_5      ,
    input  [255:0] tf_i_6      ,
    input  [255:0] tf_i_7      ,
    input  [255:0] tf_i_8      ,
    input  [255:0] tf_i_9      ,
    input  [255:0] tf_i_a      ,
    input  [255:0] tf_i_b      ,
    input  [255:0] tf_i_c      ,
    input  [255:0] tf_i_d      ,
    input  [255:0] tf_i_e      ,
    input  [255:0] tf_i_f      ,
    output [  7:0] tf_bank_addr,
    output         tf_bank_web ,
    output         tf_bank_en  ,
    output [255:0] tf_r_0      ,
    output [255:0] tf_r_1      ,
    output [255:0] tf_r_2      ,
    output [255:0] tf_r_3      ,
    output [255:0] tf_r_4      ,
    output [255:0] tf_r_5      ,
    output [255:0] tf_r_6      ,
    output [255:0] tf_r_7      ,
    output [255:0] tf_r_8      ,
    output [255:0] tf_r_9      ,
    output [255:0] tf_r_a      ,
    output [255:0] tf_r_b      ,
    output [255:0] tf_r_c      ,
    output [255:0] tf_r_d      ,
    output [255:0] tf_r_e      ,
    output [255:0] tf_r_f      ,
    output [255:0] tf_o_0      ,
    output [255:0] tf_o_1      ,
    output [255:0] tf_o_2      ,
    output [255:0] tf_o_3      ,
    output [255:0] tf_o_4      ,
    output [255:0] tf_o_5      ,
    output [255:0] tf_o_6      ,
    output [255:0] tf_o_7      ,
    output [255:0] tf_o_8      ,
    output [255:0] tf_o_9      ,
    output [255:0] tf_o_a      ,
    output [255:0] tf_o_b      ,
    output [255:0] tf_o_c      ,
    output [255:0] tf_o_d      ,
    output [255:0] tf_o_e      ,
    output [255:0] tf_o_f      ,
    output         done_row    ,
    output         done        //
    );

    wire         load  ;
    wire         vld   ;
    wire         en    ;
    wire         ren_c   ;
    wire         wen_c   ;
    wire [7:0]   addr_r_c;
    wire [7:0]   addr_w_c;
    wire [1:0]   sel_sr;
    wire         sel_mm;
    wire [255:0] tf [15:0];
    wire         done_c;
    //wire         en_mem;

    wire [255:0] seed_in [3:0];
    assign seed_in[0] = seed_i_0;
    assign seed_in[1] = seed_i_1;
    assign seed_in[2] = seed_i_2;
    assign seed_in[3] = seed_i_3;
    wire [255:0] seed_o [3:0];

    reg [255:0] tf_r [15:0];
    integer h;
    always @(posedge clk) begin
        for (h=0; h<16; h=h+1) begin
            tf_r[h] <= tf[h];
        end
    end

    assign tf_r_0 = tf_r[0]  ;
    assign tf_r_1 = tf_r[1]  ;
    assign tf_r_2 = tf_r[2]  ;
    assign tf_r_3 = tf_r[3]  ;
    assign tf_r_4 = tf_r[4]  ;
    assign tf_r_5 = tf_r[5]  ;
    assign tf_r_6 = tf_r[6]  ;
    assign tf_r_7 = tf_r[7]  ;
    assign tf_r_8 = tf_r[8]  ;
    assign tf_r_9 = tf_r[9]  ;
    assign tf_r_a = tf_r[10] ;
    assign tf_r_b = tf_r[11] ;
    assign tf_r_c = tf_r[12] ;
    assign tf_r_d = tf_r[13] ;
    assign tf_r_e = tf_r[14] ;
    assign tf_r_f = tf_r[15] ;

    localparam M = 256'h 73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;
    reg  first;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) first <= 1'b1;
        else if (done_c) first <= 1'b1; //recover to '1' when calculation of all tf is done
        else if (start) first <= 1'b0;
    end
    wire done_row_c;
    tf_gen_ctrl ctrl_U0 (
        .clk      (clk   ),
        .rst_n    (rst_n ),
        .first    (first ),
        .start    (start ),
        .load     (load  ),
        .vld      (vld   ),
        .en       (en    ),
        .ren      (ren_c   ),
        .wen      (wen_c   ),
        .addr_r   (addr_r_c),
        .addr_w   (addr_w_c),
        .sel_sr   (sel_sr),
        .sel_mm   (sel_mm),
        .done_row (done_row_c),
        .done     (done_c  )
    );
    reg en_dly0, wen_c_dly0, done_row_dly, done_dly;
    reg [7:0] addr_r_c_dly, addr_w_c_dly0;
    reg [1:0] sel_sr_dly;
    always @(posedge clk) begin
        en_dly0       <= en       ;
        wen_c_dly0    <= wen_c    ;
        addr_w_c_dly0 <= addr_w_c ;
        sel_sr_dly   <= sel_sr   ;
        done_row_dly <= done_row_c ;
        done_dly     <= done_c     ;
    end
    assign done_row = done_row_dly;
    assign done = done_dly;

    wire [255:0] tf_o [15:0];

    assign tf_o[0]  = tf_i_0;
    assign tf_o[1]  = tf_i_1;
    assign tf_o[2]  = tf_i_2;
    assign tf_o[3]  = tf_i_3;
    assign tf_o[4]  = tf_i_4;
    assign tf_o[5]  = tf_i_5;
    assign tf_o[6]  = tf_i_6;
    assign tf_o[7]  = tf_i_7;
    assign tf_o[8]  = tf_i_8;
    assign tf_o[9]  = tf_i_9;
    assign tf_o[10] = tf_i_a;
    assign tf_o[11] = tf_i_b;
    assign tf_o[12] = tf_i_c;
    assign tf_o[13] = tf_i_d;
    assign tf_o[14] = tf_i_e;
    assign tf_o[15] = tf_i_f;

    assign tf_o_0  = tf_o[0];
    assign tf_o_1  = tf_o[1];
    assign tf_o_2  = tf_o[2];
    assign tf_o_3  = tf_o[3];
    assign tf_o_4  = tf_o[4];
    assign tf_o_5  = tf_o[5];
    assign tf_o_6  = tf_o[6];
    assign tf_o_7  = tf_o[7];
    assign tf_o_8  = tf_o[8];
    assign tf_o_9  = tf_o[9];
    assign tf_o_a  = tf_o[10];
    assign tf_o_b  = tf_o[11];
    assign tf_o_c  = tf_o[12];
    assign tf_o_d  = tf_o[13];
    assign tf_o_e  = tf_o[14];
    assign tf_o_f  = tf_o[15];

    reg wen_c_dly1, wen_c_dly2;
    reg [7:0] addr_w_c_dly1, addr_w_c_dly2;
    always @(posedge clk) begin
        wen_c_dly1 <= wen_c_dly0; wen_c_dly2 <= wen_c_dly1;
        addr_w_c_dly1 <= addr_w_c_dly0; addr_w_c_dly2 <= addr_w_c_dly1;
    end

    assign tf_bank_en = ~(ren | wen_c_dly1);
    assign tf_bank_web = (ren) ? ren : ~wen_c_dly1;
    assign tf_bank_addr = (ren) ? addr_r : addr_w_c_dly1;

    genvar i;
    generate for (i=0; i<4; i=i+1)
        begin: g_seed_bank
            data_bank_tf #(.addr_width(8), .data_width(256), .depth(256))
            seed_bank_U (.clk(clk), .A(addr_r_c), .D(seed_in[i]), .WEB(ren_c), .EN(~ren_c), .Q(seed_o[i])); //EN port low-active
        end
    endgenerate
    //genvar j;
    //generate for (j=0; j<16; j=j+1)
    //    begin: g_tf_bank
    //        data_bank_tf #(.addr_width(8), .data_width(256), .depth(256))
    //        tf_bank_U (.clk(clk), .A(tf_bank_addr), .D(tf_r[j]), .WEB(tf_bank_web), .EN(tf_bank_en), .Q(tf_o[j])); //EN port low-active
    //    end
    //endgenerate
    wire [1:0] sel_sr_engine [3:0];
    assign sel_sr_engine[0] = sel_sr;
    assign sel_sr_engine[1] = sel_sr + 2'd1;
    assign sel_sr_engine[2] = sel_sr + 2'd2;
    assign sel_sr_engine[3] = sel_sr + 2'd3;
    reg [255:0] seed_o_r [3:0];
    always @(posedge clk) begin
        seed_o_r[0] <= seed_o[0]; seed_o_r[1] <= seed_o[1]; seed_o_r[2] <= seed_o[2]; seed_o_r[3] <= seed_o[3];
    end
    reg [1:0] sel_sr_engine_dly0 [3:0];
    always @(posedge clk) begin
        sel_sr_engine_dly0[0] <= sel_sr_engine[0]; sel_sr_engine_dly0[1] <= sel_sr_engine[1];
        sel_sr_engine_dly0[2] <= sel_sr_engine[2]; sel_sr_engine_dly0[3] <= sel_sr_engine[3];
    end
    reg sel_mm_dly0 , sel_mm_dly1  ;
    reg load_dly0   , load_dly1    ;
    reg en_dly1      ;
    reg vld_dly0    , vld_dly1     ;
    always @(posedge clk) begin
        sel_mm_dly0 <= sel_mm; load_dly0 <= load;
        vld_dly0 <= vld;
        sel_mm_dly1 <= sel_mm_dly0; load_dly1 <= load_dly0;
        en_dly1 <= en_dly0; vld_dly1 <= vld_dly0;
    end
    genvar k;
    generate for (k=0; k<4; k=k+1)
        begin: g_engine0
            tf_gen_engine tf_engine_set_U0(
                .clk     (clk      ),
                .rst_n   (rst_n    ),
                .sel_sr  (sel_sr_engine_dly0[k]   ),
                .sel_mm  (sel_mm_dly0   ),
                .load    (load_dly0     ),
                .en      (en_dly0       ),
                .vld     (vld_dly0      ),
                .seed_i_a(seed_o_r[0]),
                .seed_i_b(seed_o_r[1]),
                .seed_i_c(seed_o_r[2]),
                .seed_i_d(seed_o_r[3]),
                .tf_a    (tf[k*4+0]),
                .tf_b    (tf[k*4+1]),
                .tf_c    (tf[k*4+2]),
                .tf_d    (tf[k*4+3])
            );
        end
    endgenerate

endmodule

module data_bank_tf
    #(parameter addr_width = 8,
                 data_width = 256,
                 depth = 256)
    (
    input clk,
    input [addr_width-1:0] A,//write/read address
    input [data_width-1:0] D,
    input WEB,
    input EN,
    output reg [data_width-1:0] Q
    );
    localparam INS_NUM = 2;
    reg [(data_width/INS_NUM)-1:0] d [INS_NUM-1:0];
    reg [(data_width/INS_NUM)-1:0] q [INS_NUM-1:0];

    integer i;
    always@(*) begin
      for (i=0; i<INS_NUM; i=i+1) begin
        d[i] <= D[i*128 +: 128];
        Q[i*128 +: 128] <= q[i];
      end
    end

    genvar j;
    generate for (j=0; j<INS_NUM; j=j+1)
      begin:g_mem_inst
        TS5N28HPCPHVTA256X128M2F u_mem
        (
          .A(A),
          .D(d[j]),
          .WEB(WEB),
          .CEB(EN),
          .CLK(clk),
          .Q(q[j])
        );
      end
    endgenerate
endmodule
