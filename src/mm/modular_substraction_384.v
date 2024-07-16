module modular_substraction_384(
    input  [384-1:0] x_sub,
    input  [384-1:0] y_sub,
    output [384-1:0] z_sub
    );

    localparam M = 384'h 1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab;

    wire [384-1:0] q;
    wire c;
    wire [384-1:0] d;
    wire b;

    assign {b,d} = x_sub - y_sub;
    assign  q = (b == 1)? M : 0;
    assign {c,z_sub} = d + q;

endmodule
