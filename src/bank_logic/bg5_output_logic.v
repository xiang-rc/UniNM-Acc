module bg5_output_logic(
    input                                 bg_sel       , //==0: load 0,1,4,5; ==1: load2,3,4,5
    input      [  256-1:0]                din0         ,
    input      [  256-1:0]                din1         ,
    input      [  256-1:0]                din2         ,
    input      [  256-1:0]                din3         ,
    input      [  256-1:0]                din4         ,
    input      [  256-1:0]                din5         ,
    input      [  256-1:0]                din6         ,
    input      [  256-1:0]                din7         ,
    output     [  256-1:0]                dout0        ,
    output     [  256-1:0]                dout1        ,
    output     [  256-1:0]                dout2        ,
    output     [  256-1:0]                dout3         //
);
    assign dout0 = (bg_sel) ? din1 : din0;
    assign dout1 = (bg_sel) ? din3 : din4;
    assign dout2 = (bg_sel) ? din5 : din2;
    assign dout3 = (bg_sel) ? din7 : din6;
endmodule
