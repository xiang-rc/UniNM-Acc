//only could be used for ntt or intt, and pwm, data_width=256
module bf_256 #(parameter data_width = 64, parameter M = 64'h ffff_ffff_0000_0001, parameter M_half = 64'h 7fffffff80000000) //tqc:M_half should be (M+1)/2 : 7fffffff80000001(2024/03/05)
   (input                       clk,
    input                       rst_n,
    input                       sel, //ntt or intt
    input      [data_width-1:0] a_i,
    input      [data_width-1:0] b_i,
    input      [       256-1:0] omg,
    output reg [       256-1:0] a_o,
    output reg [       256-1:0] b_o
    );

    localparam mm_pip_stages = 32'd 6; //fpga:17 ; asic:14 tqc:tbd!!!
    localparam addsub_pip_stages = 32'd 0;

    wire [ data_width-1:0] z_add_0;
    wire [        256-1:0] z_sub_0;
    wire [ data_width-1:0] p_mm;
    wire [ data_width-1:0] z_add_1, z_sub_1;
    wire [ data_width-1:0] y_half_0, y_half_1;
    reg  [        256-1:0] pip_a_0 [addsub_pip_stages:0];
    reg  [        256-1:0] pip_b_0 [addsub_pip_stages:0];
    reg  [        256-1:0] pip_omg_0 [addsub_pip_stages:0];
    reg  [        256-1:0] pip_a_1 [mm_pip_stages-1:0];//, pip_a_2, pip_a_3, pip_a_4;
    reg  [mm_pip_stages + 2*addsub_pip_stages:0] pip_sel;

    always@(posedge clk) pip_sel[0]<=sel;
    genvar i;
    generate for (i=1; i<(mm_pip_stages + 2*addsub_pip_stages)+1; i=i+1)
        begin: g_delay_sel
            always@(posedge clk) pip_sel[i]<=pip_sel[i-1];
        end
    endgenerate

    //mux of add, sub input
    wire [ data_width-1:0] add_in_a, add_in_b;
    wire [ 255:0] sub_in_a, sub_in_b;
    assign add_in_a = a_i[255:0];
    assign add_in_b = b_i[255:0];
    assign sub_in_a = a_i[255:0];
    assign sub_in_b = b_i[255:0];
    modular_add_256      add_U0 ( .x_add(add_in_a), .y_add(add_in_b), .z_add(z_add_0)); //mod to 384 version tqc:tbd!!!
    modular_substraction_256 sub_U0 ( .x_sub(sub_in_a), .y_sub(sub_in_b), .z_sub(z_sub_0)); //mod to 384 version tqc:tbd!!!

    always @ (posedge clk) begin
        pip_a_0[0]   <= z_add_0[255:0];
        pip_b_0[0]   <= z_sub_0;
        pip_omg_0[0] <= omg;
    end

    wire [ data_width-1:0] mm_op1, mm_op2;
    assign mm_op1 = pip_b_0[addsub_pip_stages];
    assign mm_op2 = pip_omg_0[addsub_pip_stages];
    mm_256x256 mm_U0 (.clk(clk), .rst_n(rst_n), .op1(mm_op1), .op2(mm_op2), .result(p_mm));

    reg  [ 256-1:0] p_mm_r;
    always @ (posedge clk) begin
        p_mm_r    <= p_mm[255:0];
    end

    always @ (posedge clk) begin
        pip_a_1[0]    <= pip_a_0[addsub_pip_stages];
    end

    generate for (i=1; i<mm_pip_stages; i=i+1)
        begin: g_delay_mm
            always@(posedge clk) pip_a_1[i]<=pip_a_1[i-1];
        end
    endgenerate

    modular_half #(.data_width(data_width), .M(M), .M_half(M_half)) half_U0 ( .x_half(pip_a_1[mm_pip_stages-1]), .y_half(y_half_0));
    modular_half #(.data_width(data_width), .M(M), .M_half(M_half)) half_U1 ( .x_half(p_mm_r), .y_half(y_half_1));

    always @ (posedge clk) begin //tqc: requirement of pip for sel signal???
        a_o   <= ( pip_sel[mm_pip_stages + addsub_pip_stages]) ? y_half_0:pip_a_1[mm_pip_stages-1];
        b_o   <= ( pip_sel[mm_pip_stages + addsub_pip_stages]) ? y_half_1:p_mm_r;
    end

endmodule
