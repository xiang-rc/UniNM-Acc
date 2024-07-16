//module mult_256x32( //2 cycles delay ver
//    input          clk,
//    input  [255:0] a,
//    input  [31 :0] b,
//    output reg [287:0] p
//    );
//
//    wire [127:0] a_h, a_l;
//    wire [15 :0] b_h, b_l;
//    wire [143:0] p_hh, p_hl, p_lh, p_ll;
//    wire [287:0] p_hh_shift, p_hl_shift, p_lh_shift, p_ll_shift;
//    
//    assign a_h = a[128+:128]; assign a_l = a[0+:128]; assign b_h = b[16+:16]; assign b_l = b[0+:16];
//    
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hh (.clk(clk), .a(a_h), .b(b_h), .p(p_hh));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hl (.clk(clk), .a(a_h), .b(b_l), .p(p_hl));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_lh (.clk(clk), .a(a_l), .b(b_h), .p(p_lh));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_ll (.clk(clk), .a(a_l), .b(b_l), .p(p_ll));
//    assign p_ll_shift = { {144{1'b0}} , p_ll };
//    assign p_hl_shift = { {16{1'b0}} , p_hl , {128{1'b0}} };
//    assign p_lh_shift = { {128{1'b0}} , p_lh, {16{1'b0}} };
//    assign p_hh_shift = { p_hh , {16{1'b0}} , {128{1'b0}} };
//
//    always @(posedge clk) begin
//        p <= p_ll_shift + p_hl_shift + p_lh_shift + p_hh_shift;
//    end
//endmodule

module mult_256x32( //no delay ver
    input  [255:0] a,
    input  [31 :0] b,
    output [287:0] p
    );

//    wire [127:0] a_h, a_l;
//    wire [15 :0] b_h, b_l;
//    wire [143:0] p_hh, p_hl, p_lh, p_ll;
//    wire [287:0] p_hh_shift, p_hl_shift, p_lh_shift, p_ll_shift;
//    
//    assign a_h = a[128+:128]; assign a_l = a[0+:128]; assign b_h = b[16+:16]; assign b_l = b[0+:16];
//    
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hh (.a(a_h), .b(b_h), .p(p_hh));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_hl (.a(a_h), .b(b_l), .p(p_hl));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_lh (.a(a_l), .b(b_h), .p(p_lh));
//    mult_partial #(.WIDTH_A(128), .WIDTH_B(16), .WIDTH_DSP(26), .DSP_NUM(5)) mult_partial_ll (.a(a_l), .b(b_l), .p(p_ll));
//    assign p_ll_shift = { {144{1'b0}} , p_ll };
//    assign p_hl_shift = { {16{1'b0}} , p_hl , {128{1'b0}} };
//    assign p_lh_shift = { {128{1'b0}} , p_lh, {16{1'b0}} };
//    assign p_hh_shift = { p_hh , {16{1'b0}} , {128{1'b0}} };
//
//    assign p = p_ll_shift + p_hl_shift + p_lh_shift + p_hh_shift;
    assign p = a*b;
endmodule