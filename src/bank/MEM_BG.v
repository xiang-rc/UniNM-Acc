module MEM_BG(
    input                     clk         ,
    input                     bg_en_0     ,
    input                     bg_en_1     ,
    input                     bg_en_2     ,
    input                     bg_en_3     ,
    input                     bg_en_4     ,
    input                     bg_en_5     ,
    input                     bg_en_6     ,
    input                     bg_en_7     ,
    input                     bg_en_8     ,
    input                     bg_en_9     ,
    input                     bg_en_10    ,
    input                     bg_en_11    ,
    input                     bg_en_12    ,
    input                     bg_en_13    ,
    input                     bg_en_14    ,
    input                     bg_en_15    ,
    input                     bg_en_16    ,
    input                     bg_en_17    ,
    input                     bg_en_18    ,
    input                     bg_en_19    ,
    input                     bg_en_20    ,
    input                     bg_en_21    ,
    input                     bg_en_22    ,
    input                     bg_en_23    ,
    input                     bg_en_24    ,
    input                     bg_en_25    ,
    input                     bg_en_26    ,
    input                     bg_en_27    ,
    input                     bg_en_28    ,
    input                     bg_en_29    ,
    input                     bg_en_30    ,
    input                     bg_en_31    ,
    input                     bg_wen_0    ,
    input                     bg_wen_1    ,
    input                     bg_wen_2    ,
    input                     bg_wen_3    ,
    input                     bg_wen_4    ,
    input                     bg_wen_5    ,
    input                     bg_wen_6    ,
    input                     bg_wen_7    ,
    input                     bg_wen_8    ,
    input                     bg_wen_9    ,
    input                     bg_wen_10   ,
    input                     bg_wen_11   ,
    input                     bg_wen_12   ,
    input                     bg_wen_13   ,
    input                     bg_wen_14   ,
    input                     bg_wen_15   ,
    input                     bg_wen_16   ,
    input                     bg_wen_17   ,
    input                     bg_wen_18   ,
    input                     bg_wen_19   ,
    input                     bg_wen_20   ,
    input                     bg_wen_21   ,
    input                     bg_wen_22   ,
    input                     bg_wen_23   ,
    input                     bg_wen_24   ,
    input                     bg_wen_25   ,
    input                     bg_wen_26   ,
    input                     bg_wen_27   ,
    input                     bg_wen_28   ,
    input                     bg_wen_29   ,
    input                     bg_wen_30   ,
    input                     bg_wen_31   ,
    input        [   6:0]     bg_addr_0   ,
    input        [   6:0]     bg_addr_1   ,
    input        [   6:0]     bg_addr_2   ,
    input        [   6:0]     bg_addr_3   ,
    input        [   6:0]     bg_addr_4   ,
    input        [   6:0]     bg_addr_5   ,
    input        [   6:0]     bg_addr_6   ,
    input        [   6:0]     bg_addr_7   ,
    input        [   6:0]     bg_addr_8   ,
    input        [   6:0]     bg_addr_9   ,
    input        [   6:0]     bg_addr_10  ,
    input        [   6:0]     bg_addr_11  ,
    input        [   6:0]     bg_addr_12  ,
    input        [   6:0]     bg_addr_13  ,
    input        [   6:0]     bg_addr_14  ,
    input        [   6:0]     bg_addr_15  ,
    input        [   6:0]     bg_addr_16  ,
    input        [   6:0]     bg_addr_17  ,
    input        [   6:0]     bg_addr_18  ,
    input        [   6:0]     bg_addr_19  ,
    input        [   6:0]     bg_addr_20  ,
    input        [   6:0]     bg_addr_21  ,
    input        [   6:0]     bg_addr_22  ,
    input        [   6:0]     bg_addr_23  ,
    input        [   6:0]     bg_addr_24  ,
    input        [   6:0]     bg_addr_25  ,
    input        [   6:0]     bg_addr_26  ,
    input        [   6:0]     bg_addr_27  ,
    input        [   6:0]     bg_addr_28  ,
    input        [   6:0]     bg_addr_29  ,
    input        [   6:0]     bg_addr_30  ,
    input        [   6:0]     bg_addr_31  ,
    input        [ 255:0]     bg_din_0    ,
    input        [ 255:0]     bg_din_1    ,
    input        [ 255:0]     bg_din_2    ,
    input        [ 255:0]     bg_din_3    ,
    input        [ 255:0]     bg_din_4    ,
    input        [ 255:0]     bg_din_5    ,
    input        [ 255:0]     bg_din_6    ,
    input        [ 255:0]     bg_din_7    ,
    input        [ 255:0]     bg_din_8    ,
    input        [ 255:0]     bg_din_9    ,
    input        [ 255:0]     bg_din_10   ,
    input        [ 255:0]     bg_din_11   ,
    input        [ 255:0]     bg_din_12   ,
    input        [ 255:0]     bg_din_13   ,
    input        [ 255:0]     bg_din_14   ,
    input        [ 255:0]     bg_din_15   ,
    input        [ 255:0]     bg_din_16   ,
    input        [ 255:0]     bg_din_17   ,
    input        [ 255:0]     bg_din_18   ,
    input        [ 255:0]     bg_din_19   ,
    input        [ 255:0]     bg_din_20   ,
    input        [ 255:0]     bg_din_21   ,
    input        [ 255:0]     bg_din_22   ,
    input        [ 255:0]     bg_din_23   ,
    input        [ 255:0]     bg_din_24   ,
    input        [ 255:0]     bg_din_25   ,
    input        [ 255:0]     bg_din_26   ,
    input        [ 255:0]     bg_din_27   ,
    input        [ 255:0]     bg_din_28   ,
    input        [ 255:0]     bg_din_29   ,
    input        [ 255:0]     bg_din_30   ,
    input        [ 255:0]     bg_din_31   ,
    output       [ 255:0]     bg_dout_0   ,
    output       [ 255:0]     bg_dout_1   ,
    output       [ 255:0]     bg_dout_2   ,
    output       [ 255:0]     bg_dout_3   ,
    output       [ 255:0]     bg_dout_4   ,
    output       [ 255:0]     bg_dout_5   ,
    output       [ 255:0]     bg_dout_6   ,
    output       [ 255:0]     bg_dout_7   ,
    output       [ 255:0]     bg_dout_8   ,
    output       [ 255:0]     bg_dout_9   ,
    output       [ 255:0]     bg_dout_10  ,
    output       [ 255:0]     bg_dout_11  ,
    output       [ 255:0]     bg_dout_12  ,
    output       [ 255:0]     bg_dout_13  ,
    output       [ 255:0]     bg_dout_14  ,
    output       [ 255:0]     bg_dout_15  ,
    output       [ 255:0]     bg_dout_16  ,
    output       [ 255:0]     bg_dout_17  ,
    output       [ 255:0]     bg_dout_18  ,
    output       [ 255:0]     bg_dout_19  ,
    output       [ 255:0]     bg_dout_20  ,
    output       [ 255:0]     bg_dout_21  ,
    output       [ 255:0]     bg_dout_22  ,
    output       [ 255:0]     bg_dout_23  ,
    output       [ 255:0]     bg_dout_24  ,
    output       [ 255:0]     bg_dout_25  ,
    output       [ 255:0]     bg_dout_26  ,
    output       [ 255:0]     bg_dout_27  ,
    output       [ 255:0]     bg_dout_28  ,
    output       [ 255:0]     bg_dout_29  ,
    output       [ 255:0]     bg_dout_30  ,
    output       [ 255:0]     bg_dout_31   //
);

    wire    [  31:0]   en            ;
    wire    [  31:0]   wen           ;
    wire    [   6:0]   A    [  31:0] ;
    wire    [ 255:0]   D    [  31:0] ;
    wire    [ 255:0]   Q    [  31:0] ;

    assign en[0]  = bg_en_0;
    assign en[1]  = bg_en_1;
    assign en[2]  = bg_en_2;
    assign en[3]  = bg_en_3;
    assign en[4]  = bg_en_4;
    assign en[5]  = bg_en_5;
    assign en[6]  = bg_en_6;
    assign en[7]  = bg_en_7;
    assign en[8]  = bg_en_8;
    assign en[9]  = bg_en_9;
    assign en[10] = bg_en_10;
    assign en[11] = bg_en_11;
    assign en[12] = bg_en_12;
    assign en[13] = bg_en_13;
    assign en[14] = bg_en_14;
    assign en[15] = bg_en_15;
    assign en[16] = bg_en_16;
    assign en[17] = bg_en_17;
    assign en[18] = bg_en_18;
    assign en[19] = bg_en_19;
    assign en[20] = bg_en_20;
    assign en[21] = bg_en_21;
    assign en[22] = bg_en_22;
    assign en[23] = bg_en_23;
    assign en[24] = bg_en_24;
    assign en[25] = bg_en_25;
    assign en[26] = bg_en_26;
    assign en[27] = bg_en_27;
    assign en[28] = bg_en_28;
    assign en[29] = bg_en_29;
    assign en[30] = bg_en_30;
    assign en[31] = bg_en_31;

    assign wen[0]  = bg_wen_0;
    assign wen[1]  = bg_wen_1;
    assign wen[2]  = bg_wen_2;
    assign wen[3]  = bg_wen_3;
    assign wen[4]  = bg_wen_4;
    assign wen[5]  = bg_wen_5;
    assign wen[6]  = bg_wen_6;
    assign wen[7]  = bg_wen_7;
    assign wen[8]  = bg_wen_8;
    assign wen[9]  = bg_wen_9;
    assign wen[10] = bg_wen_10;
    assign wen[11] = bg_wen_11;
    assign wen[12] = bg_wen_12;
    assign wen[13] = bg_wen_13;
    assign wen[14] = bg_wen_14;
    assign wen[15] = bg_wen_15;
    assign wen[16] = bg_wen_16;
    assign wen[17] = bg_wen_17;
    assign wen[18] = bg_wen_18;
    assign wen[19] = bg_wen_19;
    assign wen[20] = bg_wen_20;
    assign wen[21] = bg_wen_21;
    assign wen[22] = bg_wen_22;
    assign wen[23] = bg_wen_23;
    assign wen[24] = bg_wen_24;
    assign wen[25] = bg_wen_25;
    assign wen[26] = bg_wen_26;
    assign wen[27] = bg_wen_27;
    assign wen[28] = bg_wen_28;
    assign wen[29] = bg_wen_29;
    assign wen[30] = bg_wen_30;
    assign wen[31] = bg_wen_31;

    assign A[0]  = bg_addr_0;
    assign A[1]  = bg_addr_1;
    assign A[2]  = bg_addr_2;
    assign A[3]  = bg_addr_3;
    assign A[4]  = bg_addr_4;
    assign A[5]  = bg_addr_5;
    assign A[6]  = bg_addr_6;
    assign A[7]  = bg_addr_7;
    assign A[8]  = bg_addr_8;
    assign A[9]  = bg_addr_9;
    assign A[10] = bg_addr_10;
    assign A[11] = bg_addr_11;
    assign A[12] = bg_addr_12;
    assign A[13] = bg_addr_13;
    assign A[14] = bg_addr_14;
    assign A[15] = bg_addr_15;
    assign A[16] = bg_addr_16;
    assign A[17] = bg_addr_17;
    assign A[18] = bg_addr_18;
    assign A[19] = bg_addr_19;
    assign A[20] = bg_addr_20;
    assign A[21] = bg_addr_21;
    assign A[22] = bg_addr_22;
    assign A[23] = bg_addr_23;
    assign A[24] = bg_addr_24;
    assign A[25] = bg_addr_25;
    assign A[26] = bg_addr_26;
    assign A[27] = bg_addr_27;
    assign A[28] = bg_addr_28;
    assign A[29] = bg_addr_29;
    assign A[30] = bg_addr_30;
    assign A[31] = bg_addr_31;

    assign D[0]  = bg_din_0;
    assign D[1]  = bg_din_1;
    assign D[2]  = bg_din_2;
    assign D[3]  = bg_din_3;
    assign D[4]  = bg_din_4;
    assign D[5]  = bg_din_5;
    assign D[6]  = bg_din_6;
    assign D[7]  = bg_din_7;
    assign D[8]  = bg_din_8;
    assign D[9]  = bg_din_9;
    assign D[10] = bg_din_10;
    assign D[11] = bg_din_11;
    assign D[12] = bg_din_12;
    assign D[13] = bg_din_13;
    assign D[14] = bg_din_14;
    assign D[15] = bg_din_15;
    assign D[16] = bg_din_16;
    assign D[17] = bg_din_17;
    assign D[18] = bg_din_18;
    assign D[19] = bg_din_19;
    assign D[20] = bg_din_20;
    assign D[21] = bg_din_21;
    assign D[22] = bg_din_22;
    assign D[23] = bg_din_23;
    assign D[24] = bg_din_24;
    assign D[25] = bg_din_25;
    assign D[26] = bg_din_26;
    assign D[27] = bg_din_27;
    assign D[28] = bg_din_28;
    assign D[29] = bg_din_29;
    assign D[30] = bg_din_30;
    assign D[31] = bg_din_31;

    genvar i;
    generate
        for(i=0; i<32; i=i+1) begin:inst
            MEM_128X256 u_mem128x256(
               .CLK              (clk           ),
               .CEB              (en[i]         ),
               .WEB              (wen[i]        ),
               .A                (A[i]          ),
               .D                (D[i]          ),
               .Q                (Q[i]          )
            );
        end
    endgenerate

    assign bg_dout_0  = Q[0];
    assign bg_dout_1  = Q[1];
    assign bg_dout_2  = Q[2];
    assign bg_dout_3  = Q[3];
    assign bg_dout_4  = Q[4];
    assign bg_dout_5  = Q[5];
    assign bg_dout_6  = Q[6];
    assign bg_dout_7  = Q[7];
    assign bg_dout_8  = Q[8];
    assign bg_dout_9  = Q[9];
    assign bg_dout_10 = Q[10];
    assign bg_dout_11 = Q[11];
    assign bg_dout_12 = Q[12];
    assign bg_dout_13 = Q[13];
    assign bg_dout_14 = Q[14];
    assign bg_dout_15 = Q[15];
    assign bg_dout_16 = Q[16];
    assign bg_dout_17 = Q[17];
    assign bg_dout_18 = Q[18];
    assign bg_dout_19 = Q[19];
    assign bg_dout_20 = Q[20];
    assign bg_dout_21 = Q[21];
    assign bg_dout_22 = Q[22];
    assign bg_dout_23 = Q[23];
    assign bg_dout_24 = Q[24];
    assign bg_dout_25 = Q[25];
    assign bg_dout_26 = Q[26];
    assign bg_dout_27 = Q[27];
    assign bg_dout_28 = Q[28];
    assign bg_dout_29 = Q[29];
    assign bg_dout_30 = Q[30];
    assign bg_dout_31 = Q[31];

