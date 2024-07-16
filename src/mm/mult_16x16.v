`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2023 05:06:27 PM
// Design Name: 
// Module Name: mult_16x16
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


module mult_16x16(
    input clk,
    input a,
    input b,
    output reg p
    );
    
    reg [16-1:0] a_reg;
    reg [16-1:0] b_reg;
    reg [32-1:0] p_reg;
    wire [16-1:0] a_wire;
    wire [16-1:0] b_wire;
    wire [32-1:0] p_wire;
    reg [32-1:0] p_wire_dly;
    
    always @(posedge clk) begin
        a_reg[16-1:1] <= a_reg[16-2:0];
        a_reg[0]     <= a;
        b_reg[16-1:1] <= b_reg[16-2:0];
        b_reg[0]     <= b;
        p_reg <= p_wire;
        p <= ^ p_reg;
    end
    
    assign a_wire = a_reg;
    assign b_wire = b_reg;
    assign p_wire = a_wire * b_wire;
    
    always @(posedge clk) begin
        p_wire_dly <= p_wire;
    end
    
    
endmodule
