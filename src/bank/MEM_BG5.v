module MEM_BG5(
    input                     clk          ,
    input                     bg5_en_0     ,
    input                     bg5_en_1     ,
    input                     bg5_en_2     ,
    input                     bg5_en_3     ,
    input                     bg5_en_4     ,
    input                     bg5_en_5     ,
    input                     bg5_en_6     ,
    input                     bg5_en_7     ,
    input                     bg5_wen_0    ,
    input                     bg5_wen_1    ,
    input                     bg5_wen_2    ,
    input                     bg5_wen_3    ,
    input                     bg5_wen_4    ,
    input                     bg5_wen_5    ,
    input                     bg5_wen_6    ,
    input                     bg5_wen_7    ,
    input        [   6:0]     bg5_addr_0   ,
    input        [   6:0]     bg5_addr_1   ,
    input        [   6:0]     bg5_addr_2   ,
    input        [   6:0]     bg5_addr_3   ,
    input        [   6:0]     bg5_addr_4   ,
    input        [   6:0]     bg5_addr_5   ,
    input        [   6:0]     bg5_addr_6   ,
    input        [   6:0]     bg5_addr_7   ,
    input        [ 255:0]     bg5_din_0    ,
    input        [ 255:0]     bg5_din_1    ,
    input        [ 255:0]     bg5_din_2    ,
    input        [ 255:0]     bg5_din_3    ,
    input        [ 255:0]     bg5_din_4    ,
    input        [ 255:0]     bg5_din_5    ,
    input        [ 255:0]     bg5_din_6    ,
    input        [ 255:0]     bg5_din_7    ,
    output       [ 255:0]     bg5_dout_0   ,
    output       [ 255:0]     bg5_dout_1   ,
    output       [ 255:0]     bg5_dout_2   ,
    output       [ 255:0]     bg5_dout_3   ,
    output       [ 255:0]     bg5_dout_4   ,
    output       [ 255:0]     bg5_dout_5   ,
    output       [ 255:0]     bg5_dout_6   ,
    output       [ 255:0]     bg5_dout_7
);

    wire    [  31:0]   en            ;
    wire    [  31:0]   wen           ;
    wire    [   6:0]   A    [   7:0] ;
    wire    [ 255:0]   D    [   7:0] ;
    wire    [ 255:0]   Q    [   7:0] ;

    assign en[0]  = bg5_en_0;
    assign en[1]  = bg5_en_1;
    assign en[2]  = bg5_en_2;
    assign en[3]  = bg5_en_3;
    assign en[4]  = bg5_en_4;
    assign en[5]  = bg5_en_5;
    assign en[6]  = bg5_en_6;
    assign en[7]  = bg5_en_7;

    assign wen[0]  = bg5_wen_0;
    assign wen[1]  = bg5_wen_1;
    assign wen[2]  = bg5_wen_2;
    assign wen[3]  = bg5_wen_3;
    assign wen[4]  = bg5_wen_4;
    assign wen[5]  = bg5_wen_5;
    assign wen[6]  = bg5_wen_6;
    assign wen[7]  = bg5_wen_7;

    assign A[0]  = bg5_addr_0;
    assign A[1]  = bg5_addr_1;
    assign A[2]  = bg5_addr_2;
    assign A[3]  = bg5_addr_3;
    assign A[4]  = bg5_addr_4;
    assign A[5]  = bg5_addr_5;
    assign A[6]  = bg5_addr_6;
    assign A[7]  = bg5_addr_7;

    assign D[0]  = bg5_din_0;
    assign D[1]  = bg5_din_1;
    assign D[2]  = bg5_din_2;
    assign D[3]  = bg5_din_3;
    assign D[4]  = bg5_din_4;
    assign D[5]  = bg5_din_5;
    assign D[6]  = bg5_din_6;
    assign D[7]  = bg5_din_7;

    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin:inst
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

    assign bg5_dout_0  = Q[0];
    assign bg5_dout_1  = Q[1];
    assign bg5_dout_2  = Q[2];
    assign bg5_dout_3  = Q[3];
    assign bg5_dout_4  = Q[4];
    assign bg5_dout_5  = Q[5];
    assign bg5_dout_6  = Q[6];
    assign bg5_dout_7  = Q[7];

endmodule
