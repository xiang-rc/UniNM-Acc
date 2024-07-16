//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 01:33:55 PM
// Design Name: 
// Module Name: xm_80
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


//module xm_80( //pip3
//    input           clk,
//    input   [ 79:0] q,
//    output  reg [255:0] r
//    );
//    localparam c0 =  24'h bfff97;
//    localparam c1 = 149'h 1cfb69d4ca675f520cce76020268760154ef69;
//    
//    reg  [103:0] qxc0;
//    wire [228:0] qxc1_w;
//    reg  [228:0] qxc1, qxc1_pip1;
//    reg  [112:0] qq;
//    reg  [ 47:0] q_reg;
//    wire [ 80:0] q_add_q;
//    reg  [146:0] sub_result;
//    wire [229:0] add_result;
//    wire [104:0] qxc0_add;
//    reg  [255:0] r_pip1,r_pip2;
//    
//    assign q_add_q = q + q[32+:48];
//    
////    mult_149x80 xm_80_mult_U0 (.clk(clk), .a(c1), .b(q), .p(qxc1_w));
//    
//    always @ (posedge clk) begin
//        qxc0 <= q*c0;
//        qxc1 <= q*c1;
//        qxc1_pip1 <= qxc1;
//        qq   <= {q_add_q,q[31:0]};
//        sub_result <= {qxc0_add,q_reg[0+:42]} - qq;
//        q_reg<= q[79:32]; 
//        r <= {add_result,sub_result[48+:26]};
//    end
//    
//    assign qxc0_add = qxc0 + q_reg[47-:6];
//    assign add_result = qxc1_pip1 + sub_result[146-:73];
//    
//endmodule

module xm_80( //pip1
    input           clk,
    input   [ 79:0] q,
    output  [255:0] r
    );
    localparam c0 =  24'h bfff97;
    localparam c1 = 149'h 1cfb69d4ca675f520cce76020268760154ef69;
    
    reg  [103:0] qxc0;
    wire [228:0] qxc1_w;
    reg  [228:0] qxc1, qxc1_pip1;
    reg  [112:0] qq;
    reg  [ 47:0] q_reg;
    wire [ 80:0] q_add_q;
    wire [146:0] sub_result;
    wire [229:0] add_result;
    wire [104:0] qxc0_add;
    reg  [255:0] r_pip1,r_pip2;
    
    assign q_add_q = q + q[32+:48];
    
//    mult_149x80 xm_80_mult_U0 (.clk(clk), .a(c1), .b(q), .p(qxc1_w));
    
    always @ (posedge clk) begin
        qxc0 <= q*c0;
        qxc1 <= q*c1;
        qxc1_pip1 <= qxc1;
        qq   <= {q_add_q,q[31:0]};
        q_reg<= q[79:32];
    end
    
    assign sub_result = {qxc0_add,q_reg[0+:42]} - qq;
    assign qxc0_add = qxc0 + q_reg[47-:6];
    assign add_result = qxc1 + sub_result[146-:73];
    assign r = {add_result,sub_result[48+:26]};
    
endmodule
