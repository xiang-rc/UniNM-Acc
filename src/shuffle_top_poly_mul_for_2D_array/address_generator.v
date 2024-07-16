//date: 2024/05/11
module address_generator(
    input [8:0] k,//max = 511
    input [8:0] i,//max = 511
    input [3:0] p,//max = 9
    input [6:0] cnt_addr_gen,
    input ntt_flag,
    input rev,
    output wire [9:0] old_address_0,old_address_1,old_address_2,old_address_3,old_address_4,old_address_5,old_address_6,old_address_7
    );

    localparam BFU_NUM = 4; //tqc:for four BFUs version

    wire [9:0] J;
    wire [9:0] old_address_0_rev,old_address_1_rev,old_address_2_rev,old_address_3_rev,old_address_4_rev,old_address_5_rev,old_address_6_rev,old_address_7_rev;
    assign J = 1 << p;

    reg [9:0] old_address_1_reg;
    reg [9:0] old_address_2_reg, old_address_3_reg;
    reg [9:0] old_address_4_reg, old_address_5_reg, old_address_6_reg, old_address_7_reg;
    wire [9:0] old_address_0_tmp;
    wire [9:0] old_address_0_l2s; //for stage 1 and stage 0(the last 2 stages)
    assign old_address_0_l2s =  (((k << 1) << p) + i*BFU_NUM) * (4/J);

    //assign old_address_0_tmp = (J>=BFU_NUM) ? (((k << 1) << p) + i*BFU_NUM) : old_address_0_l2s;
    wire [9:0] old_address_0_tmp_INTT, old_address_0_tmp_NTT;
    assign old_address_0_tmp_INTT = cnt_addr_gen*BFU_NUM;
    assign  old_address_0_tmp_NTT = cnt_addr_gen << 3;  //(cnt_addr_gen << 1)*(1<<P) where p=0//tqc: read_addr for ntt is fixed! 2024/05/23
    assign old_address_0_tmp = (ntt_flag) ? old_address_0_tmp_INTT : old_address_0_tmp_NTT; //tqc: switch ntt_flag with intt!!!2024/05/09

    always@(*) // old_address_1_reg
    begin
      old_address_1_reg = (ntt_flag) ? old_address_0_tmp + 1 : old_address_0_tmp + 1;
    end
    always@(*) // old_address_2_reg
    begin
      old_address_2_reg = (ntt_flag) ? old_address_0_tmp + 2 : old_address_0_tmp + 2;
    end
    always@(*) // old_address_3_reg
    begin
      old_address_3_reg = (ntt_flag) ? old_address_0_tmp + 3 : old_address_0_tmp + 3;
    end

    always@(*) // old_address_4_reg
    begin
      case(ntt_flag)
      0: old_address_4_reg = old_address_0_tmp + 4;
      1: old_address_4_reg = {1'b1,old_address_0_tmp[8:0]};
      default: old_address_4_reg = 0;
      endcase
    end

    always@(*) // old_address_5_reg
    begin
      old_address_5_reg = (ntt_flag) ? old_address_4_reg + 1 : old_address_4_reg + 1;
    end
    always@(*) // old_address_6_reg
    begin
      old_address_6_reg = (ntt_flag) ? old_address_4_reg + 2 : old_address_4_reg + 2;
    end
    always@(*) // old_address_7_reg
    begin
      old_address_7_reg = (ntt_flag) ? old_address_4_reg + 3 : old_address_4_reg + 3;
    end

    bit_rev #(.data_width(10)) bit_rev_U0 (.s_i(old_address_0_tmp), .s_o(old_address_0_rev));
    bit_rev #(.data_width(10)) bit_rev_U1 (.s_i(old_address_1_reg), .s_o(old_address_1_rev));
    bit_rev #(.data_width(10)) bit_rev_U2 (.s_i(old_address_2_reg), .s_o(old_address_2_rev));
    bit_rev #(.data_width(10)) bit_rev_U3 (.s_i(old_address_3_reg), .s_o(old_address_3_rev));
    bit_rev #(.data_width(10)) bit_rev_U4 (.s_i(old_address_4_reg), .s_o(old_address_4_rev));
    bit_rev #(.data_width(10)) bit_rev_U5 (.s_i(old_address_5_reg), .s_o(old_address_5_rev));
    bit_rev #(.data_width(10)) bit_rev_U6 (.s_i(old_address_6_reg), .s_o(old_address_6_rev));
    bit_rev #(.data_width(10)) bit_rev_U7 (.s_i(old_address_7_reg), .s_o(old_address_7_rev));

    assign old_address_0 = (rev) ? old_address_0_rev : old_address_0_tmp; //mux for old_address_x and old_address_x_rev, used in intt and ntt
    assign old_address_1 = (rev) ? old_address_1_rev : old_address_1_reg;
    assign old_address_2 = (rev) ? old_address_2_rev : old_address_2_reg;
    assign old_address_3 = (rev) ? old_address_3_rev : old_address_3_reg;
    assign old_address_4 = (rev) ? old_address_4_rev : old_address_4_reg;
    assign old_address_5 = (rev) ? old_address_5_rev : old_address_5_reg;
    assign old_address_6 = (rev) ? old_address_6_rev : old_address_6_reg;
    assign old_address_7 = (rev) ? old_address_7_rev : old_address_7_reg;
endmodule
