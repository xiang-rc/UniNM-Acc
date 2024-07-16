module bg_output_logic(
    input                                 clk          ,
    input                                 flag_msm     , //==0: do ntt; ==1: do msm
    input      [   32-1:0]                ce_in        , //32 1-bit from bg_input_logic
    input      [  256-1:0]                din0         ,
    input      [  256-1:0]                din1         ,
    input      [  256-1:0]                din2         ,
    input      [  256-1:0]                din3         ,
    input      [  256-1:0]                din4         ,
    input      [  256-1:0]                din5         ,
    input      [  256-1:0]                din6         ,
    input      [  256-1:0]                din7         ,
    input      [  256-1:0]                din8         ,
    input      [  256-1:0]                din9         ,
    input      [  256-1:0]                din10        ,
    input      [  256-1:0]                din11        ,
    input      [  256-1:0]                din12        ,
    input      [  256-1:0]                din13        ,
    input      [  256-1:0]                din14        ,
    input      [  256-1:0]                din15        ,
    input      [  256-1:0]                din16        ,
    input      [  256-1:0]                din17        ,
    input      [  256-1:0]                din18        ,
    input      [  256-1:0]                din19        ,
    input      [  256-1:0]                din20        ,
    input      [  256-1:0]                din21        ,
    input      [  256-1:0]                din22        ,
    input      [  256-1:0]                din23        ,
    input      [  256-1:0]                din24        ,
    input      [  256-1:0]                din25        ,
    input      [  256-1:0]                din26        ,
    input      [  256-1:0]                din27        ,
    input      [  256-1:0]                din28        ,
    input      [  256-1:0]                din29        ,
    input      [  256-1:0]                din30        ,
    input      [  256-1:0]                din31        ,
    output reg [  256-1:0]                dout0        ,
    output reg [  256-1:0]                dout1        ,
    output reg [  256-1:0]                dout2        ,
    output reg [  256-1:0]                dout3        ,
    output reg [  256-1:0]                dout4        ,
    output reg [  256-1:0]                dout5        ,
    output reg [  256-1:0]                dout6        ,
    output reg [  256-1:0]                dout7        ,
    output reg [  256-1:0]                dout8        ,
    output reg [  256-1:0]                dout9        ,
    output reg [  256-1:0]                dout10       ,
    output reg [  256-1:0]                dout11       ,
    output reg [  256-1:0]                dout12       ,
    output reg [  256-1:0]                dout13       ,
    output reg [  256-1:0]                dout14       ,
    output reg [  256-1:0]                dout15       ,
    output reg [  256-1:0]                dout16       ,
    output reg [  256-1:0]                dout17       ,
    output reg [  256-1:0]                dout18       ,
    output reg [  256-1:0]                dout19       ,
    output reg [  256-1:0]                dout20       ,
    output reg [  256-1:0]                dout21       ,
    output reg [  256-1:0]                dout22       ,
    output reg [  256-1:0]                dout23       ,
    output reg [  256-1:0]                dout24       ,
    output reg [  256-1:0]                dout25       ,
    output reg [  256-1:0]                dout26       ,
    output reg [  256-1:0]                dout27       ,
    output reg [  256-1:0]                dout28       ,
    output reg [  256-1:0]                dout29       ,
    output reg [  256-1:0]                dout30       ,
    output reg [  256-1:0]                dout31        //
);
    always@(posedge clk)begin
        if(!flag_msm)begin //ntt mode
            dout0  <= din0 ;
            dout1  <= din1 ;
            dout2  <= din2 ;
            dout3  <= din3 ;
            dout4  <= din4 ;
            dout5  <= din5 ;
            dout6  <= din6 ;
            dout7  <= din7 ;
            dout8  <= din8 ;
            dout9  <= din9 ;
            dout10 <= din10;
            dout11 <= din11;
            dout12 <= din12;
            dout13 <= din13;
            dout14 <= din14;
            dout15 <= din15;
            dout16 <= din16;
            dout17 <= din17;
            dout18 <= din18;
            dout19 <= din19;
            dout20 <= din20;
            dout21 <= din21;
            dout22 <= din22;
            dout23 <= din23;
            dout24 <= din24;
            dout25 <= din25;
            dout26 <= din26;
            dout27 <= din27;
            dout28 <= din28;
            dout29 <= din29;
            dout30 <= din30;
            dout31 <= din31;
        end
        else begin //msm mode: only use dout0,dout1,dout2,dout3 four output ports
            case(ce_in)
                32'b 0000_0001_0000_0001_0000_0001_0000_0001: begin
                    {dout0,dout1,dout2,dout3} <= {din0,din16,din8,din24};
                end
                32'b 0000_0010_0000_0010_0000_0010_0000_0010: begin
                    {dout0,dout1,dout2,dout3} <= {din1,din17,din9,din25};
                end
                32'b 0000_0100_0000_0100_0000_0100_0000_0100: begin
                    {dout0,dout1,dout2,dout3} <= {din2,din18,din10,din26};
                end
                32'b 0000_1000_0000_1000_0000_1000_0000_1000: begin
                    {dout0,dout1,dout2,dout3} <= {din3,din19,din11,din27};
                end
                32'b 0001_0000_0001_0000_0001_0000_0001_0000: begin
                    {dout0,dout1,dout2,dout3} <= {din4,din20,din12,din28};
                end
                32'b 0010_0000_0010_0000_0010_0000_0010_0000: begin
                    {dout0,dout1,dout2,dout3} <= {din5,din21,din13,din29};
                end
                32'b 0100_0000_0100_0000_0100_0000_0100_0000: begin
                    {dout0,dout1,dout2,dout3} <= {din6,din22,din14,din30};
                end
                32'b 1000_0000_1000_0000_1000_0000_1000_0000: begin
                    {dout0,dout1,dout2,dout3} <= {din7,din23,din15,din31};
                end
                default:begin
                    {dout0,dout1,dout2,dout3} <= 0;
                end
            endcase
        end
    end
endmodule
