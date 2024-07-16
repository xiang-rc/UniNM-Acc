module top_2d_array(
    input          clk           ,
    input          rst_n         ,
    input          start         ,
    input          start_msm     ,
    input          pwm_en        ,
    input          flag_msm      ,
    //input          dram_ld_done  , //from dram ??? useless?
    //input          dram_st_done  , //from dram ??? useless?
    input          dram_ld_rdy_0 ,
    input          dram_ld_rdy_1 ,
    input          dram_ld_rdy_2 ,
    input          dram_ld_rdy_3 ,
    input          dram_st_rdy_0 ,
    input          dram_st_rdy_1 ,
    input          dram_st_rdy_2 ,
    input          dram_st_rdy_3 ,
    input  [255:0] data_in_0     ,
    input  [255:0] data_in_1     ,
    input  [255:0] data_in_2     ,
    input  [255:0] data_in_3     ,
    output [255:0] data_out_0    ,
    output [255:0] data_out_1    ,
    output [255:0] data_out_2    ,
    output [255:0] data_out_3    ,
    output         dram_ld_start ,
    output         dram_st_start ,
    output         done           //
);
    //bank_load_logic ports
    wire load_done, stor_done;
    wire [10:0] load_addr_in [5:0];
    wire [5:0] ce_load, wen_load;
    wire [512-1:0] data_load_out[5:0];
    reg  bg_sel; //
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) bg_sel <= 1'b 0;
        else if (load_done) bg_sel <= ~bg_sel;
    end
    wire [9:0]                ntt_load_addr;
    wire                  ntt_load_en  ;
    wire                  ntt_load_wen ;
    //bg_input_logic ports
    wire [  7*32-1:0] bg_in_addr_out [3:0];
    wire [    32-1:0] bg_in_ce_out   [3:0];
    wire [    32-1:0] bg_in_wen_out  [3:0];
    wire [256*32-1:0] bg_in_dout     [3:0];
    wire [  7*32-1:0] bg_in_ntt_addr      ;
    //bank_group ports
    wire [256*32-1:0] bg_dout  [3:0];
    //bg_output_logic ports
    wire [256*32-1:0] bg_out_dout  [3:0];
    //bg4_input_logic ports
    wire [4:0] w_addr_bucket_a, w_addr_bucket_b,r_addr_bucket_a, r_addr_bucket_b;
    wire w_en_bucket_a, w_en_bucket_b,r_en_bucket_a, r_en_bucket_b;
    wire [4:0] fifo_r_addr, fifo_w_addr;
    wire fifo_r_en, fifo_w_en;
    wire [7:0] tf_bank_addr;
    wire tf_bank_web, tf_bank_en;
    wire [255:0] bg4_din_0,bg4_din_1,bg4_din_2,bg4_din_3,bg4_din_4,bg4_din_5,bg4_din_6,bg4_din_7,bg4_din_8,bg4_din_9,bg4_din_a,bg4_din_b,bg4_din_c,bg4_din_d,bg4_din_e,bg4_din_f;
    wire [1157-1:0] din_bk_a,din_bk_b,din_rb;
    wire [5*5-1:0] addr_outa, addr_outb, addr_out_r, addr_out_w;
    wire [5*6-1:0]   addr_out32;
    wire [7*28-1:0]  addr_out128;
    wire [   5-1:0]  ce_outa      ;
    wire [   5-1:0]  ce_outb      ;
    wire [   34-1:0] ce_out       ;
    wire [   5-1:0]  wen_outa     ;
    wire [   5-1:0]  wen_outb     ;
    wire [   5-1:0]  wen_out_t    ;
    wire [   5-1:0]  ren_out_t    ;
    wire [   34-1:0] wen_out      ;
    wire [  256-1:0] dout0a       ;
    wire [  256-1:0] dout1a       ;
    wire [  256-1:0] dout0b       ;
    wire [  256-1:0] dout1b       ;
    wire [  256-1:0] dout2        ;
    wire [  256-1:0] dout3        ;
    wire [  256-1:0] dout4        ;
    wire [  256-1:0] dout5        ;
    wire [  256-1:0] dout6        ;
    wire [  256-1:0] dout7        ;
    wire [  256-1:0] dout8        ;
    wire [  256-1:0] dout9        ;
    wire [  256-1:0] dout10       ;
    wire [  256-1:0] dout11a      ;
    wire [  256-1:0] dout11b      ;
    wire [  256-1:0] dout12       ;
    wire [  256-1:0] dout13       ;
    wire [  256-1:0] dout14       ;
    wire [  256-1:0] dout15       ;
    wire [  256-1:0] dout16       ;
    wire [  256-1:0] dout17       ;
    wire [  256-1:0] dout18       ;
    wire [  256-1:0] dout19       ;
    wire [  256-1:0] dout20       ;
    wire [  256-1:0] dout21       ;
    wire [  256-1:0] dout22a      ;
    wire [  256-1:0] dout22b      ;
    wire [  256-1:0] dout23       ;
    wire [  256-1:0] dout24       ;
    wire [  256-1:0] dout25       ;
    wire [  256-1:0] dout26       ;
    wire [  256-1:0] dout27       ;
    wire [  256-1:0] dout28       ;
    wire [  256-1:0] dout29       ;
    wire [  256-1:0] dout30       ;
    wire [  256-1:0] dout31       ;
    wire [  256-1:0] dout32       ;
    wire [  256-1:0] dout33a      ;
    wire [  256-1:0] dout33b      ;
    wire [  256-1:0] dout34       ;
    wire [  256-1:0] dout35       ;
    wire [  256-1:0] dout36       ;
    wire [  256-1:0] dout37       ;
    wire [  256-1:0] dout38       ;
    wire [  256-1:0] dout39       ;
    wire [  256-1:0] dout40       ;
    wire [  256-1:0] dout41       ;
    wire [  256-1:0] dout42       ;
    wire [  256-1:0] dout43       ;
    //bg4_output ports
    wire [255:0] bg4_out_dout_0,bg4_out_dout_1,bg4_out_dout_2,bg4_out_dout_3,bg4_out_dout_4,bg4_out_dout_5,bg4_out_dout_6,bg4_out_dout_7,bg4_out_dout_8,bg4_out_dout_9,bg4_out_dout_a,bg4_out_dout_b,bg4_out_dout_c,bg4_out_dout_d,bg4_out_dout_e,bg4_out_dout_f;
    wire [1024-1:0] dout_ip;
    //bf_array ports
    wire [255:0] bf_0_upper [3:0];
    wire [255:0] bf_1_upper [3:0];
    wire [255:0] bf_2_upper [3:0];
    wire [255:0] bf_3_upper [3:0];
    wire [255:0] bf_0_lower [3:0];
    wire [255:0] bf_1_lower [3:0];
    wire [255:0] bf_2_lower [3:0];
    wire [255:0] bf_3_lower [3:0];
    wire [383:0] msm_o_0, msm_o_1, msm_o_2;
    //msm_top ports
    wire [256-1:0] scalar_out_sram;
    wire [384*2-1:0] point_out_sram;
    wire [384*2-1:0] point_in_dram = {data_in_2,data_in_1,data_in_0};
    wire [5+384*3-1:0] result_padd = {scalar_out_sram[4:0],msm_o_2, msm_o_1, msm_o_0};//
    wire [$clog2(2560)-1:0]           msm_r_addr_id_mem        ; //11bit
    wire [$clog2(2560)-1:0]           msm_r_addr_p_mem         ;
    wire [$clog2(2560)-1:0]           msm_w_addr_mem           ; //for loading
    wire                              msm_r_en_id_mem          ;
    wire                              msm_r_en_p_mem           ;
    wire                              msm_w_en_mem             ;
    wire [383:0] x1, y1, z1, x2, y2, z2; //
    wire [5+384*3-1:0]  data_2_padd_a      ;
    wire [5+384*3-1:0]  data_2_padd_b      ;
    assign x1 = data_2_padd_a[384*2 +: 384];
    assign y1 = data_2_padd_a[384*1 +: 384];
    assign z1 = data_2_padd_a[384*0 +: 384];
    assign x2 = data_2_padd_b[384*2 +: 384];
    assign y2 = data_2_padd_b[384*1 +: 384];
    assign z2 = data_2_padd_b[384*0 +: 384];
    wire dram_ld_start_msm, dram_ld_start_ntt;
    assign dram_ld_start = dram_ld_start_msm || dram_ld_start_ntt;
    wire done_msm;
    //top_poly_mul ports
    wire [ 7*8-1:0] addr_ntt [3:0]; //8*4 7-bit
    wire [ 4*8-1:0]  wen_ntt      ; //8*4 1-bit
    wire [ 4*8-1:0]   en_ntt      ; //8*4 1-bit
    assign bg_in_ntt_addr = {addr_ntt[3],addr_ntt[2],addr_ntt[1],addr_ntt[0]};
    wire [9-1:0] tf_address_0, tf_address_1, tf_address_2, tf_address_3;
    wire tf_ren;
    wire [3:0] top_mul_done_w;
    wire [3:0] top_mul_done_flag_w [3:0];
    wire [256*4-1:0] data_o_0_ntt [3:0];
    wire [256*4-1:0] data_o_1_ntt [3:0];
    wire [256*4-1:0] data_o_2_ntt [3:0];
    wire [256*4-1:0] data_o_3_ntt [3:0];
    wire [256*4-1:0] data_o_4_ntt [3:0];
    wire [256*4-1:0] data_o_5_ntt [3:0];
    wire [256*4-1:0] data_o_6_ntt [3:0];
    wire [256*4-1:0] data_o_7_ntt [3:0];
    reg  [256*4-1:0] q_0      [3:0];
    reg  [256*4-1:0] q_1      [3:0];
    reg  [256*4-1:0] q_2      [3:0];
    reg  [256*4-1:0] q_3      [3:0];
    reg  [256*4-1:0] q_4      [3:0];
    reg  [256*4-1:0] q_5      [3:0];
    reg  [256*4-1:0] q_6      [3:0];
    reg  [256*4-1:0] q_7      [3:0];
    integer l;
    always @(*)begin
        for (l=0;l<4;l=l+1)begin
            q_0[l] = {bg_out_dout[l][24*256+:256],bg_out_dout[l][8 *256+256],bg_out_dout[l][16*256+:256],bg_out_dout[l][0*256+:256]};
            q_1[l] = {bg_out_dout[l][25*256+:256],bg_out_dout[l][9 *256+256],bg_out_dout[l][17*256+:256],bg_out_dout[l][1*256+:256]};
            q_2[l] = {bg_out_dout[l][26*256+:256],bg_out_dout[l][10*256+256],bg_out_dout[l][18*256+:256],bg_out_dout[l][2*256+:256]};
            q_3[l] = {bg_out_dout[l][27*256+:256],bg_out_dout[l][11*256+256],bg_out_dout[l][19*256+:256],bg_out_dout[l][3*256+:256]};
            q_4[l] = {bg_out_dout[l][28*256+:256],bg_out_dout[l][12*256+256],bg_out_dout[l][20*256+:256],bg_out_dout[l][4*256+:256]};
            q_5[l] = {bg_out_dout[l][29*256+:256],bg_out_dout[l][13*256+256],bg_out_dout[l][21*256+:256],bg_out_dout[l][5*256+:256]};
            q_6[l] = {bg_out_dout[l][30*256+:256],bg_out_dout[l][14*256+256],bg_out_dout[l][22*256+:256],bg_out_dout[l][6*256+:256]};
            q_7[l] = {bg_out_dout[l][31*256+:256],bg_out_dout[l][15*256+256],bg_out_dout[l][23*256+:256],bg_out_dout[l][7*256+:256]};
        end
    end
    reg [256*4-1:0] q_0_ntt      [3:0];
    reg [256*4-1:0] q_1_ntt      [3:0];
    reg [256*4-1:0] q_2_ntt      [3:0];
    reg [256*4-1:0] q_3_ntt      [3:0];
    reg [256*4-1:0] q_4_ntt      [3:0];
    reg [256*4-1:0] q_5_ntt      [3:0];
    reg [256*4-1:0] q_6_ntt      [3:0];
    reg [256*4-1:0] q_7_ntt      [3:0];
    integer m;
    always @(*)begin
        for (m=0;m<4;m=m+1)begin
            q_0_ntt[m]  = (flag_msm) ? 0 : q_0[m];
            q_1_ntt[m]  = (flag_msm) ? 0 : q_1[m];
            q_2_ntt[m]  = (flag_msm) ? 0 : q_2[m];
            q_3_ntt[m]  = (flag_msm) ? 0 : q_3[m];
            q_4_ntt[m]  = (flag_msm) ? 0 : q_4[m];
            q_5_ntt[m]  = (flag_msm) ? 0 : q_5[m];
            q_6_ntt[m]  = (flag_msm) ? 0 : q_6[m];
            q_7_ntt[m]  = (flag_msm) ? 0 : q_7[m];
        end
    end
    wire [256-1:0] w_0, w_1, w_2, w_3;
    wire [3:0]   sel             ;
    wire [255:0] a_i0 [3:0];
    wire [255:0] a_i1 [3:0];
    wire [255:0] a_i2 [3:0];
    wire [255:0] a_i3 [3:0];
    wire [255:0] b_i0 [3:0];
    wire [255:0] b_i1 [3:0];
    wire [255:0] b_i2 [3:0];
    wire [255:0] b_i3 [3:0];
    wire [255:0] w_in0 [3:0];
    wire [255:0] w_in1 [3:0];
    wire [255:0] w_in2 [3:0];
    wire [255:0] w_in3 [3:0];
    wire [383:0] a_i0_0 = {128'd0 , a_i0[0]};
    wire [383:0] a_i1_0 = {128'd0 , a_i1[0]};
    wire [383:0] a_i2_0 = (flag_msm) ? x2:{128'd0 , a_i2[0]};
    wire [383:0] a_i3_0 = {128'd0 , a_i3[0]};
    wire [383:0] a_i0_1 = {128'd0 , a_i0[1]};
    wire [383:0] a_i1_1 = (flag_msm) ? x1:{128'd0 , a_i1[1]};
    wire [383:0] a_i2_1 = (flag_msm) ? y2:{128'd0 , a_i2[1]};
    wire [383:0] a_i3_1 = {128'd0 , a_i3[1]};
    wire [383:0] a_i0_2 = {128'd0 , a_i0[2]};
    wire [383:0] a_i1_2 = (flag_msm) ? y1:{128'd0 , a_i1[2]};
    wire [383:0] a_i2_2 = (flag_msm) ? z2:{128'd0 , a_i2[2]};
    wire [383:0] a_i3_2 = {128'd0 , a_i3[2]};
    wire [383:0] a_i0_3 = {128'd0 , a_i0[3]};
    wire [383:0] a_i1_3 = (flag_msm) ? z1:{128'd0 , a_i1[3]};
    wire [383:0] a_i2_3 = {128'd0 , a_i2[3]};
    wire [383:0] a_i3_3 = {128'd0 , a_i3[3]};
    wire [383:0] b_i0_0 = {128'd0 , b_i0[0]};
    wire [383:0] b_i1_0 = {128'd0 , b_i1[0]};
    wire [383:0] b_i2_0 = {128'd0 , b_i2[0]};
    wire [383:0] b_i3_0 = {128'd0 , b_i3[0]};
    wire [383:0] b_i0_1 = {128'd0 , b_i0[1]};
    wire [383:0] b_i1_1 = {128'd0 , b_i1[1]};
    wire [383:0] b_i2_1 = {128'd0 , b_i2[1]};
    wire [383:0] b_i3_1 = {128'd0 , b_i3[1]};
    wire [383:0] b_i0_2 = {128'd0 , b_i0[2]};
    wire [383:0] b_i1_2 = {128'd0 , b_i1[2]};
    wire [383:0] b_i2_2 = {128'd0 , b_i2[2]};
    wire [383:0] b_i3_2 = {128'd0 , b_i3[2]};
    wire [383:0] b_i0_3 = {128'd0 , b_i0[3]};
    wire [383:0] b_i1_3 = {128'd0 , b_i1[3]};
    wire [383:0] b_i2_3 = {128'd0 , b_i2[3]};
    wire [383:0] b_i3_3 = {128'd0 , b_i3[3]};
    //bg5_input_logic ports
    wire [8*7-1:0] bg5_in_addr_out;
    wire [8-1:0] bg5_in_ce_out, bg5_in_wen_out;
    wire [256-1:0] bg5_in_dout0,bg5_in_dout1,bg5_in_dout2,bg5_in_dout3,bg5_in_dout4,bg5_in_dout5,bg5_in_dout6,bg5_in_dout7;
    //bank_group5 ports
    wire [256-1:0] bg5_dout_0,bg5_dout_1,bg5_dout_2,bg5_dout_3,bg5_dout_4,bg5_dout_5,bg5_dout_6,bg5_dout_7;
    //bg5_output_logic ports
    wire [256-1:0] bg5_out_dout_0,bg5_out_dout_1,bg5_out_dout_2,bg5_out_dout_3;
    //tf_gen_top ports
    wire tf_gen_done_row, tf_gen_done;
    wire [255:0] tf_o_0,tf_o_1,tf_o_2,tf_o_3,tf_o_4,tf_o_5,tf_o_6,tf_o_7,tf_o_8,tf_o_9,tf_o_a,tf_o_b,tf_o_c,tf_o_d,tf_o_e,tf_o_f;
    //top_controller ports
    wire top_mul_done = top_mul_done_w[0]; //all 4 top_mul done signals arrive at the same time
    wire [3:0] top_mul_done_flag = top_mul_done_flag_w[0]; //all 4 top_mul done_flag signals are the same at one time
    wire tf_gen_start, top_mul_start;
    wire [2:0] top_mul_conf;
    wire tf_gen_wen, tf_gen_ren; //tf_gen_wen:write seed to seed bank
    assign tf_gen_wen = wen_ntt[0];
    wire [7:0] tf_gen_addr_r, tf_gen_addr_w;
    assign tf_gen_addr_w = load_addr_in[0][7:0];//
    reg cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) cnt <= 1'b 0;
        else cnt <= ~cnt;
    end
    wire [512-1:0] data_load_in;
    wire bank_group_sel;
    assign data_load_in = (bank_group_sel) ? ((cnt)?{data_in_0,data_in_1}:{data_in_2,data_in_3}):
                          ((cnt)?{scalar_out_sram,point_out_sram[767-:256]}:{point_out_sram[0+:256]});
    bank_load_logic #(.WIDTH_DATA_LOAD(512)) bank_load_logic_U0(
        .bg_sel        (bg_sel),
        .flag_msm      (flag_msm),
        .ntt_load_addr (ntt_load_addr),//
        .ntt_load_en   (ntt_load_en  ),//
        .ntt_load_wen  (ntt_load_wen ),//
        .msm_load_addr (msm_w_addr_mem),
        .msm_load_en   (msm_w_en_mem),
        .msm_load_wen  (msm_w_en_mem),
        .data_load_in  ({data_in_0,data_in_1}),//
        .bg_ce         (ce_load),
        .load_addr_out0(load_addr_in[0]),
        .load_addr_out1(load_addr_in[1]),
        .load_addr_out2(load_addr_in[2]),
        .load_addr_out3(load_addr_in[3]),
        .load_addr_out4(load_addr_in[4]),
        .load_addr_out5(load_addr_in[5]),
        .data_load_out0(data_load_out[0]),
        .data_load_out1(data_load_out[1]),
        .data_load_out2(data_load_out[2]),
        .data_load_out3(data_load_out[3]),
        .data_load_out4(data_load_out[4]),
        .data_load_out5(data_load_out[5]),
        .load_wen_out  (wen_load) 
    );
//////////////////////////bank_group 0 ~ 3 /////////////////////////////////////////
    genvar i;
    generate for(i=0;i<4;i=i+1)begin:gen_bg
        bg_input_logic bg_input_logic_U(
            .flag_msm     (flag_msm),
            .load_addr_in (load_addr_in[i]),
            .ce_load      (ce_load     [i]),
            .wen_load     (wen_load    [i]),
            .msm_addr_in  (msm_r_addr_id_mem),
            .ce_msm       (msm_r_en_id_mem),
            .ren_msm      (msm_r_en_id_mem),
            .ntt_addr_in  (bg_in_ntt_addr),
            .ce_ntt       (en_ntt),
            .wen_ntt      (wen_ntt),
            .data_load_in (data_load_out[i]),
            .din0         (data_o_0_ntt[0][256*0+:256]),
            .din1         (data_o_1_ntt[1][256*0+:256]),
            .din2         (data_o_2_ntt[2][256*0+:256]),
            .din3         (data_o_3_ntt[3][256*0+:256]),
            .din4         (data_o_4_ntt[4][256*0+:256]),
            .din5         (data_o_5_ntt[5][256*0+:256]),
            .din6         (data_o_6_ntt[6][256*0+:256]),
            .din7         (data_o_7_ntt[7][256*0+:256]),
            .din8         (data_o_0_ntt[0][256*1+:256]),
            .din9         (data_o_1_ntt[1][256*1+:256]),
            .din10        (data_o_2_ntt[2][256*1+:256]),
            .din11        (data_o_3_ntt[3][256*1+:256]),
            .din12        (data_o_4_ntt[4][256*1+:256]),
            .din13        (data_o_5_ntt[5][256*1+:256]),
            .din14        (data_o_6_ntt[6][256*1+:256]),
            .din15        (data_o_7_ntt[7][256*1+:256]),
            .din16        (data_o_0_ntt[0][256*2+:256]),
            .din17        (data_o_1_ntt[1][256*2+:256]),
            .din18        (data_o_2_ntt[2][256*2+:256]),
            .din19        (data_o_3_ntt[3][256*2+:256]),
            .din20        (data_o_4_ntt[4][256*2+:256]),
            .din21        (data_o_5_ntt[5][256*2+:256]),
            .din22        (data_o_6_ntt[6][256*2+:256]),
            .din23        (data_o_7_ntt[7][256*2+:256]),
            .din24        (data_o_0_ntt[0][256*3+:256]),
            .din25        (data_o_1_ntt[1][256*3+:256]),
            .din26        (data_o_2_ntt[2][256*3+:256]),
            .din27        (data_o_3_ntt[3][256*3+:256]),
            .din28        (data_o_4_ntt[4][256*3+:256]),
            .din29        (data_o_5_ntt[5][256*3+:256]),
            .din30        (data_o_6_ntt[6][256*3+:256]),
            .din31        (data_o_7_ntt[7][256*3+:256]),
            .addr_out     (bg_in_addr_out    [i]),
            .ce_out       (bg_in_ce_out      [i]),
            .wen_out      (bg_in_wen_out     [i]),
            .dout0        (bg_in_dout[i][0 *256+:256]),
            .dout1        (bg_in_dout[i][1 *256+:256]),
            .dout2        (bg_in_dout[i][2 *256+:256]),
            .dout3        (bg_in_dout[i][3 *256+:256]),
            .dout4        (bg_in_dout[i][4 *256+:256]),
            .dout5        (bg_in_dout[i][5 *256+:256]),
            .dout6        (bg_in_dout[i][6 *256+:256]),
            .dout7        (bg_in_dout[i][7 *256+:256]),
            .dout8        (bg_in_dout[i][8 *256+:256]),
            .dout9        (bg_in_dout[i][9 *256+:256]),
            .dout10       (bg_in_dout[i][10*256+:256]),
            .dout11       (bg_in_dout[i][11*256+:256]),
            .dout12       (bg_in_dout[i][12*256+:256]),
            .dout13       (bg_in_dout[i][13*256+:256]),
            .dout14       (bg_in_dout[i][14*256+:256]),
            .dout15       (bg_in_dout[i][15*256+:256]),
            .dout16       (bg_in_dout[i][16*256+:256]),
            .dout17       (bg_in_dout[i][17*256+:256]),
            .dout18       (bg_in_dout[i][18*256+:256]),
            .dout19       (bg_in_dout[i][19*256+:256]),
            .dout20       (bg_in_dout[i][20*256+:256]),
            .dout21       (bg_in_dout[i][21*256+:256]),
            .dout22       (bg_in_dout[i][22*256+:256]),
            .dout23       (bg_in_dout[i][23*256+:256]),
            .dout24       (bg_in_dout[i][24*256+:256]),
            .dout25       (bg_in_dout[i][25*256+:256]),
            .dout26       (bg_in_dout[i][26*256+:256]),
            .dout27       (bg_in_dout[i][27*256+:256]),
            .dout28       (bg_in_dout[i][28*256+:256]),
            .dout29       (bg_in_dout[i][29*256+:256]),
            .dout30       (bg_in_dout[i][30*256+:256]),
            .dout31       (bg_in_dout[i][31*256+:256])
        );
        MEM_BG bank_group0(
            .clk         (clk),
            .bg_en_0     (bg_in_ce_out[i][0 ]),
            .bg_en_1     (bg_in_ce_out[i][1 ]),
            .bg_en_2     (bg_in_ce_out[i][2 ]),
            .bg_en_3     (bg_in_ce_out[i][3 ]),
            .bg_en_4     (bg_in_ce_out[i][4 ]),
            .bg_en_5     (bg_in_ce_out[i][5 ]),
            .bg_en_6     (bg_in_ce_out[i][6 ]),
            .bg_en_7     (bg_in_ce_out[i][7 ]),
            .bg_en_8     (bg_in_ce_out[i][8 ]),
            .bg_en_9     (bg_in_ce_out[i][9 ]),
            .bg_en_10    (bg_in_ce_out[i][10]),
            .bg_en_11    (bg_in_ce_out[i][11]),
            .bg_en_12    (bg_in_ce_out[i][12]),
            .bg_en_13    (bg_in_ce_out[i][13]),
            .bg_en_14    (bg_in_ce_out[i][14]),
            .bg_en_15    (bg_in_ce_out[i][15]),
            .bg_en_16    (bg_in_ce_out[i][16]),
            .bg_en_17    (bg_in_ce_out[i][17]),
            .bg_en_18    (bg_in_ce_out[i][18]),
            .bg_en_19    (bg_in_ce_out[i][19]),
            .bg_en_20    (bg_in_ce_out[i][20]),
            .bg_en_21    (bg_in_ce_out[i][21]),
            .bg_en_22    (bg_in_ce_out[i][22]),
            .bg_en_23    (bg_in_ce_out[i][23]),
            .bg_en_24    (bg_in_ce_out[i][24]),
            .bg_en_25    (bg_in_ce_out[i][25]),
            .bg_en_26    (bg_in_ce_out[i][26]),
            .bg_en_27    (bg_in_ce_out[i][27]),
            .bg_en_28    (bg_in_ce_out[i][28]),
            .bg_en_29    (bg_in_ce_out[i][29]),
            .bg_en_30    (bg_in_ce_out[i][30]),
            .bg_en_31    (bg_in_ce_out[i][31]),
            .bg_wen_0    (bg_in_wen_out[i][0 ]),
            .bg_wen_1    (bg_in_wen_out[i][1 ]),
            .bg_wen_2    (bg_in_wen_out[i][2 ]),
            .bg_wen_3    (bg_in_wen_out[i][3 ]),
            .bg_wen_4    (bg_in_wen_out[i][4 ]),
            .bg_wen_5    (bg_in_wen_out[i][5 ]),
            .bg_wen_6    (bg_in_wen_out[i][6 ]),
            .bg_wen_7    (bg_in_wen_out[i][7 ]),
            .bg_wen_8    (bg_in_wen_out[i][8 ]),
            .bg_wen_9    (bg_in_wen_out[i][9 ]),
            .bg_wen_10   (bg_in_wen_out[i][10]),
            .bg_wen_11   (bg_in_wen_out[i][11]),
            .bg_wen_12   (bg_in_wen_out[i][12]),
            .bg_wen_13   (bg_in_wen_out[i][13]),
            .bg_wen_14   (bg_in_wen_out[i][14]),
            .bg_wen_15   (bg_in_wen_out[i][15]),
            .bg_wen_16   (bg_in_wen_out[i][16]),
            .bg_wen_17   (bg_in_wen_out[i][17]),
            .bg_wen_18   (bg_in_wen_out[i][18]),
            .bg_wen_19   (bg_in_wen_out[i][19]),
            .bg_wen_20   (bg_in_wen_out[i][20]),
            .bg_wen_21   (bg_in_wen_out[i][21]),
            .bg_wen_22   (bg_in_wen_out[i][22]),
            .bg_wen_23   (bg_in_wen_out[i][23]),
            .bg_wen_24   (bg_in_wen_out[i][24]),
            .bg_wen_25   (bg_in_wen_out[i][25]),
            .bg_wen_26   (bg_in_wen_out[i][26]),
            .bg_wen_27   (bg_in_wen_out[i][27]),
            .bg_wen_28   (bg_in_wen_out[i][28]),
            .bg_wen_29   (bg_in_wen_out[i][29]),
            .bg_wen_30   (bg_in_wen_out[i][30]),
            .bg_wen_31   (bg_in_wen_out[i][31]),
            .bg_addr_0   (bg_in_addr_out[i][0 *7+:7]),
            .bg_addr_1   (bg_in_addr_out[i][1 *7+:7]),
            .bg_addr_2   (bg_in_addr_out[i][2 *7+:7]),
            .bg_addr_3   (bg_in_addr_out[i][3 *7+:7]),
            .bg_addr_4   (bg_in_addr_out[i][4 *7+:7]),
            .bg_addr_5   (bg_in_addr_out[i][5 *7+:7]),
            .bg_addr_6   (bg_in_addr_out[i][6 *7+:7]),
            .bg_addr_7   (bg_in_addr_out[i][7 *7+:7]),
            .bg_addr_8   (bg_in_addr_out[i][8 *7+:7]),
            .bg_addr_9   (bg_in_addr_out[i][9 *7+:7]),
            .bg_addr_10  (bg_in_addr_out[i][10*7+:7]),
            .bg_addr_11  (bg_in_addr_out[i][11*7+:7]),
            .bg_addr_12  (bg_in_addr_out[i][12*7+:7]),
            .bg_addr_13  (bg_in_addr_out[i][13*7+:7]),
            .bg_addr_14  (bg_in_addr_out[i][14*7+:7]),
            .bg_addr_15  (bg_in_addr_out[i][15*7+:7]),
            .bg_addr_16  (bg_in_addr_out[i][16*7+:7]),
            .bg_addr_17  (bg_in_addr_out[i][17*7+:7]),
            .bg_addr_18  (bg_in_addr_out[i][18*7+:7]),
            .bg_addr_19  (bg_in_addr_out[i][19*7+:7]),
            .bg_addr_20  (bg_in_addr_out[i][20*7+:7]),
            .bg_addr_21  (bg_in_addr_out[i][21*7+:7]),
            .bg_addr_22  (bg_in_addr_out[i][22*7+:7]),
            .bg_addr_23  (bg_in_addr_out[i][23*7+:7]),
            .bg_addr_24  (bg_in_addr_out[i][24*7+:7]),
            .bg_addr_25  (bg_in_addr_out[i][25*7+:7]),
            .bg_addr_26  (bg_in_addr_out[i][26*7+:7]),
            .bg_addr_27  (bg_in_addr_out[i][27*7+:7]),
            .bg_addr_28  (bg_in_addr_out[i][28*7+:7]),
            .bg_addr_29  (bg_in_addr_out[i][29*7+:7]),
            .bg_addr_30  (bg_in_addr_out[i][30*7+:7]),
            .bg_addr_31  (bg_in_addr_out[i][31*7+:7]),
            .bg_din_0    (bg_in_dout[i][0 *256+:256]),
            .bg_din_1    (bg_in_dout[i][1 *256+:256]),
            .bg_din_2    (bg_in_dout[i][2 *256+:256]),
            .bg_din_3    (bg_in_dout[i][3 *256+:256]),
            .bg_din_4    (bg_in_dout[i][4 *256+:256]),
            .bg_din_5    (bg_in_dout[i][5 *256+:256]),
            .bg_din_6    (bg_in_dout[i][6 *256+:256]),
            .bg_din_7    (bg_in_dout[i][7 *256+:256]),
            .bg_din_8    (bg_in_dout[i][8 *256+:256]),
            .bg_din_9    (bg_in_dout[i][9 *256+:256]),
            .bg_din_10   (bg_in_dout[i][10*256+:256]),
            .bg_din_11   (bg_in_dout[i][11*256+:256]),
            .bg_din_12   (bg_in_dout[i][12*256+:256]),
            .bg_din_13   (bg_in_dout[i][13*256+:256]),
            .bg_din_14   (bg_in_dout[i][14*256+:256]),
            .bg_din_15   (bg_in_dout[i][15*256+:256]),
            .bg_din_16   (bg_in_dout[i][16*256+:256]),
            .bg_din_17   (bg_in_dout[i][17*256+:256]),
            .bg_din_18   (bg_in_dout[i][18*256+:256]),
            .bg_din_19   (bg_in_dout[i][19*256+:256]),
            .bg_din_20   (bg_in_dout[i][20*256+:256]),
            .bg_din_21   (bg_in_dout[i][21*256+:256]),
            .bg_din_22   (bg_in_dout[i][22*256+:256]),
            .bg_din_23   (bg_in_dout[i][23*256+:256]),
            .bg_din_24   (bg_in_dout[i][24*256+:256]),
            .bg_din_25   (bg_in_dout[i][25*256+:256]),
            .bg_din_26   (bg_in_dout[i][26*256+:256]),
            .bg_din_27   (bg_in_dout[i][27*256+:256]),
            .bg_din_28   (bg_in_dout[i][28*256+:256]),
            .bg_din_29   (bg_in_dout[i][29*256+:256]),
            .bg_din_30   (bg_in_dout[i][30*256+:256]),
            .bg_din_31   (bg_in_dout[i][31*256+:256]),
            .bg_dout_0   (bg_dout[i][0 *256+:256]),
            .bg_dout_1   (bg_dout[i][1 *256+:256]),
            .bg_dout_2   (bg_dout[i][2 *256+:256]),
            .bg_dout_3   (bg_dout[i][3 *256+:256]),
            .bg_dout_4   (bg_dout[i][4 *256+:256]),
            .bg_dout_5   (bg_dout[i][5 *256+:256]),
            .bg_dout_6   (bg_dout[i][6 *256+:256]),
            .bg_dout_7   (bg_dout[i][7 *256+:256]),
            .bg_dout_8   (bg_dout[i][8 *256+:256]),
            .bg_dout_9   (bg_dout[i][9 *256+:256]),
            .bg_dout_10  (bg_dout[i][10*256+:256]),
            .bg_dout_11  (bg_dout[i][11*256+:256]),
            .bg_dout_12  (bg_dout[i][12*256+:256]),
            .bg_dout_13  (bg_dout[i][13*256+:256]),
            .bg_dout_14  (bg_dout[i][14*256+:256]),
            .bg_dout_15  (bg_dout[i][15*256+:256]),
            .bg_dout_16  (bg_dout[i][16*256+:256]),
            .bg_dout_17  (bg_dout[i][17*256+:256]),
            .bg_dout_18  (bg_dout[i][18*256+:256]),
            .bg_dout_19  (bg_dout[i][19*256+:256]),
            .bg_dout_20  (bg_dout[i][20*256+:256]),
            .bg_dout_21  (bg_dout[i][21*256+:256]),
            .bg_dout_22  (bg_dout[i][22*256+:256]),
            .bg_dout_23  (bg_dout[i][23*256+:256]),
            .bg_dout_24  (bg_dout[i][24*256+:256]),
            .bg_dout_25  (bg_dout[i][25*256+:256]),
            .bg_dout_26  (bg_dout[i][26*256+:256]),
            .bg_dout_27  (bg_dout[i][27*256+:256]),
            .bg_dout_28  (bg_dout[i][28*256+:256]),
            .bg_dout_29  (bg_dout[i][29*256+:256]),
            .bg_dout_30  (bg_dout[i][30*256+:256]),
            .bg_dout_31  (bg_dout[i][31*256+:256])
        );
        bg_output_logic bg_output_logic_U(  //in msm mode: only use dout0,dout1,dout2,dout3 four output ports
            .clk      (clk),
            .flag_msm (flag_msm),
            .ce_in    (bg_in_ce_out[i]),
            .din0     (bg_dout[i][0 *256+:256]),
            .din1     (bg_dout[i][1 *256+:256]),
            .din2     (bg_dout[i][2 *256+:256]),
            .din3     (bg_dout[i][3 *256+:256]),
            .din4     (bg_dout[i][4 *256+:256]),
            .din5     (bg_dout[i][5 *256+:256]),
            .din6     (bg_dout[i][6 *256+:256]),
            .din7     (bg_dout[i][7 *256+:256]),
            .din8     (bg_dout[i][8 *256+:256]),
            .din9     (bg_dout[i][9 *256+:256]),
            .din10    (bg_dout[i][10*256+:256]),
            .din11    (bg_dout[i][11*256+:256]),
            .din12    (bg_dout[i][12*256+:256]),
            .din13    (bg_dout[i][13*256+:256]),
            .din14    (bg_dout[i][14*256+:256]),
            .din15    (bg_dout[i][15*256+:256]),
            .din16    (bg_dout[i][16*256+:256]),
            .din17    (bg_dout[i][17*256+:256]),
            .din18    (bg_dout[i][18*256+:256]),
            .din19    (bg_dout[i][19*256+:256]),
            .din20    (bg_dout[i][20*256+:256]),
            .din21    (bg_dout[i][21*256+:256]),
            .din22    (bg_dout[i][22*256+:256]),
            .din23    (bg_dout[i][23*256+:256]),
            .din24    (bg_dout[i][24*256+:256]),
            .din25    (bg_dout[i][25*256+:256]),
            .din26    (bg_dout[i][26*256+:256]),
            .din27    (bg_dout[i][27*256+:256]),
            .din28    (bg_dout[i][28*256+:256]),
            .din29    (bg_dout[i][29*256+:256]),
            .din30    (bg_dout[i][30*256+:256]),
            .din31    (bg_dout[i][31*256+:256]),
            .dout0    (bg_out_dout[i][0 *256+:256]),
            .dout1    (bg_out_dout[i][1 *256+:256]),
            .dout2    (bg_out_dout[i][2 *256+:256]),
            .dout3    (bg_out_dout[i][3 *256+:256]),
            .dout4    (bg_out_dout[i][4 *256+:256]),
            .dout5    (bg_out_dout[i][5 *256+:256]),
            .dout6    (bg_out_dout[i][6 *256+:256]),
            .dout7    (bg_out_dout[i][7 *256+:256]),
            .dout8    (bg_out_dout[i][8 *256+:256]),
            .dout9    (bg_out_dout[i][9 *256+:256]),
            .dout10   (bg_out_dout[i][10*256+:256]),
            .dout11   (bg_out_dout[i][11*256+:256]),
            .dout12   (bg_out_dout[i][12*256+:256]),
            .dout13   (bg_out_dout[i][13*256+:256]),
            .dout14   (bg_out_dout[i][14*256+:256]),
            .dout15   (bg_out_dout[i][15*256+:256]),
            .dout16   (bg_out_dout[i][16*256+:256]),
            .dout17   (bg_out_dout[i][17*256+:256]),
            .dout18   (bg_out_dout[i][18*256+:256]),
            .dout19   (bg_out_dout[i][19*256+:256]),
            .dout20   (bg_out_dout[i][20*256+:256]),
            .dout21   (bg_out_dout[i][21*256+:256]),
            .dout22   (bg_out_dout[i][22*256+:256]),
            .dout23   (bg_out_dout[i][23*256+:256]),
            .dout24   (bg_out_dout[i][24*256+:256]),
            .dout25   (bg_out_dout[i][25*256+:256]),
            .dout26   (bg_out_dout[i][26*256+:256]),
            .dout27   (bg_out_dout[i][27*256+:256]),
            .dout28   (bg_out_dout[i][28*256+:256]),
            .dout29   (bg_out_dout[i][29*256+:256]),
            .dout30   (bg_out_dout[i][30*256+:256]),
            .dout31   (bg_out_dout[i][31*256+:256]) 
        );
    end
    endgenerate
////////////////////////////////////////////////////////////////////////////////////
//////////////////////////bank_group 4     /////////////////////////////////////////
    bg4_input_logic bg4_input_logic_U4(
        .flag_msm            (flag_msm),
        .bg_sel              (bg_sel),
        .load_addr_in        (load_addr_in[4]),
        .ce_load             (ce_load[4]),
        .wen_load            (wen_load[4]),
        .msm_r_addr_id_in    (msm_r_addr_id_mem),
        .ce_r_id_msm         (msm_r_en_id_mem),
        .ren_id_msm          (msm_r_en_id_mem),
        .msm_r_addr_bk_in_a  (r_addr_bucket_a),
        .ce_r_bk_msm_a       (r_en_bucket_a),
        .ren_bk_msm_a        (r_en_bucket_a),
        .msm_r_addr_bk_in_b  (r_addr_bucket_b),
        .ce_r_bk_msm_b       (r_en_bucket_b),
        .ren_bk_msm_b        (r_en_bucket_b),
        .msm_w_addr_bk_in_a  (w_addr_bucket_a),
        .ce_w_bk_msm_a       (w_en_bucket_a),
        .wen_bk_msm_a        (w_en_bucket_a),
        .msm_w_addr_bk_in_b  (w_addr_bucket_b),
        .ce_w_bk_msm_b       (w_en_bucket_b),
        .wen_bk_msm_b        (w_en_bucket_b),
        .msm_w_addr_rb_in    (fifo_w_addr),
        .ce_w_rb_msm         (fifo_w_en),
        .wen_rb_msm          (fifo_w_en),
        .msm_r_addr_rb_in    (fifo_r_addr),
        .ce_r_rb_msm         (fifo_r_en),
        .ren_rb_msm          (fifo_r_en),
        .tf_gen_addr_in      (tf_bank_addr),
        .ce_tf_gen           (tf_bank_en),
        .wen_tf_gen          (~tf_bank_web),
        .ren_tf_gen          (tf_bank_web),
        .data_load_in        (data_load_out[4]),
        .din0                (bg4_din_0),
        .din1                (bg4_din_1),
        .din2                (bg4_din_2),
        .din3                (bg4_din_3),
        .din4                (bg4_din_4),
        .din5                (bg4_din_5),
        .din6                (bg4_din_6),
        .din7                (bg4_din_7),
        .din8                (bg4_din_8),
        .din9                (bg4_din_9),
        .din10               (bg4_din_a),
        .din11               (bg4_din_b),
        .din12               (bg4_din_c),
        .din13               (bg4_din_d),
        .din14               (bg4_din_e),
        .din15               (bg4_din_f),
        .din_bk_a            (din_bk_a ),
        .din_bk_b            (din_bk_b ),
        .din_rb              (din_rb   ),
        .addr_outa           (addr_outa),
        .addr_outb           (addr_outb),
        .addr_out_r          (addr_out_r),
        .addr_out_w          (addr_out_w),
        .addr_out32          (addr_out32),
        .addr_out128         (addr_out128),
        .ce_outa             (ce_outa),
        .ce_outb             (ce_outb    ),
        .ce_out              (ce_out     ),
        .wen_outa            (wen_outa   ),
        .wen_outb            (wen_outb   ),
        .wen_out_t           (wen_out_t  ),
        .ren_out_t           (ren_out_t  ),
        .wen_out             (wen_out    ),
        .dout0a              (dout0a     ),
        .dout1a              (dout1a     ),
        .dout0b              (dout0b     ),
        .dout1b              (dout1b     ),
        .dout2               (dout2      ),
        .dout3               (dout3      ),
        .dout4               (dout4      ),
        .dout5               (dout5      ),
        .dout6               (dout6      ),
        .dout7               (dout7      ),
        .dout8               (dout8      ),
        .dout9               (dout9      ),
        .dout10              (dout10     ),
        .dout11a             (dout11a    ),
        .dout11b             (dout11b    ),
        .dout12              (dout12     ),
        .dout13              (dout13     ),
        .dout14              (dout14     ),
        .dout15              (dout15     ),
        .dout16              (dout16     ),
        .dout17              (dout17     ),
        .dout18              (dout18     ),
        .dout19              (dout19     ),
        .dout20              (dout20     ),
        .dout21              (dout21     ),
        .dout22a             (dout22a    ),
        .dout22b             (dout22b    ),
        .dout23              (dout23     ),
        .dout24              (dout24     ),
        .dout25              (dout25     ),
        .dout26              (dout26     ),
        .dout27              (dout27     ),
        .dout28              (dout28     ),
        .dout29              (dout29     ),
        .dout30              (dout30     ),
        .dout31              (dout31     ),
        .dout32              (dout32     ),
        .dout33a             (dout33a    ),
        .dout33b             (dout33b    ),
        .dout34              (dout34     ),
        .dout35              (dout35     ),
        .dout36              (dout36     ),
        .dout37              (dout37     ),
        .dout38              (dout38     ),
        .dout39              (dout39     ),
        .dout40              (dout40     ),
        .dout41              (dout41     ),
        .dout42              (dout42     ),
        .dout43              (dout43     )
    );
    wire [256-1:0] din0a ,din1a ,din0b ,din1b ,din2  ,din3  ,din4  ,din5  ;
    wire [256-1:0] din6  ,din7  ,din8  ,din9  ,din10 ,din11a,din11b,din12 ,din13 ,din14 ;
    wire [256-1:0] din15 ,din16 ,din17 ,din18 ,din19 ,din20 ,din21 ,din22a,din22b,din23 ;
    wire [256-1:0] din24 ,din25 ,din26 ,din27 ,din28 ,din29 ,din30 ,din31 ,din32 ,din33a;
    wire [256-1:0] din33b,din34 ,din35 ,din36 ,din37 ,din38 ,din39 ,din40 ,din41 ,din42 ,din43;
    MEM_BG4 bank_group4(
        .clk           (clk),
        .bg4_en_0_a    (ce_outa [0]),
        .bg4_en_0_b    (ce_outb [0]),
        .bg4_wen_0_a   (wen_outa[0]),
        .bg4_wen_0_b   (wen_outb[0]),
        .bg4_addr_0_a  (addr_outa[0*5+:5]),
        .bg4_addr_0_b  (addr_outb[0*5+:5]),
        .bg4_din_0_a   (dout0a),
        .bg4_din_0_b   (dout0b),
        .bg4_bwe_0_a   ({256{1'b1}}),
        .bg4_bwe_0_b   ({256{1'b1}}),
        .bg4_dout_0_a  (din0a),
        .bg4_dout_0_b  (din0b),
        .bg4_en_1_a    (ce_outa [1]),
        .bg4_en_1_b    (ce_outb [1]),
        .bg4_wen_1_a   (wen_outa[1]),
        .bg4_wen_1_b   (wen_outb[1]),
        .bg4_addr_1_a  (addr_outa[4*5+:5]),
        .bg4_addr_1_b  (addr_outb[4*5+:5]),
        .bg4_din_1_a   (dout1a),
        .bg4_din_1_b   (dout1b),
        .bg4_bwe_1_a   ({256{1'b1}}),
        .bg4_bwe_1_b   ({256{1'b1}}),
        .bg4_dout_1_a  (din1a),
        .bg4_dout_1_b  (din1b),
        .bg4_addr_2_a  (addr_out_w[3*5+:5]),
        .bg4_addr_2_b  (addr_out_r[3*5+:5]),
        .bg4_din_2     (dout2),
        .bg4_bwe_2     ({256{1'b1}}),
        .bg4_wen_2     (wen_out_t[3]),
        .bg4_ren_2     (ren_out_t[3]),
        .bg4_dout_2    (din2),
        .bg4_addr_3    (addr_out32[2*5+:5]),
        .bg4_din_3     (dout3),
        .bg4_en_3      (wen_out[0]),
        .bg4_wen_3     (wen_out[0]),
        .bg4_dout_3    (din3),
        .bg4_addr_4    (addr_out128[0*7+:7]),
        .bg4_din_4     (dout4),
        .bg4_en_4      (wen_out[1]),
        .bg4_wen_4     (wen_out[1]),
        .bg4_dout_4    (din4),
        .bg4_addr_5    (addr_out128[1*7+:7]),
        .bg4_din_5     (dout5),
        .bg4_en_5      (wen_out[2]),
        .bg4_wen_5     (wen_out[2]),
        .bg4_dout_5    (din5),
        .bg4_addr_6    (addr_out128[2*7+:7]),
        .bg4_din_6     (dout6),
        .bg4_en_6      (wen_out[3]),
        .bg4_wen_6     (wen_out[3]),
        .bg4_dout_6    (din6),
        .bg4_addr_7    (addr_out128[3*7+:7]),
        .bg4_din_7     (dout7),
        .bg4_en_7      (wen_out[4]),
        .bg4_wen_7     (wen_out[4]),
        .bg4_dout_7    (din7),
        .bg4_addr_8    (addr_out128[4*7+:7]),
        .bg4_din_8     (dout8),
        .bg4_en_8      (wen_out[5]),
        .bg4_wen_8     (wen_out[5]),
        .bg4_dout_8    (din8),
        .bg4_addr_9    (addr_out128[5*7+:7]),
        .bg4_din_9     (dout9),
        .bg4_en_9      (wen_out[6]),
        .bg4_wen_9     (wen_out[6]),
        .bg4_dout_9    (din9),
        .bg4_addr_10   (addr_out128[6*7+:7]),
        .bg4_din_10    (dout10),
        .bg4_en_10     (wen_out[7]),
        .bg4_wen_10    (wen_out[7]),
        .bg4_dout_10   (din10),
        .bg4_en_13_a   (ce_outa [2]),
        .bg4_en_13_b   (ce_outb [2]),
        .bg4_wen_13_a  (wen_outa [2]),
        .bg4_wen_13_b  (wen_outb [2]),
        .bg4_addr_13_a (addr_outa[1*5+:5]),
        .bg4_addr_13_b (addr_outb[1*5+:5]),
        .bg4_din_13_a  (dout11a),
        .bg4_din_13_b  (dout11b),
        .bg4_bwe_13_a  ({256{1'b1}}),
        .bg4_bwe_13_b  ({256{1'b1}}),
        .bg4_dout_13_a (din11a),
        .bg4_dout_13_b (din11b),
        .bg4_addr_14_a (addr_out_w[0*5+:5]),
        .bg4_addr_14_b (addr_out_r[0*5+:5]),
        .bg4_din_14    (dout12),
        .bg4_bwe_14    ({256{1'b1}}),
        .bg4_wen_14    (wen_out_t[0]),
        .bg4_ren_14    (ren_out_t[0]),
        .bg4_dout_14   (din12),
        .bg4_addr_15_a (addr_out_w[4*5+:5]),
        .bg4_addr_15_b (addr_out_r[4*5+:5]),
        .bg4_din_15    (dout13),
        .bg4_bwe_15    ({256{1'b1}}),
        .bg4_wen_15    (wen_out_t[4]),
        .bg4_ren_15    (ren_out_t[4]),
        .bg4_dout_15   (din13),
        .bg4_addr_16   (addr_out32[3*5+:5]),
        .bg4_din_16    (dout14),
        .bg4_en_16     (wen_out[8]),
        .bg4_wen_16    (wen_out[8]),
        .bg4_dout_16   (din14),
        .bg4_addr_17   (addr_out128[7*7+:7]),
        .bg4_din_17    (dout15),
        .bg4_en_17     (wen_out[9]),
        .bg4_wen_17    (wen_out[9]),
        .bg4_dout_17   (din15),
        .bg4_addr_18   (addr_out128[8*7+:7]),
        .bg4_din_18    (dout16),
        .bg4_en_18     (wen_out[10]),
        .bg4_wen_18    (wen_out[10]),
        .bg4_dout_18   (din16),
        .bg4_addr_19   (addr_out128[9*7+:7]),
        .bg4_din_19    (dout17),
        .bg4_en_19     (wen_out[11]),
        .bg4_wen_19    (wen_out[11]),
        .bg4_dout_19   (din17),
        .bg4_addr_20   (addr_out128[10*7+:7]),
        .bg4_din_20    (dout18),
        .bg4_en_20     (wen_out[12]),
        .bg4_wen_20    (wen_out[12]),
        .bg4_dout_20   (din18),
        .bg4_addr_21   (addr_out128[11*7+:7]),
        .bg4_din_21    (dout19),
        .bg4_en_21     (wen_out[13]),
        .bg4_wen_21    (wen_out[13]),
        .bg4_dout_21   (din19),
        .bg4_addr_22   (addr_out128[12*7+:7]),
        .bg4_din_22    (dout20),
        .bg4_en_22     (wen_out[14]),
        .bg4_wen_22    (wen_out[14]),
        .bg4_dout_22   (din20),
        .bg4_addr_23   (addr_out128[13*7+:7]),
        .bg4_din_23    (dout21),
        .bg4_en_23     (wen_out[15]),
        .bg4_wen_23    (wen_out[15]),
        .bg4_dout_23   (din21),
        .bg4_en_26_a   (ce_outa[3]),
        .bg4_en_26_b   (ce_outb[3]),
        .bg4_wen_26_a   (wen_outa[3]),
        .bg4_wen_26_b   (wen_outb[3]),
        .bg4_addr_26_a (addr_outa[2*5+:5]),
        .bg4_addr_26_b (addr_outb[2*5+:5]),
        .bg4_din_26_a  (dout22a),
        .bg4_din_26_b  (dout22b),
        .bg4_bwe_26_a  ({256{1'b1}}),
        .bg4_bwe_26_b  ({256{1'b1}}),
        .bg4_dout_26_a (din22a),
        .bg4_dout_26_b (din22b),
        .bg4_addr_27_a (addr_out_w[1*5+:5]),
        .bg4_addr_27_b (addr_out_r[1*5+:5]),
        .bg4_din_27    (dout23),
        .bg4_bwe_27    ({256{1'b1}}),
        .bg4_wen_27    (wen_out_t[1]),
        .bg4_ren_27    (ren_out_t[1]),
        .bg4_dout_27   (din23),
        .bg4_addr_28   (addr_out32[0*5+:5]),
        .bg4_din_28    (dout24),
        .bg4_en_28     (wen_out[16]),
        .bg4_wen_28    (wen_out[16]),
        .bg4_dout_28   (din24),
        .bg4_addr_29   (addr_out32[4*5+:5]),
        .bg4_din_29    (dout25),
        .bg4_en_29     (wen_out[17]),
        .bg4_wen_29    (wen_out[17]),
        .bg4_dout_29   (din25),
        .bg4_addr_30   (addr_out128[14*7+:7]),
        .bg4_din_30    (dout26),
        .bg4_en_30     (wen_out[18]),
        .bg4_wen_30    (wen_out[18]),
        .bg4_dout_30   (din26),
        .bg4_addr_31   (addr_out128[15*7+:7]),
        .bg4_din_31    (dout27),
        .bg4_en_31     (wen_out[19]),
        .bg4_wen_31    (wen_out[19]),
        .bg4_dout_31   (din27),
        .bg4_addr_32   (addr_out128[16*7+:7]),
        .bg4_din_32    (dout28),
        .bg4_en_32     (wen_out[20]),
        .bg4_wen_32    (wen_out[20]),
        .bg4_dout_32   (din28),
        .bg4_addr_33   (addr_out128[17*7+:7]),
        .bg4_din_33    (dout29),
        .bg4_en_33     (wen_out[21]),
        .bg4_wen_33    (wen_out[21]),
        .bg4_dout_33   (din29),
        .bg4_addr_34   (addr_out128[18*7+:7]),
        .bg4_din_34    (dout30),
        .bg4_en_34     (wen_out[22]),
        .bg4_wen_34    (wen_out[22]),
        .bg4_dout_34   (din30),
        .bg4_addr_35   (addr_out128[19*7+:7]),
        .bg4_din_35    (dout31),
        .bg4_en_35     (wen_out[23]),
        .bg4_wen_35    (wen_out[23]),
        .bg4_dout_35   (din31),
        .bg4_addr_36   (addr_out128[20*7+:7]),
        .bg4_din_36    (dout32),
        .bg4_en_36     (wen_out[24]),
        .bg4_wen_36    (wen_out[24]),
        .bg4_dout_36   (din32),
        .bg4_en_39_a   (ce_outa [3]),
        .bg4_en_39_b   (ce_outb [3]),
        .bg4_wen_39_a  (wen_outa[3]),
        .bg4_wen_39_b  (wen_outb[3]),
        .bg4_addr_39_a (addr_outa[3*5+:5]),
        .bg4_addr_39_b (addr_outb[3*5+:5]),
        .bg4_din_39_a  (dout33a),
        .bg4_din_39_b  (dout33b),
        .bg4_bwe_39_a  ({256{1'b1}}),
        .bg4_bwe_39_b  ({256{1'b1}}),
        .bg4_dout_39_a (din33a),
        .bg4_dout_39_b (din33b),
        .bg4_addr_40_a (addr_out_w[2*5+:5]),
        .bg4_addr_40_b (addr_out_r[2*5+:5]),
        .bg4_din_40    (dout34),
        .bg4_bwe_40    ({256{1'b1}}),
        .bg4_wen_40    (wen_out_t[2]),
        .bg4_ren_40    (ren_out_t[2]),
        .bg4_dout_40   (din34),
        .bg4_addr_41   (addr_out32[1*5+:5]),
        .bg4_din_41    (dout35),
        .bg4_en_41     (wen_out[25]),
        .bg4_wen_41    (wen_out[25]),
        .bg4_dout_41   (din35),
        .bg4_addr_42   (addr_out32[5*5+:5]),
        .bg4_din_42    (dout36),
        .bg4_en_42     (wen_out[26]),
        .bg4_wen_42    (wen_out[26]),
        .bg4_dout_42   (din36),
        .bg4_addr_43   (addr_out128[21*7+:7]),
        .bg4_din_43    (dout37),
        .bg4_en_43     (wen_out[27]),
        .bg4_wen_43    (wen_out[27]),
        .bg4_dout_43   (din37),
        .bg4_addr_44   (addr_out128[22*7+:7]),
        .bg4_din_44    (dout38),
        .bg4_en_44     (wen_out[28]),
        .bg4_wen_44    (wen_out[28]),
        .bg4_dout_44   (din38),
        .bg4_addr_45   (addr_out128[23*7+:7]),
        .bg4_din_45    (dout39),
        .bg4_en_45     (wen_out[29]),
        .bg4_wen_45    (wen_out[29]),
        .bg4_dout_45   (din39),
        .bg4_addr_46   (addr_out128[24*7+:7]),
        .bg4_din_46    (dout40),
        .bg4_en_46     (wen_out[30]),
        .bg4_wen_46    (wen_out[30]),
        .bg4_dout_46   (din40),
        .bg4_addr_47   (addr_out128[25*7+:7]),
        .bg4_din_47    (dout41),
        .bg4_en_47     (wen_out[31]),
        .bg4_wen_47    (wen_out[31]),
        .bg4_dout_47   (din41),
        .bg4_addr_48   (addr_out128[26*7+:7]),
        .bg4_din_48    (dout42),
        .bg4_en_48     (wen_out[32]),
        .bg4_wen_48    (wen_out[32]),
        .bg4_dout_48   (din42),
        .bg4_addr_49   (addr_out128[27*7+:7]),
        .bg4_din_49    (dout43),
        .bg4_en_49     (wen_out[33]),
        .bg4_wen_49    (wen_out[33]),
        .bg4_dout_49   (din43)
    );
    bg4_output_logic bg4_output_logic_U4(
        .clk               (clk),
        .flag_msm          (flag_msm),
        .bg_sel            (bg_sel),
        .tf_gen_addr_in    (tf_gen_addr_w),
        .msm_r_addr_id_in  (msm_r_addr_id_mem),
        .din0a             (din0a   ),
        .din1a             (din1a   ),
        .din0b             (din0b   ),
        .din1b             (din1b   ),
        .din2              (din2    ),
        .din3              (din3    ),
        .din4              (din4    ),
        .din5              (din5    ),
        .din6              (din6    ),
        .din7              (din7    ),
        .din8              (din8    ),
        .din9              (din9    ),
        .din10             (din10   ),
        .din11a            (din11a  ),
        .din11b            (din11b  ),
        .din12             (din12   ),
        .din13             (din13   ),
        .din14             (din14   ),
        .din15             (din15   ),
        .din16             (din16   ),
        .din17             (din17   ),
        .din18             (din18   ),
        .din19             (din19   ),
        .din20             (din20   ),
        .din21             (din21   ),
        .din22a            (din22a  ),
        .din22b            (din22b  ),
        .din23             (din23   ),
        .din24             (din24   ),
        .din25             (din25   ),
        .din26             (din26   ),
        .din27             (din27   ),
        .din28             (din28   ),
        .din29             (din29   ),
        .din30             (din30   ),
        .din31             (din31   ),
        .din32             (din32   ),
        .din33a            (din33a  ),
        .din33b            (din33b  ),
        .din34             (din34   ),
        .din35             (din35   ),
        .din36             (din36   ),
        .din37             (din37   ),
        .din38             (din38   ),
        .din39             (din39   ),
        .din40             (din40   ),
        .din41             (din41   ),
        .din42             (din42   ),
        .din43             (din43   ),
        .dout0             (bg4_out_dout_0),
        .dout1             (bg4_out_dout_1),
        .dout2             (bg4_out_dout_2),
        .dout3             (bg4_out_dout_3),
        .dout4             (bg4_out_dout_4),
        .dout5             (bg4_out_dout_5),
        .dout6             (bg4_out_dout_6),
        .dout7             (bg4_out_dout_7),
        .dout8             (bg4_out_dout_8),
        .dout9             (bg4_out_dout_9),
        .dout10            (bg4_out_dout_a),
        .dout11            (bg4_out_dout_b),
        .dout12            (bg4_out_dout_c),
        .dout13            (bg4_out_dout_d),
        .dout14            (bg4_out_dout_e),
        .dout15            (bg4_out_dout_f),
        .dout_ip           (dout_ip)        //
    );
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////bank_group 5      /////////////////////////////////////////
    bg5_input_logic bg5_input_logic_U5(
        .flag_msm     (flag_msm     ),
        .bg_sel       (bg_sel       ),
        .load_addr_in (load_addr_in[5] ),
        .ce_load      (ce_load[5]      ),
        .wen_load     (wen_load[5]     ),
        .msm_addr_in  (msm_r_addr_id_mem  ),
        .ce_msm       (msm_r_en_id_mem),
        .ren_msm      (msm_r_en_id_mem),
        .ntt_addr_in  ({tf_address_3,tf_address_2,tf_address_1,tf_address_0}  ),
        .ce_ntt       ({8{tf_ren}}       ),
        .wen_ntt      ({8{~tf_ren}}      ),
        .data_load_in (data_load_out[5] ),
        .addr_out     (bg5_in_addr_out     ),
        .ce_out       (bg5_in_ce_out       ),
        .wen_out      (bg5_in_wen_out      ),
        .dout0        (bg5_in_dout0        ),
        .dout1        (bg5_in_dout1        ),
        .dout2        (bg5_in_dout2        ),
        .dout3        (bg5_in_dout3        ),
        .dout4        (bg5_in_dout4        ),
        .dout5        (bg5_in_dout5        ),
        .dout6        (bg5_in_dout6        ),
        .dout7        (bg5_in_dout7        )
    );
    MEM_BG5 bank_group5(
        .clk          (clk),
        .bg5_en_0     (bg5_in_ce_out[0]),
        .bg5_en_1     (bg5_in_ce_out[1]),
        .bg5_en_2     (bg5_in_ce_out[2]),
        .bg5_en_3     (bg5_in_ce_out[3]),
        .bg5_en_4     (bg5_in_ce_out[4]),
        .bg5_en_5     (bg5_in_ce_out[5]),
        .bg5_en_6     (bg5_in_ce_out[6]),
        .bg5_en_7     (bg5_in_ce_out[7]),
        .bg5_wen_0    (bg5_in_wen_out[0]),
        .bg5_wen_1    (bg5_in_wen_out[1]),
        .bg5_wen_2    (bg5_in_wen_out[2]),
        .bg5_wen_3    (bg5_in_wen_out[3]),
        .bg5_wen_4    (bg5_in_wen_out[4]),
        .bg5_wen_5    (bg5_in_wen_out[5]),
        .bg5_wen_6    (bg5_in_wen_out[6]),
        .bg5_wen_7    (bg5_in_wen_out[7]),
        .bg5_addr_0   (bg5_in_addr_out[0*7+:7]),
        .bg5_addr_1   (bg5_in_addr_out[1*7+:7]),
        .bg5_addr_2   (bg5_in_addr_out[2*7+:7]),
        .bg5_addr_3   (bg5_in_addr_out[3*7+:7]),
        .bg5_addr_4   (bg5_in_addr_out[4*7+:7]),
        .bg5_addr_5   (bg5_in_addr_out[5*7+:7]),
        .bg5_addr_6   (bg5_in_addr_out[6*7+:7]),
        .bg5_addr_7   (bg5_in_addr_out[7*7+:7]),
        .bg5_din_0    (bg5_in_dout0),
        .bg5_din_1    (bg5_in_dout1),
        .bg5_din_2    (bg5_in_dout2),
        .bg5_din_3    (bg5_in_dout3),
        .bg5_din_4    (bg5_in_dout4),
        .bg5_din_5    (bg5_in_dout5),
        .bg5_din_6    (bg5_in_dout6),
        .bg5_din_7    (bg5_in_dout7),
        .bg5_dout_0   (bg5_dout_0),
        .bg5_dout_1   (bg5_dout_1),
        .bg5_dout_2   (bg5_dout_2),
        .bg5_dout_3   (bg5_dout_3),
        .bg5_dout_4   (bg5_dout_4),
        .bg5_dout_5   (bg5_dout_5),
        .bg5_dout_6   (bg5_dout_6),
        .bg5_dout_7   (bg5_dout_7)
    );
    bg5_output_logic bg5_output_logic_U5(
        .bg_sel (bg_sel),
        .din0   (bg5_dout_0),
        .din1   (bg5_dout_1),
        .din2   (bg5_dout_2),
        .din3   (bg5_dout_3),
        .din4   (bg5_dout_4),
        .din5   (bg5_dout_5),
        .din6   (bg5_dout_6),
        .din7   (bg5_dout_7),
        .dout0  (bg5_out_dout_0),
        .dout1  (bg5_out_dout_1),
        .dout2  (bg5_out_dout_2),
        .dout3  (bg5_out_dout_3)
    );
////////////////////////////////////////////////////////////////////////////////////
    bf_array bf_array_U3(
        .clk           (clk           ),
        .rst_n         (rst_n         ),
        .sel           (sel[0]           ),
        .flag_msm      (flag_msm      ),
        .a_i0_0        (a_i0_0        ),//
        .a_i1_0        (a_i1_0        ),//
        .a_i2_0        (a_i2_0        ),//
        .a_i3_0        (a_i3_0        ),//
        .a_i0_1        (a_i0_1        ),//
        .a_i1_1        (a_i1_1        ),//
        .a_i2_1        (a_i2_1        ),//
        .a_i3_1        (a_i3_1        ),//
        .a_i0_2        (a_i0_2        ),//
        .a_i1_2        (a_i1_2        ),//
        .a_i2_2        (a_i2_2        ),//
        .a_i3_2        (a_i3_2        ),//
        .a_i0_3        (a_i0_3        ),//
        .a_i1_3        (a_i1_3        ),//
        .a_i2_3        (a_i2_3        ),//
        .a_i3_3        (a_i3_3        ),//
        .b_i0_0        (b_i0_0        ),//
        .b_i1_0        (b_i1_0        ),//
        .b_i2_0        (b_i2_0        ),//
        .b_i3_0        (b_i3_0        ),//
        .b_i0_1        (b_i0_1        ),//
        .b_i1_1        (b_i1_1        ),//
        .b_i2_1        (b_i2_1        ),//
        .b_i3_1        (b_i3_1        ),//
        .b_i0_2        (b_i0_2        ),//
        .b_i1_2        (b_i1_2        ),//
        .b_i2_2        (b_i2_2        ),//
        .b_i3_2        (b_i3_2        ),//
        .b_i0_3        (b_i0_3        ),//
        .b_i1_3        (b_i1_3        ),//
        .b_i2_3        (b_i2_3        ),//
        .b_i3_3        (b_i3_3        ),//
        .w_in0_0       (w_in0[0]      ),//
        .w_in1_0       (w_in1[0]      ),//
        .w_in2_0       (w_in2[0]      ),//
        .w_in3_0       (w_in3[0]      ),//
        .w_in0_1       (w_in0[1]      ),//
        .w_in1_1       (w_in1[1]      ),//
        .w_in2_1       (w_in2[1]      ),//
        .w_in3_1       (w_in3[1]      ),//
        .w_in0_2       (w_in0[2]      ),//
        .w_in1_2       (w_in1[2]      ),//
        .w_in2_2       (w_in2[2]      ),//
        .w_in3_2       (w_in3[2]      ),//
        .w_in0_3       (w_in0[3]      ),//
        .w_in1_3       (w_in1[3]      ),//
        .w_in2_3       (w_in2[3]      ),//
        .w_in3_3       (w_in3[3]      ),//
        .bf_0_upper_0  (bf_0_upper[0] ),
        .bf_1_upper_0  (bf_1_upper[0] ),
        .bf_2_upper_0  (bf_2_upper[0] ),
        .bf_3_upper_0  (bf_3_upper[0] ),
        .bf_0_upper_1  (bf_0_upper[1] ),
        .bf_1_upper_1  (bf_1_upper[1] ),
        .bf_2_upper_1  (bf_2_upper[1] ),
        .bf_3_upper_1  (bf_3_upper[1] ),
        .bf_0_upper_2  (bf_0_upper[2] ),
        .bf_1_upper_2  (bf_1_upper[2] ),
        .bf_2_upper_2  (bf_2_upper[2] ),
        .bf_3_upper_2  (bf_3_upper[2] ),
        .bf_0_upper_3  (bf_0_upper[3] ),
        .bf_1_upper_3  (bf_1_upper[3] ),
        .bf_2_upper_3  (bf_2_upper[3] ),
        .bf_3_upper_3  (bf_3_upper[3] ),
        .bf_0_lower_0  (bf_0_lower[0] ),
        .bf_1_lower_0  (bf_1_lower[0] ),
        .bf_2_lower_0  (bf_2_lower[0] ),
        .bf_3_lower_0  (bf_3_lower[0] ),
        .bf_0_lower_1  (bf_0_lower[1] ),
        .bf_1_lower_1  (bf_1_lower[1] ),
        .bf_2_lower_1  (bf_2_lower[1] ),
        .bf_3_lower_1  (bf_3_lower[1] ),
        .bf_0_lower_2  (bf_0_lower[2] ),
        .bf_1_lower_2  (bf_1_lower[2] ),
        .bf_2_lower_2  (bf_2_lower[2] ),
        .bf_3_lower_2  (bf_3_lower[2] ),
        .bf_0_lower_3  (bf_0_lower[3] ),
        .bf_1_lower_3  (bf_1_lower[3] ),
        .bf_2_lower_3  (bf_2_lower[3] ),
        .bf_3_lower_3  (bf_3_lower[3] ),
        .msm_o_0       (msm_o_0       ),//
        .msm_o_1       (msm_o_1       ),//
        .msm_o_2       (msm_o_2       ) //
    );
    wire [256-1:0] scalar_in_sram = bg_out_dout[0][0+:256] | bg_out_dout[3][0+:256] | bg_out_dout[2][0+:256] | bg_out_dout[1][0+:256] | dout_ip[0+:256];
    wire [384*2-1:0] point_in_sram = bg_out_dout[0][0*256+:384*2] | bg_out_dout[3][0*256+:384*2] | bg_out_dout[2][0*256+:384*2] | bg_out_dout[1][0*256+:384*2] | dout_ip[0*256+:384*2];
    wire [256*5-1:0] data_from_bucket_a = {bg4_out_dout_0,bg4_out_dout_1,bg4_out_dout_2,bg4_out_dout_3,bg4_out_dout_4};
    wire [256*5-1:0] data_from_bucket_b = {bg4_out_dout_5,bg4_out_dout_6,bg4_out_dout_7,bg4_out_dout_8,bg4_out_dout_9};
    wire [256*5-1:0] fifo_i = {bg4_out_dout_a,bg4_out_dout_b,bg4_out_dout_c,bg4_out_dout_d,bg4_out_dout_e};
    msm_top#(.WIDTH_ID(5), .WIDTH_DATA(384), .P_NUM(2560), .PADD_LATENCY(21))msm_top_U4(
        .clk                  (clk                  ),
        .rst_n                (rst_n                ),
        .start                (start_msm            ),
        .load_rdy             (dram_ld_rdy_0        ),//
        .scalar_in_dram       (data_in_3            ),
        .point_in_dram        (point_in_dram        ),
        .scalar_in_sram       (scalar_in_sram       ),//
        .point_in_sram        (point_in_sram        ),//
        .result_padd          (result_padd          ),
        .data_from_bucket_a   (data_from_bucket_a[5+384*3-1:0]   ),//
        .data_from_bucket_b   (data_from_bucket_b[5+384*3-1:0]   ),//
        .fifo_i               (fifo_i[5+384*3-1:0]               ),//
        .bank_group_sel       (bank_group_sel       ),//
        .fifo_r_addr          (fifo_r_addr          ),//
        .fifo_w_addr          (fifo_w_addr          ),//
        .fifo_r_en            (fifo_r_en            ),//
        .fifo_w_en            (fifo_w_en            ),//
        .fifo_o               (din_rb               ),//
        .scalar_out_sram      (scalar_out_sram      ),//
        .point_out_sram       (point_out_sram       ),//
        .r_addr_id_mem        (msm_r_addr_id_mem    ),
        .r_addr_p_mem         (msm_r_addr_p_mem     ),
        .w_addr_mem           (msm_w_addr_mem       ),
        .r_en_id_mem          (msm_r_en_id_mem      ),
        .r_en_p_mem           (msm_r_en_p_mem       ),
        .w_en_mem             (msm_w_en_mem         ),
        .r_en_bucket_a        (r_en_bucket_a        ),
        .r_addr_bucket_a      (r_addr_bucket_a      ),
        .r_en_bucket_b        (r_en_bucket_b        ),
        .r_addr_bucket_b      (r_addr_bucket_b      ),
        .w_en_bucket_a        (w_en_bucket_a        ),
        .w_en_bucket_b        (w_en_bucket_b        ),
        .w_addr_bucket_a      (w_addr_bucket_a      ),
        .w_addr_bucket_b      (w_addr_bucket_b      ),
        .data_2_bucket_a      (din_bk_a             ),
        .data_2_bucket_b      (din_bk_b             ),
        .data_2_padd_a        (data_2_padd_a        ),
        .data_2_padd_b        (data_2_padd_b        ),
        .load_start           (dram_ld_start_msm    ),
        .done                 (done_msm             ) //
    );
    assign done = done_msm | top_mul_done;
//////////////////////load_done_r, stor_done_r/////////////////////////////////
    reg  [3:0] load_done_r, stor_done_r;
    wire [3:0] load_done_w, stor_done_w;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) load_done_r <= 4'd 0;
        else if (load_done) load_done_r <= 4'd 0;
        else begin
            casez(load_done_w)
            4'b ???1: load_done_r[0] <= 1'b 1;
            4'b ??1?: load_done_r[1] <= 1'b 1;
            4'b ?1??: load_done_r[2] <= 1'b 1;
            4'b 1???: load_done_r[3] <= 1'b 1;
            default : load_done_r <= load_done_r;
            endcase
        end
    end
    assign load_done = (load_done_r == 4'b 1111) ? 1'b 1:1'b 0;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) stor_done_r <= 4'd 0;
        else if (stor_done) stor_done_r <= 4'd 0;
        else begin
            casez(stor_done_w)
            4'b ???1: stor_done_r[0] <= 1'b 1;
            4'b ??1?: stor_done_r[1] <= 1'b 1;
            4'b ?1??: stor_done_r[2] <= 1'b 1;
            4'b 1???: stor_done_r[3] <= 1'b 1;
            default : stor_done_r <= stor_done_r;
            endcase
        end
    end
    assign stor_done = (stor_done_r == 4'b 1111) ? 1'b 1:1'b 0;
////////////////////////////////////////////////////////////////////////////////
    wire w_bank0, w_bank2, r_bank1, r_bank3;
    top_controller top_ctrl_U0 (
        .clk               (clk               ),
        .rst_n             (rst_n             ),
        .start             (start             ),
        .pwm_en            (pwm_en            ),
        .dram_ld_done      (load_done         ), //generate by cnt in top_mul
        .dram_st_done      (stor_done         ), //generate by cnt in top_mul
        .tf_gen_done       (tf_gen_done       ),
        .top_mul_done      (top_mul_done      ),
        .top_mul_done_flag (top_mul_done_flag ),
        .w_bank0           (w_bank0           ), //
        .w_bank2           (w_bank2           ), //
        .r_bank1           (r_bank1           ), //
        .r_bank3           (r_bank3           ), //
        .tf_gen_start      (tf_gen_start      ),
        .top_mul_start     (top_mul_start     ),
        .top_mul_conf      (top_mul_conf      ),
        .tf_gen_ren        (tf_gen_ren        ), //read tf from bank_group4
        .tf_gen_addr_r     (tf_gen_addr_r     ), //read tf from bank_group4
        .dram_ld_start     (dram_ld_start_ntt ),
        .dram_st_start     (dram_st_start     )
    );
    wire [255:0] data_in_w [3:0];
    reg  [255:0] tf_in [15:0];
    assign data_in_w[0] = data_in_0;
    assign data_in_w[1] = data_in_1;
    assign data_in_w[2] = data_in_2;
    assign data_in_w[3] = data_in_3;
    wire [255:0] data_out_w [3:0];
    wire [3:0] dram_ld_rdy_w;
    wire [3:0] dram_st_rdy_w;
    assign dram_ld_rdy_w[0] = dram_ld_rdy_0;     assign dram_st_rdy_w[0] = dram_st_rdy_0;
    assign dram_ld_rdy_w[1] = dram_ld_rdy_1;     assign dram_st_rdy_w[1] = dram_st_rdy_1;
    assign dram_ld_rdy_w[2] = dram_ld_rdy_2;     assign dram_st_rdy_w[2] = dram_st_rdy_2;
    assign dram_ld_rdy_w[3] = dram_ld_rdy_3;     assign dram_st_rdy_w[3] = dram_st_rdy_3;
    genvar j;
    generate for(j=0; j<=3; j=j+1) begin:gen_top_mul
        top_poly_mul top_mul_U (
        .clk       (clk                    ),
        .rst_n     (rst_n                  ),
        .start     (top_mul_start          ),
        .load      (dram_ld_rdy_w[j]       ),
        .stor      (dram_st_rdy_w[j]       ),
        .conf      (top_mul_conf           ),
        .d_in      (data_in_w[j]           ),//
        .tf_in_0   (tf_in[j*4+0]          ),//
        .tf_in_1   (tf_in[j*4+1]          ),//
        .tf_in_2   (tf_in[j*4+2]          ),//
        .tf_in_3   (tf_in[j*4+3]          ),//
        .bf_0_upper(bf_0_upper[j]          ),//
        .bf_1_upper(bf_1_upper[j]          ),//
        .bf_2_upper(bf_2_upper[j]          ),//
        .bf_3_upper(bf_3_upper[j]          ),//
        .bf_0_lower(bf_0_lower[j]          ),//
        .bf_1_lower(bf_1_lower[j]          ),//
        .bf_2_lower(bf_2_lower[j]          ),//
        .bf_3_lower(bf_3_lower[j]          ),//
        .q_0       (q_0_ntt[j]                 ),//from bank
        .q_1       (q_1_ntt[j]                 ),//from bank
        .q_2       (q_2_ntt[j]                 ),//from bank
        .q_3       (q_3_ntt[j]                 ),//from bank
        .q_4       (q_4_ntt[j]                 ),//from bank
        .q_5       (q_5_ntt[j]                 ),//from bank
        .q_6       (q_6_ntt[j]                 ),//from bank
        .q_7       (q_7_ntt[j]                 ),//from bank
        .w_0       (bg5_out_dout_0             ),//
        .w_1       (bg5_out_dout_1             ),//
        .w_2       (bg5_out_dout_2             ),//
        .w_3       (bg5_out_dout_3             ),//
        .done_flag (top_mul_done_flag_w[j] ),
        .d_out     (data_out_w[j]          ),//
        .load_done (load_done_w[j]         ),//
        .stor_done (stor_done_w[j]         ),//
        .done      (top_mul_done_w[j]      ),
        .sel       (sel[j]                 ),//
        .a_i0      (a_i0[j]                ),//
        .a_i1      (a_i1[j]                ),//
        .a_i2      (a_i2[j]                ),//
        .a_i3      (a_i3[j]                ),//
        .b_i0      (b_i0[j]                ),//
        .b_i1      (b_i1[j]                ),//
        .b_i2      (b_i2[j]                ),//
        .b_i3      (b_i3[j]                ),//
        .w_in0     (w_in0[j]               ),//
        .w_in1     (w_in1[j]               ),//
        .w_in2     (w_in2[j]               ),//
        .w_in3     (w_in3[j]               ),//
        .addr_0    ({4{addr_ntt[j][0*7+:7]}}        ),//to bg_input_logic
        .addr_1    ({4{addr_ntt[j][1*7+:7]}}        ),//to bg_input_logic
        .addr_2    ({4{addr_ntt[j][2*7+:7]}}        ),//to bg_input_logic
        .addr_3    ({4{addr_ntt[j][3*7+:7]}}        ),//to bg_input_logic
        .addr_4    ({4{addr_ntt[j][4*7+:7]}}        ),//to bg_input_logic
        .addr_5    ({4{addr_ntt[j][5*7+:7]}}        ),//to bg_input_logic
        .addr_6    ({4{addr_ntt[j][6*7+:7]}}        ),//to bg_input_logic
        .addr_7    ({4{addr_ntt[j][7*7+:7]}}        ),//to bg_input_logic
        .data_o_0  (data_o_0_ntt[j]            ),//to bg_input_logic
        .data_o_1  (data_o_1_ntt[j]            ),//to bg_input_logic
        .data_o_2  (data_o_2_ntt[j]            ),//to bg_input_logic
        .data_o_3  (data_o_3_ntt[j]            ),//to bg_input_logic
        .data_o_4  (data_o_4_ntt[j]            ),//to bg_input_logic
        .data_o_5  (data_o_5_ntt[j]            ),//to bg_input_logic
        .data_o_6  (data_o_6_ntt[j]            ),//to bg_input_logic
        .data_o_7  (data_o_7_ntt[j]            ),//to bg_input_logic
        .w_en_0    (wen_ntt[0*4+:4]             ),//to bg_input_logic
        .w_en_1    (wen_ntt[1*4+:4]             ),//to bg_input_logic
        .w_en_2    (wen_ntt[2*4+:4]             ),//to bg_input_logic
        .w_en_3    (wen_ntt[3*4+:4]             ),//to bg_input_logic
        .w_en_4    (wen_ntt[4*4+:4]             ),//to bg_input_logic
        .w_en_5    (wen_ntt[5*4+:4]             ),//to bg_input_logic
        .w_en_6    (wen_ntt[6*4+:4]             ),//to bg_input_logic
        .w_en_7    (wen_ntt[7*4+:4]             ),//to bg_input_logic
        .en_0      (en_ntt[0*4+:4]              ),//to bg_input_logic
        .en_1      (en_ntt[1*4+:4]              ),//to bg_input_logic
        .en_2      (en_ntt[2*4+:4]              ),//to bg_input_logic
        .en_3      (en_ntt[3*4+:4]              ),//to bg_input_logic
        .en_4      (en_ntt[4*4+:4]              ),//to bg_input_logic
        .en_5      (en_ntt[5*4+:4]              ),//to bg_input_logic
        .en_6      (en_ntt[6*4+:4]              ),//to bg_input_logic
        .en_7      (en_ntt[7*4+:4]              ),//to bg_input_logic
        .tf_address_0 (tf_address_0),
        .tf_address_1 (tf_address_1),
        .tf_address_2 (tf_address_2),
        .tf_address_3 (tf_address_3),
        .ren          (tf_ren      ), //read tf from bg5 for HP
        .ntt_load_addr(ntt_load_addr),
        .ntt_load_en  (ntt_load_en  ),
        .ntt_load_wen (ntt_load_wen )
    );
    end
    endgenerate
    assign data_out_0 = data_out_w[0];
    assign data_out_1 = data_out_w[1];
    assign data_out_2 = data_out_w[2];
    assign data_out_3 = data_out_w[3];
    wire [255:0] tf_gen_tf_o [15:0];
    integer k;
    always @(*) begin
        for (k=0; k<16; k=k+1) begin
            tf_in[k] = tf_gen_tf_o[k];
        end
    end
    tf_gen_top tf_gen_U2 (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (tf_gen_start),//
        .wen         (tf_gen_wen),//
        .ren         (tf_gen_ren),
        .addr_r      (tf_gen_addr_r),
        .addr_w      (tf_gen_addr_w),//
        .seed_i_0    (data_in_0    ),//
        .seed_i_1    (data_in_1    ),//
        .seed_i_2    (data_in_2    ),//
        .seed_i_3    (data_in_3    ),//
        .tf_i_0      (bg4_out_dout_0),//
        .tf_i_1      (bg4_out_dout_1),//
        .tf_i_2      (bg4_out_dout_2),//
        .tf_i_3      (bg4_out_dout_3),//
        .tf_i_4      (bg4_out_dout_4),//
        .tf_i_5      (bg4_out_dout_5),//
        .tf_i_6      (bg4_out_dout_6),//
        .tf_i_7      (bg4_out_dout_7),//
        .tf_i_8      (bg4_out_dout_8),//
        .tf_i_9      (bg4_out_dout_9),//
        .tf_i_a      (bg4_out_dout_a),//
        .tf_i_b      (bg4_out_dout_b),//
        .tf_i_c      (bg4_out_dout_c),//
        .tf_i_d      (bg4_out_dout_d),//
        .tf_i_e      (bg4_out_dout_e),//
        .tf_i_f      (bg4_out_dout_f),//
        .tf_bank_addr(tf_bank_addr),
        .tf_bank_web (tf_bank_web),
        .tf_bank_en  (tf_bank_en),
        .tf_r_0      (bg4_din_0),
        .tf_r_1      (bg4_din_1),
        .tf_r_2      (bg4_din_2),
        .tf_r_3      (bg4_din_3),
        .tf_r_4      (bg4_din_4),
        .tf_r_5      (bg4_din_5),
        .tf_r_6      (bg4_din_6),
        .tf_r_7      (bg4_din_7),
        .tf_r_8      (bg4_din_8),
        .tf_r_9      (bg4_din_9),
        .tf_r_a      (bg4_din_a),
        .tf_r_b      (bg4_din_b),
        .tf_r_c      (bg4_din_c),
        .tf_r_d      (bg4_din_d),
        .tf_r_e      (bg4_din_e),
        .tf_r_f      (bg4_din_f),
        .tf_o_0      (tf_gen_tf_o[0] ),
        .tf_o_1      (tf_gen_tf_o[1] ),
        .tf_o_2      (tf_gen_tf_o[2] ),
        .tf_o_3      (tf_gen_tf_o[3] ),
        .tf_o_4      (tf_gen_tf_o[4] ),
        .tf_o_5      (tf_gen_tf_o[5] ),
        .tf_o_6      (tf_gen_tf_o[6] ),
        .tf_o_7      (tf_gen_tf_o[7] ),
        .tf_o_8      (tf_gen_tf_o[8] ),
        .tf_o_9      (tf_gen_tf_o[9] ),
        .tf_o_a      (tf_gen_tf_o[10]),
        .tf_o_b      (tf_gen_tf_o[11]),
        .tf_o_c      (tf_gen_tf_o[12]),
        .tf_o_d      (tf_gen_tf_o[13]),
        .tf_o_e      (tf_gen_tf_o[14]),
        .tf_o_f      (tf_gen_tf_o[15]),
        .done_row    (tf_gen_done_row),
        .done        (tf_gen_done)
    );
endmodule
