`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2023 02:53:56 PM
// Design Name: 
// Module Name: mm_64x64
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

module mm_64x64(
    input             clk,
//    input             rst_n,
//    input             en,
    input      [63:0] a,
    input      [63:0] b,
    output reg [63:0] p
);

    wire [127:0] product_ab;
    reg  [127:0] product_ab_reg;
    wire [31:0] ab [3:0];
    wire [31:0] sum_ab_2_3, t1, t0;
    reg  [31:0] t0_reg;
    wire [63:0] t1_shift, c, c_sub_mod;
    reg  [63:0] t1_shift_reg;
    wire [63:0] p_wire;
    localparam mod = 64'h ffff_ffff_0000_0001;
    localparam mod_sub_1 = 64'h ffff_ffff_0000_0000;

//    assign product_ab = a*b;
    mult_64x64 mult_U0 (.clk(clk), .a(a), .b(b), .p(product_ab));
    always@(posedge clk) product_ab_reg <= product_ab;
    
    assign ab[0] = product_ab_reg[0*32+:32]; 
    assign ab[1] = product_ab_reg[1*32+:32]; 
    assign ab[2] = product_ab_reg[2*32+:32]; 
    assign ab[3] = product_ab_reg[3*32+:32];

    assign sum_ab_2_3 = ab[2] + ab[3];
    assign t1 = ab[1] + ab[2];

    assign t0 = ab[0] - sum_ab_2_3;
    assign t1_shift = t1 << 32;
    always@(posedge clk) begin t0_reg <= t0; t1_shift_reg <= t1_shift; end

    assign c = {32'b0,t0_reg} + t1_shift_reg;
    assign c_sub_mod = c - mod;
    
    assign p_wire = (c > mod_sub_1) ? c_sub_mod:c;
    always@(posedge clk) p <= p_wire;

endmodule
