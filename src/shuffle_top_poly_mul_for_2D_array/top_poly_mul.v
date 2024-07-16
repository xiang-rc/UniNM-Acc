//date: 2024/07/10 384bit,support ntt intt pwm msm function, store tf in ram
module top_poly_mul
    #(parameter addr_rom_width = 9,
                addr_width = 9,
                data_width = 256)
   (
    input clk,rst_n,start,
    input load, //for loading data from dram
    input stor, //for storing data to   dram
    input [2:0] conf,
    input [data_width-1:0] d_in,
    input [data_width-1:0] tf_in_0,
    input [data_width-1:0] tf_in_1,
    input [data_width-1:0] tf_in_2,
    input [data_width-1:0] tf_in_3,
    input [data_width-1:0] bf_0_upper,//input from bf_array
    input [data_width-1:0] bf_1_upper,
    input [data_width-1:0] bf_2_upper,
    input [data_width-1:0] bf_3_upper,
    input [data_width-1:0] bf_0_lower,
    input [data_width-1:0] bf_1_lower,
    input [data_width-1:0] bf_2_lower,
    input [data_width-1:0] bf_3_lower,
    input [data_width*4-1:0] q_0  ,//from bank
    input [data_width*4-1:0] q_1  ,//from bank
    input [data_width*4-1:0] q_2  ,//from bank
    input [data_width*4-1:0] q_3  ,//from bank
    input [data_width*4-1:0] q_4  ,//from bank
    input [data_width*4-1:0] q_5  ,//from bank
    input [data_width*4-1:0] q_6  ,//from bank
    input [data_width*4-1:0] q_7  ,//from bank
    input [data_width-1:0] w_0, //from tf_ram_group
    input [data_width-1:0] w_1, //from tf_ram_group
    input [data_width-1:0] w_2, //from tf_ram_group
    input [data_width-1:0] w_3, //from tf_ram_group
    output wire [3:0] done_flag,
    output reg [data_width-1:0] d_out,
    output reg load_done,
    output reg stor_done,
    output done,
    output                  sel  ,//output to bf_array
    output [data_width-1:0] a_i0 ,
    output [data_width-1:0] a_i1 ,
    output [data_width-1:0] a_i2 ,
    output [data_width-1:0] a_i3 ,
    output [data_width-1:0] b_i0 ,
    output [data_width-1:0] b_i1 ,
    output [data_width-1:0] b_i2 ,
    output [data_width-1:0] b_i3 ,
    output [       256-1:0] w_in0,
    output [       256-1:0] w_in1,
    output [       256-1:0] w_in2,
    output [       256-1:0] w_in3,
    output [         7*4-1:0] addr_0  ,//to bank
    output [         7*4-1:0] addr_1  ,//to bank
    output [         7*4-1:0] addr_2  ,//to bank
    output [         7*4-1:0] addr_3  ,//to bank
    output [         7*4-1:0] addr_4  ,//to bank
    output [         7*4-1:0] addr_5  ,//to bank
    output [         7*4-1:0] addr_6  ,//to bank
    output [         7*4-1:0] addr_7  ,//to bank
    output [data_width*4-1:0] data_o_0,//to bank
    output [data_width*4-1:0] data_o_1,//to bank
    output [data_width*4-1:0] data_o_2,//to bank
    output [data_width*4-1:0] data_o_3,//to bank
    output [data_width*4-1:0] data_o_4,//to bank
    output [data_width*4-1:0] data_o_5,//to bank
    output [data_width*4-1:0] data_o_6,//to bank
    output [data_width*4-1:0] data_o_7,//to bank
    output [           4-1:0] w_en_0  ,//to bank
    output [           4-1:0] w_en_1  ,//to bank
    output [           4-1:0] w_en_2  ,//to bank
    output [           4-1:0] w_en_3  ,//to bank
    output [           4-1:0] w_en_4  ,//to bank
    output [           4-1:0] w_en_5  ,//to bank
    output [           4-1:0] w_en_6  ,//to bank
    output [           4-1:0] w_en_7  ,//to bank
    output [           4-1:0] en_0    ,//to bank
    output [           4-1:0] en_1    ,//to bank
    output [           4-1:0] en_2    ,//to bank
    output [           4-1:0] en_3    ,//to bank
    output [           4-1:0] en_4    ,//to bank
    output [           4-1:0] en_5    ,//to bank
    output [           4-1:0] en_6    ,//to bank
    output [           4-1:0] en_7    ,//to bank
    output [addr_rom_width-1:0] tf_address_0, //to tf_ram_group
    output [addr_rom_width-1:0] tf_address_1, //to tf_ram_group
    output [addr_rom_width-1:0] tf_address_2, //to tf_ram_group
    output [addr_rom_width-1:0] tf_address_3, //to tf_ram_group
    output                               ren,  //to tf_ram_group
    output [9:0]                ntt_load_addr,
    output                      ntt_load_en  ,
    output                      ntt_load_wen  //
    );

    localparam M = 256'h 73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;
    localparam M_half = (M+256'd1)>>1;

    //fsm port signal
    wire [8:0] k;
    wire [8:0] i;
    wire [3:0] p;
    //wire sel;
    wire wen,wen_a,ren_a,wen_b,ren_b,en,en_tf_rom;
    wire ntt_flag;
    wire [6:0] cnt_addr_gen;
    wire a_flag_neg;
    wire a_flag_neg_dly;

    //address_generator port signal
    wire [9:0] old_address_0,old_address_1,old_address_2,old_address_3,old_address_4,old_address_5,old_address_6,old_address_7;
    wire [9:0] old_address_0_rev,old_address_1_rev,old_address_2_rev,old_address_3_rev,old_address_4_rev,old_address_5_rev,old_address_6_rev,old_address_7_rev;

    //w_address_generator port signal
    wire [9:0] addr_w_0,addr_w_1,addr_w_2,addr_w_3,addr_w_4,addr_w_5,addr_w_6,addr_w_7;

    //memory map port signal --- map_address
    wire [9:0] map_old_address_0,map_old_address_1,map_old_address_2,map_old_address_3,map_old_address_4,map_old_address_5,map_old_address_6,map_old_address_7;
    wire [6:0] map_address_0,map_address_1,map_address_2,map_address_3,map_address_4,map_address_5,map_address_6,map_address_7;
    //memory map port signal --- bank_number
    wire [2:0] a0,a1,a2,a3,a4,a5,a6,a7;

    wire cros, cros_delay0, cros_delay1;

    //network_bank_addr_in signal --- new_address
    wire [6:0] new_address_0,new_address_1,new_address_2,new_address_3,new_address_4,new_address_5,new_address_6,new_address_7;

    wire [6:0] w_address_0,w_address_1,w_address_2,w_address_3,w_address_4,w_address_5,w_address_6,w_address_7;

    //arbiter port signal
    wire [2:0] sel_a_0,sel_a_1,sel_a_2,sel_a_3,sel_a_4,sel_a_5,sel_a_6,sel_a_7;

    //data from bank
    wire [data_width-1:0] q_a_0,q_a_1,q_a_2,q_a_3,q_a_4,q_a_5,q_a_6,q_a_7;
    wire [data_width-1:0] q_b_0,q_b_1,q_b_2,q_b_3,q_b_4,q_b_5,q_b_6,q_b_7;
    //output of mux_data
    wire [data_width-1:0] q0,q1,q2,q3,q4,q5,q6,q7;

    //data for bfu
    wire [data_width-1:0] u0,v0,u1,v1,u2,v2,u3,v3;
    //data from bfu
    //wire [data_width-1:0] bf_0_upper,bf_0_lower,bf_1_upper,bf_1_lower,bf_2_upper,bf_2_lower,bf_3_upper,bf_3_lower;

    //data for bank
    wire [data_width-1:0] d0,d1,d2,d3,d4,d5,d6,d7;

    //twiddle factor from ROM
    wire [data_width-1:0] w_p_0; //w_p is w after processing
    wire [data_width-1:0] w_p_1;
    wire [data_width-1:0] w_p_2;
    wire [data_width-1:0] w_p_3;

    //tf address for ROM
    //wire [addr_rom_width-1:0] tf_address_0;
    //wire [addr_rom_width-1:0] tf_address_1;
    //wire [addr_rom_width-1:0] tf_address_2;
    //wire [addr_rom_width-1:0] tf_address_3;

    wire proc_flag_0,proc_flag_1,proc_flag_2,proc_flag_3;

    wire wen_a_r, wen_b_r;

  fsm fsm_U0 (.clk(clk),
      .rst_n(rst_n),
      .conf(conf),
      .start(start),
      .sel(sel),
      .k(k),
      .i(i),
      .p(p),
      .wen(wen),
      .ren(ren),
      .wen_a(wen_a),
      .wen_b(wen_b),
      .ren_a(ren_a),
      .ren_b(ren_b),
      .en(en),
      .ntt_flag(ntt_flag),
      .cnt_addr_gen_o(cnt_addr_gen),
      .a_flag_neg_o(a_flag_neg),
      .done_flag(done_flag),
      .done(done));

  address_generator address_generator_U1(
          .k(k),
          .i(i),
          .p(p),
          .cnt_addr_gen(cnt_addr_gen),
          .ntt_flag(ntt_flag),
          .old_address_0(old_address_0),
          .old_address_1(old_address_1),
          .old_address_2(old_address_2),
          .old_address_3(old_address_3),
          .old_address_4(old_address_4),
          .old_address_5(old_address_5),
          .old_address_6(old_address_6),
          .old_address_7(old_address_7)  );
//mux for old_address_x and old_address_x_rev, old_address_x used in intt and ntt, old_address_x_rev used in pwm
          //assign map_old_address_0 = (conf == 3'd 2) ? old_address_0_rev : old_address_0; //rev_flag:tqc!!!
          //assign map_old_address_1 = (conf == 3'd 2) ? old_address_1_rev : old_address_1; //rev_flag:tqc!!!
          //assign map_old_address_2 = (conf == 3'd 2) ? old_address_2_rev : old_address_2; //rev_flag:tqc!!!
          //assign map_old_address_3 = (conf == 3'd 2) ? old_address_3_rev : old_address_3; //rev_flag:tqc!!!
          //assign map_old_address_4 = (conf == 3'd 2) ? old_address_4_rev : old_address_4; //rev_flag:tqc!!!
          //assign map_old_address_5 = (conf == 3'd 2) ? old_address_5_rev : old_address_5; //rev_flag:tqc!!!
          //assign map_old_address_6 = (conf == 3'd 2) ? old_address_6_rev : old_address_6; //rev_flag:tqc!!!
          //assign map_old_address_7 = (conf == 3'd 2) ? old_address_7_rev : old_address_7; //rev_flag:tqc!!!

   conflict_free_memory_map conflict_free_memory_map_U0(
              .clk(clk),
              .rst_n(rst_n),
              .old_address_0(old_address_0),
              .old_address_1(old_address_1),
              .old_address_2(old_address_2),
              .old_address_3(old_address_3),
              .old_address_4(old_address_4),
              .old_address_5(old_address_5),
              .old_address_6(old_address_6),
              .old_address_7(old_address_7),
              .new_address_0(map_address_0),
              .new_address_1(map_address_1),
              .new_address_2(map_address_2),
              .new_address_3(map_address_3),
              .new_address_4(map_address_4),
              .new_address_5(map_address_5),
              .new_address_6(map_address_6),
              .new_address_7(map_address_7),
              .bank_number_0(a0),
              .bank_number_1(a1),
              .bank_number_2(a2),
              .bank_number_3(a3),
              .bank_number_4(a4),
              .bank_number_5(a5),
              .bank_number_6(a6),
              .bank_number_7(a7),
              .cros(cros)
              );

  arbiter arbiter_U3(
              .a0(a0),.a1(a1),.a2(a2),.a3(a3),.a4(a4),.a5(a5),.a6(a6),.a7(a7),
              .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),.sel_a_2(sel_a_2),.sel_a_3(sel_a_3),.sel_a_4(sel_a_4),.sel_a_5(sel_a_5),.sel_a_6(sel_a_6),.sel_a_7(sel_a_7));

  network_bank_addr_in  #(.addr_width(7)) network_bank_addr_in_U4(
                 .b0(map_address_0),
                 .b1(map_address_1),
                 .b2(map_address_2),
                 .b3(map_address_3),
                 .b4(map_address_4),
                 .b5(map_address_5),
                 .b6(map_address_6),
                 .b7(map_address_7),
                 .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),.sel_a_2(sel_a_2),.sel_a_3(sel_a_3),.sel_a_4(sel_a_4),.sel_a_5(sel_a_5),.sel_a_6(sel_a_6),.sel_a_7(sel_a_7),
                 .new_address_0(new_address_0),
                 .new_address_1(new_address_1),
                 .new_address_2(new_address_2),
                 .new_address_3(new_address_3),
                 .new_address_4(new_address_4),
                 .new_address_5(new_address_5),
                 .new_address_6(new_address_6),
                 .new_address_7(new_address_7));
   wire [6:0] r_address_0, r_address_1, r_address_2, r_address_3, r_address_4, r_address_5, r_address_6, r_address_7;
   assign r_address_0 = new_address_0; //ntt or intt mode : pwm mode tqc
   assign r_address_1 = new_address_1; //ntt or intt mode : pwm mode
   assign r_address_2 = new_address_2; //ntt or intt mode : pwm mode
   assign r_address_3 = new_address_3; //ntt or intt mode : pwm mode
   assign r_address_4 = new_address_4; //ntt or intt mode : pwm mode
   assign r_address_5 = new_address_5; //ntt or intt mode : pwm mode
   assign r_address_6 = new_address_6; //ntt or intt mode : pwm mode
   assign r_address_7 = new_address_7; //ntt or intt mode : pwm mode

   wire [6:0] w_address_INTT;
   shifter #(.data_width(1), .depth( 1)) dff_n8(.clk(clk),.rst_n(rst_n),.din(cros       ),.dout(cros_delay0)); // 1 cycles delay for readout signal from bank
   shifter #(.data_width(1), .depth(10)) dff_n9(.clk(clk),.rst_n(rst_n),.din(cros_delay0),.dout(cros_delay1)); //depth control delay cycles, it should equal to latency of bf (10)
   shifter #(.data_width(7), .depth(12)) dff_n0(.clk(clk),.rst_n(rst_n),.din(cnt_addr_gen),.dout(w_address_INTT));//depth control delay cycles, it should equal to latency of bf + 2+1(10 + 2+1)//0522
   shifter #(.data_width(1), .depth( 2)) dff_n1(.clk(clk),.rst_n(rst_n),.din(a_flag_neg),.dout(a_flag_neg_dly)); //2cycles delay

   shifter #(.data_width(1), .depth(11)) dff_n2(.clk(clk),.rst_n(rst_n),.din(wen_a),.dout(wen_a_r)); //it should equal to latency of bf+1 (10+1)
   shifter #(.data_width(1), .depth(11)) dff_n(.clk(clk),.rst_n(rst_n),.din(wen_b),.dout(wen_b_r)); //it should equal to latency of bf+1 (10+1)

   bank_write_address_generator w_addr_gen ( //ntt and intt have diff read regulation
        .clk         (clk         ),
        .rst_n       (rst_n       ),
        .ntt_flag    (ntt_flag    ),
        .cnt_addr_gen(cnt_addr_gen),
        .addr_w_0    (addr_w_0    ),
        .addr_w_1    (addr_w_1    ),
        .addr_w_2    (addr_w_2    ),
        .addr_w_3    (addr_w_3    ),
        .addr_w_4    (addr_w_4    ),
        .addr_w_5    (addr_w_5    ),
        .addr_w_6    (addr_w_6    ),
        .addr_w_7    (addr_w_7    ));

    //memory map U1 port signal --- map_address
    wire [6:0] map_addr_w_0,map_addr_w_1,map_addr_w_2,map_addr_w_3,map_addr_w_4,map_addr_w_5,map_addr_w_6,map_addr_w_7;
    //memory map port signal --- bank_number
    wire [2:0] addr_w_a0,addr_w_a1,addr_w_a2,addr_w_a3,addr_w_a4,addr_w_a5,addr_w_a6,addr_w_a7;
    wire cros_addr_w;
    //arbiter port signal
    wire [2:0] addr_w_sel_a_0,addr_w_sel_a_1,addr_w_sel_a_2,addr_w_sel_a_3,addr_w_sel_a_4,addr_w_sel_a_5,addr_w_sel_a_6,addr_w_sel_a_7;
    wire [6:0] w_address_NTT_0;
    wire [6:0] w_address_NTT_1;
    wire [6:0] w_address_NTT_2;
    wire [6:0] w_address_NTT_3;
    wire [6:0] w_address_NTT_4;
    wire [6:0] w_address_NTT_5;
    wire [6:0] w_address_NTT_6;
    wire [6:0] w_address_NTT_7;
    conflict_free_memory_map conflict_free_memory_map_U1(
                .clk(clk),
                .rst_n(rst_n),
                .old_address_0(addr_w_0),
                .old_address_1(addr_w_1),
                .old_address_2(addr_w_2),
                .old_address_3(addr_w_3),
                .old_address_4(addr_w_4),
                .old_address_5(addr_w_5),
                .old_address_6(addr_w_6),
                .old_address_7(addr_w_7),
                .new_address_0(map_addr_w_0),
                .new_address_1(map_addr_w_1),
                .new_address_2(map_addr_w_2),
                .new_address_3(map_addr_w_3),
                .new_address_4(map_addr_w_4),
                .new_address_5(map_addr_w_5),
                .new_address_6(map_addr_w_6),
                .new_address_7(map_addr_w_7),
                .bank_number_0(addr_w_a0),
                .bank_number_1(addr_w_a1),
                .bank_number_2(addr_w_a2),
                .bank_number_3(addr_w_a3),
                .bank_number_4(addr_w_a4),
                .bank_number_5(addr_w_a5),
                .bank_number_6(addr_w_a6),
                .bank_number_7(addr_w_a7),
                .cros(cros_addr_w) //float
                );

    arbiter arbiter_U4(
                .a0(addr_w_a0),.a1(addr_w_a1),.a2(addr_w_a2),.a3(addr_w_a3),.a4(addr_w_a4),.a5(addr_w_a5),.a6(addr_w_a6),.a7(addr_w_a7),
                .sel_a_0(addr_w_sel_a_0),.sel_a_1(addr_w_sel_a_1),
                .sel_a_2(addr_w_sel_a_2),.sel_a_3(addr_w_sel_a_3),
                .sel_a_4(addr_w_sel_a_4),.sel_a_5(addr_w_sel_a_5),
                .sel_a_6(addr_w_sel_a_6),.sel_a_7(addr_w_sel_a_7));

    network_bank_addr_in  #(.addr_width(7)) network_bank_addr_in_U5(
                   .b0(map_addr_w_0),
                   .b1(map_addr_w_1),
                   .b2(map_addr_w_2),
                   .b3(map_addr_w_3),
                   .b4(map_addr_w_4),
                   .b5(map_addr_w_5),
                   .b6(map_addr_w_6),
                   .b7(map_addr_w_7),
                   .sel_a_0(addr_w_sel_a_0),.sel_a_1(addr_w_sel_a_1),
                   .sel_a_2(addr_w_sel_a_2),.sel_a_3(addr_w_sel_a_3),
                   .sel_a_4(addr_w_sel_a_4),.sel_a_5(addr_w_sel_a_5),
                   .sel_a_6(addr_w_sel_a_6),.sel_a_7(addr_w_sel_a_7),
                   .new_address_0(w_address_NTT_0),
                   .new_address_1(w_address_NTT_1),
                   .new_address_2(w_address_NTT_2),
                   .new_address_3(w_address_NTT_3),
                   .new_address_4(w_address_NTT_4),
                   .new_address_5(w_address_NTT_5),
                   .new_address_6(w_address_NTT_6),
                   .new_address_7(w_address_NTT_7));
