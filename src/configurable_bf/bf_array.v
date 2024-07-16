module bf_array( //ntt/intt pe, and msm padd
    input  clk,
    input  rst_n,
    input  sel,
    input  flag_msm,
    input  [383:0] a_i0_0, a_i1_0, a_i2_0, a_i3_0,
    input  [383:0] a_i0_1, a_i1_1, a_i2_1, a_i3_1,// in msm mode, reuse a_i1_1(x1), a_i1_2(y1), a_i1_3(z1) as input
    input  [383:0] a_i0_2, a_i1_2, a_i2_2, a_i3_2,// in msm mode, reuse a_i2_0(x2), a_i2_1(y2), a_i2_2(z2) as input
    input  [383:0] a_i0_3, a_i1_3, a_i2_3, a_i3_3,
    input  [383:0] b_i0_0, b_i1_0, b_i2_0, b_i3_0,
    input  [383:0] b_i0_1, b_i1_1, b_i2_1, b_i3_1,
    input  [383:0] b_i0_2, b_i1_2, b_i2_2, b_i3_2,
    input  [383:0] b_i0_3, b_i1_3, b_i2_3, b_i3_3,
    input  [255:0] w_in0_0, w_in1_0, w_in2_0, w_in3_0,
    input  [255:0] w_in0_1, w_in1_1, w_in2_1, w_in3_1,
    input  [255:0] w_in0_2, w_in1_2, w_in2_2, w_in3_2,
    input  [255:0] w_in0_3, w_in1_3, w_in2_3, w_in3_3,
    output [255:0] bf_0_upper_0, bf_1_upper_0, bf_2_upper_0, bf_3_upper_0,
    output [255:0] bf_0_upper_1, bf_1_upper_1, bf_2_upper_1, bf_3_upper_1,
    output [255:0] bf_0_upper_2, bf_1_upper_2, bf_2_upper_2, bf_3_upper_2,
    output [255:0] bf_0_upper_3, bf_1_upper_3, bf_2_upper_3, bf_3_upper_3,
    output [255:0] bf_0_lower_0, bf_1_lower_0, bf_2_lower_0, bf_3_lower_0,
    output [255:0] bf_0_lower_1, bf_1_lower_1, bf_2_lower_1, bf_3_lower_1,
    output [255:0] bf_0_lower_2, bf_1_lower_2, bf_2_lower_2, bf_3_lower_2,
    output [255:0] bf_0_lower_3, bf_1_lower_3, bf_2_lower_3, bf_3_lower_3,
    output [383:0] msm_o_0, msm_o_1, msm_o_2
);
    localparam M_256 = 256'h73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;
    localparam M_384 = 384'h1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab;
    wire [383:0] bf_a_i [15:0]; //ntt intt mode
    wire [383:0] bf_b_i [15:0]; //ntt intt mode
    wire [255:0] bf_omg [15:0]; //ntt intt mode
    wire [255:0] bf_a_o [15:0]; //ntt intt mode
    wire [255:0] bf_b_o [15:0]; //ntt intt mode
    wire [383:0] msm_add_a [11:0]; //msm mode
    wire [383:0] msm_add_b [11:0]; //msm mode
    wire [383:0] msm_sub_a [11:0]; //msm mode
    wire [383:0] msm_sub_b [11:0]; //msm mode
    wire [383:0] msm_mul_a [11:0]; //msm mode
    wire [383:0] msm_mul_b [11:0]; //msm mode
    wire [383:0] add_o     [11:0]; //msm mode
    wire [383:0] sub_o     [11:0]; //msm mode
    wire [383:0] mul_o     [11:0]; //msm mode
    assign bf_a_i[0] = a_i0_0; assign bf_a_i[4] = a_i0_1; assign bf_a_i[ 8] = a_i0_2; assign bf_a_i[12] = a_i0_3;
    assign bf_a_i[1] = a_i1_0; assign bf_a_i[5] = a_i1_1; assign bf_a_i[ 9] = a_i1_2; assign bf_a_i[13] = a_i1_3;
    assign bf_a_i[2] = a_i2_0; assign bf_a_i[6] = a_i2_1; assign bf_a_i[10] = a_i2_2; assign bf_a_i[14] = a_i2_3;
    assign bf_a_i[3] = a_i3_0; assign bf_a_i[7] = a_i3_1; assign bf_a_i[11] = a_i3_2; assign bf_a_i[15] = a_i3_3;

    assign bf_b_i[0] = b_i0_0; assign bf_b_i[4] = b_i0_1; assign bf_b_i[ 8] = b_i0_2; assign bf_b_i[12] = b_i0_3;
    assign bf_b_i[1] = b_i1_0; assign bf_b_i[5] = b_i1_1; assign bf_b_i[ 9] = b_i1_2; assign bf_b_i[13] = b_i1_3;
    assign bf_b_i[2] = b_i2_0; assign bf_b_i[6] = b_i2_1; assign bf_b_i[10] = b_i2_2; assign bf_b_i[14] = b_i2_3;
    assign bf_b_i[3] = b_i3_0; assign bf_b_i[7] = b_i3_1; assign bf_b_i[11] = b_i3_2; assign bf_b_i[15] = b_i3_3;

    assign bf_omg[0] = w_in0_0; assign bf_omg[4] = w_in0_1; assign bf_omg[ 8] = w_in0_2; assign bf_omg[12] = w_in0_3;
    assign bf_omg[1] = w_in1_0; assign bf_omg[5] = w_in1_1; assign bf_omg[ 9] = w_in1_2; assign bf_omg[13] = w_in1_3;
    assign bf_omg[2] = w_in2_0; assign bf_omg[6] = w_in2_1; assign bf_omg[10] = w_in2_2; assign bf_omg[14] = w_in2_3;
    assign bf_omg[3] = w_in3_0; assign bf_omg[7] = w_in3_1; assign bf_omg[11] = w_in3_2; assign bf_omg[15] = w_in3_3;

    assign bf_0_upper_0 = bf_a_o[0]; assign bf_0_upper_1 = bf_a_o[4]; assign bf_0_upper_2 = bf_a_o[ 8]; assign bf_0_upper_3 = bf_a_o[12];
    assign bf_1_upper_0 = bf_a_o[1]; assign bf_1_upper_1 = bf_a_o[5]; assign bf_1_upper_2 = bf_a_o[ 9]; assign bf_1_upper_3 = bf_a_o[13];
    assign bf_2_upper_0 = bf_a_o[2]; assign bf_2_upper_1 = bf_a_o[6]; assign bf_2_upper_2 = bf_a_o[10]; assign bf_2_upper_3 = bf_a_o[14];
    assign bf_3_upper_0 = bf_a_o[3]; assign bf_3_upper_1 = bf_a_o[7]; assign bf_3_upper_2 = bf_a_o[11]; assign bf_3_upper_3 = bf_a_o[15];

    assign bf_0_lower_0 = bf_b_o[0]; assign bf_0_lower_1 = bf_b_o[4]; assign bf_0_lower_2 = bf_b_o[ 8]; assign bf_0_lower_3 = bf_b_o[12];
    assign bf_1_lower_0 = bf_b_o[1]; assign bf_1_lower_1 = bf_b_o[5]; assign bf_1_lower_2 = bf_b_o[ 9]; assign bf_1_lower_3 = bf_b_o[13];
    assign bf_2_lower_0 = bf_b_o[2]; assign bf_2_lower_1 = bf_b_o[6]; assign bf_2_lower_2 = bf_b_o[10]; assign bf_2_lower_3 = bf_b_o[14];
    assign bf_3_lower_0 = bf_b_o[3]; assign bf_3_lower_1 = bf_b_o[7]; assign bf_3_lower_2 = bf_b_o[11]; assign bf_3_lower_3 = bf_b_o[15];
    genvar i;
    generate for(i=0; i<=6; i=i+1) begin:gen_bf_384_add_mul
        bf_384_add_mul  #(.data_width(384), .M(M_384)) bf_384_add_mul_U(
            .clk       (clk      ),
            .rst_n     (rst_n    ),
            .sel       (sel      ),
            .flag_msm  (flag_msm ),
            .a_i       (bf_a_i[i]      ),
            .b_i       (bf_b_i[i]      ),
            .msm_add_a (msm_add_a[i]),
            .msm_add_b (msm_add_b[i]),
            .msm_mul_a (msm_mul_a[i]),
            .msm_mul_b (msm_mul_b[i]),
            .omg       (bf_omg[i]      ),
            .add_o     (add_o[i]   ),
            .mul_o     (mul_o[i]   ),
            .a_o       (bf_a_o[i]      ),
            .b_o       (bf_b_o[i]      )
        );
    end
    endgenerate
    genvar j;
    generate for(j=7; j<=11; j=j+1) begin:gen_bf_384_add_sub_mul
        bf_384_add_sub_mul #(.data_width(384), .M(M_384)) bf_384_add_sub_mul_U (
            .clk       (clk      ),
            .rst_n     (rst_n    ),
            .sel       (sel      ),
            .flag_msm  (flag_msm ),
            .a_i       (bf_a_i[j]      ),
            .b_i       (bf_b_i[j]      ),
            .msm_add_a (msm_add_a[j]),
            .msm_add_b (msm_add_b[j]),
            .msm_sub_a (msm_sub_a[j]),
            .msm_sub_b (msm_sub_b[j]),
            .msm_mul_a (msm_mul_a[j]),
            .msm_mul_b (msm_mul_b[j]),
            .omg       (bf_omg[j]      ),
            .add_o     (add_o[j]    ),
            .sub_o     (sub_o[j]    ),
            .mul_o     (mul_o[j]    ),
            .a_o       (bf_a_o[j]      ),
            .b_o       (bf_b_o[j]      )
        );
    end
    endgenerate
    genvar k;
    generate for(k=12; k<=15; k=k+1) begin:gen_bf_256
        bf_256 #(.data_width(256), .M(M_256)) bf_256_U (
            .clk       (clk      ),
            .rst_n     (rst_n    ),
            .sel       (sel      ),
            .a_i       (bf_a_i[k][255:0]      ),
            .b_i       (bf_b_i[k][255:0]      ),
            .omg       (bf_omg[k]      ),
            .a_o       (bf_a_o[k]      ),
            .b_o       (bf_b_o[k]      )
        );
    end
    endgenerate

    reg  [383:0] mul_r [11:0];
    reg  [383:0] add_r [11:0];
    reg  [383:0] sub_r [11:0];
    integer l;
    always @ (posedge clk) begin
        for (l=0; l<=11; l=l+1) begin
            mul_r[l] <= mul_o[l];
            add_r[l] <= add_o[l];
            sub_r[l] <= sub_o[l];
        end
    end
