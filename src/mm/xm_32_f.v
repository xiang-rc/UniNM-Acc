module xm_32_f(
    input   [ 31:0] q,
    output  [255:0] r
    );
    localparam c0 =  24'h bfff97;
    localparam c1 = 149'h 1cfb69d4ca675f520cce76020268760154ef69;
    
    wire [ 97:0] qxc0_shift;
    wire [ 97:0] sub_result;
    wire [181:0] add_result;
    
    wire [55:0]  qxc0 = q*c0;
    wire [180:0] qxc1 = q*c1;
    wire [63:0]  qq   = {q,q};
    
    assign qxc0_shift = {qxc0,{42{1'b0}}};
    assign sub_result = qxc0_shift - qq;
    assign add_result = qxc1 + sub_result[97-:24];
    
    assign r = {add_result,sub_result[0+:74]};
    
endmodule
