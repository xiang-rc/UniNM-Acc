module top_controller(
    input            clk              ,
    input            rst_n            ,
    input            start            , //start ntt or intt
    input            pwm_en           , //pwm_en = 1 means do pwm after intt or ntt, pwm_en = 0 means do not pwm after intt or ntt
    input            dram_ld_done     ,
    input            dram_st_done     ,
    input            tf_gen_done      ,
    input            top_mul_done     ,
    input      [3:0] top_mul_done_flag,
    output reg       w_bank0          ,
    output reg       w_bank2          ,
    output reg       r_bank1          ,
    output reg       r_bank3          ,
    output reg       tf_gen_start     ,
    output           top_mul_start    ,
    output reg [2:0] top_mul_conf     ,
    output           dram_ld_start    ,
    output reg       tf_gen_ren       , //read tf from tf bank
    output     [7:0] tf_gen_addr_r    , //read tf from tf bank
    output reg       dram_st_start     //
);

    reg [7:0] cnt_round; //0~128
    reg       cnt_ntt_intt;
    reg       dram_ld_start_inter;
    reg       pwm_start, ntt_or_intt_start;
    wire      pwm_done, ntt_done, intt_done;
    reg [7:0] cnt_tf_addr; //0~255
    reg       cnt_tf_en;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) tf_gen_ren <= 1'b 0;
        else if (pwm_start) tf_gen_ren <= 1'b 1;
        else if (pwm_done) tf_gen_ren <= 1'b 0;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_tf_en <= 1'b 0;
        else if (pwm_start) cnt_tf_en <= 1'b 1;
        else if (pwm_done) cnt_tf_en <= 1'b 0;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_tf_addr <= 8'd 0;
        else if (pwm_start) cnt_tf_addr <= 8'd 0;
        else if (cnt_tf_en) cnt_tf_addr <= cnt_tf_addr + 8'd 1;
    end
    assign tf_gen_addr_r = cnt_tf_addr;

    assign pwm_done  = top_mul_done && top_mul_done_flag==4'd2;
    assign ntt_done  = top_mul_done && top_mul_done_flag==4'd1;
    assign intt_done = top_mul_done && top_mul_done_flag==4'd4;

    assign top_mul_start = pwm_start | ntt_or_intt_start;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_round <= 8'd 0;
        else if (start) cnt_round <= 8'd 0;
        else if (dram_ld_done) cnt_round <= cnt_round + 8'd 1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_ntt_intt <= 1'b0;
        else if (cnt_round == 8'd128 && (ntt_done || intt_done) && !pwm_en) cnt_ntt_intt <= ~cnt_ntt_intt; //the last time ntt or intt done(without doing pwm)
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)              dram_ld_start_inter <= 1'b 0;
        else if (start)          dram_ld_start_inter <= 1'b 1;
        else if (cnt_round==0  ) dram_ld_start_inter <= dram_ld_done;
        else if (cnt_round==128) dram_ld_start_inter <= 1'b 0;
        else                     dram_ld_start_inter <= (pwm_en) ? pwm_done : (intt_done || ntt_done); //latency of ntt(or intt) is larger than loading
        //else                     dram_ld_start_inter <= dram_ld_done; //latency of ntt(or intt) is shorter than loading
    end
    assign dram_ld_start = dram_ld_start_inter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) dram_st_start <= 1'b 0;
        else        dram_st_start <= (pwm_en) ? pwm_done : (intt_done || ntt_done);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)  pwm_start <= 1'b 0;
        else if (pwm_en) pwm_start <= ntt_done | intt_done; //ntt_done or intt_done
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)              ntt_or_intt_start <= 1'b 0;
        else if (cnt_round==0  ) ntt_or_intt_start <= dram_ld_done;
        else                     ntt_or_intt_start <= (pwm_en) ? pwm_done : (intt_done || ntt_done);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                        top_mul_conf <= 3'd 0;
        else if ((ntt_done || intt_done) && pwm_en) top_mul_conf <= 3'd 2; //PWM
        else if (pwm_done || dram_ld_done) top_mul_conf <= (cnt_ntt_intt) ? 3'd 1 : 3'd 3; //1: NTT; 3:INTT; do INTT first then NTT
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)              tf_gen_start <= 1'b 0;
        else if (cnt_round==0  ) tf_gen_start <= dram_ld_done && pwm_en;
        else                     tf_gen_start <= pwm_done;
    end

    ///////////////useless???/////////////////////////////////////////////////
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                                    w_bank0 <= 1'b0;
        else if (dram_ld_start_inter && !cnt_round[0]) w_bank0 <= 1'b1;
        else if (dram_ld_done        && !cnt_round[0]) w_bank0 <= 1'b0;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                                    w_bank2 <= 1'b0;
        else if (dram_ld_start_inter &&  cnt_round[0]) w_bank2 <= 1'b1;
        else if (dram_ld_done        &&  cnt_round[0]) w_bank2 <= 1'b0;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                             r_bank1 <= 1'b0;
        else if (pwm_done     && !cnt_round[0]) r_bank1 <= 1'b1;
        else if (dram_ld_done && !cnt_round[0]) r_bank1 <= 1'b0;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                             r_bank3 <= 1'b0;
        else if (pwm_done     &&  cnt_round[0]) r_bank3 <= 1'b1;
        else if (dram_ld_done &&  cnt_round[0]) r_bank3 <= 1'b0;
    end
    ///////////////useless???/////////////////////////////////////////////////

endmodule
