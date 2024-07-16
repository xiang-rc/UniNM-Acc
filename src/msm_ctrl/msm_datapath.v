module msm_datapath#(parameter WIDTH_ID = 2, parameter WIDTH_DATA = 384, parameter P_NUM = 16)(
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  data_from_pm       ,
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  data_from_bucket_a ,
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  data_from_bucket_b ,
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  data_from_rb       ,
    input      [WIDTH_ID+WIDTH_DATA*3-1:0]  data_from_padd     , //output of bf_array(padd)
    input      [                      2:0]  padd_in_a_sel      ,
    input      [                      2:0]  padd_in_b_sel      ,
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_bucket_a    ,
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_bucket_b    ,
    output     [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_rb          ,
    output reg [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_padd_a      ,
    output reg [WIDTH_ID+WIDTH_DATA*3-1:0]  data_2_padd_b       //
);
    wire [WIDTH_ID+WIDTH_DATA*3-1:0] BUBBLE = 0;
    assign data_2_bucket_a = data_from_pm;
    assign data_2_bucket_b = data_from_rb;
    assign data_2_rb       = data_from_padd;
    always@(*)begin //data_2_padd_a
        case(padd_in_a_sel)
            3'd 0:   data_2_padd_a = data_from_rb;
            3'd 1:   data_2_padd_a = data_from_bucket_a;
            3'd 2:   data_2_padd_a = data_from_bucket_b;
            3'd 3:   data_2_padd_a = BUBBLE;
            default: data_2_padd_a = BUBBLE;
        endcase
    end
    always@(*)begin //data_2_padd_b
        case(padd_in_b_sel)
            3'd 0:   data_2_padd_b = data_from_rb;
            3'd 1:   data_2_padd_b = data_from_pm;
            3'd 2:   data_2_padd_b = BUBBLE;
            3'd 3:   data_2_padd_b = BUBBLE;
            default: data_2_padd_b = BUBBLE;
        endcase
    end
endmodule
