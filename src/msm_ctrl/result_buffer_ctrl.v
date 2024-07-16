module result_buffer_ctrl#(parameter WIDTH_ID = 2, parameter WIDTH_DATA = 384, parameter P_NUM = 16)(//result_buffer ctrl
    input                                   clk             ,
    input                                   rst_n           ,
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  result_i        , //from msm
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  fifo_i          , //from fifo
    input                                   w_req           , //ask for write data to cash tqc???
    input                                   r_req           , //ask for read data from cash tqc???
    output                           [4:0]  fifo_r_addr     ,
    output                           [4:0]  fifo_w_addr     ,
    output                                  fifo_r_en       ,
    output                                  fifo_w_en       ,
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_o          , //output to msm or bucket
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  fifo_o          , //output to fifo
    output reg                              rb_status       , //0:empty, 1:full
    output     [WIDTH_ID-1:0]               rb_id            //
);
    integer i,j;
    reg [4:0] cnt_cash_num;//0~31
    reg [4:0] cnt_cash_w_addr;//0~31 cycle
    reg [4:0] cnt_cash_r_addr;//0~31 cycle
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_cash_num <= 0;
        //else if (w_req && r_req                     ) cnt_cash_num <= cnt_cash_num    ; //read and write happen at the same time
        else if (w_req && !r_req && cnt_cash_num<31 ) cnt_cash_num <= cnt_cash_num + 1; //assume depth is enough, never be full
        else if (r_req && !w_req && cnt_cash_num> 0 ) cnt_cash_num <= cnt_cash_num - 1;
    end
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_cash_w_addr <= 0;
        else if (w_req) cnt_cash_w_addr <= cnt_cash_w_addr + 1; //assume depth is enough, never be full
    end
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_cash_r_addr <= 0;
        else if (r_req) cnt_cash_r_addr <= cnt_cash_r_addr + 1; //assume depth is enough, never be full
    end
    assign fifo_r_addr = cnt_cash_r_addr;
    assign fifo_w_addr = cnt_cash_w_addr;
    assign fifo_r_en   = r_req          ;
    assign fifo_w_en   = w_req          ;
    assign fifo_o      = result_i       ;
    assign data_o      = fifo_i         ;
    //always @ (posedge clk or negedge rst_n) begin
    //    if (!rst_n) begin
    //        cash_poor[0] <= 0; cash_poor[1] <= 0;
    //        fifo_push <= 0; fifo_pop <= 0;
    //        data_o <= 0;
    //        fifo_o <= 0;
    //    end
    //    else if (w_req) begin
    //        if(cnt_cash_id==0)      cash_poor[0] <= result_i;
    //        else if(cnt_cash_id==1) cash_poor[1] <= result_i;
    //        else begin fifo_push <= 1; fifo_o <= result_i; end
    //    end
    //    else if(r_req) begin
    //        if(cnt_cash_id!=0) begin 
    //            cash_poor[0] <= cash_poor[1];
    //            cash_poor[1] <= fifo_i;
    //            fifo_pop <= 1;
    //            data_o <= cash_poor[0];
    //        end
    //    end
    //    else begin fifo_push <= 0; fifo_pop <= 0; data_o <= 0;end
    //end
    //assign rb_id = cash_poor[WIDTH_ID+WIDTH_DATA*3-1 -: WIDTH_ID];
    assign rb_id = fifo_i[WIDTH_ID+WIDTH_DATA*3-1 -: WIDTH_ID];
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) rb_status <= 0;
        else if (cnt_cash_num == 0) rb_status <= 0;
        else                        rb_status <= 1;
    end
endmodule
