module modular_add_384 (
    input [384-1:0] x_add,
    input [384-1:0] y_add,
    output [384-1:0] z_add
    );

    //assign z_add = x_add + y_add;
    localparam M = 384'h1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab;
    wire [384-1:0] s;
    wire c;
    wire [384-1:0] d;
    wire b;
    wire sel;

    assign sel = ~((~c) & b);
    assign {c,s} = x_add + y_add;
    assign {b,d} = s - M;
    assign z_add = (sel == 1)? d : s;

endmodule
