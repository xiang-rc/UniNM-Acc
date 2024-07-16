module bg5_input_logic(
    input                                 flag_msm     , //==0: do ntt; ==1: do msm
    input                                 bg_sel       , //==0: load 0,1,4,5; ==1: load2,3,4,5
    input      [     10:0]                load_addr_in ,
    input                                 ce_load      , //from bank_load_logic
    input                                 wen_load     ,
    input      [     11:0]                msm_addr_in  ,
    input                                 ce_msm       ,
    input                                 ren_msm      ,
    input      [  9*4-1:0]                ntt_addr_in  , //4 9-bit
    input      [    8-1:0]                ce_ntt       , //8 1-bit
    input      [    8-1:0]                wen_ntt      , //8 1-bit
    input      [  512-1:0]                data_load_in , //from bank_load_logic
    output reg [  8*7-1:0]                addr_out     , //8 7-bit
    output reg [    8-1:0]                ce_out       , //8 1-bit
    output reg [    8-1:0]                wen_out      , //8 1-bit
    output reg [  256-1:0]                dout0        ,
    output reg [  256-1:0]                dout1        ,
    output reg [  256-1:0]                dout2        ,
    output reg [  256-1:0]                dout3        ,
    output reg [  256-1:0]                dout4        ,
    output reg [  256-1:0]                dout5        ,
    output reg [  256-1:0]                dout6        ,
    output reg [  256-1:0]                dout7         //
);
    always@(*)begin //ce_out
        if(ce_load || flag_msm)begin//load or msm mode, read point and scalar
            if(bg_sel)begin
                ce_out = 8'b 1010_1010;
            end
            else begin
                ce_out = 8'b 0101_1010;
            end
        end
        //else if(flag_msm)begin//msm mode, read point and scalar
        //    if(bg_sel)begin
        //        ce_out = 8'b 1010_1010;
        //    end
        //    else begin
        //        ce_out = 8'b 0101_1010;
        //    end
        //end
        else begin//ntt mode, read tf value
            ce_out = 8'b 1111_1111;
        end
    end
    always@(*)begin //wen_out
        if(ce_load)begin//load
            if(bg_sel)begin
                wen_out = 8'b 1010_1010;
            end
            else begin
                wen_out = 8'b 0101_1010;
            end
        end
        else if(flag_msm)begin//msm mode, read point and scalar
            if(bg_sel)begin
                wen_out = 8'b 0101_1010;
            end
            else begin
                wen_out = 8'b 1010_1010;
            end
        end
        else begin//ntt mode, read tf value
            wen_out = 8'b 0000_0000;
        end
    end
    always@(*)begin //addr_out
        if(ce_load)begin//load
            if(bg_sel)begin
                addr_out = {load_addr_in[6:0],7'b0,load_addr_in[6:0],7'b0,load_addr_in[6:0],7'b0,load_addr_in[6:0],7'b0};
            end
            else begin
                addr_out = {7'b0,load_addr_in[6:0],7'b0,load_addr_in[6:0],7'b0,load_addr_in[6:0],7'b0,load_addr_in[6:0]};
            end
        end
        else if(flag_msm)begin//msm mode, read point and scalar
            if(bg_sel)begin
                addr_out = {msm_addr_in[6:0],7'b0,msm_addr_in[6:0],7'b0,msm_addr_in[6:0],7'b0,msm_addr_in[6:0],7'b0};
            end
            else begin
                addr_out = {7'b0,msm_addr_in[6:0],7'b0,msm_addr_in[6:0],7'b0,msm_addr_in[6:0],7'b0,msm_addr_in[6:0]};
            end
        end
        else begin//ntt mode, read tf value
            addr_out = {8{ntt_addr_in[6:0]}};
            //if (ntt_addr_in[9*0+:9]<128)begin
            //end
            //    addr_out[7*0+:7] = 
            //    addr_out[7*1+:7] = 
            //    addr_out[7*2+:7] = 
            //    addr_out[7*3+:7] = 
            //    addr_out[7*4+:7] = 
            //    addr_out[7*5+:7] = 
            //    addr_out[7*6+:7] = 
            //    addr_out[7*7+:7] = 
        end
    end
    always@(*)begin //dout
        if(ce_load)begin//load
            if(bg_sel)begin
                if(load_addr_in[7])begin//>=128
                    {dout1,dout5}=data_load_in;
                end
                else begin//<128
                    {dout3,dout7}=data_load_in;
                end
            end
            else begin
                if(load_addr_in[7])begin//>=128
                    {dout0,dout4}=data_load_in;
                end
                else begin//<128
                    {dout2,dout6}=data_load_in;
                end
            end
        end
        else begin
            dout0 = 0;
            dout1 = 0;
            dout2 = 0;
            dout3 = 0;
            dout4 = 0;
            dout5 = 0;
            dout6 = 0;
            dout7 = 0;
        end
    end
endmodule
