module shifter #(parameter data_width = 14, parameter depth = 8)(
    input [data_width-1:0] din,
	input rst_n,clk,
	output wire [data_width-1:0] dout
);

	reg [data_width-1:0] t [depth-1:0];
    
	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n) t[0] <= 0;
		else        t[0] <= din;
	end

	genvar i;
	generate for (i=1;i<=depth-1;i=i+1)
	    begin:shift
		    always @ (posedge clk or negedge rst_n) begin
		        if (!rst_n) t[i] <= 0;
		    	else        t[i] <= t[i-1];
		    end
		end
	endgenerate

	assign dout = t[depth-1];
endmodule
