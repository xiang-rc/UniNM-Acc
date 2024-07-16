`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2023 03:12:36 PM
// Design Name: 
// Module Name: mult_64x64
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mult_64x64(
    input          clk,
    input  [63 :0] a,
    input  [63 :0] b,
    output [127:0] p
    );

    wire [25 :0] a_0, a_1, a_2, a_3;
    wire [15 :0] b_0, b_1, b_2;
    reg  [31 :0] p_0 [3:0];
    reg  [31 :0] p_1 [3:0];
    reg  [31 :0] p_2 [3:0];
    reg  [31 :0] p_3 [3:0];
    wire [79 :0] p_x_sum [3:0];
    
    assign a_0 = a[16*0+:16]; assign a_1 = a[16*1+:16]; assign a_2 = a[16*2+:16]; assign a_3 = a[16*3+:16];
    assign b_0 = b[26*0+:26]; assign b_1 = b[26*1+:26]; assign b_2 = {14'b0,b[26*2+:12]}; 
    
    always @ (posedge clk) begin
        p_0[0] <= a_0*b_0;  p_0[1] <= a_0*b_1;  p_0[2] <= a_0*b_2;
        p_1[0] <= a_1*b_0;  p_1[1] <= a_1*b_1;  p_1[2] <= a_1*b_2;
        p_2[0] <= a_2*b_0;  p_2[1] <= a_2*b_1;  p_2[2] <= a_2*b_2;
        p_3[0] <= a_3*b_0;  p_3[1] <= a_3*b_1;  p_3[2] <= a_3*b_2;
    end
    
    assign p_x_sum[0] = p_0[0] + (p_0[1]<<26*1) + (p_0[2]<<26*2);
    assign p_x_sum[1] = p_1[0] + (p_1[1]<<26*1) + (p_1[2]<<26*2);
    assign p_x_sum[2] = p_2[0] + (p_2[1]<<26*1) + (p_2[2]<<26*2);
    assign p_x_sum[3] = p_3[0] + (p_3[1]<<26*1) + (p_3[2]<<26*2);
    
    assign p = p_x_sum[0] + (p_x_sum[1]<<16*1) + (p_x_sum[2]<<16*2) + (p_x_sum[3]<<16*3);
endmodule
