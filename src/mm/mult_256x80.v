`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 03:57:31 PM
// Design Name: 
// Module Name: mult_256x80
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

//8 cycles delay ver
//module mult_256x80(
//    input          clk,
//    input  [255:0] a,
//    input  [79 :0] b,
//    output reg [335:0] p
//    );
//    
//    wire [31 :0] b_32b;
//    wire [47 :0] b_48b;
//    wire [287:0] p_288b;
//    wire [303:0] p_304b;
//    wire [335:0] p_288b_shift, p_304b_shift;
//    reg  [335:0] p_288b_shift_dly1, p_288b_shift_dly2;
//    reg  [335:0] p_pip0, p_pip1, p_pip2;
//    
//    assign b_32b = b[0+:32]; assign b_48b = b[32+:48];
//    
//    mult_256x32 mult_U32b(.clk(clk), .a(a), .b(b_32b), .p(p_288b));//2cycles
//    mult_256x48 mult_U48b(.clk(clk), .a(a), .b(b_48b), .p(p_304b));//4cycles
//    
//    assign p_288b_shift = { {48{1'b0}} , p_288b };
//    assign p_304b_shift = { p_304b , {32{1'b0}} };
//    
//    always @(posedge clk) begin
//        p_288b_shift_dly1 <= p_288b_shift;
//        p_288b_shift_dly2 <= p_288b_shift_dly1;
//    end
//    
//    always @ (posedge clk) begin
//        p_pip0 <= p_288b_shift_dly2 + p_304b_shift;
//        p_pip1 <= p_pip0;
//        p_pip2 <= p_pip1;
//        p      <= p_pip2;
//    end
//    
//endmodule

//4 cycles delay ver
module mult_256x80(
    input          clk,
    input  [255:0] a,
    input  [79 :0] b,
    output reg [335:0] p
    );
    
//    wire [31 :0] b_32b;
//    wire [47 :0] b_48b;
//    wire [287:0] p_288b;
//    wire [303:0] p_304b;
//    wire [335:0] p_288b_shift, p_304b_shift;
//    reg  [335:0] p_288b_shift_dly1;
//    reg  [335:0] p_pip0, p_pip1;
//    
//    assign b_32b = b[0+:32]; assign b_48b = b[32+:48];
//    
//    mult_256x32 mult_U32b(.a(a), .b(b_32b), .p(p_288b));
//    mult_256x48 mult_U48b(.clk(clk), .a(a), .b(b_48b), .p(p_304b));//1cycle
//    
//    assign p_288b_shift = { {48{1'b0}} , p_288b };
//    assign p_304b_shift = { p_304b , {32{1'b0}} };
//    
//    always @(posedge clk) begin
//        p_288b_shift_dly1 <= p_288b_shift;
//    end
//    
//    always @ (posedge clk) begin
//        p_pip0 <= p_288b_shift_dly1 + p_304b_shift;
//        p_pip1 <= p_pip0;
//        p      <= p_pip1;
//    end
    wire [335:0] p_w = a*b;
    reg  [355:0] p_r0, p_r1;
    always @(posedge clk) begin
        p_r0 <= p_w;
        p_r1 <= p_r0;
        p <= p_r1;
    end
    
endmodule
