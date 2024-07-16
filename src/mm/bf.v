`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 04:26:32 PM
// Design Name: 
// Module Name: bf
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: butterfly module for ntt/intt
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`define DATA_WIDTH_64
`define ADDSUB_NOPIP

module bf #(parameter data_width = 64, parameter M = 64'h ffff_ffff_0000_0001, parameter M_half = 64'h 7fffffff80000000) //tqc:M_half should be (M+1)/2 : 7fffffff80000001(2024/03/05)
   (input                       clk,
    input                       rst_n,
    input                       sel,
    input      [data_width-1:0] a_i,
    input      [data_width-1:0] b_i,
    input      [data_width-1:0] omg,
    output reg [data_width-1:0] a_o,
    output reg [data_width-1:0] b_o
    );

    `ifdef DATA_WIDTH_64
    localparam mm_pip_stages = 32'd 4; 
    localparam addsub_pip_stages = 32'd 0;
    `else
    localparam mm_pip_stages = 32'd 8; //fpga:17 ; asic:14 
    localparam addsub_pip_stages = 32'd 0;
    `endif

    wire [ data_width-1:0] z_add_0, z_sub_0;
    wire [ data_width-1:0] p_mm;
    wire [ data_width-1:0] z_add_1, z_sub_1;
    wire [ data_width-1:0] y_half_0, y_half_1;
    reg  [ data_width-1:0] pip_a_0 [addsub_pip_stages:0];
    reg  [ data_width-1:0] pip_b_0 [addsub_pip_stages:0];
    reg  [ data_width-1:0] pip_omg_0 [addsub_pip_stages:0];
    reg  [ data_width-1:0] pip_a_1 [mm_pip_stages-1:0];//, pip_a_2, pip_a_3, pip_a_4;
    reg  [mm_pip_stages + 2*addsub_pip_stages:0] pip_sel;

    always@(posedge clk) pip_sel[0]<=sel;
    genvar i;
    generate for (i=1; i<(mm_pip_stages + 2*addsub_pip_stages)+1; i=i+1)
        begin: g_delay_sel
            always@(posedge clk) pip_sel[i]<=pip_sel[i-1];
        end
    endgenerate

    modular_add          #(.data_width(data_width), .M(M)) add_U0 ( .x_add(a_i), .y_add(b_i), .z_add(z_add_0));
    modular_substraction #(.data_width(data_width), .M(M)) sub_U0 ( .x_sub(a_i), .y_sub(b_i), .z_sub(z_sub_0));

    `ifdef ADDSUB_NOPIP
    always @ (posedge clk) begin
        //pip_a_0[0]   <= ( sel) ? a_i:z_add_0;
        //pip_b_0[0]   <= ( sel) ? b_i:z_sub_0;
        pip_a_0[0]   <= z_add_0;
        pip_b_0[0]   <= z_sub_0;
        pip_omg_0[0] <= omg;
    end
    `else
    //when addsub_pip_stages>0
    always @ (posedge clk) begin
        pip_a_0[0]   <= ( pip_sel[addsub_pip_stages]) ? a_i:z_add_0;
        pip_b_0[0]   <= ( pip_sel[addsub_pip_stages]) ? b_i:z_sub_0;
        pip_omg_0[0] <= omg;
    end
    generate for (i=1; i<(addsub_pip_stages)+1; i=i+1)
        begin: g_delay_addsub
            always@(posedge clk) begin
                pip_a_0[i]<=pip_a_0[i-1]; pip_b_0[i]<=pip_b_0[i-1]; pip_omg_0[i]<=pip_omg_0[i-1];
            end
        end
    endgenerate
    `endif

    `ifdef DATA_WIDTH_64
    mm_64x64 mm_U0(.clk(clk), .a(pip_b_0[addsub_pip_stages]), .b(pip_omg_0[addsub_pip_stages]), .p(p_mm));
    `else
    mm_256x256 mm_U0 (.clk(clk), .rst_n(rst_n), .op1(pip_b_0[addsub_pip_stages]), .op2(pip_omg_0[addsub_pip_stages]), .result(p_mm));
    `endif
    always @ (posedge clk) begin
        pip_a_1[0]    <= pip_a_0[addsub_pip_stages];
    end

    generate for (i=1; i<mm_pip_stages; i=i+1)
        begin: g_delay_mm
            always@(posedge clk) pip_a_1[i]<=pip_a_1[i-1];
        end
    endgenerate

    //modular_add          #(.data_width(data_width), .M(M)) add_U1 ( .x_add(pip_a_1[mm_pip_stages-1]), .y_add(p_mm), .z_add(z_add_1));
    //modular_substraction #(.data_width(data_width), .M(M)) sub_U1 ( .x_sub(pip_a_1[mm_pip_stages-1]), .y_sub(p_mm), .z_sub(z_sub_1));
    modular_half #(.data_width(data_width), .M(M), .M_half(M_half)) half_U0 ( .x_half(pip_a_1[mm_pip_stages-1]), .y_half(y_half_0));
    modular_half #(.data_width(data_width), .M(M), .M_half(M_half)) half_U1 ( .x_half(p_mm), .y_half(y_half_1));

    //always @ (posedge clk) begin
    //    a_o   <= ( pip_sel[mm_pip_stages + 2*addsub_pip_stages]) ? z_add_1:y_half_0;
    //    b_o   <= ( pip_sel[mm_pip_stages + 2*addsub_pip_stages]) ? z_sub_1:y_half_1;
    //end
    always @ (posedge clk) begin //tqc: requirement of pip for sel signal???
        a_o   <= ( pip_sel[mm_pip_stages + addsub_pip_stages]) ? y_half_0:pip_a_1[mm_pip_stages-1];
        b_o   <= ( pip_sel[mm_pip_stages + addsub_pip_stages]) ? y_half_1:p_mm;
    end
endmodule
