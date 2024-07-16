module modular_substraction_256(
    input  [256-1:0] x_sub,
    input  [256-1:0] y_sub,
    output [256-1:0] z_sub
    );

    parameter M = 256'h 73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;

    wire [256-1:0] q;
    wire c;
    wire [256-1:0] d;
    wire b;

    assign {b,d} = x_sub - y_sub;
    assign  q = (b == 1)? M : 0;
    assign {c,z_sub} = d + q;

endmodule
