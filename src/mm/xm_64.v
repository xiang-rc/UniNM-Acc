//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 02:02:14 PM
// Design Name: 
// Module Name: xm_64
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


module xm_64(
    input           clk,
    input   [ 63:0] q,
    output  [255:0] r
    );
    localparam c0 =  24'h bfff97;
    localparam c1 = 149'h 1cfb69d4ca675f520cce76020268760154ef69;
    
    reg  [ 87:0] qxc0;
    wire [212:0] qxc1_w;
    reg  [212:0] qxc1;
    reg  [ 96:0] qq;
    reg  [ 31:0] q_reg;
    wire [ 64:0] q_add_q;
    wire [ 97:0] qxc0_shift;
    wire [129:0] sub_result;
    wire [213:0] add_result;
    
    assign q_add_q = q+q[32+:32];
    
//    mult_149x64 xm_64_mult_U0 (.clk(clk), .a(c1), .b(q), .p(qxc1_w));
    
    always @ (posedge clk) begin
        qxc0 <= q*c0;
        qxc1 <= q*c1;
        qq   <= {q_add_q,q[0+:32]};
        q_reg<= q[32+:32];
    end
    
    assign qxc0_shift = {qxc0,{10{1'b0}}};
    assign sub_result = {qxc0_shift,q_reg} - qq;
    assign add_result = qxc1 + sub_result[129-:56];
    
    assign r = {add_result,sub_result[32+:42]};
endmodule
