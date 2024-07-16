module msm_top#(parameter WIDTH_ID = 2, parameter WIDTH_DATA = 384, parameter P_NUM = 16, parameter PADD_LATENCY = 21)(
    input                                   clk                  ,
    input                                   rst_n                ,
    input                                   start                ,
    input                                   load_rdy             ,
    input      [         256-1:0]           scalar_in_dram       ,
    input      [WIDTH_DATA*2-1:0]           point_in_dram        ,
    input      [         256-1:0]           scalar_in_sram       ,
    input      [WIDTH_DATA*2-1:0]           point_in_sram        ,
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  result_padd          , //output of bf_array(padd)
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  data_from_bucket_a   ,
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  data_from_bucket_b   ,
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  fifo_i               , //from fifo
    output                                  bank_group_sel       ,
    output     [                      4:0]  fifo_r_addr          ,
    output     [                      4:0]  fifo_w_addr          ,
    output                                  fifo_r_en            ,
    output                                  fifo_w_en            ,
    output reg [WIDTH_ID+WIDTH_DATA*3-1:0]  fifo_o               , //output to fifo
    output     [         256-1:0]           scalar_out_sram      ,
    output     [WIDTH_DATA*2-1:0]           point_out_sram       ,
    output     [$clog2(P_NUM)-1:0]          r_addr_id_mem        , //to scalar mem
    output     [$clog2(P_NUM)-1:0]          r_addr_p_mem         , //to point mem
    output     [$clog2(P_NUM)-1:0]          w_addr_mem           , //to scalar and point mem
    output                                  r_en_id_mem          , //to scalar mem
    output                                  r_en_p_mem           , //to point mem
    output                                  w_en_mem             , //to scalar and point mem
    output                                  r_en_bucket_a        , //to bucket
    output     [     WIDTH_ID-1:0]          r_addr_bucket_a      , //to bucket
    output                                  r_en_bucket_b        , //to bucket
    output     [     WIDTH_ID-1:0]          r_addr_bucket_b      , //to bucket
    output                                  w_en_bucket_a        , //write data to bucket
    output                                  w_en_bucket_b        , //write data to bucket
    output     [     WIDTH_ID-1:0]          w_addr_bucket_a      , //write data to bucket
    output     [     WIDTH_ID-1:0]          w_addr_bucket_b      , //write data to bucket
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_bucket_a      ,
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_bucket_b      ,
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_padd_a        ,
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_padd_b        ,
    output                                  load_start           ,
    output                                  done                  //
);
    //point_mem_ctrl port
    wire msm_start;
    wire msm_done;
    wire [WIDTH_ID+WIDTH_DATA*3-1:0] data_from_pm;
    wire pm_status;
    wire load_done;

    //result_buffer_ctrl port
    wire [WIDTH_ID+WIDTH_DATA*3-1:0] data_2_rb;
    wire w_req;
    wire r_req;
    wire [WIDTH_ID+WIDTH_DATA*3-1:0] data_from_rb;
    wire rb_status;
    wire [WIDTH_ID-1:0] id_i_rb;
    wire rb_r_req;

    //bucket_ctrl port
    wire [WIDTH_ID-1:0] id_i_pm;
    wire p_bucket_a;
    wire r_bucket_b;
    wire [(2**WIDTH_ID)-1:0] bucket_flag;

    //msm_datapath port
    wire [2:0] padd_in_a_sel;
    wire [2:0] padd_in_b_sel;

    //msm_ctrl port
    wire padd_out_vld;

    assign id_i_pm = data_from_pm[WIDTH_ID+WIDTH_DATA*3-1 -: WIDTH_ID];

    assign scalar_out_sram = scalar_in_dram;
    assign point_out_sram  = point_in_dram ;
    point_mem_ctrl #(.WIDTH_ID(WIDTH_ID), .WIDTH_DATA(WIDTH_DATA), .P_NUM(P_NUM)) pm_ctrl_U0(
        .clk             (clk             ),
        .rst_n           (rst_n           ),
        .msm_start       (msm_start       ),
        .load_rdy        (load_rdy        ),
        .msm_done        (msm_done        ),
        .id_i            (scalar_in_sram  ),
        .data_i_p_mem    (point_in_sram   ),
        .r_addr_id_mem   (r_addr_id_mem   ),
        .r_addr_p_mem    (r_addr_p_mem    ),
        .w_addr_mem      (w_addr_mem      ),
        .r_en_id_mem     (r_en_id_mem     ),
        .r_en_p_mem      (r_en_p_mem      ),
        .w_en_mem        (w_en_mem        ),
        .data_o          (data_from_pm    ),
        .pm_status       (pm_status       ),
        .load_done       (load_done       ),
        .bank_group_sel  (bank_group_sel  )
    );
    result_buffer_ctrl #(.WIDTH_ID(WIDTH_ID), .WIDTH_DATA(WIDTH_DATA), .P_NUM(P_NUM)) rb_ctrl_U1(
        .clk             (clk             ),
        .rst_n           (rst_n           ),
        .result_i        (data_2_rb       ),
        .fifo_i          (fifo_i          ), //from fifo
        .w_req           (padd_out_vld    ), //ask for write data to cash tqc???
        .r_req           (rb_r_req        ), //ask for read data from cash tqc???
        .fifo_r_addr     (fifo_r_addr     ),
        .fifo_w_addr     (fifo_w_addr     ),
        .fifo_r_en       (fifo_r_en       ),
        .fifo_w_en       (fifo_w_en       ),
        .data_o          (data_from_rb    ), //output to msm or bucket
        .fifo_o          (fifo_o          ), //to fifo
        .rb_status       (rb_status       ),
        .rb_id           (id_i_rb         )
    );
    bucket_ctrl #(.WIDTH_ID(WIDTH_ID), .WIDTH_DATA(WIDTH_DATA), .P_NUM(P_NUM)) bucket_ctrl_U2(
        .clk             (clk             ),
        .rst_n           (rst_n           ),
        .id_i_pm         (id_i_pm         ),
        .id_i_rb         (id_i_rb         ),
        .pm_status       (pm_status       ),
        .rb_status       (rb_status       ),
        .r_en_bucket_a   (r_en_bucket_a   ),
        .r_addr_bucket_a (r_addr_bucket_a ),
        .r_en_bucket_b   (r_en_bucket_b   ),
        .r_addr_bucket_b (r_addr_bucket_b ),
        .w_en_bucket_a   (w_en_bucket_a   ),
        .w_en_bucket_b   (w_en_bucket_b   ),
        .w_addr_bucket_a (w_addr_bucket_a ),
        .w_addr_bucket_b (w_addr_bucket_b ),
        .p_bucket_a_o    (p_bucket_a      ), //p_bucket_a==1: hit by point_mem_id
        .r_bucket_b_o    (r_bucket_b      ), //r_bucket_b==1: hit by result_buffer_id
        .bucket_flag     (bucket_flag     )  //tqc: tbd???
    );
    msm_datapath #(.WIDTH_ID(WIDTH_ID), .WIDTH_DATA(WIDTH_DATA), .P_NUM(P_NUM)) msm_datapath_U3(
        .data_from_pm       (data_from_pm       ),
        .data_from_bucket_a (data_from_bucket_a ),
        .data_from_bucket_b (data_from_bucket_b ),
        .data_from_rb       (data_from_rb       ),
        .data_from_padd     (result_padd        ),
        .padd_in_a_sel      (padd_in_a_sel      ),
        .padd_in_b_sel      (padd_in_b_sel      ),
        .data_2_bucket_a    (data_2_bucket_a    ),
        .data_2_bucket_b    (data_2_bucket_b    ),
        .data_2_rb          (data_2_rb          ),
        .data_2_padd_a      (data_2_padd_a      ),
        .data_2_padd_b      (data_2_padd_b      )
    );
    msm_ctrl #(.WIDTH_ID(WIDTH_ID), .WIDTH_DATA(WIDTH_DATA), .P_NUM(P_NUM), .PADD_LATENCY(PADD_LATENCY)) msm_ctrl_U4(
        .clk            (clk            ),
        .rst_n          (rst_n          ),
        .start          (start          ),
        .load_done      (load_done      ),
        .id_i_pm        (id_i_pm        ),
        .id_i_rb        (id_i_rb        ),
        .p_bucket_a     (p_bucket_a     ),
        .r_bucket_b     (r_bucket_b     ),
        .pm_status      (pm_status      ),
        .rb_status      (rb_status      ),
        .msm_start      (msm_start      ),
        .load_start     (load_start     ),
        .msm_done       (msm_done       ),
        .padd_out_vld   (padd_out_vld   ),
        .rb_r_req       (rb_r_req       ),
        .padd_in_a_sel  (padd_in_a_sel  ),
        .padd_in_b_sel  (padd_in_b_sel  )
    );
endmodule
