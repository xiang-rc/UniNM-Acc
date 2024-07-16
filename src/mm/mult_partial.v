//module mult_partial #(parameter WIDTH_A=128, parameter WIDTH_B=16, parameter WIDTH_DSP=26, parameter DSP_NUM=5) //one cycle delay ver
//    (input                        clk,
//     input  [WIDTH_A-1        :0] a,
//     input  [WIDTH_B-1        :0] b,
//     output [WIDTH_A+WIDTH_B-1:0] p
//    );
//    
////    localparam WIDTH_DSP=26;//width of DSP port a
////    localparam DSP_NUM  =5 ;//$ceil(WIDTH_A/WIDTH_DSP)
//    wire [WIDTH_DSP-1:0] a_part [DSP_NUM-1:0];
//    wire [WIDTH_DSP+WIDTH_B+1:0] p_part [DSP_NUM-1:0];//27+16bit
//    wire [WIDTH_A+WIDTH_B-1:0] p_patr_shift [DSP_NUM-1:0];
//    wire [DSP_NUM-1:0] carryout;
//    reg  [WIDTH_A+WIDTH_B-1:0] p_patr_shift_reg [DSP_NUM-1:0];
//
//    genvar i;
//    generate for (i=0;i<DSP_NUM-1;i=i+1) 
//        begin:a_dev
//            assign a_part[i]=a[i*WIDTH_DSP+:WIDTH_DSP]; 
//        end 
//    endgenerate
//    assign a_part[DSP_NUM-1] = {{WIDTH_DSP-(WIDTH_A-1-(DSP_NUM-1)*WIDTH_DSP+1){1'b0}},a[WIDTH_A-1:(DSP_NUM-1)*WIDTH_DSP]};
//
//    genvar j;
//    generate for (j=0;j<=DSP_NUM-1;j=j+1) 
////        begin: dsp
////            DSP_mult_26x16 dsp_mult_U0 (.A({1'b0,a_part[j]}), .B({1'b0,b}), .CARRYOUT(carryout[j]), .P(p_part[j])); //27bitx17bit,msb always be 0
////            assign p_patr_shift[j] = { {(WIDTH_A-j*WIDTH_DSP-WIDTH_DSP+WIDTH_B-1){1'b0}} , 1'b0 , p_part[j][0+:42] , {(j*WIDTH_DSP){1'b0}} };
////            always @(posedge clk) begin p_patr_shift_reg[j] <= p_patr_shift[j]; end
////        end
//        begin: mult_27x17
////            DSP_mult_26x16 dsp_mult_U0 (.A({1'b0,a_part[j]}), .B({1'b0,b}), .CARRYOUT(carryout[j]), .P(p_part[j])); //27bitx17bit,msb always be 0
//            assign p_part[j] = {1'b0,a_part[j]} * {1'b0,b}; //27bitx17bit,msb always be 0
//            assign p_patr_shift[j] = { {(WIDTH_A-j*WIDTH_DSP-WIDTH_DSP+WIDTH_B-1){1'b0}} , 1'b0 , p_part[j][0+:42] , {(j*WIDTH_DSP){1'b0}} };
//            always @(posedge clk) begin p_patr_shift_reg[j] <= p_patr_shift[j]; end
//        end
//    endgenerate
//    
//    assign p = p_patr_shift_reg[0] + p_patr_shift_reg[1] + p_patr_shift_reg[2] + p_patr_shift_reg[3] + p_patr_shift_reg[4];
//endmodule

module mult_partial #(parameter WIDTH_A=128, parameter WIDTH_B=16, parameter WIDTH_DSP=26, parameter DSP_NUM=5) //no delay ver
    (
     input  [WIDTH_A-1        :0] a,
     input  [WIDTH_B-1        :0] b,
     output [WIDTH_A+WIDTH_B-1:0] p
    );

    wire [WIDTH_DSP-1:0] a_part [DSP_NUM-1:0];
    wire [WIDTH_DSP+WIDTH_B+1:0] p_part [DSP_NUM-1:0];//27+16bit
    wire [WIDTH_A+WIDTH_B-1:0] p_patr_shift [DSP_NUM-1:0];
    wire [DSP_NUM-1:0] carryout;
    wire [WIDTH_A+WIDTH_B-1:0] p_patr_shift_reg [DSP_NUM-1:0];

    genvar i;
    generate for (i=0;i<DSP_NUM-1;i=i+1) 
        begin:a_dev
            assign a_part[i]=a[i*WIDTH_DSP+:WIDTH_DSP]; 
        end 
    endgenerate
    assign a_part[DSP_NUM-1] = {{WIDTH_DSP-(WIDTH_A-1-(DSP_NUM-1)*WIDTH_DSP+1){1'b0}},a[WIDTH_A-1:(DSP_NUM-1)*WIDTH_DSP]};

    genvar j;
    generate for (j=0;j<=DSP_NUM-1;j=j+1)
        begin: mult_27x17
            assign p_part[j] = {1'b0,a_part[j]} * {1'b0,b}; //27bitx17bit,msb always be 0
            assign p_patr_shift[j] = { {(WIDTH_A-j*WIDTH_DSP-WIDTH_DSP+WIDTH_B-1){1'b0}} , 1'b0 , p_part[j][0+:42] , {(j*WIDTH_DSP){1'b0}} };
            assign p_patr_shift_reg[j] = p_patr_shift[j];
        end
    endgenerate

    assign p = p_patr_shift_reg[0] + p_patr_shift_reg[1] + p_patr_shift_reg[2] + p_patr_shift_reg[3] + p_patr_shift_reg[4];
endmodule