module bg4_input_logic(
    input                                 flag_msm            , //==0: do ntt; ==1: do msm
    input                                 bg_sel              , //==0: load 0,1,4,5; ==1: load2,3,4,5
    input      [     10:0]                load_addr_in        ,
    input                                 ce_load             , //from bank_load_logic
    input                                 wen_load            ,
    input      [     11:0]                msm_r_addr_id_in    , //r_addr_id_mem from msm_top(read scalar and point)
    input                                 ce_r_id_msm         ,
    input                                 ren_id_msm          ,
    input      [      4:0]                msm_r_addr_bk_in_a  , //r_addr_bucket_a from msm_top(read bucket)
    input                                 ce_r_bk_msm_a       ,
    input                                 ren_bk_msm_a        ,
    input      [      4:0]                msm_r_addr_bk_in_b  , //r_addr_bucket_b from msm_top(read bucket)
    input                                 ce_r_bk_msm_b       ,
    input                                 ren_bk_msm_b        ,
    input      [      4:0]                msm_w_addr_bk_in_a  , //w_addr_bucket_a from msm_top(write bucket)
    input                                 ce_w_bk_msm_a       ,
    input                                 wen_bk_msm_a        ,
    input      [      4:0]                msm_w_addr_bk_in_b  , //w_addr_bucket_b from msm_top(write bucket)
    input                                 ce_w_bk_msm_b       ,
    input                                 wen_bk_msm_b        ,
    input      [      4:0]                msm_w_addr_rb_in    , //fifo_w_addr from msm_top(write result_buffer)
    input                                 ce_w_rb_msm         ,
    input                                 wen_rb_msm          ,
    input      [      4:0]                msm_r_addr_rb_in    , //fifo_r_addr from msm_top(read result_buffer)
    input                                 ce_r_rb_msm         ,
    input                                 ren_rb_msm          ,
    input      [    8-1:0]                tf_gen_addr_in      , //one 8-bit from tf_gen_top
    input                                 ce_tf_gen           , //one 1-bit from tf_gen_top
    input                                 wen_tf_gen          , //one 1-bit from tf_gen_top
    input                                 ren_tf_gen          , //one 1-bit from tf_gen_top
    input      [  512-1:0]                data_load_in        , //from bank_load_logic
    input      [  256-1:0]                din0                , //from tf_gen
    input      [  256-1:0]                din1                , //from tf_gen
    input      [  256-1:0]                din2                , //from tf_gen
    input      [  256-1:0]                din3                , //from tf_gen
    input      [  256-1:0]                din4                , //from tf_gen
    input      [  256-1:0]                din5                , //from tf_gen
    input      [  256-1:0]                din6                , //from tf_gen
    input      [  256-1:0]                din7                , //from tf_gen
    input      [  256-1:0]                din8                , //from tf_gen
    input      [  256-1:0]                din9                , //from tf_gen
    input      [  256-1:0]                din10               , //from tf_gen
    input      [  256-1:0]                din11               , //from tf_gen
    input      [  256-1:0]                din12               , //from tf_gen
    input      [  256-1:0]                din13               , //from tf_gen
    input      [  256-1:0]                din14               , //from tf_gen
    input      [  256-1:0]                din15               , //from tf_gen
    input      [ 1157-1:0]                din_bk_a            , //from msm_top
    input      [ 1157-1:0]                din_bk_b            , //from msm_top
    input      [ 1157-1:0]                din_rb              , //from msm_top
    output reg [  5*5-1:0]                addr_outa           , //5 5-bit for dual port ram
    output reg [  5*5-1:0]                addr_outb           , //5 5-bit for dual port ram
    output     [  5*5-1:0]                addr_out_r          , //5 5-bit for two port ram
    output     [  5*5-1:0]                addr_out_w          , //5 5-bit for two port ram
    output     [  5*6-1:0]                addr_out32          , //6 5-bit
    output     [  7*28-1:0]               addr_out128         , //28 7-bit
    output reg [   5-1:0]                 ce_outa             , //5 1-bit for dual port ram
    output reg [   5-1:0]                 ce_outb             , //5 1-bit for dual port ram
    output reg [   34-1:0]                ce_out              , //34 1-bit for single prot ram
    output reg [   5-1:0]                 wen_outa            , //5 1-bit for dual port ram
    output reg [   5-1:0]                 wen_outb            , //5 1-bit for dual port ram
    output reg [   5-1:0]                 wen_out_t           , //5 1-bit for two port ram
    output reg [   5-1:0]                 ren_out_t           , //5 1-bit for two port ram
    output reg [   34-1:0]                wen_out             , //34 1-bit
    output reg [  256-1:0]                dout0a              ,
    output reg [  256-1:0]                dout1a              ,
    output reg [  256-1:0]                dout0b              ,
    output reg [  256-1:0]                dout1b              ,
    output reg [  256-1:0]                dout2               ,
    output reg [  256-1:0]                dout3               ,
    output reg [  256-1:0]                dout4               ,
    output reg [  256-1:0]                dout5               ,
    output reg [  256-1:0]                dout6               ,
    output reg [  256-1:0]                dout7               ,
    output reg [  256-1:0]                dout8               ,
    output reg [  256-1:0]                dout9               ,
    output reg [  256-1:0]                dout10              ,
    output reg [  256-1:0]                dout11a             ,
    output reg [  256-1:0]                dout11b             ,
    output reg [  256-1:0]                dout12              ,
    output reg [  256-1:0]                dout13              ,
    output reg [  256-1:0]                dout14              ,
    output reg [  256-1:0]                dout15              ,
    output reg [  256-1:0]                dout16              ,
    output reg [  256-1:0]                dout17              ,
    output reg [  256-1:0]                dout18              ,
    output reg [  256-1:0]                dout19              ,
    output reg [  256-1:0]                dout20              ,
    output reg [  256-1:0]                dout21              ,
    output reg [  256-1:0]                dout22a             ,
    output reg [  256-1:0]                dout22b             ,
    output reg [  256-1:0]                dout23              ,
    output reg [  256-1:0]                dout24              ,
    output reg [  256-1:0]                dout25              ,
    output reg [  256-1:0]                dout26              ,
    output reg [  256-1:0]                dout27              ,
    output reg [  256-1:0]                dout28              ,
    output reg [  256-1:0]                dout29              ,
    output reg [  256-1:0]                dout30              ,
    output reg [  256-1:0]                dout31              ,
    output reg [  256-1:0]                dout32              ,
    output reg [  256-1:0]                dout33a             ,
    output reg [  256-1:0]                dout33b             ,
    output reg [  256-1:0]                dout34              ,
    output reg [  256-1:0]                dout35              ,
    output reg [  256-1:0]                dout36              ,
    output reg [  256-1:0]                dout37              ,
    output reg [  256-1:0]                dout38              ,
    output reg [  256-1:0]                dout39              ,
    output reg [  256-1:0]                dout40              ,
    output reg [  256-1:0]                dout41              ,
    output reg [  256-1:0]                dout42              ,
    output reg [  256-1:0]                dout43               //
    );
    always @(*)begin //ce_outa, ce_outb ce_out
        if(ce_load)begin
            if(bg_sel) begin
                if(load_addr_in<2048+128) begin
                    //ce_out[5]  = 1; ce_out[13] = 1; ce_out[22] = 1; ce_out[31] = 1;
                    ce_out  = 34'b 00_1000_0000_0100_0000_0010_0000_0010_0000;
                  //               32   28   24   20   16   12    8    4    0
                end
                else if(load_addr_in<2048+256) begin
                    //ce_out[6]  = 1; ce_out[14] = 1; ce_out[23] = 1; ce_out[32] = 1;
                    ce_out  = 34'b 01_0000_0000_1000_0000_0100_0000_0100_0000;
                end
                else if(load_addr_in<2048+384) begin
                    //ce_out[7]  = 1; ce_out[15] = 1; ce_out[24] = 1; ce_out[33] = 1;
                    ce_out  = 34'b 10_0000_0001_0000_0000_1000_0000_1000_0000;
                end
            end
            else begin
                if(load_addr_in<2048+128) begin
                    //ce_out[2]  = 1; ce_out[10] = 1; ce_out[19] = 1; ce_out[28] = 1;
                    ce_out  = 34'b 00_0001_0000_0000_1000_0000_0100_0000_0100;
                end
                else if(load_addr_in<2048+256) begin
                    //ce_out[3]  = 1; ce_out[11] = 1; ce_out[20] = 1; ce_out[29] = 1;
                    ce_out  = 34'b 00_0010_0000_0001_0000_0000_1000_0000_1000;
                end
                else if(load_addr_in<2048+384) begin
                    //ce_out[4]  = 1; ce_out[12] = 1; ce_out[21] = 1; ce_out[30] = 1;
                    ce_out  = 34'b 00_0100_0000_0010_0000_0001_0000_0001_0000;
                end
            end
        end
        else if(ce_tf_gen)begin
            if (tf_gen_addr_in[7]) begin
                ce_out  = 34'b 1010101001010101001010101010101010;
                ce_outa = 5'b 00000;
                ce_outb = 5'b 00000;
            end
            else begin
                ce_out  = 34'b 0101010110101010110101010101010101;
                ce_outa = 5'b 11111;
                ce_outb = 5'b 00000;
            end
        end
        else if(ce_r_id_msm)begin //read scalar-mem and point-mem
            ce_outa = {ce_r_bk_msm_a | ce_w_bk_msm_a, ce_r_bk_msm_a | ce_w_bk_msm_a, ce_r_bk_msm_a | ce_w_bk_msm_a, ce_r_bk_msm_a | ce_w_bk_msm_a, ce_r_bk_msm_a | ce_w_bk_msm_a};
            ce_outb = {ce_r_bk_msm_b | ce_w_bk_msm_b, ce_r_bk_msm_b | ce_w_bk_msm_b, ce_r_bk_msm_b | ce_w_bk_msm_b, ce_r_bk_msm_b | ce_w_bk_msm_b, ce_r_bk_msm_b | ce_w_bk_msm_b};
            if(bg_sel) begin
                if(msm_r_addr_id_in<2048+128) begin
                    //ce_out[5]  = 1; ce_out[13] = 1; ce_out[22] = 1; ce_out[31] = 1;
                    ce_out  = 34'b 00_1000_0000_0100_0000_0010_0000_0010_0000;
                  //               32   28   24   20   16   12    8    4    0
                end
                else if(msm_r_addr_id_in<2048+256) begin
                    //ce_out[6]  = 1; ce_out[14] = 1; ce_out[23] = 1; ce_out[32] = 1;
                    ce_out  = 34'b 01_0000_0000_1000_0000_0100_0000_0100_0000;
                end
                else if(msm_r_addr_id_in<2048+384) begin
                    //ce_out[7]  = 1; ce_out[15] = 1; ce_out[24] = 1; ce_out[33] = 1;
                    ce_out  = 34'b 10_0000_0001_0000_0000_1000_0000_1000_0000;
                end
            end
            else begin
                if(msm_r_addr_id_in<2048+128) begin
                    //ce_out[2]  = 1; ce_out[10] = 1; ce_out[19] = 1; ce_out[28] = 1;
                    ce_out  = 34'b 00_0001_0000_0000_1000_0000_0100_0000_0100;
                end
                else if(msm_r_addr_id_in<2048+256) begin
                    //ce_out[3]  = 1; ce_out[11] = 1; ce_out[20] = 1; ce_out[29] = 1;
                    ce_out  = 34'b 00_0010_0000_0001_0000_0000_1000_0000_1000;
                end
                else if(msm_r_addr_id_in<2048+384) begin
                    //ce_out[4]  = 1; ce_out[12] = 1; ce_out[21] = 1; ce_out[30] = 1;
                    ce_out  = 34'b 00_0100_0000_0010_0000_0001_0000_0001_0000;
                end
            end
        end
        else begin
            ce_out = 0;
            ce_outa = 0;
            ce_outb = 0;
        end
    end
    always @(*)begin //wen_out
        if(ce_load)begin
            wen_out_t = 0;
            ren_out_t = 0;
            wen_outa  = 0;
            wen_outb  = 0;
            if(bg_sel) begin
                if(load_addr_in<2048+128) begin
                    //ce_out[5]  = 1; ce_out[13] = 1; ce_out[22] = 1; ce_out[31] = 1;
                    wen_out  = 34'b 00_1000_0000_0100_0000_0010_0000_0010_0000;
                  //               32   28   24   20   16   12    8    4    0
                end
                else if(load_addr_in<2048+256) begin
                    //ce_out[6]  = 1; ce_out[14] = 1; ce_out[23] = 1; ce_out[32] = 1;
                    wen_out  = 34'b 01_0000_0000_1000_0000_0100_0000_0100_0000;
                end
                else if(load_addr_in<2048+384) begin
                    //ce_out[7]  = 1; ce_out[15] = 1; ce_out[24] = 1; ce_out[33] = 1;
                    wen_out  = 34'b 10_0000_0001_0000_0000_1000_0000_1000_0000;
                end
            end
            else begin
                if(load_addr_in<2048+128) begin
                    //ce_out[2]  = 1; ce_out[10] = 1; ce_out[19] = 1; ce_out[28] = 1;
                    wen_out  = 34'b 00_0001_0000_0000_1000_0000_0100_0000_0100;
                end
                else if(load_addr_in<2048+256) begin
                    //ce_out[3]  = 1; ce_out[11] = 1; ce_out[20] = 1; ce_out[29] = 1;
                    wen_out  = 34'b 00_0010_0000_0001_0000_0000_1000_0000_1000;
                end
                else if(load_addr_in<2048+384) begin
                    //ce_out[4]  = 1; ce_out[12] = 1; ce_out[21] = 1; ce_out[30] = 1;
                    wen_out  = 34'b 00_0100_0000_0010_0000_0001_0000_0001_0000;
                end
            end
        end
        else if(ce_tf_gen)begin
            if(tf_gen_addr_in[7]) begin
                wen_outa  = 5'b 00000;
                wen_outb  = 5'b 00000;
                wen_out_t = 5'b 11111;
                ren_out_t = 5'b 00000;
                wen_out = {34{wen_tf_gen}};
            end
            else begin
                wen_out_t = 5'b 11111;
                ren_out_t = 5'b 00000;
                wen_outa  = 5'b 11111;
                wen_outb  = 5'b 00000;
                wen_out = {34{wen_tf_gen}};
            end
            
        end
        else if(ce_r_id_msm)begin //read scalar-mem and point-mem
            wen_out_t = {wen_rb_msm, wen_rb_msm, wen_rb_msm, wen_rb_msm, wen_rb_msm};
            ren_out_t = {ren_rb_msm, ren_rb_msm, ren_rb_msm, ren_rb_msm, ren_rb_msm};
            wen_outa  = {wen_bk_msm_a, wen_bk_msm_a, wen_bk_msm_a, wen_bk_msm_a, wen_bk_msm_a};
            wen_outb  = {wen_bk_msm_b, wen_bk_msm_b, wen_bk_msm_b, wen_bk_msm_b, wen_bk_msm_b};
            if(bg_sel) begin
                if(msm_r_addr_id_in<2048+128) begin
                    wen_out  = 34'b 00_1000_0000_0100_0000_0010_0000_0010_0000;
                  //               32   28   24   20   16   12    8    4    0
                end
                else if(msm_r_addr_id_in<2048+256) begin
                    wen_out  = 34'b 01_0000_0000_1000_0000_0100_0000_0100_0000;
                end
                else if(msm_r_addr_id_in<2048+384) begin
                    wen_out  = 34'b 10_0000_0001_0000_0000_1000_0000_1000_0000;
                end
            end
            else begin
                if(msm_r_addr_id_in<2048+128) begin
                    wen_out  = 34'b 00_0001_0000_0000_1000_0000_0100_0000_0100;
                end
                else if(msm_r_addr_id_in<2048+256) begin
                    wen_out  = 34'b 00_0010_0000_0001_0000_0000_1000_0000_1000;
                end
                else if(msm_r_addr_id_in<2048+384) begin
                    wen_out  = 34'b 00_0100_0000_0010_0000_0001_0000_0001_0000;
                end
            end
        end
        else begin
            wen_out_t = {wen_rb_msm, wen_rb_msm, wen_rb_msm, wen_rb_msm, wen_rb_msm};
            ren_out_t = {ren_rb_msm, ren_rb_msm, ren_rb_msm, ren_rb_msm, ren_rb_msm};
            wen_outa  = {wen_bk_msm_a, wen_bk_msm_a, wen_bk_msm_a, wen_bk_msm_a, wen_bk_msm_a};
            wen_outb  = {wen_bk_msm_b, wen_bk_msm_b, wen_bk_msm_b, wen_bk_msm_b, wen_bk_msm_b};
            wen_out   = 0;
        end
    end
    always@(*)begin //addr_outa 
        if(ce_tf_gen) begin //tf_mode
            addr_outa = {5{tf_gen_addr_in[6:0]}};
        end
        else begin
            addr_outa = (ce_r_bk_msm_a) ? {5{msm_r_addr_bk_in_a}} : {5{msm_w_addr_bk_in_a}};
        end
    end
    always@(*)begin //addr_outb
        addr_outb = (ce_r_bk_msm_b) ? {5{msm_r_addr_bk_in_b}} : {5{msm_w_addr_bk_in_b}};
    end
    assign addr_out_r = (ce_tf_gen) ? {5{tf_gen_addr_in[6:0]}} : {5{msm_r_addr_rb_in}};
    assign addr_out_w = (ce_tf_gen) ? {5{tf_gen_addr_in[6:0]}} : {5{msm_w_addr_rb_in}};
    assign addr_out32 = {6{tf_gen_addr_in[6:0]}};
    assign addr_out128 = (ce_tf_gen) ? {28{tf_gen_addr_in[6:0]}} : (ce_load) ? {28{load_addr_in}} : {28{msm_r_addr_id_in}};
    always@(*)begin //doutXa, b 
        if(ce_tf_gen) begin //tf_mode
            dout0a = din0; dout11a = din4; dout22a = din8; dout33a = din12; dout1a = din0;
            dout0b = 0;    dout11b =    0; dout22b =    0; dout33b =     0; dout1b =    0;
        end
        else begin
            {dout0a,dout11a,dout22a,dout33a,dout1a} = din_bk_a;
            {dout0b,dout11b,dout22b,dout33b,dout1b} = din_bk_b;
        end
    end
    always@(*)begin //dout 
        if(ce_tf_gen) begin //tf_mode
            dout12 = din4; dout23 = din8; dout34 = din12; dout2 = din0; dout13 = din4;
            dout24 = din8; dout35 = din12; dout3 = din0; dout14 = din4; dout25 = din8; dout36 = din12;
            dout4 = din0; dout15 = din4; dout26 = din8; dout37 = din12;
            dout5 = din1; dout16 = din5; dout27 = din9; dout38 = din13;
            dout6 = din1; dout17 = din5; dout28 = din9; dout39 = din13;
            dout7 = din2; dout18 = din6; dout29 = din10; dout40 = din14;
            dout8 = din2; dout19 = din6; dout30 = din10; dout41 = din14;
            dout9 = din3; dout20 = din7; dout31 = din11; dout42 = din15;
            dout10 = din3; dout21 = din7; dout32 = din11; dout43 = din15;
        end
        else begin
            {dout12,dout23,dout34,dout2,dout13} = din_rb;
            dout24 = 0; dout35 = 0; dout3 = 0; dout14 = 0; dout25 = 0; dout36 = 0;
            {dout4, dout15} = data_load_in; {dout26, dout37} = data_load_in;
            {dout5  , dout16} = data_load_in; {dout27 , dout38 } = data_load_in;
            {dout6  , dout17} = data_load_in; {dout28 , dout39 } = data_load_in;
            {dout7  , dout18} = data_load_in; {dout29 ,  dout40} = data_load_in;
            {dout8  , dout19} = data_load_in; {dout30 ,  dout41} = data_load_in;
            {dout9  , dout20} = data_load_in; {dout31 ,  dout42} = data_load_in;
            {dout10 , dout21} = data_load_in; {dout32 ,  dout43} = data_load_in;
        end
    end
endmodule
