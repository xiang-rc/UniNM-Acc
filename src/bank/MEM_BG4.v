module MEM_BG4(
    input                     clk           ,
    input                     bg4_en_0_a    , //CEB
    input                     bg4_en_0_b    ,
    input                     bg4_wen_0_a   , //WEB
    input                     bg4_wen_0_b   ,
    input        [   4:0]     bg4_addr_0_a  ,
    input        [   4:0]     bg4_addr_0_b  ,
    input        [ 255:0]     bg4_din_0_a   ,
    input        [ 255:0]     bg4_din_0_b   ,
    input        [ 255:0]     bg4_bwe_0_a   ,
    input        [ 255:0]     bg4_bwe_0_b   ,
    output       [ 255:0]     bg4_dout_0_a  ,
    output       [ 255:0]     bg4_dout_0_b  ,
    input                     bg4_en_1_a    , //CEB
    input                     bg4_en_1_b    ,
    input                     bg4_wen_1_a   , //WEB
    input                     bg4_wen_1_b   ,
    input        [   4:0]     bg4_addr_1_a  ,
    input        [   4:0]     bg4_addr_1_b  ,
    input        [ 255:0]     bg4_din_1_a   ,
    input        [ 255:0]     bg4_din_1_b   ,
    input        [ 255:0]     bg4_bwe_1_a   ,
    input        [ 255:0]     bg4_bwe_1_b   ,
    output       [ 255:0]     bg4_dout_1_a  ,
    output       [ 255:0]     bg4_dout_1_b  ,
    input        [   4:0]     bg4_addr_2_a  ,
    input        [   4:0]     bg4_addr_2_b  ,
    input        [ 255:0]     bg4_din_2     ,
    input        [ 255:0]     bg4_bwe_2     ,
    input                     bg4_wen_2     ,
    input                     bg4_ren_2     ,
    output       [ 255:0]     bg4_dout_2    ,
    input        [   4:0]     bg4_addr_3    ,
    input        [ 255:0]     bg4_din_3     ,
    input                     bg4_en_3      ,
    input                     bg4_wen_3     ,
    output       [ 255:0]     bg4_dout_3    ,
    input        [   6:0]     bg4_addr_4    ,
    input        [ 255:0]     bg4_din_4     ,
    input                     bg4_en_4      ,
    input                     bg4_wen_4     ,
    output       [ 255:0]     bg4_dout_4    ,
    input        [   6:0]     bg4_addr_5    ,
    input        [ 255:0]     bg4_din_5     ,
    input                     bg4_en_5      ,
    input                     bg4_wen_5     ,
    output       [ 255:0]     bg4_dout_5    ,
    input        [   6:0]     bg4_addr_6    ,
    input        [ 255:0]     bg4_din_6     ,
    input                     bg4_en_6      ,
    input                     bg4_wen_6     ,
    output       [ 255:0]     bg4_dout_6    ,
    input        [   6:0]     bg4_addr_7   ,
    input        [ 255:0]     bg4_din_7    ,
    input                     bg4_en_7     ,
    input                     bg4_wen_7    ,
    output       [ 255:0]     bg4_dout_7   ,
    input        [   6:0]     bg4_addr_8   ,
    input        [ 255:0]     bg4_din_8    ,
    input                     bg4_en_8     ,
    input                     bg4_wen_8    ,
    output       [ 255:0]     bg4_dout_8   ,
    input        [   6:0]     bg4_addr_9    ,
    input        [ 255:0]     bg4_din_9     ,
    input                     bg4_en_9      ,
    input                     bg4_wen_9     ,
    output       [ 255:0]     bg4_dout_9    ,
    input        [   6:0]     bg4_addr_10   ,
    input        [ 255:0]     bg4_din_10    ,
    input                     bg4_en_10     ,
    input                     bg4_wen_10    ,
    output       [ 255:0]     bg4_dout_10   ,
    input                     bg4_en_13_a   , //CEB
    input                     bg4_en_13_b   ,
    input                     bg4_wen_13_a  , //WEB
    input                     bg4_wen_13_b  ,
    input        [   4:0]     bg4_addr_13_a ,
    input        [   4:0]     bg4_addr_13_b ,
    input        [ 255:0]     bg4_din_13_a  ,
    input        [ 255:0]     bg4_din_13_b  ,
    input        [ 255:0]     bg4_bwe_13_a  ,
    input        [ 255:0]     bg4_bwe_13_b  ,
    output       [ 255:0]     bg4_dout_13_a ,
    output       [ 255:0]     bg4_dout_13_b ,
    input        [   4:0]     bg4_addr_14_a ,
    input        [   4:0]     bg4_addr_14_b ,
    input        [ 255:0]     bg4_din_14    ,
    input        [ 255:0]     bg4_bwe_14    ,
    input                     bg4_wen_14    ,
    input                     bg4_ren_14    ,
    output       [ 255:0]     bg4_dout_14   ,
    input        [   4:0]     bg4_addr_15_a ,
    input        [   4:0]     bg4_addr_15_b ,
    input        [ 255:0]     bg4_din_15    ,
    input        [ 255:0]     bg4_bwe_15    ,
    input                     bg4_wen_15    ,
    input                     bg4_ren_15    ,
    output       [ 255:0]     bg4_dout_15   ,
    input        [   4:0]     bg4_addr_16   ,
    input        [ 255:0]     bg4_din_16    ,
    input                     bg4_en_16     ,
    input                     bg4_wen_16    ,
    output       [ 255:0]     bg4_dout_16   ,
    input        [   6:0]     bg4_addr_17   ,
    input        [ 255:0]     bg4_din_17    ,
    input                     bg4_en_17     ,
    input                     bg4_wen_17    ,
    output       [ 255:0]     bg4_dout_17   ,
    input        [   6:0]     bg4_addr_18   ,
    input        [ 255:0]     bg4_din_18    ,
    input                     bg4_en_18     ,
    input                     bg4_wen_18    ,
    output       [ 255:0]     bg4_dout_18   ,
    input        [   6:0]     bg4_addr_19   ,
    input        [ 255:0]     bg4_din_19    ,
    input                     bg4_en_19     ,
    input                     bg4_wen_19    ,
    output       [ 255:0]     bg4_dout_19   ,
    input        [   6:0]     bg4_addr_20   ,
    input        [ 255:0]     bg4_din_20    ,
    input                     bg4_en_20     ,
    input                     bg4_wen_20    ,
    output       [ 255:0]     bg4_dout_20   ,
    input        [   6:0]     bg4_addr_21   ,
    input        [ 255:0]     bg4_din_21    ,
    input                     bg4_en_21     ,
    input                     bg4_wen_21    ,
    output       [ 255:0]     bg4_dout_21   ,
    input        [   6:0]     bg4_addr_22   ,
    input        [ 255:0]     bg4_din_22    ,
    input                     bg4_en_22     ,
    input                     bg4_wen_22    ,
    output       [ 255:0]     bg4_dout_22   ,
    input        [   6:0]     bg4_addr_23   ,
    input        [ 255:0]     bg4_din_23    ,
    input                     bg4_en_23     ,
    input                     bg4_wen_23    ,
    output       [ 255:0]     bg4_dout_23   ,
    input                     bg4_en_26_a    , //CEB
    input                     bg4_en_26_b    ,
    input                     bg4_wen_26_a   , //WEB
    input                     bg4_wen_26_b   ,
    input        [   4:0]     bg4_addr_26_a  ,
    input        [   4:0]     bg4_addr_26_b  ,
    input        [ 255:0]     bg4_din_26_a   ,
    input        [ 255:0]     bg4_din_26_b   ,
    input        [ 255:0]     bg4_bwe_26_a   ,
    input        [ 255:0]     bg4_bwe_26_b   ,
    output       [ 255:0]     bg4_dout_26_a  ,
    output       [ 255:0]     bg4_dout_26_b  ,
    input        [   4:0]     bg4_addr_27_a ,
    input        [   4:0]     bg4_addr_27_b ,
    input        [ 255:0]     bg4_din_27    ,
    input        [ 255:0]     bg4_bwe_27    ,
    input                     bg4_wen_27    ,
    input                     bg4_ren_27    ,
    output       [ 255:0]     bg4_dout_27   ,
    input        [   4:0]     bg4_addr_28   ,
    input        [ 255:0]     bg4_din_28    ,
    input                     bg4_en_28     ,
    input                     bg4_wen_28    ,
    output       [ 255:0]     bg4_dout_28   ,
    input        [   4:0]     bg4_addr_29   ,
    input        [ 255:0]     bg4_din_29    ,
    input                     bg4_en_29     ,
    input                     bg4_wen_29    ,
    output       [ 255:0]     bg4_dout_29   ,
    input        [   6:0]     bg4_addr_30   ,
    input        [ 255:0]     bg4_din_30    ,
    input                     bg4_en_30     ,
    input                     bg4_wen_30    ,
    output       [ 255:0]     bg4_dout_30   ,
    input        [   6:0]     bg4_addr_31   ,
    input        [ 255:0]     bg4_din_31    ,
    input                     bg4_en_31     ,
    input                     bg4_wen_31    ,
    output       [ 255:0]     bg4_dout_31   ,
    input        [   6:0]     bg4_addr_32   ,
    input        [ 255:0]     bg4_din_32    ,
    input                     bg4_en_32     ,
    input                     bg4_wen_32    ,
    output       [ 255:0]     bg4_dout_32   ,
    input        [   6:0]     bg4_addr_33   ,
    input        [ 255:0]     bg4_din_33    ,
    input                     bg4_en_33     ,
    input                     bg4_wen_33    ,
    output       [ 255:0]     bg4_dout_33   ,
    input        [   6:0]     bg4_addr_34   ,
    input        [ 255:0]     bg4_din_34    ,
    input                     bg4_en_34     ,
    input                     bg4_wen_34    ,
    output       [ 255:0]     bg4_dout_34   ,
    input        [   6:0]     bg4_addr_35   ,
    input        [ 255:0]     bg4_din_35    ,
    input                     bg4_en_35     ,
    input                     bg4_wen_35    ,
    output       [ 255:0]     bg4_dout_35   ,
    input        [   6:0]     bg4_addr_36   ,
    input        [ 255:0]     bg4_din_36    ,
    input                     bg4_en_36     ,
    input                     bg4_wen_36    ,
    output       [ 255:0]     bg4_dout_36   ,
    input                     bg4_en_39_a   , //CEB
    input                     bg4_en_39_b   ,
    input                     bg4_wen_39_a  , //WEB
    input                     bg4_wen_39_b  ,
    input        [   4:0]     bg4_addr_39_a ,
    input        [   4:0]     bg4_addr_39_b ,
    input        [ 255:0]     bg4_din_39_a  ,
    input        [ 255:0]     bg4_din_39_b  ,
    input        [ 255:0]     bg4_bwe_39_a  ,
    input        [ 255:0]     bg4_bwe_39_b  ,
    output       [ 255:0]     bg4_dout_39_a ,
    output       [ 255:0]     bg4_dout_39_b ,
    input        [   4:0]     bg4_addr_40_a ,
    input        [   4:0]     bg4_addr_40_b ,
    input        [ 255:0]     bg4_din_40    ,
    input        [ 255:0]     bg4_bwe_40    ,
    input                     bg4_wen_40    ,
    input                     bg4_ren_40    ,
    output       [ 255:0]     bg4_dout_40   ,
    input        [   4:0]     bg4_addr_41   ,
    input        [ 255:0]     bg4_din_41    ,
    input                     bg4_en_41     ,
    input                     bg4_wen_41    ,
    output       [ 255:0]     bg4_dout_41   ,
    input        [   4:0]     bg4_addr_42   ,
    input        [ 255:0]     bg4_din_42    ,
    input                     bg4_en_42     ,
    input                     bg4_wen_42    ,
    output       [ 255:0]     bg4_dout_42   ,
    input        [   6:0]     bg4_addr_43   ,
    input        [ 255:0]     bg4_din_43    ,
    input                     bg4_en_43     ,
    input                     bg4_wen_43    ,
    output       [ 255:0]     bg4_dout_43   ,
    input        [   6:0]     bg4_addr_44   ,
    input        [ 255:0]     bg4_din_44    ,
    input                     bg4_en_44     ,
    input                     bg4_wen_44    ,
    output       [ 255:0]     bg4_dout_44   ,
    input        [   6:0]     bg4_addr_45   ,
    input        [ 255:0]     bg4_din_45    ,
    input                     bg4_en_45     ,
    input                     bg4_wen_45    ,
    output       [ 255:0]     bg4_dout_45   ,
    input        [   6:0]     bg4_addr_46   ,
    input        [ 255:0]     bg4_din_46    ,
    input                     bg4_en_46     ,
    input                     bg4_wen_46    ,
    output       [ 255:0]     bg4_dout_46   ,
    input        [   6:0]     bg4_addr_47   ,
    input        [ 255:0]     bg4_din_47    ,
    input                     bg4_en_47     ,
    input                     bg4_wen_47    ,
    output       [ 255:0]     bg4_dout_47   ,
    input        [   6:0]     bg4_addr_48   ,
    input        [ 255:0]     bg4_din_48    ,
    input                     bg4_en_48     ,
    input                     bg4_wen_48    ,
    output       [ 255:0]     bg4_dout_48   ,
    input        [   6:0]     bg4_addr_49   ,
    input        [ 255:0]     bg4_din_49    ,
    input                     bg4_en_49     ,
    input                     bg4_wen_49    ,
    output       [ 255:0]     bg4_dout_49    //
);

    wire    [   4:0]   AA_dp    [  4:0] ;
    wire    [ 255:0]   DA_dp    [  4:0] ;
    wire    [ 255:0]   BWEBA_dp [  4:0] ;
    wire    [   4:0]   WEBA_dp          ;
    wire    [   4:0]   CEBA_dp          ;
    wire    [   4:0]   AB_dp    [  4:0] ;
    wire    [ 255:0]   DB_dp    [  4:0] ;
    wire    [ 255:0]   BWEBB_dp [  4:0] ;
    wire    [   4:0]   WEBB_dp          ;
    wire    [   4:0]   CEBB_dp          ;
    wire    [ 255:0]   QA_dp    [  4:0] ;
    wire    [ 255:0]   QB_dp    [  4:0] ;

    assign AA_dp[0] = bg4_addr_0_a;
    assign DA_dp[0] = bg4_din_0_a ;
    assign BWEBA_dp[0] = bg4_bwe_0_a;
    assign WEBA_dp[0] = bg4_wen_0_a;
    assign CEBA_dp[0] = bg4_en_0_a;
    assign AB_dp[0] = bg4_addr_0_b;
    assign DB_dp[0] = bg4_din_0_b ;
    assign BWEBB_dp[0] = bg4_bwe_0_b;
    assign WEBB_dp[0] = bg4_wen_0_b;
    assign CEBB_dp[0] = bg4_en_0_b;
    assign bg4_dout_0_a = QA_dp[0];
    assign bg4_dout_0_b = QB_dp[0];

    assign AA_dp[1] = bg4_addr_1_a;
    assign DA_dp[1] = bg4_din_1_a ;
    assign BWEBA_dp[1] = bg4_bwe_1_a;
    assign WEBA_dp[1] = bg4_wen_1_a;
    assign CEBA_dp[1] = bg4_en_1_a;
    assign AB_dp[1] = bg4_addr_1_b;
    assign DB_dp[1] = bg4_din_1_b ;
    assign BWEBB_dp[1] = bg4_bwe_1_b;
    assign WEBB_dp[1] = bg4_wen_1_b;
    assign CEBB_dp[1] = bg4_en_1_b;
    assign bg4_dout_1_a = QA_dp[1];
    assign bg4_dout_1_b = QB_dp[1];

    //assign AA_dp[2] = bg4_addr_2_a;
    //assign DA_dp[2] = bg4_din_2 ;
    //assign BWEBA_dp[2] = bg4_bwe_2_a;
    //assign WEBA_dp[2] = bg4_wen_2_a;
    //assign CEBA_dp[2] = bg4_en_2_a;
    //assign AB_dp[2] = bg4_addr_2_b;
    //assign DB_dp[2] = bg4_din_2_b ;
    //assign BWEBB_dp[2] = bg4_bwe_2_b;
    //assign WEBB_dp[2] = bg4_wen_2_b;
    //assign CEBB_dp[2] = bg4_en_2_b;
    //assign bg4_dout_2_a = QA_dp[2];
    //assign bg4_dout_2_b = QB_dp[2];

    assign AA_dp[3] = bg4_addr_26_a;
    assign DA_dp[3] = bg4_din_26_a ;
    assign BWEBA_dp[3] = bg4_bwe_26_a;
    assign WEBA_dp[3] = bg4_wen_26_a;
    assign CEBA_dp[3] = bg4_en_26_a;
    assign AB_dp[3] = bg4_addr_26_b;
    assign DB_dp[3] = bg4_din_26_b ;
    assign BWEBB_dp[3] = bg4_bwe_26_b;
    assign WEBB_dp[3] = bg4_wen_26_b;
    assign CEBB_dp[3] = bg4_en_26_b;
    assign bg4_dout_26_a = QA_dp[3];
    assign bg4_dout_26_b = QB_dp[3];

    assign AA_dp[4] = bg4_addr_39_a;
    assign DA_dp[4] = bg4_din_39_a ;
    assign BWEBA_dp[4] = bg4_bwe_39_a;
    assign WEBA_dp[4] = bg4_wen_39_a;
    assign CEBA_dp[4] = bg4_en_39_a;
    assign AB_dp[4] = bg4_addr_39_b;
    assign DB_dp[4] = bg4_din_39_b ;
    assign BWEBB_dp[4] = bg4_bwe_39_b;
    assign WEBB_dp[4] = bg4_wen_39_b;
    assign CEBB_dp[4] = bg4_en_39_b;
    assign bg4_dout_39_a = QA_dp[4];
    assign bg4_dout_39_b = QB_dp[4];

    wire    [   4:0]   AA_2prf    [  4:0] ;
    wire    [ 255:0]   D_2prf     [  4:0] ;
    wire    [ 255:0]   BWEB_2prf  [  4:0] ;
    wire    [   4:0]   WEB_2prf           ;
    wire    [   4:0]   AB_2prf    [  4:0] ;
    wire    [   4:0]   REB_2prf           ;
    wire    [ 255:0]   Q_2prf     [  4:0] ;

    assign AA_2prf[0] = bg4_addr_2_a;
    assign AB_2prf[0] = bg4_addr_2_b;
    assign D_2prf[0] = bg4_din_2;
    assign BWEB_2prf[0] = bg4_bwe_2;
    assign WEB_2prf[0] = bg4_wen_2;
    assign REB_2prf[0] = bg4_ren_2;
    assign bg4_dout_2 = Q_2prf[0];

    assign AA_2prf[1] = bg4_addr_14_a;
    assign AB_2prf[1] = bg4_addr_14_b;
    assign D_2prf[1] = bg4_din_14;
    assign BWEB_2prf[1] = bg4_bwe_14;
    assign WEB_2prf[1] = bg4_wen_14;
    assign REB_2prf[1] = bg4_ren_14;
    assign bg4_dout_14 = Q_2prf[1];

    assign AA_2prf[2] = bg4_addr_15_a;
    assign AB_2prf[2] = bg4_addr_15_b;
    assign D_2prf[2] = bg4_din_15;
    assign BWEB_2prf[2] = bg4_bwe_15;
    assign WEB_2prf[2] = bg4_wen_15;
    assign REB_2prf[2] = bg4_ren_15;
    assign bg4_dout_15 = Q_2prf[2];

    assign AA_2prf[3] = bg4_addr_27_a;
    assign AB_2prf[3] = bg4_addr_27_b;
    assign D_2prf[3] = bg4_din_27;
    assign BWEB_2prf[3] = bg4_bwe_27;
    assign WEB_2prf[3] = bg4_wen_27;
    assign REB_2prf[3] = bg4_ren_27;
    assign bg4_dout_27 = Q_2prf[3];

    assign AA_2prf[4] = bg4_addr_40_a;
    assign AB_2prf[4] = bg4_addr_40_b;
    assign D_2prf[4] = bg4_din_40;
    assign BWEB_2prf[4] = bg4_bwe_40;
    assign WEB_2prf[4] = bg4_wen_40;
    assign REB_2prf[4] = bg4_ren_40;
    assign bg4_dout_40 = Q_2prf[4];

    wire    [   5:0]   en_sp           ;
    wire    [   5:0]   wen_sp          ;
    wire    [   4:0]   A_sp    [  5:0] ;
    wire    [ 255:0]   D_sp    [  5:0] ;
    wire    [ 255:0]   Q_sp    [  5:0] ;

    assign A_sp[0] = bg4_addr_3;
    assign D_sp[0] = bg4_din_3;
    assign en_sp[0] = bg4_en_3;
    assign wen_sp[0] = bg4_wen_3;
    assign bg4_dout_3 = Q_sp[0];

    assign A_sp[1] = bg4_addr_16;
    assign D_sp[1] = bg4_din_16;
    assign en_sp[1] = bg4_en_16;
    assign wen_sp[1] = bg4_wen_16;
    assign bg4_dout_16 = Q_sp[1];

    assign A_sp[2] = bg4_addr_28;
    assign D_sp[2] = bg4_din_28;
    assign en_sp[2] = bg4_en_28;
    assign wen_sp[2] = bg4_wen_28;
    assign bg4_dout_28 = Q_sp[2];

    assign A_sp[3] = bg4_addr_29;
    assign D_sp[3] = bg4_din_29;
    assign en_sp[3] = bg4_en_29;
    assign wen_sp[3] = bg4_wen_29;
    assign bg4_dout_29 = Q_sp[3];

    assign A_sp[4] = bg4_addr_41;
    assign D_sp[4] = bg4_din_41;
    assign en_sp[4] = bg4_en_41;
    assign wen_sp[4] = bg4_wen_41;
    assign bg4_dout_41 = Q_sp[4];

    assign A_sp[5] = bg4_addr_42;
    assign D_sp[5] = bg4_din_42;
    assign en_sp[5] = bg4_en_42;
    assign wen_sp[5] = bg4_wen_42;
    assign bg4_dout_42 = Q_sp[5];

    wire    [  35:0]   en            ;
    wire    [  35:0]   wen           ;
    wire    [   6:0]   A    [  35:0] ;
    wire    [ 255:0]   D    [  35:0] ;
    wire    [ 255:0]   Q    [  35:0] ;

    assign A[0] = bg4_addr_4;
    assign D[0] = bg4_din_4;
    assign en[0] = bg4_en_4;
    assign wen[0] = bg4_wen_4;
    assign bg4_dout_4 = Q[0];

    assign A[1] = bg4_addr_5;
    assign D[1] = bg4_din_5;
    assign en[1] = bg4_en_5;
    assign wen[1] = bg4_wen_5;
    assign bg4_dout_5 = Q[1];

    assign A[2] = bg4_addr_6;
    assign D[2] = bg4_din_6;
    assign en[2] = bg4_en_6;
    assign wen[2] = bg4_wen_6;
    assign bg4_dout_6 = Q[2];

    assign A[3] = bg4_addr_7;
    assign D[3] = bg4_din_7;
    assign en[3] = bg4_en_7;
    assign wen[3] = bg4_wen_7;
    assign bg4_dout_7 = Q[3];

    assign A[4] = bg4_addr_8;
    assign D[4] = bg4_din_8;
    assign en[4] = bg4_en_8;
    assign wen[4] = bg4_wen_8;
    assign bg4_dout_8 = Q[4];

    assign A[5] = bg4_addr_9;
    assign D[5] = bg4_din_9;
    assign en[5] = bg4_en_9;
    assign wen[5] = bg4_wen_9;
    assign bg4_dout_9 = Q[5];

    assign A[6] = bg4_addr_10;
    assign D[6] = bg4_din_10;
    assign en[6] = bg4_en_10;
    assign wen[6] = bg4_wen_10;
    assign bg4_dout_10 = Q[6];

    assign A[9] = bg4_addr_17;
    assign D[9] = bg4_din_17;
    assign en[9] = bg4_en_17;
    assign wen[9] = bg4_wen_17;
    assign bg4_dout_17 = Q[9];

    assign A[10] = bg4_addr_18;
    assign D[10] = bg4_din_18;
    assign en[10] = bg4_en_18;
    assign wen[10] = bg4_wen_18;
    assign bg4_dout_18 = Q[10];

    assign A[11] = bg4_addr_19;
    assign D[11] = bg4_din_19;
    assign en[11] = bg4_en_19;
    assign wen[11] = bg4_wen_19;
    assign bg4_dout_19 = Q[11];

    assign A[12] = bg4_addr_20;
    assign D[12] = bg4_din_20;
    assign en[12] = bg4_en_20;
    assign wen[12] = bg4_wen_20;
    assign bg4_dout_20 = Q[12];

    assign A[13] = bg4_addr_21;
    assign D[13] = bg4_din_21;
    assign en[13] = bg4_en_21;
    assign wen[13] = bg4_wen_21;
    assign bg4_dout_21 = Q[13];

    assign A[14] = bg4_addr_22;
    assign D[14] = bg4_din_22;
    assign en[14] = bg4_en_22;
    assign wen[14] = bg4_wen_22;
    assign bg4_dout_22 = Q[14];

    assign A[15] = bg4_addr_23;
    assign D[15] = bg4_din_23;
    assign en[15] = bg4_en_23;
    assign wen[15] = bg4_wen_23;
    assign bg4_dout_23 = Q[15];

    assign A[18] = bg4_addr_30;
    assign D[18] = bg4_din_30;
    assign en[18] = bg4_en_30;
    assign wen[18] = bg4_wen_30;
    assign bg4_dout_30 = Q[18];

    assign A[19] = bg4_addr_31;
    assign D[19] = bg4_din_31;
    assign en[19] = bg4_en_31;
    assign wen[19] = bg4_wen_31;
    assign bg4_dout_31 = Q[19];

    assign A[20] = bg4_addr_32;
    assign D[20] = bg4_din_32;
    assign en[20] = bg4_en_32;
    assign wen[20] = bg4_wen_32;
    assign bg4_dout_32 = Q[20];

    assign A[21] = bg4_addr_33;
    assign D[21] = bg4_din_33;
    assign en[21] = bg4_en_33;
    assign wen[21] = bg4_wen_33;
    assign bg4_dout_33 = Q[21];

    assign A[22] = bg4_addr_34;
    assign D[22] = bg4_din_34;
    assign en[22] = bg4_en_34;
    assign wen[22] = bg4_wen_34;
    assign bg4_dout_34 = Q[22];

    assign A[23] = bg4_addr_35;
    assign D[23] = bg4_din_35;
    assign en[23] = bg4_en_35;
    assign wen[23] = bg4_wen_35;
    assign bg4_dout_35 = Q[23];

    assign A[24] = bg4_addr_36;
    assign D[24] = bg4_din_36;
    assign en[24] = bg4_en_36;
    assign wen[24] = bg4_wen_36;
    assign bg4_dout_36 = Q[24];

    assign A[27] = bg4_addr_43;
    assign D[27] = bg4_din_43;
    assign en[27] = bg4_en_43;
    assign wen[27] = bg4_wen_43;
    assign bg4_dout_43 = Q[27];

    assign A[28] = bg4_addr_44;
    assign D[28] = bg4_din_44;
    assign en[28] = bg4_en_44;
    assign wen[28] = bg4_wen_44;
    assign bg4_dout_44 = Q[28];

    assign A[29] = bg4_addr_45;
    assign D[29] = bg4_din_45;
    assign en[29] = bg4_en_45;
    assign wen[29] = bg4_wen_45;
    assign bg4_dout_45 = Q[29];

    assign A[30] = bg4_addr_46;
    assign D[30] = bg4_din_46;
    assign en[30] = bg4_en_46;
    assign wen[30] = bg4_wen_46;
    assign bg4_dout_46 = Q[30];

    assign A[31] = bg4_addr_47;
    assign D[31] = bg4_din_47;
    assign en[31] = bg4_en_47;
    assign wen[31] = bg4_wen_47;
    assign bg4_dout_47 = Q[31];

    assign A[32] = bg4_addr_48;
    assign D[32] = bg4_din_48;
    assign en[32] = bg4_en_48;
    assign wen[32] = bg4_wen_48;
    assign bg4_dout_48 = Q[32];

    assign A[33] = bg4_addr_49;
    assign D[33] = bg4_din_49;
    assign en[33] = bg4_en_49;
    assign wen[33] = bg4_wen_49;
    assign bg4_dout_49 = Q[33];

    genvar i,j,k,l;

    generate
        for(i=0; i<5; i=i+1) begin:inst0
            MEM_32X256_DP u_mem32x256_dp(
               .CLK              (clk           ),
               .AA               (AA_dp[i]      ),
               .DA               (DA_dp[i]      ),
               .BWEBA            (BWEBA_dp[i]   ),
               .WEBA             (WEBA_dp[i]    ),
               .CEBA             (CEBA_dp[i]    ),
               .AB               (AB_dp[i]      ),
               .DB               (DB_dp[i]      ),
               .BWEBB            (BWEBB_dp[i]   ),
               .WEBB             (WEBB_dp[i]    ),
               .CEBB             (CEBB_dp[i]    ),
               .QA               (QA_dp[i]      ),
               .QB               (QB_dp[i]      )
            );
        end
    endgenerate

    generate
        for(j=0; j<5; j=j+1) begin:inst1
            MEM_32X256_2PRF u_mem32x256_2prf(
               .CLK              (clk           ),
               .AA               (AA_2prf[j]    ),
               .D                (D_2prf[j]     ),
               .BWEB             (BWEB_2prf[j]  ),
               .WEB              (WEB_2prf[j]   ),
               .AB               (AB_2prf[j]    ),
               .REB              (REB_2prf[j]   ),
               .Q                (Q_2prf[j]     )
            );
        end
    endgenerate

    generate
        for(k=0; k<6; k=k+1) begin:inst2
            MEM_32X256_SP u_mem32x256_sp(
               .CLK              (clk           ),
               .CEB              (en_sp[k]      ),
               .WEB              (wen_sp[k]     ),
               .A                (A_sp[k]       ),
               .D                (D_sp[k]       ),
               .Q                (Q_sp[k]       )
            );
        end
    endgenerate

    generate
        for(l=0; l<36; l=l+1) begin:inst3
            MEM_128X256 u_mem128x256(
               .CLK              (clk           ),
               .CEB              (en[l]         ),
               .WEB              (wen[l]        ),
               .A                (A[l]          ),
               .D                (D[l]          ),
               .Q                (Q[l]          )
            );
        end
    endgenerate