assign w_address_0 = (ntt_flag) ? w_address_INTT: w_address_NTT_0;  //ntt and intt have diff write regulation
assign w_address_1 = (ntt_flag) ? w_address_INTT: w_address_NTT_1;
assign w_address_2 = (ntt_flag) ? w_address_INTT: w_address_NTT_2;
assign w_address_3 = (ntt_flag) ? w_address_INTT: w_address_NTT_3;
assign w_address_4 = (ntt_flag) ? w_address_INTT: w_address_NTT_4;
assign w_address_5 = (ntt_flag) ? w_address_INTT: w_address_NTT_5;
assign w_address_6 = (ntt_flag) ? w_address_INTT: w_address_NTT_6;
assign w_address_7 = (ntt_flag) ? w_address_INTT: w_address_NTT_7;

////////////////mux for PWM mode ///////////////////////////////////////////////////////////////////////////////////////////////////
wire [data_width-1:0] d_2_bf0, d_2_bf1, d_2_bf2, d_2_bf3;
//wire [data_width-1:0] a_i0, a_i1, a_i2, a_i3;
//wire [data_width-1:0] b_i0, b_i1, b_i2, b_i3;
reg  [7:0] cnt_pwm_addr; //tqc:tbd useless?
reg  pwm_en;
always @(posedge clk or negedge rst_n) begin
     if (!rst_n) pwm_en <= 1'b 0;
     else if (start && (conf == 3'd 2)) pwm_en <= 1'b 1;
     else if (cnt_pwm_addr == 8'd 255)  pwm_en <= 1'b 0;
end
always @(posedge clk or negedge rst_n) begin
     if (!rst_n) cnt_pwm_addr <= 8'd 0;
     else if (start && (conf == 3'd 2)) cnt_pwm_addr <= 8'd 0;
     else if (pwm_en) cnt_pwm_addr <= cnt_pwm_addr + 8'd 1;
end
assign a_i0 = (conf == 3'd 2) ? d_2_bf0 : u0; // mux for PWM mode, data from bank when PWM
assign a_i1 = (conf == 3'd 2) ? d_2_bf1 : u1; // mux for PWM mode, data from bank when PWM
assign a_i2 = (conf == 3'd 2) ? d_2_bf2 : u2; // mux for PWM mode, data from bank when PWM
assign a_i3 = (conf == 3'd 2) ? d_2_bf3 : u3; // mux for PWM mode, data from bank when PWM
assign b_i0 = (conf == 3'd 2) ? 0 : v0;       // mux for PWM mode, 0 when PWN
assign b_i1 = (conf == 3'd 2) ? 0 : v1;       // mux for PWM mode, 0 when PWN
assign b_i2 = (conf == 3'd 2) ? 0 : v2;       // mux for PWM mode, 0 when PWN
assign b_i3 = (conf == 3'd 2) ? 0 : v3;       // mux for PWM mode, 0 when PWN
assign d_2_bf0 = (cnt_pwm_addr[7]) ? q_a_0: q_a_4;
assign d_2_bf1 = (cnt_pwm_addr[7]) ? q_a_1: q_a_5;
assign d_2_bf2 = (cnt_pwm_addr[7]) ? q_a_2: q_a_6;
assign d_2_bf3 = (cnt_pwm_addr[7]) ? q_a_3: q_a_7;
////////////////////////////bank set switch logic////////////////////////////////////////////////////////////////////////////////////
    reg bank_set_sel_flag; //0: use bank 2 and bank 3;  1: use bank 0 and bank 1
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) bank_set_sel_flag <= 1'b 0;
        else if (start && conf != 3'd 2) bank_set_sel_flag <= ~bank_set_sel_flag;
    end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //load signal part
    reg load_en;
    reg load_flag; //load_flag=1: load ban0; load_flag=0: load bank2
    reg [9:0] cnt_load; //0~1023
    reg [6:0] load_addr_0, load_addr_1, load_addr_2, load_addr_3, load_addr_4, load_addr_5, load_addr_6, load_addr_7;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) load_en <= 1'b 0;
        else if (load) load_en <= 1'b 1;
        else if (cnt_load == 1023) load_en <= 1'b 0;
    end
    assign ntt_load_addr = cnt_load;
    assign ntt_load_en  = load_en;
    assign ntt_load_wen = load_en;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) load_flag <= 1'b 0;
        else if (load) load_flag <= ~load_flag;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) cnt_load <= 10'd 0;
        else if(load) cnt_load <= 10'd 0;
        else if(load_en) cnt_load <= cnt_load + 10'd 1;
    end
    always @(*)begin
        load_addr_0 = 7'd 0; load_addr_1 = 7'd 0; load_addr_2 = 7'd 0; load_addr_3 = 7'd 0;
        load_addr_4 = 7'd 0; load_addr_5 = 7'd 0; load_addr_6 = 7'd 0; load_addr_7 = 7'd 0;
        case(cnt_load[9:7])
            3'd 0:  begin load_addr_0 = cnt_load[6:0];end
            3'd 1:  begin load_addr_1 = cnt_load[6:0];end
            3'd 2:  begin load_addr_2 = cnt_load[6:0];end
            3'd 3:  begin load_addr_3 = cnt_load[6:0];end
            3'd 4:  begin load_addr_4 = cnt_load[6:0];end
            3'd 5:  begin load_addr_5 = cnt_load[6:0];end
            3'd 6:  begin load_addr_6 = cnt_load[6:0];end
            3'd 7:  begin load_addr_7 = cnt_load[6:0];end
            default:begin load_addr_0 = 7'd 0; load_addr_1 = 7'd 0; load_addr_2 = 7'd 0; load_addr_3 = 7'd 0;
                          load_addr_4 = 7'd 0; load_addr_5 = 7'd 0; load_addr_6 = 7'd 0; load_addr_7 = 7'd 0; end
        endcase
    end
    wire [6:0] w_addr0_0, w_addr0_1, w_addr0_2, w_addr0_3, w_addr0_4, w_addr0_5, w_addr0_6, w_addr0_7;
    wire [6:0] w_addr2_0, w_addr2_1, w_addr2_2, w_addr2_3, w_addr2_4, w_addr2_5, w_addr2_6, w_addr2_7;
    assign w_addr0_0 = (load_en) ? load_addr_0 : w_address_0;
    assign w_addr0_1 = (load_en) ? load_addr_1 : w_address_1;
    assign w_addr0_2 = (load_en) ? load_addr_2 : w_address_2;
    assign w_addr0_3 = (load_en) ? load_addr_3 : w_address_3;
    assign w_addr0_4 = (load_en) ? load_addr_4 : w_address_4;
    assign w_addr0_5 = (load_en) ? load_addr_5 : w_address_5;
    assign w_addr0_6 = (load_en) ? load_addr_6 : w_address_6;
    assign w_addr0_7 = (load_en) ? load_addr_7 : w_address_7;
    assign w_addr2_0 = (load_en) ? load_addr_0 : w_address_0;
    assign w_addr2_1 = (load_en) ? load_addr_1 : w_address_1;
    assign w_addr2_2 = (load_en) ? load_addr_2 : w_address_2;
    assign w_addr2_3 = (load_en) ? load_addr_3 : w_address_3;
    assign w_addr2_4 = (load_en) ? load_addr_4 : w_address_4;
    assign w_addr2_5 = (load_en) ? load_addr_5 : w_address_5;
    assign w_addr2_6 = (load_en) ? load_addr_6 : w_address_6;
    assign w_addr2_7 = (load_en) ? load_addr_7 : w_address_7;

    wire [255:0] data0_0,data0_1,data0_2,data0_3,data0_4,data0_5,data0_6,data0_7;
    wire [255:0] data2_0,data2_1,data2_2,data2_3,data2_4,data2_5,data2_6,data2_7;
    assign data0_0 = (load_en) ? d_in : d0;
    assign data0_1 = (load_en) ? d_in : d1;
    assign data0_2 = (load_en) ? d_in : d2;
    assign data0_3 = (load_en) ? d_in : d3;
    assign data0_4 = (load_en) ? d_in : d4;
    assign data0_5 = (load_en) ? d_in : d5;
    assign data0_6 = (load_en) ? d_in : d6;
    assign data0_7 = (load_en) ? d_in : d7;
    assign data2_0 = (load_en) ? d_in : d0;
    assign data2_1 = (load_en) ? d_in : d1;
    assign data2_2 = (load_en) ? d_in : d2;
    assign data2_3 = (load_en) ? d_in : d3;
    assign data2_4 = (load_en) ? d_in : d4;
    assign data2_5 = (load_en) ? d_in : d5;
    assign data2_6 = (load_en) ? d_in : d6;
    assign data2_7 = (load_en) ? d_in : d7;

    wire [7:0] w_en0, w_en2;
    reg [7:0] w_en_load;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) w_en_load <= 8'd 1;
        else if(load) w_en_load <= 8'd 1;
        else if(cnt_load[6:0] == 7'd 127) w_en_load <= {w_en_load[5:0],w_en_load[6]};
    end
    genvar i_g;
    generate for (i_g = 0; i_g <= 7; i_g = i_g+1) begin:gen_w_en0
        assign w_en0[i_g] = (load_en &&  load_flag) ? w_en_load[i_g] : (wen_a &  bank_set_sel_flag);
        assign w_en2[i_g] = (load_en && !load_flag) ? w_en_load[i_g] : (wen_a & ~bank_set_sel_flag);
    end
    endgenerate
    wire w_en1, w_en3;
    assign w_en1 = wen_b &  bank_set_sel_flag;
    assign w_en3 = wen_b & ~bank_set_sel_flag;

    wire en0, en2;
    assign en0 = load_en | en;
    assign en2 = load_en | en;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) load_done <= 1'b 0;
        else if(cnt_load == 10'd 1023) load_done <= 1'b 1;
        else load_done <= 1'b 0;
    end

    //store signal part
    reg stor_en;
    reg stor_flag; //stor_flag=1: store from bank1; stor_flag=0: store from bank3
    reg [9:0] cnt_stor; //0~1023
    reg [6:0] stor_addr_0, stor_addr_1, stor_addr_2, stor_addr_3, stor_addr_4, stor_addr_5, stor_addr_6, stor_addr_7;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) stor_en <= 1'b 0;
        else if (stor) stor_en <= 1'b 1;
        else if (cnt_stor == 1023) stor_en <= 1'b 0;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) stor_flag <= 1'b 0;
        else if (stor) stor_flag <= ~stor_flag;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) cnt_stor <= 10'd 0;
        else if(stor) cnt_stor <= 10'd 0;
        else if(stor_en) cnt_stor <= cnt_stor + 10'd 1;
    end
    always @(*)begin
        stor_addr_0 = 7'd 0; stor_addr_1 = 7'd 0; stor_addr_2 = 7'd 0; stor_addr_3 = 7'd 0;
        stor_addr_4 = 7'd 0; stor_addr_5 = 7'd 0; stor_addr_6 = 7'd 0; stor_addr_7 = 7'd 0;
        case(cnt_stor[9:7])
            3'd 0:  begin stor_addr_0 = cnt_stor[6:0];end
            3'd 1:  begin stor_addr_1 = cnt_stor[6:0];end
            3'd 2:  begin stor_addr_2 = cnt_stor[6:0];end
            3'd 3:  begin stor_addr_3 = cnt_stor[6:0];end
            3'd 4:  begin stor_addr_4 = cnt_stor[6:0];end
            3'd 5:  begin stor_addr_5 = cnt_stor[6:0];end
            3'd 6:  begin stor_addr_6 = cnt_stor[6:0];end
            3'd 7:  begin stor_addr_7 = cnt_stor[6:0];end
            default:begin stor_addr_0 = 7'd 0; stor_addr_1 = 7'd 0; stor_addr_2 = 7'd 0; stor_addr_3 = 7'd 0;
                          stor_addr_4 = 7'd 0; stor_addr_5 = 7'd 0; stor_addr_6 = 7'd 0; stor_addr_7 = 7'd 0; end
        endcase
    end
    wire [6:0] r_addr1_0, r_addr1_1, r_addr1_2, r_addr1_3, r_addr1_4, r_addr1_5, r_addr1_6, r_addr1_7;
    wire [6:0] r_addr3_0, r_addr3_1, r_addr3_2, r_addr3_3, r_addr3_4, r_addr3_5, r_addr3_6, r_addr3_7;
    assign r_addr1_0 = (stor_en) ? stor_addr_0 : r_address_0;
    assign r_addr1_1 = (stor_en) ? stor_addr_1 : r_address_1;
    assign r_addr1_2 = (stor_en) ? stor_addr_2 : r_address_2;
    assign r_addr1_3 = (stor_en) ? stor_addr_3 : r_address_3;
    assign r_addr1_4 = (stor_en) ? stor_addr_4 : r_address_4;
    assign r_addr1_5 = (stor_en) ? stor_addr_5 : r_address_5;
    assign r_addr1_6 = (stor_en) ? stor_addr_6 : r_address_6;
    assign r_addr1_7 = (stor_en) ? stor_addr_7 : r_address_7;
    assign r_addr3_0 = (stor_en) ? stor_addr_0 : r_address_0;
    assign r_addr3_1 = (stor_en) ? stor_addr_1 : r_address_1;
    assign r_addr3_2 = (stor_en) ? stor_addr_2 : r_address_2;
    assign r_addr3_3 = (stor_en) ? stor_addr_3 : r_address_3;
    assign r_addr3_4 = (stor_en) ? stor_addr_4 : r_address_4;
    assign r_addr3_5 = (stor_en) ? stor_addr_5 : r_address_5;
    assign r_addr3_6 = (stor_en) ? stor_addr_6 : r_address_6;
    assign r_addr3_7 = (stor_en) ? stor_addr_7 : r_address_7;

    wire [255:0] q_0_0,q_0_1,q_0_2,q_0_3,q_0_4,q_0_5,q_0_6,q_0_7;
    wire [255:0] q_1_0,q_1_1,q_1_2,q_1_3,q_1_4,q_1_5,q_1_6,q_1_7;
    wire [255:0] q_2_0,q_2_1,q_2_2,q_2_3,q_2_4,q_2_5,q_2_6,q_2_7;
    wire [255:0] q_3_0,q_3_1,q_3_2,q_3_3,q_3_4,q_3_5,q_3_6,q_3_7;
    assign q_a_0 = (bank_set_sel_flag) ? q_0_0 : q_2_0;
    assign q_a_1 = (bank_set_sel_flag) ? q_0_1 : q_2_1;
    assign q_a_2 = (bank_set_sel_flag) ? q_0_2 : q_2_2;
    assign q_a_3 = (bank_set_sel_flag) ? q_0_3 : q_2_3;
    assign q_a_4 = (bank_set_sel_flag) ? q_0_4 : q_2_4;
    assign q_a_5 = (bank_set_sel_flag) ? q_0_5 : q_2_5;
    assign q_a_6 = (bank_set_sel_flag) ? q_0_6 : q_2_6;
    assign q_a_7 = (bank_set_sel_flag) ? q_0_7 : q_2_7;

    assign q_b_0 = (bank_set_sel_flag) ? q_1_0 : q_3_0;
    assign q_b_1 = (bank_set_sel_flag) ? q_1_1 : q_3_1;
    assign q_b_2 = (bank_set_sel_flag) ? q_1_2 : q_3_2;
    assign q_b_3 = (bank_set_sel_flag) ? q_1_3 : q_3_3;
    assign q_b_4 = (bank_set_sel_flag) ? q_1_4 : q_3_4;
    assign q_b_5 = (bank_set_sel_flag) ? q_1_5 : q_3_5;
    assign q_b_6 = (bank_set_sel_flag) ? q_1_6 : q_3_6;
    assign q_b_7 = (bank_set_sel_flag) ? q_1_7 : q_3_7;

    wire [7:0] r_en1, r_en3;
    reg [7:0] r_en_stor;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) r_en_stor <= 8'd 1;
        else if(stor) r_en_stor <= 8'd 1;
        else if(cnt_stor[6:0] == 7'd 127) r_en_stor <= {r_en_stor[5:0],r_en_stor[6]};
    end
    genvar j;
    generate for (j = 0; j <= 7; j = j+1) begin:gen_r_en0
        assign r_en1[j] = (stor_en &&  stor_flag) ? r_en_stor[j] : (ren_b &  bank_set_sel_flag);
        assign r_en3[j] = (stor_en && !stor_flag) ? r_en_stor[j] : (ren_b & ~bank_set_sel_flag);
    end
    endgenerate
    wire r_en0, r_en2;
    assign r_en0 = ren_a &  bank_set_sel_flag;
    assign r_en2 = ren_a & ~bank_set_sel_flag;

    wire en1, en3;
    assign en1 = stor_en | en;
    assign en3 = stor_en | en;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) stor_done <= 1'b 0;
        else if(cnt_stor == 10'd 1023) stor_done <= 1'b 1;
        else stor_done <= 1'b 0;
    end

    always @(*) begin
        case(r_en_stor)
        8'b 0000_0001: d_out = q_b_0;
        8'b 0000_0010: d_out = q_b_1;
        8'b 0000_0100: d_out = q_b_2;
        8'b 0000_1000: d_out = q_b_3;
        8'b 0001_0000: d_out = q_b_4;
        8'b 0010_0000: d_out = q_b_5;
        8'b 0100_0000: d_out = q_b_6;
        8'b 1000_0000: d_out = q_b_7;
        default : d_out = 256'd 0;
        endcase
    end
/////////////////////////////////////bank group 0,1,2,3 wire connection//////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire [6:0] addr0_0 = (w_en0[0]) ? w_addr0_0 : (r_en0) ? r_address_0 : 0;
    wire [6:0] addr0_1 = (w_en0[1]) ? w_addr0_1 : (r_en0) ? r_address_1 : 0;
    wire [6:0] addr0_2 = (w_en0[2]) ? w_addr0_2 : (r_en0) ? r_address_2 : 0;
    wire [6:0] addr0_3 = (w_en0[3]) ? w_addr0_3 : (r_en0) ? r_address_3 : 0;
    wire [6:0] addr0_4 = (w_en0[4]) ? w_addr0_4 : (r_en0) ? r_address_4 : 0;
    wire [6:0] addr0_5 = (w_en0[5]) ? w_addr0_5 : (r_en0) ? r_address_5 : 0;
    wire [6:0] addr0_6 = (w_en0[6]) ? w_addr0_6 : (r_en0) ? r_address_6 : 0;
    wire [6:0] addr0_7 = (w_en0[7]) ? w_addr0_7 : (r_en0) ? r_address_7 : 0;

    wire [6:0] addr1_0 = (w_en1) ? w_address_0 : (r_en1[0]) ? r_addr1_0 : 0;
    wire [6:0] addr1_1 = (w_en1) ? w_address_1 : (r_en1[1]) ? r_addr1_1 : 0;
    wire [6:0] addr1_2 = (w_en1) ? w_address_2 : (r_en1[2]) ? r_addr1_2 : 0;
    wire [6:0] addr1_3 = (w_en1) ? w_address_3 : (r_en1[3]) ? r_addr1_3 : 0;
    wire [6:0] addr1_4 = (w_en1) ? w_address_4 : (r_en1[4]) ? r_addr1_4 : 0;
    wire [6:0] addr1_5 = (w_en1) ? w_address_5 : (r_en1[5]) ? r_addr1_5 : 0;
    wire [6:0] addr1_6 = (w_en1) ? w_address_6 : (r_en1[6]) ? r_addr1_6 : 0;
    wire [6:0] addr1_7 = (w_en1) ? w_address_7 : (r_en1[7]) ? r_addr1_7 : 0;

    wire [6:0] addr2_0 = (w_en2[0]) ? w_addr2_0 : (r_en2) ? r_address_0 : 0;
    wire [6:0] addr2_1 = (w_en2[1]) ? w_addr2_1 : (r_en2) ? r_address_1 : 0;
    wire [6:0] addr2_2 = (w_en2[2]) ? w_addr2_2 : (r_en2) ? r_address_2 : 0;
    wire [6:0] addr2_3 = (w_en2[3]) ? w_addr2_3 : (r_en2) ? r_address_3 : 0;
    wire [6:0] addr2_4 = (w_en2[4]) ? w_addr2_4 : (r_en2) ? r_address_4 : 0;
    wire [6:0] addr2_5 = (w_en2[5]) ? w_addr2_5 : (r_en2) ? r_address_5 : 0;
    wire [6:0] addr2_6 = (w_en2[6]) ? w_addr2_6 : (r_en2) ? r_address_6 : 0;
    wire [6:0] addr2_7 = (w_en2[7]) ? w_addr2_7 : (r_en2) ? r_address_7 : 0;

    wire [6:0] addr3_0 = (w_en3) ? w_address_0 : (r_en3[0]) ? r_addr3_0 : 0;
    wire [6:0] addr3_1 = (w_en3) ? w_address_1 : (r_en3[1]) ? r_addr3_1 : 0;
    wire [6:0] addr3_2 = (w_en3) ? w_address_2 : (r_en3[2]) ? r_addr3_2 : 0;
    wire [6:0] addr3_3 = (w_en3) ? w_address_3 : (r_en3[3]) ? r_addr3_3 : 0;
    wire [6:0] addr3_4 = (w_en3) ? w_address_4 : (r_en3[4]) ? r_addr3_4 : 0;
    wire [6:0] addr3_5 = (w_en3) ? w_address_5 : (r_en3[5]) ? r_addr3_5 : 0;
    wire [6:0] addr3_6 = (w_en3) ? w_address_6 : (r_en3[6]) ? r_addr3_6 : 0;
    wire [6:0] addr3_7 = (w_en3) ? w_address_7 : (r_en3[7]) ? r_addr3_7 : 0;

    assign addr_0 = {addr3_0,addr2_0,addr1_0,addr0_0};
    assign addr_1 = {addr3_1,addr2_1,addr1_1,addr0_1};
    assign addr_2 = {addr3_2,addr2_2,addr1_2,addr0_2};
    assign addr_3 = {addr3_3,addr2_3,addr1_3,addr0_3};
    assign addr_4 = {addr3_4,addr2_4,addr1_4,addr0_4};
    assign addr_5 = {addr3_5,addr2_5,addr1_5,addr0_5};
    assign addr_6 = {addr3_6,addr2_6,addr1_6,addr0_6};
    assign addr_7 = {addr3_7,addr2_7,addr1_7,addr0_7};
    assign data_o_0 = {d0,data2_0,d0,data0_0};
    assign data_o_1 = {d1,data2_1,d1,data0_1};
    assign data_o_2 = {d2,data2_2,d2,data0_2};
    assign data_o_3 = {d3,data2_3,d3,data0_3};
    assign data_o_4 = {d4,data2_4,d4,data0_4};
    assign data_o_5 = {d5,data2_5,d5,data0_5};
    assign data_o_6 = {d6,data2_6,d6,data0_6};
    assign data_o_7 = {d7,data2_7,d7,data0_7};
    assign w_en_0 = {w_en3,w_en2[0],w_en1,w_en0[0]};
    assign w_en_1 = {w_en3,w_en2[1],w_en1,w_en0[1]};
    assign w_en_2 = {w_en3,w_en2[2],w_en1,w_en0[2]};
    assign w_en_3 = {w_en3,w_en2[3],w_en1,w_en0[3]};
    assign w_en_4 = {w_en3,w_en2[4],w_en1,w_en0[4]};
    assign w_en_5 = {w_en3,w_en2[5],w_en1,w_en0[5]};
    assign w_en_6 = {w_en3,w_en2[6],w_en1,w_en0[6]};
    assign w_en_7 = {w_en3,w_en2[7],w_en1,w_en0[7]};
    assign en_0 = {en3,en2,en1,en0};
    assign en_1 = {en3,en2,en1,en0};
    assign en_2 = {en3,en2,en1,en0};
    assign en_3 = {en3,en2,en1,en0};
    assign en_4 = {en3,en2,en1,en0};
    assign en_5 = {en3,en2,en1,en0};
    assign en_6 = {en3,en2,en1,en0};
    assign en_7 = {en3,en2,en1,en0};
    assign  q_0_0 = q_0[256*0+:256];
    assign  q_0_1 = q_0[256*0+:256];
    assign  q_0_2 = q_0[256*0+:256];
    assign  q_0_3 = q_0[256*0+:256];
    assign  q_0_4 = q_0[256*0+:256];
    assign  q_0_5 = q_0[256*0+:256];
    assign  q_0_6 = q_0[256*0+:256];
    assign  q_0_7 = q_0[256*0+:256];
    assign  q_1_0 = q_0[256*1+:256];
    assign  q_1_1 = q_0[256*1+:256];
    assign  q_1_2 = q_0[256*1+:256];
    assign  q_1_3 = q_0[256*1+:256];
    assign  q_1_4 = q_0[256*1+:256];
    assign  q_1_5 = q_0[256*1+:256];
    assign  q_1_6 = q_0[256*1+:256];
    assign  q_1_7 = q_0[256*1+:256];
    assign  q_2_0 = q_0[256*2+:256];
    assign  q_2_1 = q_0[256*2+:256];
    assign  q_2_2 = q_0[256*2+:256];
    assign  q_2_3 = q_0[256*2+:256];
    assign  q_2_4 = q_0[256*2+:256];
    assign  q_2_5 = q_0[256*2+:256];
    assign  q_2_6 = q_0[256*2+:256];
    assign  q_2_7 = q_0[256*2+:256];
    assign  q_3_0 = q_0[256*3+:256];
    assign  q_3_1 = q_0[256*3+:256];
    assign  q_3_2 = q_0[256*3+:256];
    assign  q_3_3 = q_0[256*3+:256];
    assign  q_3_4 = q_0[256*3+:256];
    assign  q_3_5 = q_0[256*3+:256];
    assign  q_3_6 = q_0[256*3+:256];
    assign  q_3_7 = q_0[256*3+:256];
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////bank group 0,1,2,3 wire connection//////////////////////////////////////

    mux_data mux_0(
        .sel       (a_flag_neg_dly),
        .data_a_i_0(q_a_0),
        .data_a_i_1(q_a_1),
        .data_a_i_2(q_a_2),
        .data_a_i_3(q_a_3),
        .data_a_i_4(q_a_4),
        .data_a_i_5(q_a_5),
        .data_a_i_6(q_a_6),
        .data_a_i_7(q_a_7),
        .data_b_i_0(q_b_0),
        .data_b_i_1(q_b_1),
        .data_b_i_2(q_b_2),
        .data_b_i_3(q_b_3),
        .data_b_i_4(q_b_4),
        .data_b_i_5(q_b_5),
        .data_b_i_6(q_b_6),
        .data_b_i_7(q_b_7),
        .data_o_0  (q0),
        .data_o_1  (q1),
        .data_o_2  (q2),
        .data_o_3  (q3),
        .data_o_4  (q4),
        .data_o_5  (q5),
        .data_o_6  (q6),
        .data_o_7  (q7)
    );

   shuffle_0 shuffle_0_u0(.clk(clk),.rst_n(rst_n),.en(1'b1),.cros(cros_delay0),.ntt(ntt_flag), //tqc:en signal required!!! ntt signal required!!!
                          .data_in_0(q0),.data_in_1(q1),.data_in_2(q2),.data_in_3(q3),.data_in_4(q4),.data_in_5(q5),.data_in_6(q6),.data_in_7(q7),
                          .data_out_0(u0),.data_out_1(v0),.data_out_2(u1),.data_out_3(v1),.data_out_4(u2),.data_out_5(v2),.data_out_6(u3),.data_out_7(v3));

    //wire [255:0] w_in0, w_in1, w_in2, w_in3;
    assign w_in0 = (conf == 3'd 2) ? tf_in_0 : w_p_0;
    assign w_in1 = (conf == 3'd 2) ? tf_in_1 : w_p_1;
    assign w_in2 = (conf == 3'd 2) ? tf_in_2 : w_p_2;
    assign w_in3 = (conf == 3'd 2) ? tf_in_3 : w_p_3;

   shuffle_1 shuffle_1_u0(.clk(clk),.rst_n(rst_n),.en(1'b1),.cros(cros_delay1),.ntt(ntt_flag), //tqc:en signal required!!! ntt signal required!!!
                          .data_in_0(bf_0_upper),.data_in_1(bf_0_lower),.data_in_2(bf_1_upper),.data_in_3(bf_1_lower),
                          .data_in_4(bf_2_upper),.data_in_5(bf_2_lower),.data_in_6(bf_3_upper),.data_in_7(bf_3_lower),
                          .data_out_0(d0),.data_out_1(d1),.data_out_2(d2),.data_out_3(d3),.data_out_4(d4),.data_out_5(d5),.data_out_6(d6),.data_out_7(d7));

   tf_address_generator tf_address_generator_U7(
                          .clk(clk),.rst_n(rst_n),
                          .conf(conf),
                          .k(k),
                          .i(i),
                          .p(p),
                          .cnt_addr_gen(cnt_addr_gen),
                          .tf_proc_flag_0(proc_flag_0),
                          .tf_proc_flag_1(proc_flag_1),
                          .tf_proc_flag_2(proc_flag_2),
                          .tf_proc_flag_3(proc_flag_3),
                          .tf_address_0(tf_address_0),
                          .tf_address_1(tf_address_1),
                          .tf_address_2(tf_address_2),
                          .tf_address_3(tf_address_3));

   tf_proc tf_proc_U0 (.clk(clk), .rst_n(rst_n), .conf(conf), .proc_flag(proc_flag_0), .tf_i(w_0), .tf_o(w_p_0));
   tf_proc tf_proc_U1 (.clk(clk), .rst_n(rst_n), .conf(conf), .proc_flag(proc_flag_1), .tf_i(w_1), .tf_o(w_p_1));
   tf_proc tf_proc_U2 (.clk(clk), .rst_n(rst_n), .conf(conf), .proc_flag(proc_flag_2), .tf_i(w_2), .tf_o(w_p_2));
   tf_proc tf_proc_U3 (.clk(clk), .rst_n(rst_n), .conf(conf), .proc_flag(proc_flag_3), .tf_i(w_3), .tf_o(w_p_3));

endmodule
