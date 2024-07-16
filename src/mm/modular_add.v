module modular_add #(parameter data_width = 64, parameter M = 64'h ffff_ffff_0000_0001)(
    input [data_width-1:0] x_add,
    input [data_width-1:0] y_add,
    output [data_width-1:0] z_add
    );

//    parameter M = 12289;
    wire [data_width-1:0] s;
    wire c;
    wire [data_width-1:0] d;
    wire b;
    wire sel;

    assign sel = ~((~c) & b);
    assign {c,s} = x_add + y_add;
    assign {b,d} = s - M;
    assign z_add = (sel == 1)? d : s;

endmodule