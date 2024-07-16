module modular_add_256 (
    input  [256-1:0] x_add,
    input  [256-1:0] y_add,
    output [256-1:0] z_add
    );

    //assign z_add = x_add + y_add;
    localparam M = 256'h 73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;
    wire [256-1:0] s;
    wire c;
    wire [256-1:0] d;
    wire b;
    wire sel;

    assign sel = ~((~c) & b);
    assign {c,s} = x_add + y_add;
    assign {b,d} = s - M;
    assign z_add = (sel == 1)? d : s;
endmodule