//the first (2A)
    reg  [383:0] mul_r_0_dly1, mul_r_0_dly2;
    always @(posedge clk) begin
        mul_r_0_dly1 <= mul_r[0];
        mul_r_0_dly2 <= mul_r_0_dly1;
    end
//the second (2A)
    reg  [383:0] mul_r_1_dly1, mul_r_1_dly2;
    always @(posedge clk) begin
        mul_r_1_dly1 <= mul_r[1];
        mul_r_1_dly2 <= mul_r_1_dly1;
    end
//the first x3
    wire [383:0] x3_0_out, x3_0_r;
    m_x3 x3_U0(.q_i(mul_r[2]), .q_o(x3_0_out));
    reg  [383:0] x3_0_out_dly1, x3_0_out_dly2;
    always @(posedge clk) begin
        x3_0_out_dly1 <= x3_0_out;
        x3_0_out_dly2 <= x3_0_out_dly1;
    end
    assign x3_0_r = x3_0_out_dly2;
//the second x3
    wire [383:0] x3_1_out, x3_1_r;
    m_x3 x3_U1(.q_i(mul_r_0_dly2), .q_o(x3_1_out));
    reg  [383:0] x3_1_out_dly1;
    always @(posedge clk) begin
        x3_1_out_dly1 <= x3_1_out;
    end
    assign x3_1_r = x3_1_out_dly1;
