module bg4_output_logic(
    input                                 clk               ,
    input                                 flag_msm          , //==0: do ntt; ==1: do msm
    input                                 bg_sel            , //==0: load 0,1,4,5; ==1: load2,3,4,5
    input      [    8-1:0]                tf_gen_addr_in    ,
    input      [     11:0]                msm_r_addr_id_in  , //r_addr_id_mem from msm_top(read scalar and point)
    input      [  256-1:0]                din0a             ,
    input      [  256-1:0]                din1a             ,
    input      [  256-1:0]                din0b             ,
    input      [  256-1:0]                din1b             ,
    input      [  256-1:0]                din2              ,
    input      [  256-1:0]                din3              ,
    input      [  256-1:0]                din4              ,
    input      [  256-1:0]                din5              ,
    input      [  256-1:0]                din6              ,
    input      [  256-1:0]                din7              ,
    input      [  256-1:0]                din8              ,
    input      [  256-1:0]                din9              ,
    input      [  256-1:0]                din10             ,
    input      [  256-1:0]                din11a            ,
    input      [  256-1:0]                din11b            ,
    input      [  256-1:0]                din12             ,
    input      [  256-1:0]                din13             ,
    input      [  256-1:0]                din14             ,
    input      [  256-1:0]                din15             ,
    input      [  256-1:0]                din16             ,
    input      [  256-1:0]                din17             ,
    input      [  256-1:0]                din18             ,
    input      [  256-1:0]                din19             ,
    input      [  256-1:0]                din20             ,
    input      [  256-1:0]                din21             ,
    input      [  256-1:0]                din22a            ,
    input      [  256-1:0]                din22b            ,
    input      [  256-1:0]                din23             ,
    input      [  256-1:0]                din24             ,
    input      [  256-1:0]                din25             ,
    input      [  256-1:0]                din26             ,
    input      [  256-1:0]                din27             ,
    input      [  256-1:0]                din28             ,
    input      [  256-1:0]                din29             ,
    input      [  256-1:0]                din30             ,
    input      [  256-1:0]                din31             ,
    input      [  256-1:0]                din32             ,
    input      [  256-1:0]                din33a            ,
    input      [  256-1:0]                din33b            ,
    input      [  256-1:0]                din34             ,
    input      [  256-1:0]                din35             ,
    input      [  256-1:0]                din36             ,
    input      [  256-1:0]                din37             ,
    input      [  256-1:0]                din38             ,
    input      [  256-1:0]                din39             ,
    input      [  256-1:0]                din40             ,
    input      [  256-1:0]                din41             ,
    input      [  256-1:0]                din42             ,
    input      [  256-1:0]                din43             ,
    output reg [  256-1:0]                dout0             ,
    output reg [  256-1:0]                dout1             ,
    output reg [  256-1:0]                dout2             ,
    output reg [  256-1:0]                dout3             ,
    output reg [  256-1:0]                dout4             ,
    output reg [  256-1:0]                dout5             ,
    output reg [  256-1:0]                dout6             ,
    output reg [  256-1:0]                dout7             ,
    output reg [  256-1:0]                dout8             ,
    output reg [  256-1:0]                dout9             ,
    output reg [  256-1:0]                dout10            ,
    output reg [  256-1:0]                dout11            ,
    output reg [  256-1:0]                dout12            ,
    output reg [  256-1:0]                dout13            ,
    output reg [  256-1:0]                dout14            ,
    output reg [  256-1:0]                dout15            ,
    output reg [ 1024-1:0]                dout_ip              //
    );
    always@(posedge clk)begin
        if(!flag_msm)begin //ntt mode
            dout_ip <= 0;
            if(tf_gen_addr_in[7])begin
                dout0 <=din4;
                dout1 <=din6;
                dout2 <=din8;
                dout3 <=din10;
                dout4 <=din15;
                dout5 <=din17;
                dout6 <=din19;
                dout7 <=din21;
                dout8 <=din26;
                dout9 <=din28;
                dout10<=din30;
                dout11<=din32;
                dout12<=din37;
                dout13<=din39;
                dout14<=din41;
                dout15<=din43;
            end
            else begin
                dout1 <=din5;
                dout2 <=din7;
                dout3 <=din9;
                dout5 <=din16;
                dout6 <=din18;
                dout7 <=din20;
                dout9 <=din27;
                dout10<=din29;
                dout11<=din31;
                dout13<=din38;
                dout14<=din40;
                dout15<=din42;
                if(tf_gen_addr_in<32)begin
                    dout0 <=din0a;
                    dout4 <=din11a;
                    dout8 <=din22a;
                    dout12<=din33a;
                end
                else if(tf_gen_addr_in<64)begin
                    dout0 <=din1a;
                    dout4 <=din12;
                    dout8 <=din23;
                    dout12<=din34;
                end
                else if(tf_gen_addr_in<96)begin
                    dout0 <=din2;
                    dout4 <=din13;
                    dout8 <=din24;
                    dout12<=din35;
                end
                else begin
                    dout0 <=din3;
                    dout4 <=din12;
                    dout8 <=din25;
                    dout12<=din36;
                end
            end
        end
        else begin //msm mode: use dout0,1,2,3,4 for bucket_a;
                   //          use dout5,6,7,8,9 for bucket_b;
                   //          use dout10,11,12,13,14 for result_buffer;
                   //          use a new dout_ip[1023:0] for ip and point.
            {dout0,dout1,dout2,dout3,dout4} <= {din0a,din11a,din22a,din33a,din1a};
            {dout5,dout6,dout7,dout8,dout9} <= {din0b,din11b,din22b,din33b,din1b};
            {dout10,dout11,dout12,dout13,dout14} <= {din12,din23,din34,din2,din13};
            if(bg_sel)begin
                if(msm_r_addr_id_in<2176)begin
                    dout_ip <= {din8,din19,din30,din41};
                end
                else if(msm_r_addr_id_in<2304)begin
                    dout_ip <= {din9,din20,din31,din42};
                end
                else begin
                    dout_ip <= {din10,din21,din32,din43};
                end
            end
            else begin
                if(msm_r_addr_id_in<2176)begin
                    dout_ip <= {din5,din16,din27,din38};
                end
                else if(msm_r_addr_id_in<2304)begin
                    dout_ip <= {din6,din17,din28,din39};
                end
                else begin
                    dout_ip <= {din7,din18,din29,din40};
                end
            end
        end
    end
endmodule
