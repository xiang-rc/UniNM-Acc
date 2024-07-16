module tf_gen_engine #(parameter MM_NUM=4)( //number of mm is 4
    input clk,
    input rst_n,
    input [1:0] sel_sr,
    input sel_mm,
    input load,//load data for sr; start cal tf after load
    input en,
    input vld,
    input [255:0] seed_i_a,
    input [255:0] seed_i_b,
    input [255:0] seed_i_c,
    input [255:0] seed_i_d,
    output [255:0] tf_a,
    output [255:0] tf_b,
    output [255:0] tf_c,
    output [255:0] tf_d
);
    wire [255:0] seed_i [MM_NUM-1:0];
    assign seed_i[0] = seed_i_a;
    assign seed_i[1] = seed_i_b;
    assign seed_i[2] = seed_i_c;
    assign seed_i[3] = seed_i_d;
    wire [255:0] tf [MM_NUM-1:0];
    assign tf_a = tf[0];
    assign tf_b = tf[1];
    assign tf_c = tf[2];
    assign tf_d = tf[3];

    wire preset; //load data to shift register
    assign preset = load;
    reg  [255:0] sr;
    reg  [255:0] mux_o;
    always @(*) begin //mux_sr
        case(sel_sr)
        3'd0: mux_o = seed_i[0];
        3'd1: mux_o = seed_i[1];
        3'd2: mux_o = seed_i[2];
        3'd3: mux_o = seed_i[3];
        default: mux_o = 256'd0;
        endcase
    end
    always @(posedge clk or negedge rst_n) //sr
    begin
        if (!rst_n) sr <= 256'd 0;
        else if (preset) sr <= mux_o;
        else if (en) sr <= {sr[63:0],sr[255:64]};
    end

    genvar i;
    generate for (i=0;i<MM_NUM;i=i+1) begin: g_mm
        mm_256x256_iter mm_U (.clk(clk), .rst_n(rst_n), .sel(sel_mm), .vld(vld), .op1(sr[0+:64]), .op2(seed_i[i]), .result(tf[i]));
    end
    endgenerate
endmodule