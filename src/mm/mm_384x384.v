//384 or 256 mm, mult_128*384 optimized, xf xm seperated ver
//get rid of output reg(put the reg outside of mm,and bf module),
//8 cycles for 384; 6 cycles for 256
module mm_384x384(
    input          clk,
    input          rst_n,
    input          flag_384,
    input  [383:0] op1,
    input  [383:0] op2,
    output [383:0] result
    );

    localparam M_256 = 256'h73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;
    localparam M_384 = 384'h1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab;

    reg [ 31:0] op1_reg_0, op1_reg_1;
    reg [ 47:0] op1_reg_2;
    reg [ 63:0] op1_reg_3;
    reg [ 79:0] op1_reg_4;
    reg [127:0] op1_reg_5;
    reg [383:0] op2_reg;

    wire [415:0] mult_result0, mult_result1;
    wire [431:0] mult_result2;
    wire [447:0] mult_result3;
    wire [463:0] mult_result4;
    wire [511:0] mult_result5;
    wire [415:0] result_xm0, result_xm1;
    wire [431:0] result_xm2;
    wire [447:0] result_xm3;
    wire [463:0] result_xm4;
    wire [511:0] result_xm5;

    wire c_in0;
    wire [ 31:0] xf0_result;
    wire [383:0] add0_in_a;
    wire [415:0] add0_in_b, add0_result, sub0_result;
    reg  [415:0] add0_result_reg, sub0_result_reg;

    wire c_in1;
    wire [ 31:0] xf1_result;
    wire [383:0] add1_in_a;
    wire [431:0] add1_in_b, add1_result, sub1_result;
    reg  [431:0] add1_result_reg, sub1_result_reg;

    wire c_in2;
    wire [ 47:0] xf2_result;
    wire [383:0] add2_in_a;
    wire [447:0] add2_in_b, add2_result, sub2_result;
    reg  [447:0] add2_result_reg, sub2_result_reg;

    wire c_in3;
    wire [ 63:0] xf3_result;
    wire [383:0] add3_in_a;
    wire [463:0] add3_in_b, add3_result, sub3_result;
    reg  [463:0] add3_result_reg, sub3_result_reg;

    wire c_in4;
    wire [ 79:0] xf4_result;
    wire [383:0] add4_in_a;
    wire [511:0] add4_in_b, add4_result, sub4_result;
    reg  [511:0] add4_result_reg, sub4_result_reg;

    reg  c_in5;
    wire [127:0] xf5_result;
    wire [383:0] sub5_in_a;
    reg  [383:0] sub5_in_b;
    wire [383:0] sub5_result;
    wire [383:0] sub5_result_M, sub5_result_reg;
    wire sel4,sel5;

    wire [31:0] xm_in0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            op1_reg_0 <= 32'b0; op1_reg_1 <= 32'b0;
            op1_reg_2 <= 48'b0;
            op1_reg_3 <= 64'b0;
            op1_reg_4 <= 80'b0;
            op1_reg_5 <= 127'b0;
            op2_reg   <= 383'b0;
        end
        else begin
            op1_reg_0 <= op1[0+:32]; op1_reg_1 <= op1[32+:32];
            op1_reg_2 <= op1[64+:48];
            op1_reg_3 <= op1[112+:64];
            op1_reg_4 <= op1[176+:80];
            op1_reg_5 <= op1[256+:128];
            op2_reg   <= op2;
        end
    end

    mult_384x32  mult_U0 (           .a(op2_reg), .b(op1_reg_0), .p(mult_result0));//no delay in mul ver
    mult_384x32  mult_U1 (           .a(op2_reg), .b(op1_reg_1), .p(mult_result1));//no delay in mul ver
    mult_384x48  mult_U2 (.clk(clk), .a(op2_reg), .b(op1_reg_2), .p(mult_result2));
    mult_384x64  mult_U3 (.clk(clk), .a(op2_reg), .b(op1_reg_3), .p(mult_result3));
    mult_384x80  mult_U4 (.clk(clk), .a(op2_reg), .b(op1_reg_4), .p(mult_result4));
    mult_384x128 mult_U5 (.clk(clk), .a(op2_reg), .b(op1_reg_5), .p(mult_result5));

    //////part0/////
    xf0 xf0_U0 (.flag_384(flag_384), .qi(mult_result0[0+:32]), .qo(xf0_result));
    xm0 #(.M_256(M_256), .M_384(M_384)) xm0_U0 (.flag_384(flag_384), .qi(xf0_result), .qo(result_xm0));
    //assign result_xm0 = (flag_384) ? xf0_result * M_384 : xf0_result * M_256;
    assign c_in0 = (mult_result0[0+:32] != 32'b0);
    assign add0_in_a = mult_result0[32+:384];
    assign add0_in_b = mult_result1;
    assign add0_result = add0_in_a + add0_in_b + c_in0;
    reg [383:0] result_xm0_reg;
    always @(posedge clk) begin add0_result_reg <= add0_result; end
    always @(posedge clk) begin result_xm0_reg <= result_xm0[32+:384]; end
    assign sub0_result = add0_result_reg + result_xm0_reg;

    always @(posedge clk) begin sub0_result_reg <= sub0_result; end

    //////part1/////
    xf0 xf0_U1 (.flag_384(flag_384), .qi(sub0_result[0+:32]), .qo(xf1_result));
    xm1 #(.M_256(M_256), .M_384(M_384)) xm1_U1 (.flag_384(flag_384), .qi(xf1_result), .qo(result_xm1));
    //assign result_xm1 = (flag_384) ? xf1_result * M_384 : xf1_result * M_256;
    assign c_in1 = (sub0_result[0+:32] != 32'b0);
    assign add1_in_a = sub0_result[32+:384];
    assign add1_in_b = mult_result2;
    assign add1_result = add1_in_a + add1_in_b + c_in1;
    reg [383:0] result_xm1_reg;
    always @(posedge clk) begin add1_result_reg <= add1_result; end
    always @(posedge clk) begin result_xm1_reg <= result_xm1[32+:384]; end
    assign sub1_result = add1_result_reg + result_xm1_reg;

    always @(posedge clk) begin sub1_result_reg <= sub1_result; end

    //////part2/////
    xf2 xf2_U0 (.flag_384(flag_384), .qi(sub1_result[0+:48]), .qo(xf2_result));
    wire [47:0] xm_in2 = xf2_result;
    xm2 #(.M_256(M_256), .M_384(M_384)) xm2_U2 (.flag_384(flag_384), .qi(xm_in2), .qo(result_xm2));
    //assign result_xm2 = (flag_384) ? xm_in2 * M_384 : xm_in2 * M_256;
    assign c_in2 = (sub1_result[0+:48] != 48'b0);
    assign add2_in_a = sub1_result[48+:384];
    assign add2_in_b = mult_result3;
    assign add2_result = add2_in_a + add2_in_b + c_in2;
    reg [383:0] result_xm2_reg;
    always @(posedge clk) begin add2_result_reg <= add2_result; end
    always @(posedge clk) begin result_xm2_reg <= result_xm2[48+:384]; end
    assign sub2_result = add2_result_reg + result_xm2_reg;

    always @(posedge clk) begin sub2_result_reg <= sub2_result; end

    //////part3/////
    xf3 xf3_U1 (.flag_384(flag_384), .qi(sub2_result[0+:64]), .qo(xf3_result));
    wire [63:0] xm_in3 = xf3_result;
    xm3 #(.M_256(M_256), .M_384(M_384)) xm3_U3 (.flag_384(flag_384), .qi(xm_in3), .qo(result_xm3));
    //assign result_xm3 = (flag_384) ? xm_in3 * M_384 : xm_in3 * M_256;
    //reg [255:0] result_xm3_r;
    //always@(posedge clk) begin result_xm3_r <= result_xm3[64+:384]; end
    assign c_in3 = (sub2_result[0+:64] != 64'b0);
    assign add3_in_a = sub2_result[64+:384];
    assign add3_in_b = mult_result4;
    assign add3_result = add3_in_a + add3_in_b + c_in3;
    reg [383:0] result_xm3_reg;
    always @(posedge clk) begin add3_result_reg <= add3_result; end
    always @(posedge clk) begin result_xm3_reg <= result_xm3[64+:384]; end
    assign sub3_result = add3_result_reg + result_xm3_reg;

    always @(posedge clk) begin sub3_result_reg <= sub3_result; end

    //////part4/////
    xf4 xf4_U1 (.flag_384(flag_384), .qi(sub3_result[0+:80]), .qo(xf4_result));
    wire [79:0] xm_in4 = xf4_result;
    xm4 #(.M_256(M_256), .M_384(M_384)) xm4_U3 (.flag_384(flag_384), .qi(xm_in4), .qo(result_xm4));
    //assign result_xm4 =  (flag_384) ? xm_in4 * M_384 : xm_in4 * M_256;
    //reg [255:0] result_xm4_r;
    //always@(posedge clk) begin result_xm4_r <= result_xm4[80+:384]; end
    assign c_in4 = (sub3_result[0+:80] != 80'b0);
    assign add4_in_a = sub3_result[80+:384];
    assign add4_in_b = mult_result5;
    assign add4_result = add4_in_a + add4_in_b + c_in4;
    reg [383:0] result_xm4_reg;
    always @(posedge clk) begin add4_result_reg <= add4_result; end
    always @(posedge clk) begin result_xm4_reg <= result_xm4[80+:384]; end
    assign sub4_result = add4_result_reg + result_xm4_reg;

    always @(posedge clk) begin sub4_result_reg <= sub4_result; end //

    wire [255:0] sub4_result_M;
    assign sub4_result_M = sub4_result - M_256;
    assign sel4 = sub4_result_M[255];
    //reg [255:0]  result_256;
    //always @(posedge clk) begin
    //    if (~sel4)
    //        result_256 <= sub4_result_M;
    //    else
    //        result_256 <= sub4_result;
    //end
    wire [255:0]  result_256;
    assign result_256 = (sel4) ? sub4_result : sub4_result_M;

    //////part5/////
    xf5 xf5_U1 (.qi(sub4_result[0+:128]), .qo(xf5_result));
    reg [127:0] xm_in5;
    always @(posedge clk) begin xm_in5 <= xf5_result; end
    xm5 #(.M_256(M_256), .M_384(M_384)) xm5_U3 (.qi(xm_in5), .qo(result_xm5));
    //assign result_xm5 = xm_in5 * M_384;
    reg [383:0] result_xm5_r;
    always@(posedge clk) begin result_xm5_r <= result_xm5[128+:384]; end
    reg c_in5_pip;
    reg [383:0] sub5_in_b_pip;
    always @(posedge clk) begin
        c_in5   <= (sub4_result[0+:128] != 128'b0);
        c_in5_pip   <= c_in5;
        sub5_in_b <= sub4_result[128+:384];
        sub5_in_b_pip <= sub5_in_b;
    end
    assign sub5_in_a = result_xm5_r;
    assign sub5_result = sub5_in_b_pip + sub5_in_a + c_in5_pip;
    assign sub5_result_M = sub5_result - M_384;

    assign sel5 = sub5_result_M[383];
    //reg [383:0] result_384;
    //always @(posedge clk) begin 
    //    if (~sel5)
    //        result_384 <= sub5_result_M;
    //    else
    //        result_384 <= sub5_result;
    //end
    wire [383:0] result_384;
    assign result_384 = (sel5) ? sub5_result : sub5_result_M;

    assign result = (flag_384) ? result_384 : {128'b0,result_256};

endmodule

module xf0(
  input flag_384,
  input [31:0] qi,
  output wire [31:0] qo
  );
  localparam F_256 = 32'h ffffffff;
  localparam F_384 = 32'h fffcfffd;
  assign qo = (flag_384) ? qi*F_384 : qi*F_256;

endmodule

module xm0#(parameter M_256 = 256'd 1,parameter M_384 = 384'd 1)(
        input  flag_384,
        input  [31:0] qi,
        output [415:0] qo
    );
        assign qo = (flag_384) ? qi * M_384 : qi * M_256;
endmodule

module xm1#(parameter M_256 = 256'd 1,parameter M_384 = 384'd 1)(
        input  flag_384,
        input  [31:0] qi,
        output [415:0] qo
    );
        assign qo = (flag_384) ? qi * M_384 : qi * M_256;
endmodule

module xf2(
  input flag_384,
  input [47:0] qi,
  output wire [47:0] qo
  );
  localparam F_256 = 48'h fffeffffffff;
  localparam F_384 = 48'h fffcfffcfffd;
  assign qo = (flag_384) ? qi*F_384: qi*F_256;

endmodule

module xm2#(parameter M_256 = 256'd 1,parameter M_384 = 384'd 1)(
        input  flag_384,
        input  [47:0] qi,
        output [431:0] qo
    );
        assign qo = (flag_384) ? qi * M_384 : qi * M_256;
endmodule

module xf3(
  input flag_384,
  input [63:0] qi,
  output wire [63:0] qo
  );
  localparam F_256 = 64'h fffffffeffffffff;
  localparam F_384 = 64'h 89f3fffcfffcfffd;
  assign qo = (flag_384) ? qi*F_384: qi*F_256;

endmodule

module xm3#(parameter M_256 = 256'd 1,parameter M_384 = 384'd 1)(
        input  flag_384,
        input  [63:0] qi,
        output [447:0] qo
    );
        assign qo = (flag_384) ? qi * M_384 : qi * M_256;
endmodule

module xf4(
  input flag_384,
  input [79:0] qi,
  output wire [79:0] qo
  );

  localparam F_256 = 80'h 5bfdfffffffeffffffff;
  localparam F_384 = 80'h 13e889f3fffcfffcfffd;
  assign qo = (flag_384) ? qi*F_384: qi*F_256;

endmodule

module xm4#(parameter M_256 = 256'd 1,parameter M_384 = 384'd 1)(
        input  flag_384,
        input  [79:0] qi,
        output [463:0] qo
    );
        assign qo = (flag_384) ? qi * M_384 : qi * M_256;
endmodule

module xf5(
  input [127:0] qi,
  output wire [127:0] qo
  );

  localparam F_384 = 128'h 286adb92d9d113e889f3fffcfffcfffd;
  assign qo = qi*F_384;

endmodule

module xm5#(parameter M_256 = 256'd 1,parameter M_384 = 384'd 1)(
        input  [127:0] qi,
        output [511:0] qo
    );
        assign qo = qi * M_384;
endmodule

module mult_384x32( //0-cycle delay
    input  [383:0] a,
    input  [31 :0] b,
    output [415:0] p
    );

    assign p = a*b;

endmodule

module mult_384x48( //1-cycle delay
    input          clk,
    input  [383:0] a,
    input  [47 :0] b,
    output reg [431:0] p
    );

    wire [431:0] p_w = a*b;
    always @(posedge clk) begin p <= p_w; end

endmodule

module mult_384x64( //2-cycles delay
    input          clk,
    input  [383:0] a,
    input  [63 :0] b,
    output reg [447:0] p
    );

    wire [447:0] p_w = a*b;
    reg [447:0] p_r;
    always @(posedge clk) begin p <= p_r; p_r <= p_w; end

endmodule

module mult_384x80( //3-cycles delay
    input          clk,
    input  [383:0] a,
    input  [79 :0] b,
    output reg [463:0] p
    );

    wire [463:0] p_w = a*b;
    reg [463:0] p_r0, p_r1;
    always @(posedge clk) begin p <= p_r1; p_r1 <= p_r0; p_r0 <= p_w; end

endmodule

//module mult_384x128( //4-cycles delay
//    input          clk,
//    input  [383:0] a,
//    input  [127:0] b,
//    output reg [511:0] p
//    );
//
//    wire [511:0] p_w = a*b;
//    reg [511:0] p_r0, p_r1, p_r2;
//    always @(posedge clk) begin p <= p_r2; p_r2 <= p_r1; p_r1 <= p_r0; p_r0 <= p_w;; end
//
//endmodule


module mult_384x128( //4-cycles delay
    input          clk,
    input  [383:0] a,
    input  [127:0] b,
    output reg [511:0] p
    );

    wire [127:0] a0 = a[127:0];
    wire [127:0] a1 = a[255:128];
    wire [127:0] a2 = a[383:256];

    wire [63:0] b0 = b[63:0];
    wire [63:0] b1 = b[127:64];

    wire [63:0] a00 = a0[63:0];
    wire [63:0] a01 = a0[127:64];

    wire [63:0] a10 = a1[63:0];
    wire [63:0] a11 = a1[127:64];

    wire [63:0] a20 = a2[63:0];
    wire [63:0] a21 = a2[127:64];

    wire [129:0] x00 = (a00 + a01) * (b0 + b1);
    wire [127:0] x01 = a01 * b1;
    wire [127:0] x02 = a00 * b0;
    reg [129:0] x00_r;
    reg [127:0] x01_r, x02_r;
    always @(posedge clk) begin x00_r <= x00; x01_r <= x01; x02_r <= x02; end

    wire [129:0] x10 = (a10 + a11) * (b0 + b1);
    wire [127:0] x11 = a11 * b1;
    wire [127:0] x12 = a10 * b0;
    reg [129:0] x10_r;
    reg [127:0] x11_r, x12_r;
    always @(posedge clk) begin x10_r <= x10; x11_r <= x11; x12_r <= x12; end

    wire [129:0] x20 = (a20 + a21) * (b0 + b1);
    wire [127:0] x21 = a21 * b1;
    wire [127:0] x22 = a20 * b0;
    reg [129:0] x20_r;
    reg [127:0] x21_r, x22_r;
    always @(posedge clk) begin x20_r <= x20; x21_r <= x21; x22_r <= x22; end


    wire [128:0] p0_t = x00_r - x01_r - x02_r;
    wire [255:0] p0 = x02_r + {p0_t, 64'b0} + {x01_r, 128'b0};
    wire [128:0] p1_t = x10_r - x11_r - x12_r;
    wire [255:0] p1 = x12_r + {p1_t, 64'b0} + {x11_r, 128'b0};
    wire [128:0] p2_t = x20_r - x21_r - x22_r;
    wire [255:0] p2 = x22_r + {p2_t, 64'b0} + {x21_r, 128'b0};

    reg [255:0] p0_r0, p1_r0, p2_r0, p2_r1;
    always @(posedge clk) begin p0_r0 <= p0; p1_r0 <= p1; p2_r0 <= p2; p2_r1 <= p2_r0; end

    wire [383:0] p3 = p0_r0 + {p1_r0, 128'b0};
    reg [383:0] p3_r0;
    always @(posedge clk) begin p3_r0 <= p3; end

    wire [511:0] p_w = p3_r0 + {p2_r1, 256'b0};
    always @(posedge clk) begin p <= p_w; end

endmodule

