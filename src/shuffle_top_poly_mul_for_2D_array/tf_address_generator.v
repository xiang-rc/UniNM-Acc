////date: 2024/05/11
//module tf_address_generator(
//    input clk,rst_n,
//    input [2:0] conf,
//    input [8:0] k, //max = 511
//    input [8:0] i, //max = 511
//    input [3:0] p,
//    input [6:0] cnt_addr_gen,
//    output wire tf_proc_flag_0,
//    output wire tf_proc_flag_1,
//    output wire tf_proc_flag_2,
//    output wire tf_proc_flag_3,
//    output wire [8:0] tf_address_0,
//    output wire [8:0] tf_address_1,
//    output wire [8:0] tf_address_2,
//    output wire [8:0] tf_address_3
//    );
//
//    wire [8:0] tf_address_reg_NTT;
//    wire [8:0] tf_address_reg_NTT_0, tf_address_reg_NTT_1, tf_address_reg_NTT_2, tf_address_reg_NTT_3;
//    wire [8:0] tf_address_reg_INTT_0, tf_address_reg_INTT_1, tf_address_reg_INTT_2, tf_address_reg_INTT_3;
//    wire [9:0] idx; //index
//    reg [8:0] i_shift; //i * int(n/(2*J))
//    wire [8:0] tf_address_tmp_0,tf_address_tmp_1,tf_address_tmp_2,tf_address_tmp_3;
//
//    //conf = 3'b001 NTT mode; conf == 3'b011 INTT mode
//    assign tf_address_tmp_0 = (conf == 3'b001) ? tf_address_reg_NTT_0 : (conf == 3'b011) ? {tf_address_reg_INTT_0} : 9'd0; //tqc:dont't care other options
//    assign tf_address_tmp_1 = (conf == 3'b001) ? tf_address_reg_NTT_1 : (conf == 3'b011) ? {tf_address_reg_INTT_1} : 9'd0; //tqc:dont't care other options
//    assign tf_address_tmp_2 = (conf == 3'b001) ? tf_address_reg_NTT_2 : (conf == 3'b011) ? {tf_address_reg_INTT_2} : 9'd0; //tqc:dont't care other options
//    assign tf_address_tmp_3 = (conf == 3'b001) ? tf_address_reg_NTT_3 : (conf == 3'b011) ? {tf_address_reg_INTT_3} : 9'd0; //tqc:dont't care other options
//
//    DFF #(.data_width(9)) dff_tf_0(.clk(clk),.rst_n(rst_n),.d(tf_address_tmp_0),.q(tf_address_0));
//    DFF #(.data_width(9)) dff_tf_1(.clk(clk),.rst_n(rst_n),.d(tf_address_tmp_1),.q(tf_address_1));
//    DFF #(.data_width(9)) dff_tf_2(.clk(clk),.rst_n(rst_n),.d(tf_address_tmp_2),.q(tf_address_2));
//    DFF #(.data_width(9)) dff_tf_3(.clk(clk),.rst_n(rst_n),.d(tf_address_tmp_3),.q(tf_address_3));
//
//    //NTT mode
//    reg [8:0] tf_address_reg_NTT_shift;
//    always@(*)
//    begin
//      tf_address_reg_NTT_shift = tf_address_reg_NTT << (2);
//    end
//
//    //NTT mode
//    //assign tf_address_reg_NTT = k;
//    assign tf_address_reg_NTT = {2'd0,cnt_addr_gen};
//    assign tf_address_reg_NTT_0 = tf_address_reg_NTT_shift;
//    assign tf_address_reg_NTT_1 = tf_address_reg_NTT_shift + 1;
//    assign tf_address_reg_NTT_2 = tf_address_reg_NTT_shift + 2;
//    assign tf_address_reg_NTT_3 = tf_address_reg_NTT_shift + 3;
//
//    //INTT mode
//    always@(*)
//    begin
//      i_shift = i << (0+2);
//    end
//    wire [8:0] i_shift_0, i_shift_1, i_shift_2, i_shift_3;
//    wire [9:0] idx_0, idx_1, idx_2, idx_3;
//    assign i_shift_0 = i_shift;               //could be used in tf_proc
//    assign i_shift_1 = i_shift + 1; //could be used in tf_proc
//    assign i_shift_2 = i_shift + 2; //could be used in tf_proc
//    assign i_shift_3 = i_shift + 3; //could be used in tf_proc
//    assign tf_proc_flag_0 = (i_shift_0 == 0) ? 1:0;
//    assign tf_proc_flag_1 = (i_shift_1 == 0) ? 1:0;
//    assign tf_proc_flag_2 = (i_shift_2 == 0) ? 1:0;
//    assign tf_proc_flag_3 = (i_shift_3 == 0) ? 1:0;
//    assign idx = 10'd512 - {1'b0,i_shift};
//    assign idx_0 = 10'd512 - {1'b0,i_shift_0};
//    assign idx_1 = 10'd512 - {1'b0,i_shift_1};
//    assign idx_2 = 10'd512 - {1'b0,i_shift_2};
//    assign idx_3 = 10'd512 - {1'b0,i_shift_3};
//
//    bit_rev #(.data_width(9)) bit_rev_U1 (.s_i(idx_0[8:0]), .s_o(tf_address_reg_INTT_0));
//    bit_rev #(.data_width(9)) bit_rev_U2 (.s_i(idx_1[8:0]), .s_o(tf_address_reg_INTT_1));
//    bit_rev #(.data_width(9)) bit_rev_U3 (.s_i(idx_2[8:0]), .s_o(tf_address_reg_INTT_2));
//    bit_rev #(.data_width(9)) bit_rev_U4 (.s_i(idx_3[8:0]), .s_o(tf_address_reg_INTT_3));
////                                               % 512
//endmodule

