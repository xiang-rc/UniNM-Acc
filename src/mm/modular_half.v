module modular_half #(parameter data_width = 64, parameter M = 64'h ffff_ffff_0000_0001, parameter M_half = 64'h 0fff_ffff_f000_0001)(
    input [data_width-1:0] x_half,
    output [data_width-1:0] y_half
    );
    
//    parameter M = 14'd12289;
//    parameter M_half = 13'd6145;//(M+1)/2

    wire [data_width-1:0] x_sh;
    wire c;
    wire [data_width-1:0] s;
    
    assign x_sh = x_half >> 1;
    assign {c,s} = x_sh + M_half;
    assign y_half = (x_half[0] == 1)? s : x_sh;
endmodule