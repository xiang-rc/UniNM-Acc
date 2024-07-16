//date: 2024/06/17
module fsm (
  input clk,rst_n,
  input wire [2:0] conf,
  input start,
  output wire sel,
  output wire [8:0] k, //max = 511
  output wire [8:0] i, //max = 511
  output wire [3:0] p, //max = 9
  output wire wen,
  output wire ren,
  output reg wen_a,
  output reg wen_b,
  output reg ren_a,
  output reg ren_b,
  output wire en,
  output wire ntt_flag,
  output wire [6:0] cnt_addr_gen_o, //output for addr_generator
  output wire a_flag_neg_o,
  output wire [3:0] done_flag,
  output reg done );

  //typedef enum reg [2:0] {IDLE = 3'b000,NTT = 3'b001,PWM = 3'b010,INTT= 3'b011,DONE_NTT = 3'b100,DONE_INTT = 3'b101} fsm_state_type;
  //fsm_state_type c_state, n_state;

  localparam IDLE = 3'b000;
  localparam NTT = 3'b001;
  localparam PWM = 3'b010;
  localparam INTT = 3'b011;
  localparam DONE_NTT = 3'b100;
  localparam DONE_INTT = 3'b101;

  localparam CNT_DONE_NTT  = 5'd11;
  localparam CNT_DONE_INTT = 5'd11;
  localparam BFU_NUM = 4; //tqc:for four BFUs version
  localparam CNT_PWM_DONE = 9'd 267; // 0~255 + 1 (read data) + pipline latency

  reg wen_reg,ren_reg,en_reg,sel_reg;
  wire wen_dly;
  wire en_reg_q,en_reg_q_tmp;
  reg [2:0] c_state;
  reg [2:0] n_state;
  reg [8:0] k_reg,i_reg;
  reg [3:0] p_reg;
  reg [3:0] done_reg;
  wire [3:0] end_stage,begin_stage;
  reg [4:0] cnt; //cnt for DONE_NTT & DONE_INTT, empty pipline
  reg cnt_en;
  reg [8:0] cnt_pwm; //cnt pwm cycles, 0~255 + 1 (read data) + pipline latency
  reg cnt_pwm_en;
  wire cnt_start;
  reg [6:0] cnt_addr_gen; //cnt for addr_generator (0~127)
  reg a_flag_neg_dly;

  wire a_flag_neg; // bank_a read when a_flag==0 (bank_b write), bank_b read when a_flag==1 (bank_a write)
  wire pwm_done;
  assign pwm_done = (cnt_pwm == CNT_PWM_DONE); //tqc:tbd!!!

  assign a_flag_neg_o = a_flag_neg;

  assign a_flag_neg = p[0] ^ (conf==3'd3);

  always @(posedge clk) begin
    if (!a_flag_neg) begin ren_a <= ren_reg; ren_b <= 1'b0   ; end
    else             begin ren_a <= 1'b0   ; ren_b <= ren_reg; end
  end
  always @(posedge clk) begin
    if (!a_flag_neg_dly) begin wen_a <= 1'b0   ; wen_b <= wen_dly; end
    else                 begin wen_a <= wen_dly; wen_b <= 1'b0   ; end
  end

  assign i = i_reg;
  assign k = k_reg;
  assign p = p_reg;
  assign done_flag = done_reg;
  assign cnt_addr_gen_o = cnt_addr_gen;

  assign en = ((n_state == DONE_NTT) || (n_state == DONE_INTT)) ? en_reg_q : en_reg_q_tmp;

  assign ntt_flag = (conf==3'd1) ? 0 : 1;//tqc: switch ntt_flag with intt!!!2024/05/09

  shifter #(.data_width(1), .depth(11)) shif_a_flag_neg(.clk(clk),.rst_n(rst_n),.din(a_flag_neg),.dout(a_flag_neg_dly));
  shifter #(.data_width(1), .depth(11)) shif_wen(.clk(clk),.rst_n(rst_n),.din(wen_reg),.dout(wen_dly)); //depth control delay cycles, it should equal to latency of bf + 1(10 + 1)
  shifter #(.data_width(1), .depth(11)) shif_en(.clk(clk),.rst_n(rst_n),.din(en_reg_q_tmp),.dout(en_reg_q)); //t should equal to latency of bf+1(10+1)

  DFF #(.data_width(1)) dff_en(.clk(clk),.rst_n(rst_n),.d(en_reg),.q(en_reg_q_tmp));
  DFF #(.data_width(1)) dff_ren(.clk(clk),.rst_n(rst_n),.d(ren_reg),.q(ren));
  DFF #(.data_width(1)) dff_sel(.clk(clk),.rst_n(rst_n),.d(sel_reg),.q(sel));

  always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      c_state <= IDLE;
    else
      c_state <= n_state;
  end

  always@(*)
  begin
    n_state = c_state;
    case(c_state)
    IDLE      : if(start)                                      n_state = (conf==3'd1)?NTT:(conf==3'd2)?PWM:(conf==3'd3)?INTT:IDLE;
    NTT       : if((p_reg == 9)&&(k_reg == 0)&&(i_reg == 512/BFU_NUM -1)) n_state = DONE_NTT;
    PWM       : if(cnt_pwm == CNT_PWM_DONE+1)                             n_state = IDLE;
    INTT      : if((p_reg == 0)&&(k_reg == 512/BFU_NUM -1)&&(i_reg == 0)) n_state = DONE_INTT;
    DONE_NTT  : if(cnt==CNT_DONE_NTT)                          n_state = IDLE;
    DONE_INTT : if(cnt==CNT_DONE_INTT)                         n_state = IDLE;
    default   : n_state = IDLE;
    endcase
  end

  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)                                  done <= 1'b0;
    else if (cnt==CNT_DONE_NTT-1 || cnt==CNT_DONE_INTT-1 || pwm_done) done <= 1'b1;
    else                                         done <= 1'b0;
  end

  assign cnt_start = ((c_state==NTT && n_state==DONE_NTT) || (c_state==INTT && n_state==DONE_INTT));
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n) cnt <= 5'd0;
    else begin
        if (cnt_start) cnt <= 5'd0;
        else if (cnt_en) cnt <= cnt + 5'd1;
    end
  end

  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n) cnt_pwm <= 9'd0;
    else begin
        if (conf==3'd2 && start) cnt_pwm <= 9'd0;
        else if (cnt_pwm_en) cnt_pwm <= cnt_pwm + 9'd1;
    end
  end
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) cnt_pwm_en <= 1'b 0;
    else if (conf==3'd2 && start) cnt_pwm_en <= 1'b 1;
    else if (cnt_pwm == CNT_PWM_DONE) cnt_pwm_en <= 1'b 0;
  end

  always@(*)
  begin
    sel_reg = 0;
    en_reg = 0;
    wen_reg = 0;
    ren_reg = 0;
    done_reg = 4'b0;
    cnt_en = 1'b0;
    case(c_state)
    IDLE:begin
         sel_reg = 0;
         en_reg = 0;
         wen_reg = 0;
         ren_reg = 0;
         done_reg = 4'b0000;
         end
    NTT:begin
         sel_reg = 0;
         en_reg = 1;
         wen_reg = 1;
         ren_reg = 1;
         if((p_reg == 9)&&(k_reg == 0)&&(i_reg == 512/BFU_NUM -1))begin
           done_reg = 4'b0001; end
         else begin
           done_reg = 4'b0000; end
         end
    PWM:begin
         sel_reg = 0;
         en_reg = 1;
         wen_reg = 1;
         ren_reg = 1;
         if(cnt_pwm == CNT_PWM_DONE+1)begin
           done_reg = 4'b0010; end
         else begin
           done_reg = 4'b0000; end
         end
    INTT:begin
         sel_reg = 1;
         en_reg = 1;
         wen_reg = 1;
         ren_reg = 1;
         if((p_reg == 0)&&(k_reg == 512/BFU_NUM -1)&&(i_reg == 0))begin
           done_reg = 4'b0100; end
         else begin
           done_reg = 4'b0000; end
         end
    //NTT emptying pipeline phase
    DONE_NTT:begin
         sel_reg = 0; //NTT = 0
         en_reg = 1;
         wen_reg = 0;
         ren_reg = 0;
         done_reg = 4'b0001;
         cnt_en = 1'b1;
         end
    DONE_INTT:begin
         sel_reg = 1;//INTT = 1
         en_reg = 1;
         wen_reg = 0;
         ren_reg = 0;
         done_reg = 4'b0100;
         cnt_en = 1'b1;
         end
    default:begin
         sel_reg = 0;
         done_reg = 4'b0000;
         en_reg = 0;
         wen_reg = 0;
         ren_reg = 0;
         cnt_en = 1'b0;
         end
     endcase
  end

 assign end_stage = conf == NTT ? 4'd9 : 4'd0;
 assign begin_stage = conf == NTT ? 4'd0 : 4'd9;

 wire [9:0] J;
 assign J = 1 << p_reg;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      p_reg <= begin_stage;
      i_reg <= 0;
      k_reg <= 0;
      cnt_addr_gen <= 0;
  end
  else if((c_state == NTT) || (c_state == PWM) || (c_state == INTT)) begin
      cnt_addr_gen <= cnt_addr_gen + 1;
      if (J>=BFU_NUM) begin
          //if(i_reg == ((J)/BFU_NUM) - 1) begin
          if(k_reg == (512 >> p_reg) - 1) begin
              //i_reg <= 0;
              k_reg <= 0;
              //if(k_reg == (512 >> p_reg) - 1) begin
              if(i_reg == ((J)/BFU_NUM) - 1) begin
                  //k_reg <= 0;
                  i_reg <= 0;
                  if(p_reg == end_stage)
                      p_reg <= begin_stage;
                  else begin
                      if(c_state == INTT)
                          p_reg <= p_reg - 1;
                      else
                          p_reg <= p_reg + 1;
                  end
              end
              else
                  //k_reg <= k_reg + 1;
                  i_reg <= i_reg + 1;
          end
          else
              //i_reg <= i_reg + 1;
              k_reg <= k_reg + 1;
      end
      else begin
          if(k_reg == (512/BFU_NUM) - 1) begin
              k_reg <= 0;
              if(p_reg == end_stage)
                  p_reg <= end_stage;
              else begin
                  if(c_state == INTT)
                      p_reg <= p_reg - 1;
                  else
                      p_reg <= p_reg + 1;
              end
          end
          else
              k_reg <= k_reg + 1;
      end
  end
  else begin
      p_reg <= begin_stage;
      i_reg <= 0;
      k_reg <= 0;
  end
end

endmodule
