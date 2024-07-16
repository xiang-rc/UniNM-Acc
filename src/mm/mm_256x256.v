//new_version: *M directly 6-cycle-test(put out reg out of the mm module)
module mm_256x256(
    input          clk,
    input          rst_n,
    input  [255:0] op1,
    input  [255:0] op2,
    output [255:0] result
    );

    localparam M = 256'h 73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;

    reg [ 31:0] op1_reg_0, op1_reg_1;
    reg [ 47:0] op1_reg_2;
    reg [ 63:0] op1_reg_3;
    reg [ 79:0] op1_reg_4;
    reg [255:0] op2_reg;

    wire [287:0] mult_result0, mult_result1;
    wire [303:0] mult_result2;
    wire [319:0] mult_result3;
    wire [335:0] mult_result4;
    wire [287:0] result_xm0;
    wire [287:0] result_xm1;
    wire [303:0] result_xm2;
    wire [319:0] result_xm3;
    wire [335:0] result_xm4;

    wire c_in0;
    wire [255:0] add0_in_a;
    wire [287:0] add0_in_b, add0_result, sub0_result;
    reg  [287:0] add0_result_reg, sub0_result_reg;

    wire c_in1;
    wire [255:0] add1_in_a;
    wire [303:0] add1_in_b, add1_result, sub1_result;
    reg  [303:0] add1_result_reg, sub1_result_reg;

    wire c_in2;
    wire [ 47:0] xf2_result;
    wire [255:0] add2_in_a;
    wire [319:0] add2_in_b, add2_result, sub2_result;
    reg  [319:0] add2_result_reg, sub2_result_reg;

    wire c_in3;
    wire [ 63:0] xf3_result;
    wire [255:0] add3_in_a;
    wire [335:0] add3_in_b, add3_result, sub3_result;
    reg  [335:0] add3_result_reg, sub3_result_reg;

    reg  c_in4, c_in4_pip0, c_in4_pip1, c_in4_pip2;
    wire [ 79:0] xf4_result;
    wire [255:0] sub4_in_a;
    reg  [255:0] sub4_in_b, sub4_in_b_pip0, sub4_in_b_pip1, sub4_in_b_pip2;
    wire [255:0] sub4_result;
    wire [255:0] sub4_result_M, sub4_result_reg;
    wire sel;

    wire [31:0] xm_in0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            op1_reg_0 <= 32'b0; op1_reg_1 <= 32'b0;
            op1_reg_2 <= 48'b0;
            op1_reg_3 <= 64'b0;
            op1_reg_4 <= 80'b0;
            op2_reg   <= 255'b0;
        end
        else begin
            op1_reg_0 <= op1[0+:32]; op1_reg_1 <= op1[32+:32];
            op1_reg_2 <= op1[64+:48];
            op1_reg_3 <= op1[112+:64];
            op1_reg_4 <= op1[176+:80];
            op2_reg   <= op2;
        end
    end

    mult_256x32_neg32 mult_U0 (.a(op2_reg), .b(op1_reg_0), .p(mult_result0), .neg_32(xm_in0));//no delay in mul ver
    mult_256x32 mult_U1 (.a(op2_reg), .b(op1_reg_1), .p(mult_result1));//no delay in mul ver
    mult_256x48 mult_U2 (.clk(clk), .a(op2_reg), .b(op1_reg_2), .p(mult_result2));
    mult_256x64 mult_U3 (.clk(clk), .a(op2_reg), .b(op1_reg_3), .p(mult_result3));
    mult_256x80 mult_U4 (.clk(clk), .a(op2_reg), .b(op1_reg_4), .p(mult_result4));

    //////part0/////
    //xm_32_f xm_U0 (.q(xm_in0), .r(result_xm0));//no delay in xm
    assign result_xm0 = xm_in0 * M;
    assign c_in0 = (mult_result0[0+:32] != 32'b0);
    assign add0_in_a = mult_result0[32+:256];
    assign add0_in_b = mult_result1;
    assign add0_result = add0_in_a + add0_in_b + c_in0;
    always @(posedge clk) begin add0_result_reg <= add0_result; end
    assign sub0_result = add0_result + result_xm0[32+:256];

    wire [31:0] xm_in1 = ~sub0_result[0+:32] + 1'b1;
    reg  [31:0] xm_in1_reg;

    always @(posedge clk) begin sub0_result_reg <= sub0_result; end
    always @(posedge clk) begin xm_in1_reg <= xm_in1; end

    //////part1/////
    //xm_32_f xm_U1 (.q(xm_in1_reg), .r(result_xm1));//no delay in xm
    assign result_xm1 = xm_in1_reg * M;
    assign c_in1 = (sub0_result_reg[0+:32] != 32'b0);
    assign add1_in_a = sub0_result_reg[32+:256];
    assign add1_in_b = mult_result2;
    assign add1_result = add1_in_a + add1_in_b + c_in1;
    always @(posedge clk) begin add1_result_reg <= add1_result; end
    assign sub1_result = add1_result + result_xm1[32+:256];

    //wire [47:0] xf_in2 = ~sub1_result[0+:48] + 1'b1;
    wire [47:0] xf_in2 = sub1_result[0+:48];
    reg  [47:0] xf_in2_reg;

    always @(posedge clk) begin sub1_result_reg <= sub1_result; end
    always @(posedge clk) begin xf_in2_reg <= xf_in2; end

    //////part2/////
    xf2_256 xf2_U0 (.qi(xf_in2_reg), .qo(xf2_result));
    wire [47:0] xm_in2 = xf2_result;
    //xm_48 xm_U2 (.clk(clk), .q(xm_in2), .r(result_xm2));
    assign result_xm2 = xm_in2 * M;
    reg [255:0] result_xm2_r;
    always@(posedge clk) begin result_xm2_r <= result_xm2[48+:256]; end
    assign c_in2 = (sub1_result_reg[0+:48] != 48'b0);
    assign add2_in_a = sub1_result_reg[48+:256];
    assign add2_in_b = mult_result3;
    assign add2_result = add2_in_a + add2_in_b + c_in2;
    always @(posedge clk) begin add2_result_reg <= add2_result; end
    assign sub2_result = add2_result_reg + result_xm2_r;

    //always @(posedge clk) begin sub2_result_reg <= sub2_result; end

    //////part3/////
    xf3_256 xf3_U1 (.qi(sub2_result[0+:64]), .qo(xf3_result));
    //wire [63:0] xm_in3 = ~xf3_result + 1'b1;
    wire [63:0] xm_in3 = xf3_result;
    //xm_64 xm_U3 (.clk(clk), .q(x_in3), .r(result_xm3));
    assign result_xm3 = xm_in3 * M;
    reg [255:0] result_xm3_r;
    always@(posedge clk) begin result_xm3_r <= result_xm3[64+:256]; end
    assign c_in3 = (sub2_result[0+:64] != 64'b0);
    assign add3_in_a = sub2_result[64+:256];
    assign add3_in_b = mult_result4;
    assign add3_result = add3_in_a + add3_in_b + c_in3;
    always @(posedge clk) begin add3_result_reg <= add3_result;end
    assign sub3_result = add3_result_reg + result_xm3_r;

    always @(posedge clk) begin sub3_result_reg <= sub3_result; end

    //////part4/////
    xf4_256 xf4_U1 (.qi(sub3_result[0+:80]), .qo(xf4_result));
    //wire [79:0] xm_in4 = ~xf4_result + 1'b1;
    wire [79:0] xm_in4 = xf4_result;
    //xm_80 xm_U4 (.clk(clk), .q(xm_in4), .r(result_xm4));
    assign result_xm4 = xm_in4 * M;
    reg [255:0] result_xm4_r;
    always@(posedge clk) begin result_xm4_r <= result_xm4[80+:256]; end
    always @(posedge clk) begin 
        c_in4   <= (sub3_result[0+:80] != 80'b0); 
        c_in4_pip0 <= c_in4; c_in4_pip1 <= c_in4_pip0; c_in4_pip2 <= c_in4_pip1;
        sub4_in_b <= sub3_result[80+:256];
        sub4_in_b_pip0 <= sub4_in_b; sub4_in_b_pip1 <= sub4_in_b_pip0; sub4_in_b_pip2 <= sub4_in_b_pip1; 
    end
    assign sub4_in_a = result_xm4[80+:256];
    assign sub4_result = sub4_in_b + sub4_in_a + c_in4;
    assign sub4_result_M = sub4_result - M;
    assign sub4_result_reg = sub4_result;

    assign sel = sub4_result_M[255];
    //always @(posedge clk) begin 
    //    if (~sel)
    //        result <= sub4_result_M;
    //    else
    //        result <= sub4_result_reg;
    //end
    assign result = (sel) ? sub4_result_reg : sub4_result_M;

endmodule

module xf2_256(
  input [47:0] qi,
  output wire [47:0] qo
  );
  localparam F = 48'h fffeffffffff;
  assign qo = qi*F;

endmodule

module xf3_256(
  input [63:0] qi,
  output wire [63:0] qo
  );
  localparam F = 64'h fffffffeffffffff;
  assign qo = qi*F;

endmodule

module xf4_256(
  input [79:0] qi,
  output wire [79:0] qo
  );

  localparam F = 80'h 5bfdfffffffeffffffff;
  assign qo = qi*F;

endmodule