endmodule

module MEM_128X256(
    input                     CLK         ,
    input                     CEB         ,
    input                     WEB         ,
    input        [   6:0]     A           ,
    input        [ 255:0]     D           ,
    output       [ 255:0]     Q
);

    TS1N28HPCPHVTB128X128M4SWBASO u0_mem128x128(
       .CLK              (CLK               ),
       .CEB              (CEB               ), // active low
       .WEB              (WEB               ), // active low
       .A                (A                 ), // 7bit
       .D                (D[127:0]          ), // 128bit
       .BWEB             (128'b0            ), // active low, bit write enable
       .CEBM             (1'b1              ), // BIST Mode
       .WEBM             (1'b1              ), // BIST Mode
       .AM               (7'b0              ), // BIST Mode
       .DM               (128'b0            ), // BIST Mode
       .BWEBM            (128'b0            ), // BIST Mode
       .BIST             (1'b0              ), // Mode Control
       .AWT              (1'b0              ), // Mode Control
       .SLP              (1'b0              ),
       .SD               (1'b0              ),
       .Q                (Q[127:0]          )
    );

    TS1N28HPCPHVTB128X128M4SWBASO u1_mem128x128(
       .CLK              (CLK               ),
       .CEB              (CEB               ), // active low
       .WEB              (WEB               ), // active low
       .A                (A                 ), // 7bit
       .D                (D[255:128]        ), // 128bit
       .BWEB             (128'b0            ), // active low, bit write enable
       .CEBM             (1'b1              ), // BIST Mode
       .WEBM             (1'b1              ), // BIST Mode
       .AM               (7'b0              ), // BIST Mode
       .DM               (128'b0            ), // BIST Mode
       .BWEBM            (128'b0            ), // BIST Mode
       .BIST             (1'b0              ), // Mode Control
       .AWT              (1'b0              ), // Mode Control
       .SLP              (1'b0              ),
       .SD               (1'b0              ),
       .Q                (Q[255:128]        )
    );

endmodule
