module point_mem_ctrl#(parameter WIDTH_ID = 2, parameter WIDTH_DATA = 384, parameter P_NUM = 16)(//point_mem ctrl
    input                                   clk             ,
    input                                   rst_n           ,
    input                                   msm_start       , //start msm and read one ID
    input                                   load_rdy        , //load_rdy from dram
    input                                   msm_done        , //start next msm when last msm done
    input      [         256-1:0]           id_i            , //from mem (id)
    input      [WIDTH_DATA*2-1:0]           data_i_p_mem    , //from mem (data)
    output     [$clog2(P_NUM)-1:0]          r_addr_id_mem   , //to mem
    output     [$clog2(P_NUM)-1:0]          r_addr_p_mem    , //to mem
    output     [$clog2(P_NUM)-1:0]     w_addr_mem      , //to mem
    output                                  r_en_id_mem     , //to id_mem
    output                                  r_en_p_mem      , //to id_mem
    output                                  w_en_mem        ,
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_o          , //to bucket or mem {id,data}
    output reg                              pm_status       , //0:empty, 1:full
    output                                  load_done       ,  //to msm_ctrl
    output reg                              bank_group_sel    //
);
    localparam LOAD_CYCLE = P_NUM;
    localparam P_MEM_R_CYCLE = P_NUM;
    localparam ID_SHIFT_CYCLE = 256/WIDTH_ID;
    localparam ID_MEM_R_CYCLE = P_NUM;
    reg  [$clog2(LOAD_CYCLE)-1:0] cnt_load;
    reg  cnt_load_en;
    reg  [$clog2(P_MEM_R_CYCLE)-1:0] cnt_p_mem_r;
    reg  cnt_p_mem_r_en;
    reg  [$clog2(P_MEM_R_CYCLE)-1:0] cnt_id_mem_r;
    reg  cnt_id_mem_r_en;
    reg  [$clog2(ID_SHIFT_CYCLE)-1:0] cnt_id_shift;
    reg  cnt_id_shift_en;
    reg  [256-1:0] id_poor;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) bank_group_sel <= 0;
        else if (msm_done) bank_group_sel <= ~bank_group_sel;
    end
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_load_en <= 0;
        else if (load_rdy) cnt_load_en <= 1;
        else if (cnt_load == LOAD_CYCLE-1) cnt_load_en <= 0;
    end
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_load <= 0;
        else if (load_rdy) cnt_load <= 0;
        else if (cnt_load_en) cnt_load <= cnt_load + 1;
    end
    assign load_done = (cnt_load == LOAD_CYCLE-1);
    assign w_en_mem = cnt_load_en;
    assign w_addr_mem = cnt_load;
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_p_mem_r_en <= 0;
        else if (msm_start || msm_done) cnt_p_mem_r_en <= 1;
        else if (cnt_p_mem_r == P_MEM_R_CYCLE-1) cnt_p_mem_r_en <= 0;
    end
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_p_mem_r <= 0;
        else if (msm_start || msm_done) cnt_p_mem_r <= 0;
        else if (cnt_p_mem_r_en) cnt_p_mem_r <= cnt_p_mem_r + 1;
    end
    assign r_addr_p_mem = cnt_p_mem_r;
    assign r_en_p_mem = cnt_p_mem_r_en;
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_id_shift_en <= 0;
        else if (msm_start) cnt_id_shift_en <= 1;
        else if (cnt_id_shift == ID_SHIFT_CYCLE-1) cnt_id_shift_en <= 0;
    end
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_id_shift <= 0;
        else if (msm_start) cnt_id_shift <= 0;
        else if (cnt_id_shift_en || msm_done) cnt_id_shift <= cnt_id_shift + 1;
    end
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_id_mem_r <= 0;
        else if (msm_start) cnt_id_mem_r <= 0;
        else if (cnt_id_shift == ID_SHIFT_CYCLE-1) cnt_id_mem_r <= cnt_id_mem_r + 1;
    end
    assign r_addr_id_mem = cnt_id_mem_r;
    assign    r_en_id_mem = msm_start || (cnt_id_shift == ID_SHIFT_CYCLE-1);
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) id_poor <= 256'd 0;
        else if (msm_start || (cnt_id_shift == ID_SHIFT_CYCLE-1)) id_poor <= id_i;
        else if (msm_done) id_poor <= {id_poor[0+:WIDTH_ID],id_poor[WIDTH_ID+:(256-WIDTH_ID)]};
    end
    assign data_o = {id_poor[0+:WIDTH_ID], data_i_p_mem};
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) pm_status <= 2'd 0;
        else if (cnt_load == LOAD_CYCLE-1) pm_status <= 2'd 1;
        else if (cnt_p_mem_r == P_MEM_R_CYCLE-1) pm_status <= 2'd 0;
    end
endmodule
