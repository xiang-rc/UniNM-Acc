module bucket_ctrl#(parameter WIDTH_ID = 2, parameter WIDTH_DATA = 384, parameter P_NUM = 16)(
    input                                   clk             ,
    input                                   rst_n           ,
    input      [WIDTH_ID-1:0]               id_i_pm         , //id from point_mem
    input      [WIDTH_ID-1:0]               id_i_rb         , //id from result_buffer
    input                                   pm_status       ,
    input                                   rb_status       ,
    output reg                              r_en_bucket_a   , //to bucket
    output reg [     WIDTH_ID-1:0]          r_addr_bucket_a , //to bucket
    output reg                              r_en_bucket_b   , //to bucket
    output reg [     WIDTH_ID-1:0]          r_addr_bucket_b , //to bucket
    output reg                              w_en_bucket_a   , //write data to bucket
    output reg                              w_en_bucket_b   , //write data to bucket
    output reg [     WIDTH_ID-1:0]          w_addr_bucket_a , //write data to bucket
    output reg [     WIDTH_ID-1:0]          w_addr_bucket_b , //write data to bucket
    output                                  p_bucket_a_o    , //p_bucket_a==1: hit by point_mem_id
    output                                  r_bucket_b_o    , //r_bucket_b==1: hit by result_buffer_id
    output     [(2**WIDTH_ID)-1:0]          bucket_flag       // 1:bucket[id] is full; 0:bucket[id] is empty (bucket status)
);
    integer i, j, k;
    reg [(2**WIDTH_ID)-1:0] bucket_flag_r;
    assign bucket_flag = bucket_flag_r;
    reg  [(2**WIDTH_ID)-1:0] p_bucket_a_r, r_bucket_b_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin p_bucket_a_r <= 0; r_bucket_b_r <= 0;end
        else begin
            for (j = 0; j <= (2**WIDTH_ID)-1; j = j+1) begin
                if (bucket_flag_r[j] && id_i_pm == j) p_bucket_a_r[j] <= 1;
                else                                  p_bucket_a_r[j] <= 0;
            end
            for (k = 0; k <= (2**WIDTH_ID)-1; k = k+1) begin
                if (bucket_flag_r[k] && id_i_rb == k) r_bucket_b_r[k] <= 1;
                else                                  r_bucket_b_r[k] <= 0;
            end
        end
    end
    wire p_bucket_a, r_bucket_b;
    assign p_bucket_a = | p_bucket_a_r;
    assign r_bucket_b = | r_bucket_b_r;
    assign p_bucket_a_o = p_bucket_a;
    assign r_bucket_b_o = r_bucket_b;
    always @ (posedge clk or negedge rst_n) begin //bucket_flag_r
        if (!rst_n) bucket_flag_r <= 0;
        else begin
            case({pm_status, rb_status})
                2'b 10: begin //case0a and case0b
                    for (i = 0; i <= (2**WIDTH_ID)-1; i = i+1) begin
                        if (id_i_pm == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                    end
                end
                2'b 11:begin //case1 and case2(a,b,c,d)
                    if (id_i_pm != id_i_rb) begin //case2(a,b,c,d)
                        case({p_bucket_a, r_bucket_b})
                            2'b 10: begin //case2a
                                for (i = 0; i <= (2**WIDTH_ID)-1; i = i+1) begin
                                    if     (id_i_pm == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                                    else if(id_i_rb == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                                end
                            end
                            2'b 01: begin //case2b
                                for (i = 0; i <= (2**WIDTH_ID)-1; i = i+1) begin
                                    if     (id_i_pm == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                                    else if(id_i_rb == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                                end
                            end
                            2'b 00: begin //case2c
                                for (i = 0; i <= (2**WIDTH_ID)-1; i = i+1) begin
                                    if     (id_i_pm == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                                    else if(id_i_rb == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                                end
                            end
                            2'b 11: begin //case2d
                                for (i = 0; i <= (2**WIDTH_ID)-1; i = i+1) begin
                                    if     (id_i_pm == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                                end
                            end
                        endcase
                    end
                    else bucket_flag_r <= bucket_flag_r; //case1
                end
                2'b 01: begin //case3(a,b)
                    for (i = 0; i <= (2**WIDTH_ID)-1; i = i+1) begin
                        if (id_i_rb == i) bucket_flag_r[i] <= ~bucket_flag_r[i];
                    end
                end
                2'b 00: begin //case4
                     bucket_flag_r <= bucket_flag_r;
                end
                default: bucket_flag_r <= 0;
            endcase
        end
    end
    always @ (posedge clk or negedge rst_n) begin //r_en_bucket_a and r_addr_bucket_a
        if (!rst_n) begin r_en_bucket_a <= 0; r_addr_bucket_a <= 0; end
        else begin
            case({pm_status, rb_status})
                2'b 10: begin //case0a and case0b
                    if(p_bucket_a) begin r_en_bucket_a <= 1; r_addr_bucket_a <= id_i_pm; end //case0b
                    else           begin r_en_bucket_a <= 0; r_addr_bucket_a <= 0      ; end //case0a
                end
                2'b 11:begin //case1 and case2(a,b,c,d)
                    if (id_i_pm != id_i_rb) begin //case2(a,b,c,d)
                        case({p_bucket_a, r_bucket_b})
                            2'b 10: begin r_en_bucket_a <= 1; r_addr_bucket_a <= id_i_pm; end //case2a
                            2'b 01: begin r_en_bucket_a <= 0; r_addr_bucket_a <= 0      ; end //case2b
                            2'b 00: begin r_en_bucket_a <= 0; r_addr_bucket_a <= 0      ; end //case2c
                            2'b 11: begin r_en_bucket_a <= 1; r_addr_bucket_a <= id_i_pm; end //case2d
                        endcase
                    end
                    else begin r_en_bucket_a <= 0; r_addr_bucket_a <= 0; end //case1
                end
                2'b 01: begin r_en_bucket_a <= 0; r_addr_bucket_a <= 0      ; end //case3(a,b)
                2'b 00: begin r_en_bucket_a <= 0; r_addr_bucket_a <= 0      ; end //case4
                default:begin r_en_bucket_a <= 0; r_addr_bucket_a <= 0      ; end
            endcase
        end
    end

    always @ (posedge clk or negedge rst_n) begin //r_en_bucket_b and r_addr_bucket_b
        if (!rst_n) begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0; end
        else begin
            case({pm_status, rb_status})
                2'b 10: begin //case0a and case0b
                    if(p_bucket_a) begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end //case0b
                    else           begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end //case0a
                end
                2'b 11:begin //case1 and case2(a,b,c,d)
                    if (id_i_pm != id_i_rb) begin //case2(a,b,c,d)
                        case({p_bucket_a, r_bucket_b})
                            2'b 10: begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end //case2a
                            2'b 01: begin r_en_bucket_b <= 1; r_addr_bucket_b <= id_i_rb; end //case2b
                            2'b 00: begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end //case2c
                            2'b 11: begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end //case2d
                        endcase
                    end
                    else begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end //case1
                end
                2'b 01: begin 
                    if (r_bucket_b) begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end //case3b
                    else            begin r_en_bucket_b <= 1; r_addr_bucket_b <= id_i_rb; end //case3a
                end
                2'b 00: begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end //case4
                default:begin r_en_bucket_b <= 0; r_addr_bucket_b <= 0      ; end
            endcase
        end
    end

    always @ (posedge clk or negedge rst_n) begin //w_en_bucket_a and w_addr_bucket_a
        if (!rst_n) begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0; end
        else begin
            case({pm_status, rb_status})
                2'b 10: begin //case0a and case0b
                    if(p_bucket_a) begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0      ; end //case0b
                    else           begin w_en_bucket_a <= 1; w_addr_bucket_a <= id_i_pm; end //case0a
                end
                2'b 11:begin //case1 and case2(a,b,c,d)
                    if (id_i_pm != id_i_rb) begin //case2(a,b,c,d)
                        case({p_bucket_a, r_bucket_b})
                            2'b 10: begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0      ; end //case2a
                            2'b 01: begin w_en_bucket_a <= 1; w_addr_bucket_a <= id_i_pm; end //case2b
                            2'b 00: begin w_en_bucket_a <= 1; w_addr_bucket_a <= id_i_pm; end //case2c
                            2'b 11: begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0      ; end //case2d
                        endcase
                    end
                    else begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0      ; end //case1
                end
                2'b 01: begin 
                    if (r_bucket_b) begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0      ; end //case3b
                    else            begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0      ; end //case3a
                end
                2'b 00: begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0      ; end //case4
                default:begin w_en_bucket_a <= 0; w_addr_bucket_a <= 0      ; end
            endcase
        end
    end

    always @ (posedge clk or negedge rst_n) begin //w_en_bucket_b and w_addr_bucket_b
        if (!rst_n) begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0; end
        else begin
            case({pm_status, rb_status})
                2'b 10: begin //case0a and case0b
                    if(p_bucket_a) begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0      ; end //case0b
                    else           begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0      ; end //case0a
                end
                2'b 11:begin //case1 and case2(a,b,c,d)
                    if (id_i_pm != id_i_rb) begin //case2(a,b,c,d)
                        case({p_bucket_a, r_bucket_b})
                            2'b 10: begin w_en_bucket_b <= 1; w_addr_bucket_b <= id_i_rb; end //case2a
                            2'b 01: begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0      ; end //case2b
                            2'b 00: begin w_en_bucket_b <= 1; w_addr_bucket_b <= id_i_rb; end //case2c
                            2'b 11: begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0      ; end //case2d
                        endcase
                    end
                    else begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0      ; end //case1
                end
                2'b 01: begin 
                    if (r_bucket_b) begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0      ; end //case3b
                    else            begin w_en_bucket_b <= 1; w_addr_bucket_b <= id_i_rb; end //case3a
                end
                2'b 00: begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0      ; end //case4
                default:begin w_en_bucket_b <= 0; w_addr_bucket_b <= 0      ; end
            endcase
        end
    end

endmodule
