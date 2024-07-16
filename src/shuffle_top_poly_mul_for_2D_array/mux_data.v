module mux_data(
        input              sel       ,
        input [255:0]      data_a_i_0,
        input [255:0]      data_a_i_1,
        input [255:0]      data_a_i_2,
        input [255:0]      data_a_i_3,
        input [255:0]      data_a_i_4,
        input [255:0]      data_a_i_5,
        input [255:0]      data_a_i_6,
        input [255:0]      data_a_i_7,
        input [255:0]      data_b_i_0,
        input [255:0]      data_b_i_1,
        input [255:0]      data_b_i_2,
        input [255:0]      data_b_i_3,
        input [255:0]      data_b_i_4,
        input [255:0]      data_b_i_5,
        input [255:0]      data_b_i_6,
        input [255:0]      data_b_i_7,
        output reg [255:0] data_o_0  ,
        output reg [255:0] data_o_1  ,
        output reg [255:0] data_o_2  ,
        output reg [255:0] data_o_3  ,
        output reg [255:0] data_o_4  ,
        output reg [255:0] data_o_5  ,
        output reg [255:0] data_o_6  ,
        output reg [255:0] data_o_7
);
    always @(*) begin
        case (sel)
        1'b0 : begin
                data_o_0 = data_a_i_0;
                data_o_1 = data_a_i_1;
                data_o_2 = data_a_i_2;
                data_o_3 = data_a_i_3;
                data_o_4 = data_a_i_4;
                data_o_5 = data_a_i_5;
                data_o_6 = data_a_i_6;
                data_o_7 = data_a_i_7;
        end
        1'b1 : begin
                data_o_0 = data_b_i_0;
                data_o_1 = data_b_i_1;
                data_o_2 = data_b_i_2;
                data_o_3 = data_b_i_3;
                data_o_4 = data_b_i_4;
                data_o_5 = data_b_i_5;
                data_o_6 = data_b_i_6;
                data_o_7 = data_b_i_7;
        end
        default:begin
                data_o_0 = 256'd 0;
                data_o_1 = 256'd 0;
                data_o_2 = 256'd 0;
                data_o_3 = 256'd 0;
                data_o_4 = 256'd 0;
                data_o_5 = 256'd 0;
                data_o_6 = 256'd 0;
                data_o_7 = 256'd 0;
        end
        endcase
    end
endmodule
