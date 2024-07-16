//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 11:16:15 AM
// Design Name: 
// Module Name: xm_48
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


module xm_48(
    input           clk,
    input   [ 47:0] q,
    output  [255:0] r
    );
    localparam c0 =  24'h bfff97;
    localparam c1 = 149'h 1cfb69d4ca675f520cce76020268760154ef69;
    
    reg  [ 71:0] qxc0;
    wire [196:0] qxc1_w;
    reg  [196:0] qxc1, qxc1_pip1;
    reg  [ 80:0] qq;
    reg  [ 15:0] q_reg;
    wire [ 48:0] q_add_q;
    wire [ 97:0] qxc0_shift;
    wire [113:0] sub_result;
    wire [197:0] add_result;
    
    assign q_add_q = q+q[47:32];
    
//    mult_149x48 xm_48_mult_U0 (.clk(clk), .a(c1), .b(q), .p(qxc1_w));
    assign qxc1_w = q*c1;
    
    always @ (posedge clk) begin
        qxc0 <= q*c0;
//        qxc1 <= q*c1;
        qxc1 <= qxc1_w;
        qq   <= {q_add_q,q[31:0]};
        q_reg<= q[47:32]; 
//        sub_result <= {qxc0_shift,q_reg} - qq;
//        r <= {add_result,sub_result[16+:58]};
    end
    
//    assign qxc0_shift = qxc0 << 26;
    assign qxc0_shift = {qxc0,{26{1'b0}}};
    assign sub_result = {qxc0_shift,q_reg} - qq;
    assign add_result = qxc1 + sub_result[113-:40];
    
    assign r = {add_result,sub_result[16+:58]};
endmodule
