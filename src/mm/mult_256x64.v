`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 03:17:41 PM
// Design Name: 
// Module Name: mult_256x64
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

//6 cycles delay ver
//module mult_256x64(
//    input          clk,
//    input  [255:0] a,
//    input  [63 :0] b,
//    output reg [319:0] p
//    );
//    
//    wire [31 :0] b_32b1;
//    wire [31 :0] b_32b2;
//    wire [287:0] p_288b1;
//    wire [287:0] p_288b2;
//    wire [319:0] p_288b1_shift, p_288b2_shift;
//    reg  [319:0] p_288b1_shift_dly1, p_288b1_shift_dly2, p_288b2_shift_dly1, p_288b2_shift_dly2;
//    reg  [319:0] p_pip0;
//    assign b_32b1 = b[0+:32]; assign b_32b2 = b[32+:32];
//    
//    mult_256x32 mult_U32b1(.clk(clk), .a(a), .b(b_32b1), .p(p_288b1));//2cycles
//    mult_256x32 mult_U32b2(.clk(clk), .a(a), .b(b_32b2), .p(p_288b2));//2cycles
//    
//    assign p_288b1_shift = { {32{1'b0}} , p_288b1 };
//    assign p_288b2_shift = { p_288b2 , {32{1'b0}} };
//    
//    always @(posedge clk) begin
//        p_288b1_shift_dly1 <= p_288b1_shift;
//        p_288b1_shift_dly2 <= p_288b1_shift_dly1;
//        p_288b2_shift_dly1 <= p_288b2_shift;
//        p_288b2_shift_dly2 <= p_288b2_shift_dly1;
//    end
//    
//    always @ (posedge clk) begin
//        p_pip0 <= p_288b2_shift_dly2 + p_288b1_shift_dly2;
//        p      <= p_pip0;
//    end
//    
//endmodule

//2 cycles delay ver
module mult_256x64(
    input          clk,
    input  [255:0] a,
    input  [63 :0] b,
    output reg [319:0] p
    );
    
//    wire [31 :0] b_32b1;
//    wire [31 :0] b_32b2;
//    wire [287:0] p_288b1;
//    wire [287:0] p_288b2;
//    wire [319:0] p_288b1_shift, p_288b2_shift;
//    reg  [319:0] p_288b1_shift_dly1, p_288b2_shift_dly1;
//
//    assign b_32b1 = b[0+:32]; assign b_32b2 = b[32+:32];
//    
//    mult_256x32 mult_U32b1(.a(a), .b(b_32b1), .p(p_288b1));
//    mult_256x32 mult_U32b2(.a(a), .b(b_32b2), .p(p_288b2));
//    
//    assign p_288b1_shift = { {32{1'b0}} , p_288b1 };
//    assign p_288b2_shift = { p_288b2 , {32{1'b0}} };
//    
//    always @(posedge clk) begin
//        p_288b1_shift_dly1 <= p_288b1_shift;
//        p_288b2_shift_dly1 <= p_288b2_shift;
//        p <= p_288b2_shift_dly1 + p_288b1_shift_dly1;
//    end
    wire [319:0] p_w = a*b;
    reg [319:0] p_r;
    always @(posedge clk) begin p <= p_r; p_r <= p_w; end

endmodule
