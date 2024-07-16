//64-bit version
module mm_384x384_iter(
    input          clk,
    input          rst_n,
    input          sel,
    input          vld, //for the 7th cycle output, one of the op need be 0
    input  [ 63:0] op1,
    input  [383:0] op2,
    output [383:0] result
    );

    localparam M = 384'h 1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab;
    wire [447:0] mult_result;
    wire [447:0] mux_o;
    wire [447:0] sub_result;
    reg  [447:0] sub_result_r;
    wire         c_in;
    wire [383:0] add_in_a;
    wire [287:0] add_in_b;
    wire [447:0] add_result;
    wire [447:0] result_xm;
    wire [ 63:0] op1_w;

    assign op1_w = (vld) ? 64'd0 : op1;
    assign mult_result = op2 * op1_w;

    //mux
    assign mux_o = (sel) ? sub_result_r : 448'd0;

    wire [63:0] xm_in = ~mux_o[0+:64] + 1'b1;
    assign result_xm = xm_in * M;
    assign c_in = (mux_o[0+:64] != 64'b0);
    assign add_in_a = mux_o[64+:384];
    assign add_in_b = mult_result;
    assign add_result = add_in_a + add_in_b + c_in;
    assign sub_result = add_result + result_xm[64+:384];

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) sub_result_r <= 448'd0;
        else       sub_result_r <= sub_result;
    end
    //result check
    wire [383:0] sub_M = sub_result - M;
    wire flag = sub_M[383];
    assign result = (flag) ? sub_result : sub_M;

endmodule
