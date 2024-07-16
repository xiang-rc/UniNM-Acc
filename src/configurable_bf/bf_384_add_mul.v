//could be used for 384-bit add, and mul in msm, data_width=384
module bf_384_add_mul #(parameter data_width = 64, parameter M = 64'h ffff_ffff_0000_0001, parameter M_half = 64'h 7fffffff80000000) //tqc:M_half should be (M+1)/2 : 7fffffff80000001(2024/03/05)
   (input                       clk      ,
    input                       rst_n    ,
    input                       sel      , //ntt or intt
    input                       flag_msm ,//1:used for 384-bit calculation; 0: used for 256-bit bf
    input      [data_width-1:0] a_i      ,
    input      [data_width-1:0] b_i      ,
    input      [data_width-1:0] msm_add_a,
    input      [data_width-1:0] msm_add_b,
    input      [data_width-1:0] msm_mul_a,
    input      [data_width-1:0] msm_mul_b,
    input      [       256-1:0] omg      ,
    output     [data_width-1:0] add_o    ,
    output     [data_width-1:0] mul_o    ,
    output reg [       256-1:0] a_o      ,
    output reg [       256-1:0] b_o       //
    );

    localparam mm_pip_stages = 32'd 6; //fpga:17 ; asic:14 tqc:tbd!!!
    localparam addsub_pip_stages = 32'd 0;

    wire [ data_width-1:0] z_add_0;
    wire [        256-1:0] z_sub_0;
    wire [ data_width-1:0] p_mm;
    wire [ data_width-1:0] z_add_1, z_sub_1;
    wire [        256-1:0] y_half_0, y_half_1;
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
    assign add_in_a = (flag_msm) ? msm_add_a : a_i;
    assign add_in_b = (flag_msm) ? msm_add_b : b_i;
    assign sub_in_a = a_i[255:0];
    assign sub_in_b = b_i[255:0];
    modular_add_384      add_U0 ( .x_add(add_in_a), .y_add(add_in_b), .z_add(z_add_0)); //mod to 384 version tqc:tbd!!!
    modular_substraction_256 sub_U0 ( .x_sub(sub_in_a), .y_sub(sub_in_b), .z_sub(z_sub_0)); //mod to 384 version tqc:tbd!!!

    always @ (posedge clk) begin
        pip_a_0[0]   <= z_add_0[255:0];
        pip_b_0[0]   <= z_sub_0;
        pip_omg_0[0] <= omg;
    end

    wire [ data_width-1:0] mm_op1, mm_op2;
    assign mm_op1 = (flag_msm) ? msm_mul_a : {128'd 0, pip_b_0[addsub_pip_stages]};
    assign mm_op2 = (flag_msm) ? msm_mul_b : {128'd 0, pip_omg_0[addsub_pip_stages]};
    mm_384x384 mm_U0 (.clk(clk), .rst_n(rst_n), .flag_384(flag_msm), .op1(mm_op1), .op2(mm_op2), .result(p_mm));//tqc: mod mm384x384 tbd!!!

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

    modular_half #(.data_width(256), .M(M), .M_half(M_half)) half_U0 ( .x_half(pip_a_1[mm_pip_stages-1]), .y_half(y_half_0));
    modular_half #(.data_width(256), .M(M), .M_half(M_half)) half_U1 ( .x_half(p_mm_r), .y_half(y_half_1));

    always @ (posedge clk) begin //tqc: requirement of pip for sel signal???
        a_o   <= ( pip_sel[mm_pip_stages + addsub_pip_stages]) ? y_half_0:pip_a_1[mm_pip_stages-1];
        b_o   <= ( pip_sel[mm_pip_stages + addsub_pip_stages]) ? y_half_1:p_mm_r;
    end

    assign add_o = z_add_0;
    assign mul_o = p_mm   ;
endmodule
