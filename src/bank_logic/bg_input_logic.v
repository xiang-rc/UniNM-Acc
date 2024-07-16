module bg_input_logic( //suitable for bank_group0,1,2,3
    input                                 flag_msm     , //==0: do ntt; ==1: do msm
    input      [     10:0]                load_addr_in ,
    input                                 ce_load      , //from bank_load_logic
    input                                 wen_load     ,
    input      [     11:0]                msm_addr_in  ,
    input                                 ce_msm       ,
    input                                 ren_msm      ,
    input      [ 7*32-1:0]                ntt_addr_in  , //32 7-bit
    input      [   32-1:0]                ce_ntt       , //32 1-bit
    input      [   32-1:0]                wen_ntt      , //32 1-bit
    input      [  512-1:0]                data_load_in , //from bank_load_logic
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
    output reg [ 7*32-1:0]                addr_out     , //32 7-bit
    output reg [   32-1:0]                ce_out       , //32 1-bit
    output reg [   32-1:0]                wen_out      , //32 1-bit
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
    always@(*)begin//ce_out
        if(ce_load) begin
            if(load_addr_in[10]) begin //>=1024
                case(load_addr_in[9:7])
                3'b000: begin
                    ce_out = 32'b 0000_0001_0000_0000_0000_0001_0000_0000;
                end
                3'b001: begin
                    ce_out = 32'b 0000_0010_0000_0000_0000_0010_0000_0000;
                end
                3'b010: begin
                    ce_out = 32'b 0000_0100_0000_0000_0000_0100_0000_0000;
                end
                3'b011: begin
                    ce_out = 32'b 0000_1000_0000_0000_0000_1000_0000_0000;
                end
                3'b100: begin
                    ce_out = 32'b 0001_0000_0000_0000_0001_0000_0000_0000;
                end
                3'b101: begin
                    ce_out = 32'b 0010_0000_0000_0000_0010_0000_0000_0000;
                end
                3'b110: begin
                    ce_out = 32'b 0100_0000_0000_0000_0100_0000_0000_0000;
                end
                3'b111: begin
                    ce_out = 32'b 1000_0000_0000_0000_1000_0000_0000_0000;
                end
                default:begin
                    ce_out = 32'b 0000_0000_0000_0000_0000_0000_0000_0000;
                end
                endcase
            end
            else begin  //<1024
                case(load_addr_in[9:7])
                3'b000: begin
                    ce_out = 32'b 0000_0000_0000_0001_0000_0000_0000_0001;
                end
                3'b001: begin
                    ce_out = 32'b 0000_0000_0000_0010_0000_0000_0000_0010;
                end
                3'b010: begin
                    ce_out = 32'b 0000_0000_0000_0100_0000_0000_0000_0100;
                end
                3'b011: begin
                    ce_out = 32'b 0000_0000_0000_1000_0000_0000_0000_1000;
                end
                3'b100: begin
                    ce_out = 32'b 0000_0000_0001_0000_0000_0000_0001_0000;
                end
                3'b101: begin
                    ce_out = 32'b 0000_0000_0010_0000_0000_0000_0010_0000;
                end
                3'b110: begin
                    ce_out = 32'b 0000_0000_0100_0000_0000_0000_0100_0000;
                end
                3'b111: begin
                    ce_out = 32'b 0000_0000_1000_0000_0000_0000_1000_0000;
                end
                default:begin
                    ce_out = 32'b 0000_0000_0000_0000_0000_0000_0000_0000;
                end
                endcase
            end
        end
        else if(ce_msm) begin
            //if(msm_addr_in[10]) begin //>=1024
            //    case(msm_addr_in[9:7])
            //    3'b000: begin
            //        ce_out = 32'b 0000_0001_0000_0000_0000_0001_0000_0000;
            //    end
            //    3'b001: begin
            //        ce_out = 32'b 0000_0010_0000_0000_0000_0010_0000_0000;
            //    end
            //    3'b010: begin
            //        ce_out = 32'b 0000_0100_0000_0000_0000_0100_0000_0000;
            //    end
            //    3'b011: begin
            //        ce_out = 32'b 0000_1000_0000_0000_0000_1000_0000_0000;
            //    end
            //    3'b100: begin
            //        ce_out = 32'b 0001_0000_0000_0000_0001_0000_0000_0000;
            //    end
            //    3'b101: begin
            //        ce_out = 32'b 0010_0000_0000_0000_0010_0000_0000_0000;
            //    end
            //    3'b110: begin
            //        ce_out = 32'b 0100_0000_0000_0000_0100_0000_0000_0000;
            //    end
            //    3'b111: begin
            //        ce_out = 32'b 1000_0000_0000_0000_1000_0000_0000_0000;
            //    end
            //    default:begin
            //        ce_out = 32'b 0000_0000_0000_0000_0000_0000_0000_0000;
            //    end
            //    endcase
            //end
            //else begin  //<1024
                case(msm_addr_in[9:7])
                3'b000: begin
                    ce_out = 32'b 0000_0001_0000_0001_0000_0001_0000_0001;
                end
                3'b001: begin
                    ce_out = 32'b 0000_0010_0000_0010_0000_0010_0000_0010;
                end
                3'b010: begin
                    ce_out = 32'b 0000_0100_0000_0100_0000_0100_0000_0100;
                end
                3'b011: begin
                    ce_out = 32'b 0000_1000_0000_1000_0000_1000_0000_1000;
                end
                3'b100: begin
                    ce_out = 32'b 0001_0000_0001_0000_0001_0000_0001_0000;
                end
                3'b101: begin
                    ce_out = 32'b 0010_0000_0010_0000_0010_0000_0010_0000;
                end
                3'b110: begin
                    ce_out = 32'b 0100_0000_0100_0000_0100_0000_0100_0000;
                end
                3'b111: begin
                    ce_out = 32'b 1000_0000_1000_0000_1000_0000_1000_0000;
                end
                default:begin
                    ce_out = 32'b 0000_0000_0000_0000_0000_0000_0000_0000;
                end
                endcase
            //end
        end
        else if(ce_ntt[0]) begin
            ce_out = 32'b 1111_1111_1111_1111_1111_1111_1111_1111;
        end
        else begin
            ce_out = 0;
        end
    end
    always@(*)begin//wen_out
        if(wen_load) begin
            if(load_addr_in[10]) begin //>=1024
                case(load_addr_in[9:7])
                3'b000: begin
                    wen_out = 32'b 0000_0001_0000_0000_0000_0001_0000_0000;
                end
                3'b001: begin
                    wen_out = 32'b 0000_0010_0000_0000_0000_0010_0000_0000;
                end
                3'b010: begin
                    wen_out = 32'b 0000_0100_0000_0000_0000_0100_0000_0000;
                end
                3'b011: begin
                    wen_out = 32'b 0000_1000_0000_0000_0000_1000_0000_0000;
                end
                3'b100: begin
                    wen_out = 32'b 0001_0000_0000_0000_0001_0000_0000_0000;
                end
                3'b101: begin
                    wen_out = 32'b 0010_0000_0000_0000_0010_0000_0000_0000;
                end
                3'b110: begin
                    wen_out = 32'b 0100_0000_0000_0000_0100_0000_0000_0000;
                end
                3'b111: begin
                    wen_out = 32'b 1000_0000_0000_0000_1000_0000_0000_0000;
                end
                default:begin
                    wen_out = 32'b 0000_0000_0000_0000_0000_0000_0000_0000;
                end
                endcase
            end
            else begin  //<1024
                case(load_addr_in[9:7])
                3'b000: begin
                    wen_out = 32'b 0000_0000_0000_0001_0000_0000_0000_0001;
                end
                3'b001: begin
                    wen_out = 32'b 0000_0000_0000_0010_0000_0000_0000_0010;
                end
                3'b010: begin
                    wen_out = 32'b 0000_0000_0000_0100_0000_0000_0000_0100;
                end
                3'b011: begin
                    wen_out = 32'b 0000_0000_0000_1000_0000_0000_0000_1000;
                end
                3'b100: begin
                    wen_out = 32'b 0000_0000_0001_0000_0000_0000_0001_0000;
                end
                3'b101: begin
                    wen_out = 32'b 0000_0000_0010_0000_0000_0000_0010_0000;
                end
                3'b110: begin
                    wen_out = 32'b 0000_0000_0100_0000_0000_0000_0100_0000;
                end
                3'b111: begin
                    wen_out = 32'b 0000_0000_1000_0000_0000_0000_1000_0000;
                end
                default:begin
                    wen_out = 32'b 0000_0000_0000_0000_0000_0000_0000_0000;
                end
                endcase
            end
        end
        else if(ren_msm) begin
            wen_out = 32'b 0000_0000_0000_0000_0000_0000_0000_0000;
        end
        else if(wen_ntt[0]) begin
            wen_out = 32'b 1111_1111_1111_1111_1111_1111_1111_1111;
        end
        else begin
            wen_out = 0;
        end
    end
    always@(*)begin//addr_out
        if(wen_load) begin
            if(load_addr_in[10]) begin //>=1024
                case(load_addr_in[9:7])
                3'b000: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0],
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0  };
                end
                3'b001: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0  };
                end
                3'b010: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0],  7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0],  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0  };
                end
                3'b011: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0  };
                end
                3'b100: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0   };
                end
                3'b101: begin
                    addr_out = {7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0   };
                end
                3'b110: begin
                    addr_out = {7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0   };
                end
                3'b111: begin
                    addr_out = {load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0   };
                end
                default:begin
                    addr_out = 0;
                end
                endcase
            end
            else begin  //<1024
                case(load_addr_in[9:7])
                3'b000: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0]  };
                end
                3'b001: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0  };
                end
                3'b010: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0],  7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0],  7'd 0, 7'd 0  };
                end
                3'b011: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0,  7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0,  7'd 0, 7'd 0  };
                end
                3'b100: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0,  7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0,  7'd 0, 7'd 0  };
                end
                3'b101: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0  };
                end
                3'b110: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0  };
                end
                3'b111: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                load_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,  7'd 0, 7'd 0  };
                end
                default:begin
                    addr_out = 0;
                end
                endcase
            end
        end
        else if(ren_msm) begin
            case(msm_addr_in[9:7])
                3'b000: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0],
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0]  };
                end
                3'b001: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0  };
                end
                3'b010: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0  };
                end
                3'b011: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0  };
                end
                3'b100: begin
                    addr_out = {7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0   };
                end
                3'b101: begin
                    addr_out = {7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, 7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0   };
                end
                3'b110: begin
                    addr_out = {7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                7'd 0, msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0   };
                end
                3'b111: begin
                    addr_out = {msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 
                                msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0,
                                msm_addr_in[6:0], 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0, 7'd 0   };
                end
                default:begin
                    addr_out = 0;
                end
            endcase
        end
        else if(wen_ntt[0]) begin
            addr_out = ntt_addr_in;
        end
        else begin
            addr_out = 0;
        end
    end
    always@(*)begin//dout
        if(ce_load)begin//load data
            if(load_addr_in[10]) begin //>=1024
                case(load_addr_in[9:7])
                3'b000: begin
                    {dout24,dout8} = data_load_in;
                end
                3'b001: begin
                    {dout25,dout9} = data_load_in;
                end
                3'b010: begin
                    {dout26,dout10} = data_load_in;
                end
                3'b011: begin
                    {dout27,dout11} = data_load_in;
                end
                3'b100: begin
                    {dout28,dout12} = data_load_in;
                end
                3'b101: begin
                    {dout29,dout13} = data_load_in;
                end
                3'b110: begin
                    {dout30,dout14} = data_load_in;
                end
                3'b111: begin
                    {dout31,dout15} = data_load_in;
                end
                default:begin
                    dout0 =0;
                    dout1 =0;
                    dout2 =0;
                    dout3 =0;
                    dout4 =0;
                    dout5 =0;
                    dout6 =0;
                    dout7 =0;
                    dout8 =0;
                    dout9 =0;
                    dout10=0;
                    dout11=0;
                    dout12=0;
                    dout13=0;
                    dout14=0;
                    dout15=0;
                    dout16=0;
                    dout17=0;
                    dout18=0;
                    dout19=0;
                    dout20=0;
                    dout21=0;
                    dout22=0;
                    dout23=0;
                    dout24=0;
                    dout25=0;
                    dout26=0;
                    dout27=0;
                    dout28=0;
                    dout29=0;
                    dout30=0;
                    dout31=0;
                end
                endcase
            end
            else begin  //<1024
                case(load_addr_in[9:7])
                3'b000: begin
                    {dout16,dout0} = data_load_in;
                end
                3'b001: begin
                    {dout17,dout1} = data_load_in;
                end
                3'b010: begin
                    {dout18,dout2} = data_load_in;
                end
                3'b011: begin
                    {dout19,dout3} = data_load_in;
                end
                3'b100: begin
                    {dout20,dout4} = data_load_in;
                end
                3'b101: begin
                    {dout21,dout5} = data_load_in;
                end
                3'b110: begin
                    {dout22,dout6} = data_load_in;
                end
                3'b111: begin
                    {dout23,dout8} = data_load_in;
                end
                default:begin
                    dout0 =0;
                    dout1 =0;
                    dout2 =0;
                    dout3 =0;
                    dout4 =0;
                    dout5 =0;
                    dout6 =0;
                    dout7 =0;
                    dout8 =0;
                    dout9 =0;
                    dout10=0;
                    dout11=0;
                    dout12=0;
                    dout13=0;
                    dout14=0;
                    dout15=0;
                    dout16=0;
                    dout17=0;
                    dout18=0;
                    dout19=0;
                    dout20=0;
                    dout21=0;
                    dout22=0;
                    dout23=0;
                    dout24=0;
                    dout25=0;
                    dout26=0;
                    dout27=0;
                    dout28=0;
                    dout29=0;
                    dout30=0;
                    dout31=0;
                end
                endcase
            end
        end
        else begin
            dout0 =din0 ;
            dout1 =din1 ;
            dout2 =din2 ;
            dout3 =din3 ;
            dout4 =din4 ;
            dout5 =din5 ;
            dout6 =din6 ;
            dout7 =din7 ;
            dout8 =din8 ;
            dout9 =din9 ;
            dout10=din10;
            dout11=din11;
            dout12=din12;
            dout13=din13;
            dout14=din14;
            dout15=din15;
            dout16=din16;
            dout17=din17;
            dout18=din18;
            dout19=din19;
            dout20=din20;
            dout21=din21;
            dout22=din22;
            dout23=din23;
            dout24=din24;
            dout25=din25;
            dout26=din26;
            dout27=din27;
            dout28=din28;
            dout29=din29;
            dout30=din30;
            dout31=din31;
        end
    end
endmodule
