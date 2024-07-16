//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 02:40:21 PM
// Design Name: 
// Module Name: mult_256x48
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


//module mult_256x48( //4 cycles delay ver
//    input          clk,
//    input  [255:0] a,
//    input  [47 :0] b,
//    output reg [303:0] p
//    );
//
//    wire [127:0] a_h, a_l;
//    wire [15 :0] b_h, b_m, b_l;
//    wire [143:0] p_hl, p_hm, p_hh, p_ll, p_lm, p_lh;
//    wire [303:0] p_hl_shift, p_hm_shift, p_hh_shift, p_ll_shift, p_lm_shift, p_lh_shift;
//    reg  [303:0] p_hl_shift_reg, p_hm_shift_reg, p_hh_shift_reg, p_ll_shift_reg, p_lm_shift_reg, p_lh_shift_reg;
//    wire [303:0] p_sum_h, p_sum_l;
//    reg  [303:0] p_sum_h_reg, p_sum_l_reg;
//    
//    assign a_h = a[128+:128]; assign a_l = a[0+:128]; assign b_h = b[32+:16]; assign b_m = b[16+:16]; assign b_l = b[0+:16];
//    
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hl (.clk(clk), .a(a_h), .b(b_l), .p(p_hl));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hm (.clk(clk), .a(a_h), .b(b_m), .p(p_hm));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hh (.clk(clk), .a(a_h), .b(b_h), .p(p_hh));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_ll (.clk(clk), .a(a_l), .b(b_l), .p(p_ll));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_lm (.clk(clk), .a(a_l), .b(b_m), .p(p_lm));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_lh (.clk(clk), .a(a_l), .b(b_h), .p(p_lh));
//    
//    assign p_ll_shift = { {16{1'b0}} , {16{1'b0}} , {128{1'b0}} , p_ll };
//    assign p_lm_shift = { {16{1'b0}}  , {128{1'b0}} , p_lm , {16{1'b0}}};
//    assign p_lh_shift = { {128{1'b0}} , p_lh , {16{1'b0}} , {16{1'b0}} };
//    assign p_hl_shift = { {16{1'b0}} , {16{1'b0}}  , p_hl , {128{1'b0}}};
//    assign p_hm_shift = { {16{1'b0}}   , p_hm , {16{1'b0}}, {128{1'b0}}};
//    assign p_hh_shift = {  p_hh , {16{1'b0}} , {16{1'b0}} , {128{1'b0}}};
//    
//    always @(posedge clk) begin
//        p_ll_shift_reg <= p_ll_shift; p_lm_shift_reg <= p_lm_shift; p_lh_shift_reg <= p_lh_shift;
//        p_hl_shift_reg <= p_hl_shift; p_hm_shift_reg <= p_hm_shift; p_hh_shift_reg <= p_hh_shift;
//    end
//
//    assign p_sum_h = p_hl_shift_reg + p_hm_shift_reg + p_hh_shift_reg;
//    assign p_sum_l = p_ll_shift_reg + p_lm_shift_reg + p_lh_shift_reg;
//    
//    always @(posedge clk) begin
//        p_sum_h_reg <= p_sum_h; p_sum_l_reg <= p_sum_l;
//    end
//    
//    always @(posedge clk) begin
//        p <= p_sum_h_reg + p_sum_l_reg;
//    end
//endmodule

module mult_256x48( //1 cycle delay ver
    input          clk,
    input  [255:0] a,
    input  [47 :0] b,
    output reg [303:0] p
    );

//    wire [127:0] a_h, a_l;
//    wire [15 :0] b_h, b_m, b_l;
//    wire [143:0] p_hl, p_hm, p_hh, p_ll, p_lm, p_lh;
//    wire [303:0] p_hl_shift, p_hm_shift, p_hh_shift, p_ll_shift, p_lm_shift, p_lh_shift;
//    reg  [303:0] p_hl_shift_reg, p_hm_shift_reg, p_hh_shift_reg, p_ll_shift_reg, p_lm_shift_reg, p_lh_shift_reg;
//    wire [303:0] p_sum_h, p_sum_l;
//    wire [303:0] p_sum_h_reg, p_sum_l_reg;
//    
//    assign a_h = a[128+:128]; assign a_l = a[0+:128]; assign b_h = b[32+:16]; assign b_m = b[16+:16]; assign b_l = b[0+:16];
//    
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hl (.a(a_h), .b(b_l), .p(p_hl));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hm (.a(a_h), .b(b_m), .p(p_hm));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hh (.a(a_h), .b(b_h), .p(p_hh));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_ll (.a(a_l), .b(b_l), .p(p_ll));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_lm (.a(a_l), .b(b_m), .p(p_lm));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_lh (.a(a_l), .b(b_h), .p(p_lh));
//    
//    assign p_ll_shift = { {16{1'b0}} , {16{1'b0}} , {128{1'b0}} , p_ll };
//    assign p_lm_shift = { {16{1'b0}}  , {128{1'b0}} , p_lm , {16{1'b0}}};
//    assign p_lh_shift = { {128{1'b0}} , p_lh , {16{1'b0}} , {16{1'b0}} };
//    assign p_hl_shift = { {16{1'b0}} , {16{1'b0}}  , p_hl , {128{1'b0}}};
//    assign p_hm_shift = { {16{1'b0}}   , p_hm , {16{1'b0}}, {128{1'b0}}};
//    assign p_hh_shift = {  p_hh , {16{1'b0}} , {16{1'b0}} , {128{1'b0}}};
//    
//    always @(posedge clk) begin
//        p_ll_shift_reg <= p_ll_shift; p_lm_shift_reg <= p_lm_shift; p_lh_shift_reg <= p_lh_shift;
//        p_hl_shift_reg <= p_hl_shift; p_hm_shift_reg <= p_hm_shift; p_hh_shift_reg <= p_hh_shift;
//    end
//
//    assign p_sum_h = p_hl_shift_reg + p_hm_shift_reg + p_hh_shift_reg;
//    assign p_sum_l = p_ll_shift_reg + p_lm_shift_reg + p_lh_shift_reg;
//    
//    assign p_sum_h_reg = p_sum_h; 
//    assign p_sum_l_reg = p_sum_l;
//    
//    assign p = p_sum_h_reg + p_sum_l_reg;
//    
    wire [303:0] p_w = a*b;
    always @(posedge clk) begin p <= p_w; end
endmodule
