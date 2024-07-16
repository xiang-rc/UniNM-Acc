//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 10:49:04 AM
// Design Name: 
// Module Name: xm_32
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


module xm_32(
    input           clk,
    input   [ 31:0] q,
    output  [255:0] r
    );
    localparam c0 =  24'h bfff97;
    localparam c1 = 149'h 1cfb69d4ca675f520cce76020268760154ef69;
    
    reg  [ 55:0] qxc0;
    wire [180:0] qxc1_w;
    reg  [180:0] qxc1, qxc1_pip1;
    reg  [ 63:0] qq;
    wire [ 97:0] qxc0_shift;
    wire [ 97:0] sub_result;
    wire [181:0] add_result;
    
//    mult_149x32 xm_32_mult_U0 (.clk(clk), .a(c1), .b(q), .p(qxc1_w));
    
    always @ (posedge clk) begin
        qxc0 <= q*c0;
        qxc1 <= q*c1;
//        qxc1_pip1 <= qxc1;
        qq   <= {q,q};
//        sub_result <= qxc0_shift - qq;
//        r <= {add_result,sub_result[0+:74]};
    end
    
//    assign qxc0_shift = qxc0 << 42;
    assign qxc0_shift = {qxc0,{42{1'b0}}};
    assign sub_result = qxc0_shift - qq;
    assign add_result = qxc1 + sub_result[97-:24];
    
    assign r = {add_result,sub_result[0+:74]};
    
endmodule
