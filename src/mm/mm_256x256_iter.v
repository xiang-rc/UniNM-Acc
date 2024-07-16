//64-bit version
module mm_256x256_iter(
    input          clk,
    input          rst_n,
    input          sel,
    input          vld, //for the 5th cycle output, one of the op need be 0
    input  [ 63:0] op1,
    input  [255:0] op2,
    output [255:0] result
    );

    localparam M = 256'h 73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;
    wire [319:0] mult_result;
    wire [319:0] mux_o;
    wire [319:0] sub_result;
    reg  [319:0] sub_result_r;
    reg  [319:0] mux_o_r;
    wire         c_in;
    wire [255:0] add_in_a;
    wire [319:0] add_in_b;
    wire [319:0] add_result;
    reg  [319:0] add_result_r;
    wire [319:0] result_xm;
    wire [ 63:0] op1_w;

    assign op1_w = (vld) ? 64'd0 : op1;
    assign mult_result = op2 * op1_w;

    //mux
    assign mux_o = (sel) ? sub_result_r : 320'd0;

    wire [63:0] xm_in = ~mux_o[0+:64] + 1'b1;
    //xm_32_f xm_U0 (.q(xm_in), .r(result_xm));
    assign result_xm = xm_in * M;
    assign c_in = (mux_o[0+:64] != 64'b0);
    assign add_in_a = mux_o[64+:256];
    assign add_in_b = mult_result;
    assign add_result = add_in_a + add_in_b + c_in;
    assign sub_result = add_result + result_xm[64+:256];

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) sub_result_r <= 320'd0;
        else       sub_result_r <= sub_result;
    end
    //assign result = sub_result[255:0];
    //result check
    wire [255:0] sub_M = sub_result - M;
    wire flag = sub_M[255];
    assign result = (flag) ? sub_result : sub_M;

endmodule

////16-bit version
//module mm_256x256_iter(
//    input          clk,
//    input          rst_n,
//    input          sel,
//    input  [ 15:0] op1,
//    input  [255:0] op2,
//    output [255:0] result
//    );
//
//    wire [271:0] mult_result;
//    wire [271:0] mux_o;
//    wire [271:0] sub_result;
//    reg  [271:0] sub_result_r;
//    reg  [271:0] mux_o_r;
//    wire         c_in;
//    wire [255:0] add_in_a;
//    wire [271:0] add_in_b;
//    wire [271:0] add_result;
//    reg  [271:0] add_result_r;
//    wire [255:0] result_xm;
//
//    assign mult_result = op2 * op1;
//
//    //mux
//    assign mux_o = (sel) ? sub_result_r : 272'd0;
//
//    wire [31:0] xm_in = ~mux_o[0+:16] + 1'b1;
//    xm_16_f xm_U0 (.q(xm_in), .r(result_xm));
//    assign c_in = (mux_o[0+:16] != 16'b0);
//    assign add_in_a = mux_o[16+:256];
//    assign add_in_b = mult_result;
//    assign add_result = add_in_a + add_in_b + c_in;
//    assign sub_result = add_result + result_xm;
//
//    always @(posedge clk or negedge rst_n) begin
//        if(!rst_n) sub_result_r <= 272'd0;
//        else       sub_result_r <= sub_result;
//    end
//    assign result = sub_result[255:0];
//
//endmodule
//
//module xm_16_f(
//    input   [ 15:0] q,
//    output  [255:0] r
//    );
//    localparam c0 =  24'h bfff97;
//    localparam c1 = 149'h 1cfb69d4ca675f520cce76020268760154ef69;
//
//    wire [ 97:0] qxc0_shift;
//    wire [ 97:0] sub_result;
//    wire [165:0] add_result;
//
//    wire [ 39:0] qxc0 = q*c0;
//    wire [164:0] qxc1 = q*c1;
//    wire [ 63:0] qq   = {q,{16{1'b0}},q,{16{1'b0}}};
//
//    assign qxc0_shift = {qxc0,{58{1'b0}}};
//    assign sub_result = qxc0_shift - qq;
//    assign add_result = qxc1 + sub_result[97-:8];
//
//    assign r = {add_result,sub_result[0+:90]};
//
//endmodule

//for basline test digit_serial; not the actual mm_256x256_iter module
//32-bit version
//module mm_256x256_iter(
//    input          clk,
//    input          rst_n,
//    input          sel,
//    input          preset,
//    input  [255:0] op1,
//    input  [255:0] op2,
//    output [255:0] result
//    );
//
//    localparam M = 256'h 73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;
//    wire [287:0] mult_result;
//    wire [255:0] mux_o;
//    wire [287:0] sub_result;
//    reg  [255:0] shift_r;
//    reg  [287:0] mux_o_r;
//    wire [287:0] add_1_result;
//    reg  [287:0] add_result_r;
//    wire [255:0] result_xm;
//    wire [ 31:0] op1_w;
//    localparam FACTOR = 32'h ffff_ffff;
//
//    reg  [255:0] sr;
//    always @(posedge clk or negedge rst_n) //sr
//    begin
//        if (!rst_n) sr <= 256'd 0;
//        else if (preset) sr <= op1;
//        else sr <= {sr[31:0],sr[255:32]};
//    end
//
//    assign op1_w =  sr;
//    assign mult_result = op2 * op1_w;
//
//    //mux
//    assign mux_o = (sel) ? shift_r : 256'd0;//tqc!!!
//
//    assign add_1_result = mux_o + mult_result;
//    wire [31:0] mm_result;
//    assign mm_result = (~add_1_result[0+:32]) + 32'd1;
//    wire [287:0] mult2_result;
//    assign mult2_result = mm_result * M;
//    assign sub_result = add_1_result + mult2_result;
//
//    always @(posedge clk or negedge rst_n) begin
//        if(!rst_n) shift_r <= 288'd0;
//        else       shift_r <= sub_result[32+:256];
//    end
//    assign result = shift_r[255:0];
//
//endmodule