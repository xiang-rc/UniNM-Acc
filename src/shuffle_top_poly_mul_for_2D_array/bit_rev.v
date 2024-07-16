module bit_rev #(parameter data_width=9)
(
    input  [data_width-1:0] s_i,
    output [data_width-1:0] s_o
);
genvar i;
generate for (i=0; i<data_width; i=i+1)
    begin:g_rev
        assign s_o[data_width-1-i] = s_i[i];
    end
endgenerate
endmodule