//date: 2024/05/07
module tf_address_generator(
  input clk,rst_n,
  input [2:0] conf,
  input [8:0] k, //max = 511
  input [8:0] i, //max = 511
  input [3:0] p,
  input [6:0] cnt_addr_gen,
  output wire tf_proc_flag_0,
  output wire tf_proc_flag_1,
  output wire tf_proc_flag_2,
  output wire tf_proc_flag_3,
  output wire [8:0] tf_address_0,
  output wire [8:0] tf_address_1,
  output wire [8:0] tf_address_2,
  output wire [8:0] tf_address_3
  );

  wire [8:0] tf_address_reg_NTT;
  wire [8:0] tf_address_reg_NTT_0, tf_address_reg_NTT_1, tf_address_reg_NTT_2, tf_address_reg_NTT_3;
  wire [8:0] tf_address_reg_INTT_0, tf_address_reg_INTT_1, tf_address_reg_INTT_2, tf_address_reg_INTT_3;
  wire [9:0] idx; //index
  reg [8:0] i_shift; //i * int(n/(2*J))
  wire [8:0] tf_address_tmp_0,tf_address_tmp_1,tf_address_tmp_2,tf_address_tmp_3;

  //conf = 3'b001 NTT mode; conf == 3'b011 INTT mode
  assign tf_address_tmp_0 = (conf == 3'b001) ? tf_address_reg_NTT_0 : (conf == 3'b011) ? {tf_address_reg_INTT_0} : 9'd0; //tqc:dont't care other options
  assign tf_address_tmp_1 = (conf == 3'b001) ? tf_address_reg_NTT_1 : (conf == 3'b011) ? {tf_address_reg_INTT_1} : 9'd0; //tqc:dont't care other options
  assign tf_address_tmp_2 = (conf == 3'b001) ? tf_address_reg_NTT_2 : (conf == 3'b011) ? {tf_address_reg_INTT_2} : 9'd0; //tqc:dont't care other options
  assign tf_address_tmp_3 = (conf == 3'b001) ? tf_address_reg_NTT_3 : (conf == 3'b011) ? {tf_address_reg_INTT_3} : 9'd0; //tqc:dont't care other options

  DFF #(.data_width(9)) dff_tf_0(.clk(clk),.rst_n(rst_n),.d(tf_address_tmp_0),.q(tf_address_0));
  DFF #(.data_width(9)) dff_tf_1(.clk(clk),.rst_n(rst_n),.d(tf_address_tmp_1),.q(tf_address_1));
  DFF #(.data_width(9)) dff_tf_2(.clk(clk),.rst_n(rst_n),.d(tf_address_tmp_2),.q(tf_address_2));
  DFF #(.data_width(9)) dff_tf_3(.clk(clk),.rst_n(rst_n),.d(tf_address_tmp_3),.q(tf_address_3));

  //NTT mode
  reg [8:0] tf_address_reg_NTT_shift;
  always@(*)
  begin
    case(p)
    9:begin       tf_address_reg_NTT_shift = 0              ; end //
    8:begin       tf_address_reg_NTT_shift = 0              ; end //
    7:begin       tf_address_reg_NTT_shift = 0              ; end
    6:begin       tf_address_reg_NTT_shift = k[0]   << 2    ; end
    5:begin       tf_address_reg_NTT_shift = k[1:0] << 2    ; end
    4:begin       tf_address_reg_NTT_shift = k[2:0] << 2    ; end
    3:begin       tf_address_reg_NTT_shift = k[3:0] << 2    ; end
    2:begin       tf_address_reg_NTT_shift = k[4:0] << 2    ; end //
    1:begin       tf_address_reg_NTT_shift = k[5:0] << 2    ; end //
    0:begin       tf_address_reg_NTT_shift = k      << 2    ; end
    default:begin tf_address_reg_NTT_shift = k              ; end
    endcase
  end

  reg [2:0] NTT_bios_0, NTT_bios_1, NTT_bios_2;
  always@(*)
  begin
    case(p)
    9:begin       NTT_bios_0 = 3'd 0; NTT_bios_1 = 3'd 0; NTT_bios_2 = 3'd 0;end //
    8:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 0; NTT_bios_2 = 3'd 1;end //
    7:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end
    6:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end
    5:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end
    4:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end
    3:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end
    2:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end //
    1:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end //
    0:begin       NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end
    default:begin NTT_bios_0 = 3'd 1; NTT_bios_1 = 3'd 2; NTT_bios_2 = 3'd 3;end
    endcase
  end

  //NTT mode
  assign tf_address_reg_NTT = k;
  assign tf_address_reg_NTT_0 = tf_address_reg_NTT_shift;
  assign tf_address_reg_NTT_1 = tf_address_reg_NTT_shift + NTT_bios_0;
  assign tf_address_reg_NTT_2 = tf_address_reg_NTT_shift + NTT_bios_1;
  assign tf_address_reg_NTT_3 = tf_address_reg_NTT_shift + NTT_bios_2;

  //INTT mode
  always@(*)
    begin
      case(p)
      9:begin       i_shift = cnt_addr_gen      << 2    ; end
      8:begin       i_shift = cnt_addr_gen      << 2    ; end
      7:begin       i_shift = cnt_addr_gen      << 2    ; end
      6:begin       i_shift = cnt_addr_gen[6:1] << 3    ; end
      5:begin       i_shift = cnt_addr_gen[6:2] << 4    ; end
      4:begin       i_shift = cnt_addr_gen[6:3] << 5    ; end
      3:begin       i_shift = cnt_addr_gen[6:4] << 6    ; end
      2:begin       i_shift = cnt_addr_gen[6:5] << 7    ; end
      1:begin       i_shift = cnt_addr_gen[6]   << 8    ; end
      0:begin       i_shift = cnt_addr_gen[6]   << 9    ; end
      default:begin i_shift = cnt_addr_gen              ; end
      endcase
    end

  reg [9:0] INTT_bios_0, INTT_bios_1, INTT_bios_2;
  always@(*)
  begin
    case(p)
    9:begin       INTT_bios_0 = 10'd1; INTT_bios_1 = 10'd2; INTT_bios_2 = 10'd3;end
    8:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd2; INTT_bios_2 = 10'd2;end
    7:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd0; INTT_bios_2 = 10'd0;end
    6:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd0; INTT_bios_2 = 10'd0;end
    5:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd0; INTT_bios_2 = 10'd0;end
    4:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd0; INTT_bios_2 = 10'd0;end
    3:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd0; INTT_bios_2 = 10'd0;end
    2:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd0; INTT_bios_2 = 10'd0;end
    1:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd0; INTT_bios_2 = 10'd0;end
    0:begin       INTT_bios_0 = 10'd0; INTT_bios_1 = 10'd0; INTT_bios_2 = 10'd0;end
    default:begin INTT_bios_0 = 10'd1; INTT_bios_1 = 10'd2; INTT_bios_2 = 10'd3;end
    endcase
  end
  wire [8:0] i_shift_0, i_shift_1, i_shift_2, i_shift_3;
  wire [9:0] idx_0, idx_1, idx_2, idx_3;
  assign i_shift_0 = i_shift;               //could be used in tf_proc
  assign i_shift_1 = i_shift + INTT_bios_0; //could be used in tf_proc
  assign i_shift_2 = i_shift + INTT_bios_1; //could be used in tf_proc
  assign i_shift_3 = i_shift + INTT_bios_2; //could be used in tf_proc
  assign tf_proc_flag_0 = (i_shift_0 == 0) ? 1:0;
  assign tf_proc_flag_1 = (i_shift_1 == 0) ? 1:0;
  assign tf_proc_flag_2 = (i_shift_2 == 0) ? 1:0;
  assign tf_proc_flag_3 = (i_shift_3 == 0) ? 1:0;
  assign idx = 10'd512 - {1'b0,i_shift};
  assign idx_0 = 10'd512 - {1'b0,i_shift_0};
  assign idx_1 = 10'd512 - {1'b0,i_shift_1};
  assign idx_2 = 10'd512 - {1'b0,i_shift_2};
  assign idx_3 = 10'd512 - {1'b0,i_shift_3};

  bit_rev #(.data_width(9)) bit_rev_U1 (.s_i(idx_0[8:0]), .s_o(tf_address_reg_INTT_0));
  bit_rev #(.data_width(9)) bit_rev_U2 (.s_i(idx_1[8:0]), .s_o(tf_address_reg_INTT_1));
  bit_rev #(.data_width(9)) bit_rev_U3 (.s_i(idx_2[8:0]), .s_o(tf_address_reg_INTT_2));
  bit_rev #(.data_width(9)) bit_rev_U4 (.s_i(idx_3[8:0]), .s_o(tf_address_reg_INTT_3));
//                                               % 512
endmodule
