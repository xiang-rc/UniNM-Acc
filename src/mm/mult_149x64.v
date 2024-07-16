`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2023 01:48:37 PM
// Design Name: 
// Module Name: mult_149x64
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


module mult_149x64(
     input            clk,
     input  [149-1:0] a,
     input  [ 64-1:0] b,
     output [149+64-1:0] p
    );
    wire [31:0] b_h, b_l;
    wire [149+32-1:0] p_h, p_l;
//    reg [149+32-1:0] p_h_pip, p_l_pip;
    assign b_h = b[32+:32]; assign b_l = b[0+:32];
    mult_149x32 mult_h (.clk(clk), .a(a), .b(b_h), .p(p_h));
    mult_149x32 mult_l (.clk(clk), .a(a), .b(b_l), .p(p_l));
//    always @(posedge clk) begin
//        p_h_pip <= p_h; p_l_pip <= p_l;
//    end
    assign p = p_l + {p_h , {32{1'b0}}};
endmodule