endmodule

module MEM_32X256_SP(
    input                     CLK         ,
    input                     CEB         ,
    input                     WEB         ,
    input        [   4:0]     A           ,
    input        [ 255:0]     D           ,
    output       [ 255:0]     Q
);

    TS1N28HPCPHVTB32X128M4SWBASO u0_mem32x128_sp(
       .CLK              (CLK               ),
       .CEB              (CEB               ), // active low
       .WEB              (WEB               ), // active low
       .A                (A                 ), // 5bit
       .D                (D[127:0]          ), // 128bit
       .BWEB             (128'b0            ), // active low, bit write enable
       .CEBM             (1'b1              ), // BIST Mode
       .WEBM             (1'b1              ), // BIST Mode
       .AM               (5'b0              ), // BIST Mode
       .DM               (128'b0            ), // BIST Mode
       .BWEBM            (128'b0            ), // BIST Mode
       .BIST             (1'b0              ), // Mode Control
       .AWT              (1'b0              ), // Mode Control
       .SLP              (1'b0              ),
       .SD               (1'b0              ),
       .Q                (Q[127:0]          )
    );

    TS1N28HPCPHVTB32X128M4SWBASO u1_mem32x128_sp(
       .CLK              (CLK               ),
       .CEB              (CEB               ), // active low
       .WEB              (WEB               ), // active low
       .A                (A                 ), // 5bit
       .D                (D[255:128]        ), // 128bit
       .BWEB             (128'b0            ), // active low, bit write enable
       .CEBM             (1'b1              ), // BIST Mode
       .WEBM             (1'b1              ), // BIST Mode
       .AM               (5'b0              ), // BIST Mode
       .DM               (128'b0            ), // BIST Mode
       .BWEBM            (128'b0            ), // BIST Mode
       .BIST             (1'b0              ), // Mode Control
       .AWT              (1'b0              ), // Mode Control
       .SLP              (1'b0              ),
       .SD               (1'b0              ),
       .Q                (Q[255:128]        )
    );

endmodule

module MEM_32X256_DP(
    input                     CLK          ,
    input        [   4:0]     AA           ,
    input        [ 255:0]     DA           ,
    input        [ 255:0]     BWEBA        ,
    input                     WEBA         ,
    input                     CEBA         ,
    input        [   4:0]     AB           ,
    input        [ 255:0]     DB           ,
    input        [ 255:0]     BWEBB        ,
    input                     WEBB         ,
    input                     CEBB         ,
    output       [ 255:0]     QA           ,
    output       [ 255:0]     QB
);

    TSDN28HPCPUHDB32X128M4MWA u0_mem32x128_dp(
       .CLK              (CLK               ),
       .AA               (AA                ), // 5bit, address on port A
       .DA               (DA[127:0]         ), // 128bit, din on port A
       .BWEBA            (BWEBA[127:0]      ), // active low, bit write enable on port A
       .WEBA             (WEBA              ), // 0:write, 1:read
       .CEBA             (CEBA              ), // active low

       .AB               (AB                ), // 5bit, address on port B
       .DB               (DB[127:0]         ), // 128bit, din on port B
       .BWEBB            (BWEBB[127:0]      ), // active low, bit write enable on port B
       .WEBB             (WEBB              ), // 0:write, 1:read
       .CEBB             (CEBB              ), // active low

       .AWT              (1'b0              ), // Mode Control
       .RTSEL            (2'b0              ),
       .WTSEL            (2'b0              ),
       .PTSEL            (2'b0              ),
       .QA               (QA[127:0]         ), // dout on port A
       .QB               (QB[127:0]         )  // dout on port B
    );

    TSDN28HPCPUHDB32X128M4MWA u1_mem32x128_dp(
       .CLK              (CLK               ),
       .AA               (AA                ), // 5bit, address on port A
       .DA               (DA[255:128]       ), // 128bit, din on port A
       .BWEBA            (BWEBA[255:128]    ), // active low, bit write enable on port A
       .WEBA             (WEBA              ), // 0:write, 1:read
       .CEBA             (CEBA              ), // active low

       .AB               (AB                ), // 5bit, address on port B
       .DB               (DB[255:128]       ), // 128bit, din on port B
       .BWEBB            (BWEBB[255:128]    ), // active low, bit write enable on port B
       .WEBB             (WEBB              ), // 0:write, 1:read
       .CEBB             (CEBB              ), // active low

       .AWT              (1'b0              ), // Mode Control
       .RTSEL            (2'b0              ),
       .WTSEL            (2'b0              ),
       .PTSEL            (2'b0              ),
       .QA               (QA[255:128]       ), // dout on port A
       .QB               (QB[255:128]       )  // dout on port B
    );

endmodule

module MEM_32X256_2PRF(
    input                     CLK         ,
    input        [   4:0]     AA          ,
    input        [ 255:0]     D           ,
    input        [ 255:0]     BWEB        ,
    input                     WEB         ,
    input        [   4:0]     AB          ,
    input                     REB         ,
    output       [ 255:0]     Q
);

    TS6N28HPCPHVTA32X128M2FWBSO u0_mem32x128_2prf(
       .CLKW             (CLK               ),
       .AA               (AA                ), // 5bit, write address
       .D                (D[127:0]          ), // 128bit, data in
       .BWEB             (BWEB[127:0]       ), // active low, bit write enable
       .WEB              (WEB               ), // active low, write enable
       .CLKR             (CLK               ),
       .AB               (AB                ), // 5bit, read address
       .REB              (REB               ), // active low, read enable
       .AMA              (5'b0              ), // BIST Mode
       .DM               (128'b0            ), // BIST Mode
       .BWEBM            (128'b0            ), // BIST Mode
       .WEBM             (1'b1              ), // BIST Mode
       .AMB              (5'b0              ), // BIST Mode
       .REBM             (1'b1              ), // BIST Mode
       .BIST             (1'b0              ), // Mode Control
       .SLP              (1'b0              ),
       .SD               (1'b0              ),
       .Q                (Q[127:0]          )
    );

    TS6N28HPCPHVTA32X128M2FWBSO u1_mem32x128_2prf(
       .CLKW             (CLK               ),
       .AA               (AA                ), // 5bit, write address
       .D                (D[255:128]        ), // 128bit, data in
       .BWEB             (BWEB[255:128]     ), // active low, bit write enable
       .WEB              (WEB               ), // active low, write enable
       .CLKR             (CLK               ),
       .AB               (AB                ), // 5bit, read address
       .REB              (REB               ), // active low, read enable
       .AMA              (5'b0              ), // BIST Mode
       .DM               (128'b0            ), // BIST Mode
       .BWEBM            (128'b0            ), // BIST Mode
       .WEBM             (1'b1              ), // BIST Mode
       .AMB              (5'b0              ), // BIST Mode
       .REBM             (1'b1              ), // BIST Mode
       .BIST             (1'b0              ), // Mode Control
       .SLP              (1'b0              ),
       .SD               (1'b0              ),
       .Q                (Q[255:128]        )
    );

endmodule