//the first (A)
    reg  [383:0] sub_r_9_dly1;
    always @(posedge clk) begin
        sub_r_9_dly1 <= sub_r[9];
    end
//the third x3
    wire [383:0] x3_2_out, x3_2_r;
    m_x3 x3_U2(.q_i(sub_r[10]), .q_o(x3_2_out));
    reg  [383:0] x3_2_out_dly1;
    always @(posedge clk) begin
        x3_2_out_dly1 <= x3_2_out;
    end
    assign x3_2_r = x3_2_out_dly1;
//the second (A)
    reg  [383:0] sub_r_11_dly1;
    always @(posedge clk) begin
        sub_r_11_dly1 <= sub_r[11];
    end

    assign msm_mul_a[0] = a_i1_1;//x1
    assign msm_mul_b[0] = a_i2_0;//x2
    assign msm_mul_a[1] = a_i1_2;//y1
    assign msm_mul_b[1] = a_i2_1;//y2
    assign msm_mul_a[2] = a_i1_3;//z1
    assign msm_mul_b[2] = a_i2_2;//z2
    assign msm_add_a[3] = a_i1_1;//x1
    assign msm_add_b[3] = a_i1_2;//y1
    assign msm_add_a[4] = a_i2_0;//x2
    assign msm_add_b[4] = a_i2_1;//y2
    assign msm_add_a[5] = a_i1_1;//x1
    assign msm_add_b[5] = a_i1_3;//z1
    assign msm_add_a[6] = a_i2_0;//x2
    assign msm_add_b[6] = a_i2_2;//z2
    assign msm_add_a[7] = a_i1_2;//y1
    assign msm_add_b[7] = a_i1_3;//z1
    assign msm_add_a[8] = a_i2_1;//y2
    assign msm_add_b[8] = a_i2_2;//z2

    assign msm_add_a[0] = mul_r[0];
    assign msm_add_b[0] = mul_r[1];
    assign msm_add_a[1] = mul_r[0];
    assign msm_add_b[1] = mul_r[2];
    assign msm_add_a[2] = mul_r[1];
    assign msm_add_b[2] = mul_r[2];
    assign msm_mul_a[9] = add_r[3];
    assign msm_mul_b[9] = add_r[4];
    assign msm_mul_a[10] = add_r[5];
    assign msm_mul_b[10] = add_r[6];
    assign msm_mul_a[11] = add_r[7];
    assign msm_mul_b[11] = add_r[8];
    assign msm_sub_a[9] = mul_r[9];
    assign msm_sub_b[9] = add_r[0];
    assign msm_sub_a[10] = mul_r[10];
    assign msm_sub_b[10] = add_r[1];
    assign msm_sub_a[11] = mul_r[11];
    assign msm_sub_b[11] = add_r[2];
    assign msm_add_a[9] = mul_r_1_dly2; //(2A)
    assign msm_add_b[9] = x3_0_r;
    assign msm_sub_a[8] = mul_r_1_dly2; //(2A)
    assign msm_sub_b[8] = x3_0_r;
    assign msm_mul_a[3] = sub_r[8];
    assign msm_mul_b[3] = sub_r_9_dly1;
    assign msm_mul_a[4] = x3_2_r;
    assign msm_mul_b[4] = sub_r_11_dly1;
    assign msm_mul_a[5] = add_r[9];
    assign msm_mul_b[5] = sub_r[8];
    assign msm_mul_a[6] = x3_1_r;
    assign msm_mul_b[6] = x3_2_r;
    assign msm_mul_a[7] = add_r[9];
    assign msm_mul_b[7] = sub_r_11_dly1;
    assign msm_mul_a[8] = x3_1_r;
    assign msm_mul_b[8] = sub_r_9_dly1;
    assign msm_sub_a[7] = mul_r[3];
    assign msm_sub_b[7] = mul_r[4];
    assign msm_add_a[10] = mul_r[5];
    assign msm_add_b[10] = mul_r[6];
    assign msm_add_a[11] = mul_r[7];
    assign msm_add_b[11] = mul_r[8];

    assign msm_o_0 = sub_r[7];
    assign msm_o_1 = add_r[10];
    assign msm_o_2 = add_r[11];

endmodule

module m_x3(
    input  [383:0] q_i,
    output [383:0] q_o
);

    wire [383:0] q_ix2;
    //assign q_o = q_ix2 + q_i;
    localparam M = 384'h1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab;
    wire [383:0] s1;
    wire c1;
    wire [383:0] d1;
    wire b1;
    wire sel1;
    assign sel1 = ~((~c1) & b1);
    assign {c1,s1} = q_i + q_i;
    assign {b1,d1} = s1 - M;
    assign q_ix2 = (sel1 == 1)? d1 : s1;

    wire [383:0] s;
    wire c;
    wire [383:0] d;
    wire b;
    wire sel;
    assign sel = ~((~c) & b);
    assign {c,s} = q_ix2 + q_i;
    assign {b,d} = s - M;
    assign q_o = (sel == 1)? d : s;
endmodule
