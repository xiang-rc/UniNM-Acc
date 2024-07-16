`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2023 01:19:13 PM
// Design Name: 
// Module Name: mult_149x16
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


module mult_149x16
    (input                        clk,
     input  [149-1        :0] a,
     input  [16-1        :0] b,
     output [149+16-1:0] p
    );
    
//    localparam WIDTH_DSP=26;//width of DSP port a
//    localparam DSP_NUM  =5 ;//$ceil(149/WIDTH_DSP)
    wire [26-1:0] a_part [6-1:0];
    wire [26+16-1:0] p_part [6-1:0];
    wire [149-1:0] p_patr_shift [6-1:0];
    wire [6-1:0] carryout;
    reg  [149-1:0] p_patr_shift_reg [6-1:0];

    genvar i;
    generate for (i=0;i<6-1;i=i+1) 
        begin:a_dev
            assign a_part[i]=a[i*26+:26]; 
        end 
    endgenerate
    assign a_part[6-1] = {{26-(149-1-(6-1)*26+1){1'b0}},a[149-1:(6-1)*26]};

    genvar j;
    generate for (j=0;j<=6-1;j=j+1) 
        begin: dsp
            DSP_mult_26x16 dsp_mult_U0 (.A(a_part[j]), .B(b), .CARRYOUT(carryout[j]), .P(p_part[j]));
            assign p_patr_shift[j] = { {(149-j*26-26+16-1){1'b0}} , carryout[j] , p_part[j] , {(j*26){1'b0}} };
            always @(posedge clk) begin p_patr_shift_reg[j] <= p_patr_shift[j]; end
        end
    endgenerate
    
    assign p = p_patr_shift_reg[0] + p_patr_shift_reg[1] + p_patr_shift_reg[2] + p_patr_shift_reg[3] + p_patr_shift_reg[4] + p_patr_shift_reg[5];
endmodule
