//date: 2024/05/07
module shuffle_0(
    input clk,
    input rst_n,
    input en,
    input cros,
    input ntt,
    input [255:0] data_in_0, data_in_1, data_in_2, data_in_3, data_in_4, data_in_5, data_in_6, data_in_7,
    output[255:0] data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7
);
    reg [255:0] data_in_0_r, data_in_1_r, data_in_2_r, data_in_3_r, data_in_4_r, data_in_5_r, data_in_6_r, data_in_7_r;
    reg [255:0] data_out_0_r, data_out_1_r, data_out_2_r, data_out_3_r, data_out_4_r, data_out_5_r, data_out_6_r, data_out_7_r;

    always @ (*) begin
        if (en) begin
            data_in_0_r = (cros) ? data_in_4 : data_in_0;
            data_in_1_r = (cros) ? data_in_5 : data_in_1;
            data_in_2_r = (cros) ? data_in_6 : data_in_2;
            data_in_3_r = (cros) ? data_in_7 : data_in_3;
            data_in_4_r = (cros) ? data_in_0 : data_in_4;
            data_in_5_r = (cros) ? data_in_1 : data_in_5;
            data_in_6_r = (cros) ? data_in_2 : data_in_6;
            data_in_7_r = (cros) ? data_in_3 : data_in_7;
        end
        else begin
            data_in_0_r = 0;
            data_in_1_r = 0;
            data_in_2_r = 0;
            data_in_3_r = 0;
            data_in_4_r = 0;
            data_in_5_r = 0;
            data_in_6_r = 0;
            data_in_7_r = 0;
        end
    end

//    always @ (posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            data_out_0_r <= 0;
//            data_out_1_r <= 0;
//            data_out_2_r <= 0;
//            data_out_3_r <= 0;
//            data_out_4_r <= 0;
//            data_out_5_r <= 0;
//            data_out_6_r <= 0;
//            data_out_7_r <= 0;
//        end
//        else if (en) begin
//            data_out_0_r <= (ntt) ? data_in_0_r : data_in_0_r;
//            data_out_1_r <= (ntt) ? data_in_4_r : data_in_1_r;
//            data_out_2_r <= (ntt) ? data_in_1_r : data_in_2_r;
//            data_out_3_r <= (ntt) ? data_in_5_r : data_in_3_r;
//            data_out_4_r <= (ntt) ? data_in_2_r : data_in_4_r;
//            data_out_5_r <= (ntt) ? data_in_6_r : data_in_5_r;
//            data_out_6_r <= (ntt) ? data_in_3_r : data_in_6_r;
//            data_out_7_r <= (ntt) ? data_in_7_r : data_in_7_r;
//        end
//    end

    always @ (*) begin
        if (en) begin
            data_out_0_r = (ntt) ? data_in_0_r : data_in_0_r;
            data_out_1_r = (ntt) ? data_in_4_r : data_in_1_r;
            data_out_2_r = (ntt) ? data_in_1_r : data_in_2_r;
            data_out_3_r = (ntt) ? data_in_5_r : data_in_3_r;
            data_out_4_r = (ntt) ? data_in_2_r : data_in_4_r;
            data_out_5_r = (ntt) ? data_in_6_r : data_in_5_r;
            data_out_6_r = (ntt) ? data_in_3_r : data_in_6_r;
            data_out_7_r = (ntt) ? data_in_7_r : data_in_7_r;
        end
        else begin
            data_out_0_r = 0;
            data_out_1_r = 0;
            data_out_2_r = 0;
            data_out_3_r = 0;
            data_out_4_r = 0;
            data_out_5_r = 0;
            data_out_6_r = 0;
            data_out_7_r = 0;
        end
    end

    assign data_out_0 = data_out_0_r;
    assign data_out_1 = data_out_1_r;
    assign data_out_2 = data_out_2_r;
    assign data_out_3 = data_out_3_r;
    assign data_out_4 = data_out_4_r;
    assign data_out_5 = data_out_5_r;
    assign data_out_6 = data_out_6_r;
    assign data_out_7 = data_out_7_r;

endmodule
