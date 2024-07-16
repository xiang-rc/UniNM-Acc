`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2023 01:40:16 PM
// Design Name: 
// Module Name: mult_149x48
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


module mult_149x48(
     input            clk,
     input  [149-1:0] a,
     input  [ 48-1:0] b,
     output [149+48-1:0] p
    );
    wire [31:0] b_h;
    wire [15:0] b_l;
    wire [149+31:0] p_h;
    wire [149+15:0] p_l;
    assign b_h = b[16+:32]; assign b_l = b[0+:16];
    
    mult_149x32 mult_h(.clk(clk), .a(a), .b(b_h), .p(p_h));
    mult_149x16 mult_l(.clk(clk), .a(a), .b(b_l), .p(p_l));
    
    assign p = p_l + {p_h , {32{1'b0}}};
endmodule
