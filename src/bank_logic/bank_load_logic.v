module bank_load_logic #(parameter WIDTH_DATA_LOAD = 512)(
    input                            bg_sel        , //==0: load 0,1,4,5; ==1: load2,3,4,5
    input                            flag_msm      , //==0: do ntt; ==1: do msm
    input      [9:0]                 ntt_load_addr ,
    input                            ntt_load_en   ,
    input                            ntt_load_wen  ,
    input      [11:0]                msm_load_addr ,
    input                            msm_load_en   ,
    input                            msm_load_wen  ,
    input      [WIDTH_DATA_LOAD-1:0] data_load_in  ,
    output reg [5:0]                 bg_ce         , //select load bg0 or 1 or 2 or 3 or 4 or 5
    output reg [10:0]                load_addr_out0,
    output reg [10:0]                load_addr_out1,
    output reg [10:0]                load_addr_out2,
    output reg [10:0]                load_addr_out3,
    output reg [10:0]                load_addr_out4,
    output reg [10:0]                load_addr_out5,
    output     [WIDTH_DATA_LOAD-1:0] data_load_out0,
    output     [WIDTH_DATA_LOAD-1:0] data_load_out1,
    output     [WIDTH_DATA_LOAD-1:0] data_load_out2,
    output     [WIDTH_DATA_LOAD-1:0] data_load_out3,
    output     [WIDTH_DATA_LOAD-1:0] data_load_out4,
    output     [WIDTH_DATA_LOAD-1:0] data_load_out5,
    output reg [5:0]                 load_wen_out   //
);
    localparam BG4_BIOS = 256;
    localparam BG4_P_NUM = 384;
    localparam BG5_P_NUM = 128;
    always@(*)begin //bg_ce and load_wen_out
        if(flag_msm) begin //msm
            if(bg_sel)begin
                if(msm_load_addr<=1023) begin
                    bg_ce[0] =           0;
                    bg_ce[1] =           0;
                    bg_ce[2] = msm_load_en;
                    bg_ce[3] =           0;
                    bg_ce[4] =           0;
                    bg_ce[5] =           0;
                    load_wen_out[0] =            0;
                    load_wen_out[1] =            0;
                    load_wen_out[2] = msm_load_wen;
                    load_wen_out[3] =            0;
                    load_wen_out[4] =            0;
                    load_wen_out[5] =            0;
                end
                else if (msm_load_addr<=2047) begin
                    bg_ce[0] =           0;
                    bg_ce[1] =           0;
                    bg_ce[2] =           0;
                    bg_ce[3] = msm_load_en;
                    bg_ce[4] =           0;
                    bg_ce[5] =           0;
                    load_wen_out[0] =            0;
                    load_wen_out[1] =            0;
                    load_wen_out[2] =            0;
                    load_wen_out[3] = msm_load_wen;
                    load_wen_out[4] =            0;
                    load_wen_out[5] =            0;
                end
                else if (msm_load_addr<=2048+BG4_P_NUM-1) begin
                    bg_ce[0] =           0;
                    bg_ce[1] =           0;
                    bg_ce[2] =           0;
                    bg_ce[3] =           0;
                    bg_ce[4] = msm_load_en;
                    bg_ce[5] =           0;
                    load_wen_out[0] =            0;
                    load_wen_out[1] =            0;
                    load_wen_out[2] =            0;
                    load_wen_out[3] =            0;
                    load_wen_out[4] = msm_load_wen;
                    load_wen_out[5] =            0;
                end
                else begin
                    bg_ce[0] =           0;
                    bg_ce[1] =           0;
                    bg_ce[2] =           0;
                    bg_ce[3] =           0;
                    bg_ce[4] =           0;
                    bg_ce[5] = msm_load_en;
                    load_wen_out[0] =            0;
                    load_wen_out[1] =            0;
                    load_wen_out[2] =            0;
                    load_wen_out[3] =            0;
                    load_wen_out[4] =            0;
                    load_wen_out[5] = msm_load_wen;
                end
            end
            else begin
                if(msm_load_addr<=1023) begin
                    bg_ce[0] = msm_load_en;
                    bg_ce[1] =           0;
                    bg_ce[2] =           0;
                    bg_ce[3] =           0;
                    bg_ce[4] =           0;
                    bg_ce[5] =           0;
                    load_wen_out[0] = msm_load_wen;
                    load_wen_out[1] =            0;
                    load_wen_out[2] =            0;
                    load_wen_out[3] =            0;
                    load_wen_out[4] =            0;
                    load_wen_out[5] =            0;
                end
                else if (msm_load_addr<=2047) begin
                    bg_ce[0] =           0;
                    bg_ce[1] = msm_load_en;
                    bg_ce[2] =           0;
                    bg_ce[3] =           0;
                    bg_ce[4] =           0;
                    bg_ce[5] =           0;
                    load_wen_out[0] =            0;
                    load_wen_out[1] = msm_load_wen;
                    load_wen_out[2] =            0;
                    load_wen_out[3] =            0;
                    load_wen_out[4] =            0;
                    load_wen_out[5] =            0;
                end
                else if (msm_load_addr<=2048+BG4_P_NUM-1) begin
                    bg_ce[0] =           0;
                    bg_ce[1] =           0;
                    bg_ce[2] =           0;
                    bg_ce[3] =           0;
                    bg_ce[4] = msm_load_en;
                    bg_ce[5] =           0;
                    load_wen_out[0] =            0;
                    load_wen_out[1] =            0;
                    load_wen_out[2] =            0;
                    load_wen_out[3] =            0;
                    load_wen_out[4] = msm_load_wen;
                    load_wen_out[5] =            0;
                end
                else begin
                    bg_ce[0] =           0;
                    bg_ce[1] =           0;
                    bg_ce[2] =           0;
                    bg_ce[3] =           0;
                    bg_ce[4] =           0;
                    bg_ce[5] = msm_load_en;
                    load_wen_out[0] =            0;
                    load_wen_out[1] =            0;
                    load_wen_out[2] =            0;
                    load_wen_out[3] =            0;
                    load_wen_out[4] =            0;
                    load_wen_out[5] = msm_load_wen;
                end
            end
        end
        else begin //ntt
            if(bg_sel)begin
                bg_ce[0] =           0;
                bg_ce[1] =           0;
                bg_ce[2] = ntt_load_en;
                bg_ce[3] =           0;
                bg_ce[4] =           0;
                bg_ce[5] =           0;
                load_wen_out[0] =            0;
                load_wen_out[1] =            0;
                load_wen_out[2] = ntt_load_wen;
                load_wen_out[3] =            0;
                load_wen_out[4] =            0;
                load_wen_out[5] =            0;
            end
            else begin
                bg_ce[0] =           0;
                bg_ce[1] = ntt_load_en;
                bg_ce[2] =           0;
                bg_ce[3] =           0;
                bg_ce[4] =           0;
                bg_ce[5] =           0;
                load_wen_out[0] =            0;
                load_wen_out[1] = ntt_load_wen;
                load_wen_out[2] =            0;
                load_wen_out[3] =            0;
                load_wen_out[4] =            0;
                load_wen_out[5] =            0;
            end
        end
    end
    always@(*)begin //load_addr_out
        if(flag_msm) begin //msm
            if(bg_sel)begin
                if(msm_load_addr<=1023) begin
                    load_addr_out0 =                   0;
                    load_addr_out1 =                   0;
                    load_addr_out2 = msm_load_addr[10:0];
                    load_addr_out3 =                   0;
                    load_addr_out4 =                   0;
                    load_addr_out5 =                   0;
                end
                else if (msm_load_addr<=2047) begin
                    load_addr_out0 =                   0;
                    load_addr_out1 =                   0;
                    load_addr_out2 =                   0;
                    load_addr_out3 = msm_load_addr[10:0];
                    load_addr_out4 =                   0;
                    load_addr_out5 =                   0;
                end
                else if (msm_load_addr<=2048+BG4_P_NUM-1) begin
                    load_addr_out0 =                   0;
                    load_addr_out1 =                   0;
                    load_addr_out2 =                   0;
                    load_addr_out3 =                   0;
                    load_addr_out4 = msm_load_addr[10:0] + BG4_BIOS + BG4_P_NUM;
                    load_addr_out5 =                   0;
                end
                else begin
                    load_addr_out0 =                   0;
                    load_addr_out1 =                   0;
                    load_addr_out2 =                   0;
                    load_addr_out3 =                   0;
                    load_addr_out4 =                   0;
                    load_addr_out5 = msm_load_addr[10:0] + BG5_P_NUM;
                end
            end
            else begin
                if(msm_load_addr<=1023) begin
                    load_addr_out0 = msm_load_addr[10:0];
                    load_addr_out1 =                   0;
                    load_addr_out2 =                   0;
                    load_addr_out3 =                   0;
                    load_addr_out4 =                   0;
                    load_addr_out5 =                   0;
                end
                else if (msm_load_addr<=2047) begin
                    load_addr_out0 = msm_load_addr[10:0];
                    load_addr_out1 =                   0;
                    load_addr_out2 =                   0;
                    load_addr_out3 =                   0;
                    load_addr_out4 =                   0;
                    load_addr_out5 =                   0;
                end
                else if (msm_load_addr<=2048+BG4_P_NUM-1) begin
                    load_addr_out0 =                   0;
                    load_addr_out1 =                   0;
                    load_addr_out2 =                   0;
                    load_addr_out3 =                   0;
                    load_addr_out4 = msm_load_addr[10:0] + BG4_BIOS;
                    load_addr_out5 =                   0;
                end
                else begin
                    load_addr_out0 =                   0;
                    load_addr_out1 =                   0;
                    load_addr_out2 =                   0;
                    load_addr_out3 =                   0;
                    load_addr_out4 =                   0;
                    load_addr_out5 = msm_load_addr[10:0];
                end
            end
        end
        else begin //ntt
            if(bg_sel)begin
                load_addr_out0 =                   0;
                load_addr_out1 =                   0;
                load_addr_out2 =  {1'b0,ntt_load_addr[9:0]};
                load_addr_out3 =                   0;
                load_addr_out4 =                   0;
                load_addr_out5 =                   0;
            end
            else begin
                load_addr_out0 =  {1'b0,ntt_load_addr[9:0]};
                load_addr_out1 =                   0;
                load_addr_out2 =                   0;
                load_addr_out3 =                   0;
                load_addr_out4 =                   0;
                load_addr_out5 =                   0;
            end
        end
    end
    assign data_load_out0 = data_load_in;
    assign data_load_out1 = data_load_in;
    assign data_load_out2 = data_load_in;
    assign data_load_out3 = data_load_in;
    assign data_load_out4 = data_load_in;
    assign data_load_out5 = data_load_in;
endmodule
