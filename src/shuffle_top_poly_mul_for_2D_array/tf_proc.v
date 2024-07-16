//date: 2024/05/07
module tf_proc(
    input clk,
    input rst_n,
    input [2:0] conf,
    input proc_flag,
    input [255:0] tf_i,
    output[255:0] tf_o
);

    localparam M = 256'h 73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;
    wire [255:0] tf_NTT,tf_INTT;
    wire [255:0] tf_tmp;
    wire proc_flag_dly;
    assign tf_tmp = (conf == 3'b001) ? tf_NTT : (conf == 3'b011) ? tf_INTT : 256'd0; //tqc:dont't care other options

    shifter #(.data_width(1), .depth(2)) dff_n0(.clk(clk),.rst_n(rst_n),.din(proc_flag),.dout(proc_flag_dly));//2 cycles dealy of i

    //NTT
    assign tf_NTT = tf_i;

    //INTT
    assign tf_INTT = (proc_flag_dly)? tf_i : (M - tf_i);

    assign tf_o = tf_tmp;

endmodule
