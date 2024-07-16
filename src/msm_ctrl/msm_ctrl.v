module msm_ctrl#(parameter WIDTH_ID = 2, parameter WIDTH_DATA = 384, parameter P_NUM = 16, parameter PADD_LATENCY = 21)(
    input                     clk            ,
    input                     rst_n          ,
    input                     start          , //start loading
    input                     load_done      ,
    input      [WIDTH_ID-1:0] id_i_pm        , //id from point_mem
    input      [WIDTH_ID-1:0] id_i_rb        , //id from result_buffer
    input                     p_bucket_a     ,
    input                     r_bucket_b     ,
    input                     pm_status      ,
    input                     rb_status      ,
    output reg                msm_start      ,
    output reg                load_start     ,
    //output                    bucket_in_sel  , //not necessary
    output                    msm_done       ,
    output                    padd_out_vld   , //indicates when result buffer should write this data in
    output reg                rb_r_req       , //indicates when result buffer should read a data out
    output reg [         2:0] padd_in_a_sel  , //padd_in_sel0
    output reg [         2:0] padd_in_b_sel    //padd_in_sel1
);
    integer i;
    reg [PADD_LATENCY-1:0] padd_out_vld_r;
    always @ (posedge clk or negedge rst_n) begin //padd_out_vld_r[0],means input vld
        if (!rst_n) begin                 padd_out_vld_r[0]<=0; rb_r_req <= 0;  end
        else begin
            case({pm_status, rb_status})
                2'b 10: begin //case0a and case0b
                    if(p_bucket_a) begin  padd_out_vld_r[0]<=1; rb_r_req <= 0;  end //case0b
                    else           begin  padd_out_vld_r[0]<=0; rb_r_req <= 0;  end //case0a
                end
                2'b 11:begin //case1 and case2(a,b,c,d)
                    if (id_i_pm != id_i_rb) begin //case2(a,b,c,d)
                        case({p_bucket_a, r_bucket_b})
                            2'b 10: begin padd_out_vld_r[0]<=1; rb_r_req <= 1;  end //case2a
                            2'b 01: begin padd_out_vld_r[0]<=1; rb_r_req <= 1;  end //case2b
                            2'b 00: begin padd_out_vld_r[0]<=0; rb_r_req <= 1;  end //case2c
                            2'b 11: begin padd_out_vld_r[0]<=1; rb_r_req <= 0;  end //case2d
                        endcase
                    end
                    else begin            padd_out_vld_r[0]<=1; rb_r_req <= 1;  end //case1
                end
                2'b 01: begin 
                    if (r_bucket_b) begin padd_out_vld_r[0]<=1; rb_r_req <= 1;  end //case3b
                    else            begin padd_out_vld_r[0]<=0; rb_r_req <= 1;  end //case3a
                end
                2'b 00: begin             padd_out_vld_r[0]<=0; rb_r_req <= 0;  end //case4
                default:begin             padd_out_vld_r[0]<=0; rb_r_req <= 0;  end
            endcase
        end
    end
    always@(posedge clk or negedge rst_n) begin //padd_out_vld_r[1] ~ padd_out_vld_r[PADD_LATENCY-1]
        if(!rst_n) padd_out_vld_r[PADD_LATENCY-1:1]<=0;
        else begin
            for(i=1;i<=PADD_LATENCY-1;i=i+1) begin
                padd_out_vld_r[i] <= padd_out_vld_r[i-1];
            end
        end
    end
    assign padd_out_vld =  padd_out_vld_r[PADD_LATENCY-1];
    always@(posedge clk or negedge rst_n)begin //msm start after load_done pulse from point_mem_ctrl(finish loading)
        if(!rst_n)msm_start<=0;
        else      msm_start<=load_done;
    end
    always@(posedge clk or negedge rst_n)begin //load_start after start pulse from outside
        if(!rst_n)load_start<=0;
        else      load_start<=start;
    end
    //bucket_in_sel:(dual port sram has two input ports and tow output ports, dont need sel here)
    //padd_in_a_sel:  0:from result buffer; 1:from bucket_a; 2:from bucket_b; 3:bubble
    //padd_in_b_sel:  0:from result buffer; 1:from point_mem; 2:bubble
    always @ (posedge clk or negedge rst_n) begin //w_en_bucket_b and w_addr_bucket_b
        if (!rst_n) begin padd_in_a_sel <= 3'd 0; padd_in_b_sel <= 3'd 0; end
        else begin
            case({pm_status, rb_status})
                2'b 10: begin //case0a and case0b
                    if(p_bucket_a) begin padd_in_a_sel <= 3'd 1; padd_in_b_sel <= 3'd 1     ; end //case0b
                    else           begin padd_in_a_sel <= 3'd 3; padd_in_b_sel <= 3'd 2     ; end //case0a
                end
                2'b 11:begin //case1 and case2(a,b,c,d)
                    if (id_i_pm != id_i_rb) begin //case2(a,b,c,d)
                        case({p_bucket_a, r_bucket_b})
                            2'b 10: begin padd_in_a_sel <= 3'd 1; padd_in_b_sel <= 3'd 1     ; end //case2a
                            2'b 01: begin padd_in_a_sel <= 3'd 2; padd_in_b_sel <= 3'd 0     ; end //case2b
                            2'b 00: begin padd_in_a_sel <= 3'd 3; padd_in_b_sel <= 3'd 2     ; end //case2c
                            2'b 11: begin padd_in_a_sel <= 3'd 1; padd_in_b_sel <= 3'd 1     ; end //case2d
                        endcase
                    end
                    else begin padd_in_a_sel <= 3'd 0; padd_in_b_sel <= 3'd 1     ; end //case1
                end
                2'b 01: begin 
                    if (r_bucket_b) begin padd_in_a_sel <= 3'd 2; padd_in_b_sel <= 3'd 0     ; end //case3b
                    else            begin padd_in_a_sel <= 3'd 3; padd_in_b_sel <= 3'd 2     ; end //case3a
                end
                2'b 00: begin padd_in_a_sel <= 3'd 3; padd_in_b_sel <= 3'd 2     ; end //case4
                default:begin padd_in_a_sel <= 3'd 3; padd_in_b_sel <= 3'd 2     ; end
            endcase
        end
    end
endmodule
