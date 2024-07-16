module modular_substraction #(parameter data_width = 64, parameter M = 64'h ffff_ffff_0000_0001)(
    input [data_width-1:0] x_sub,
    input [data_width-1:0] y_sub,
    output [data_width-1:0] z_sub
    );
    
//    parameter M = 12289;
//    parameter M = 32'h73eda753;
    
    wire [data_width-1:0] q;
    wire c;
    wire [data_width-1:0] d;
    wire b;
    
    assign {b,d} = x_sub - y_sub;
    assign  q = (b == 1)? M : 0;
    assign {c,z_sub} = d + q;
    
endmodule
