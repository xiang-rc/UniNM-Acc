module DFF #(parameter data_width = 14)(
    input clk,rst_n,
    input [data_width-1:0] d,
    output reg [data_width-1:0] q 
    );
    always@(posedge clk or negedge rst_n)
    begin
      if(!rst_n)
        q <= 0;
      else
        q <= d;
    end
endmodule
