module bank_write_address_generator(
        input       clk         ,
        input       rst_n       ,
        input       ntt_flag    ,
        input [6:0] cnt_addr_gen,
        output[9:0] addr_w_0    ,
        output[9:0] addr_w_1    ,
        output[9:0] addr_w_2    ,
        output[9:0] addr_w_3    ,
        output[9:0] addr_w_4    ,
        output[9:0] addr_w_5    ,
        output[9:0] addr_w_6    ,
        output[9:0] addr_w_7    //
);
    localparam BFU_NUM = 4; //tqc:for four BFUs version
    wire [6:0] cnt_addr_gen_dly;

    shifter #(.data_width(7), .depth(11)) dff_n0(.clk(clk),.rst_n(rst_n),.din(cnt_addr_gen),.dout(cnt_addr_gen_dly));//depth control delay cycles, it should equal to latency of bf + 2(10 + 2)//0522

    reg [9:0] address_w_1_reg;
    reg [9:0] address_w_2_reg, address_w_3_reg;
    reg [9:0] address_w_4_reg, address_w_5_reg, address_w_6_reg, address_w_7_reg;

    wire [9:0] addr_w_0_tmp_INTT, addr_w_0_tmp_NTT;
    wire [9:0] addr_w_0_tmp;
    assign addr_w_0_tmp_NTT = cnt_addr_gen_dly*BFU_NUM;
    assign addr_w_0_tmp_INTT = cnt_addr_gen_dly << 3;
    assign addr_w_0_tmp = (ntt_flag) ? addr_w_0_tmp_INTT : addr_w_0_tmp_NTT;

    always@(*) // address_w_1_reg
    begin
      address_w_1_reg = (ntt_flag) ? addr_w_0_tmp + 1 : addr_w_0_tmp + 1;
    end
    always@(*) // address_w_2_reg
    begin
      address_w_2_reg = (ntt_flag) ? addr_w_0_tmp + 2 : addr_w_0_tmp + 2;
    end
    always@(*) // address_w_3_reg
    begin
      address_w_3_reg = (ntt_flag) ? addr_w_0_tmp + 3 : addr_w_0_tmp + 3;
    end

    always@(*) // address_w_4_reg
    begin
      case(!ntt_flag)
      0: address_w_4_reg = addr_w_0_tmp + 4;
      1: address_w_4_reg = {1'b1,addr_w_0_tmp[8:0]};
      default: address_w_4_reg = 0;
      endcase
    end

    always@(*) // address_w_5_reg
    begin
      address_w_5_reg = (ntt_flag) ? address_w_4_reg + 1 : address_w_4_reg + 1;
    end
    always@(*) // address_w_6_reg
    begin
      address_w_6_reg = (ntt_flag) ? address_w_4_reg + 2 : address_w_4_reg + 2;
    end
    always@(*) // address_w_7_reg
    begin
      address_w_7_reg = (ntt_flag) ? address_w_4_reg + 3 : address_w_4_reg + 3;
    end

    assign addr_w_0 = addr_w_0_tmp   ;
    assign addr_w_1 = address_w_1_reg;
    assign addr_w_2 = address_w_2_reg;
    assign addr_w_3 = address_w_3_reg;
    assign addr_w_4 = address_w_4_reg;
    assign addr_w_5 = address_w_5_reg;
    assign addr_w_6 = address_w_6_reg;
    assign addr_w_7 = address_w_7_reg;
endmodule
