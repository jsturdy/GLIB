Version 4
SymbolType BLOCK
TEXT 32 32 LEFT 4 v6_emac_v2_3_basex
RECTANGLE Normal 32 32 544 1760
LINE Normal 0 80 32 80
PIN 0 80 LEFT 36
PINATTR PinName glbl_rstn
PINATTR Polarity IN
LINE Normal 0 112 32 112
PIN 0 112 LEFT 36
PINATTR PinName rx_axi_rstn
PINATTR Polarity IN
LINE Normal 0 144 32 144
PIN 0 144 LEFT 36
PINATTR PinName tx_axi_rstn
PINATTR Polarity IN
LINE Normal 576 176 544 176
PIN 576 176 RIGHT 36
PINATTR PinName tx_axi_clk_out
PINATTR Polarity OUT
LINE Normal 0 176 32 176
PIN 0 176 LEFT 36
PINATTR PinName gtx_clk
PINATTR Polarity IN
LINE Normal 0 272 32 272
PIN 0 272 LEFT 36
PINATTR PinName rx_axi_clk
PINATTR Polarity IN
LINE Normal 0 304 32 304
PIN 0 304 LEFT 36
PINATTR PinName rx_reset_out
PINATTR Polarity OUT
LINE Wide 0 336 32 336
PIN 0 336 LEFT 36
PINATTR PinName rx_axis_mac_tdata[7:0]
PINATTR Polarity OUT
LINE Normal 0 400 32 400
PIN 0 400 LEFT 36
PINATTR PinName rx_axis_mac_tvalid
PINATTR Polarity OUT
LINE Normal 0 432 32 432
PIN 0 432 LEFT 36
PINATTR PinName rx_axis_mac_tlast
PINATTR Polarity OUT
LINE Normal 0 464 32 464
PIN 0 464 LEFT 36
PINATTR PinName rx_axis_mac_tuser
PINATTR Polarity OUT
LINE Wide 0 528 32 528
PIN 0 528 LEFT 36
PINATTR PinName rx_statistics_vector[27:0]
PINATTR Polarity OUT
LINE Normal 0 560 32 560
PIN 0 560 LEFT 36
PINATTR PinName rx_statistics_valid
PINATTR Polarity OUT
LINE Normal 0 656 32 656
PIN 0 656 LEFT 36
PINATTR PinName tx_axi_clk
PINATTR Polarity IN
LINE Normal 0 688 32 688
PIN 0 688 LEFT 36
PINATTR PinName tx_reset_out
PINATTR Polarity OUT
LINE Wide 0 720 32 720
PIN 0 720 LEFT 36
PINATTR PinName tx_axis_mac_tdata[7:0]
PINATTR Polarity IN
LINE Normal 0 784 32 784
PIN 0 784 LEFT 36
PINATTR PinName tx_axis_mac_tvalid
PINATTR Polarity IN
LINE Normal 0 816 32 816
PIN 0 816 LEFT 36
PINATTR PinName tx_axis_mac_tlast
PINATTR Polarity IN
LINE Normal 0 848 32 848
PIN 0 848 LEFT 36
PINATTR PinName tx_axis_mac_tuser
PINATTR Polarity IN
LINE Normal 0 880 32 880
PIN 0 880 LEFT 36
PINATTR PinName tx_axis_mac_tready
PINATTR Polarity OUT
LINE Wide 0 976 32 976
PIN 0 976 LEFT 36
PINATTR PinName tx_ifg_delay[7:0]
PINATTR Polarity IN
LINE Wide 0 1008 32 1008
PIN 0 1008 LEFT 36
PINATTR PinName tx_statistics_vector[31:0]
PINATTR Polarity OUT
LINE Normal 0 1040 32 1040
PIN 0 1040 LEFT 36
PINATTR PinName tx_statistics_valid
PINATTR Polarity OUT
LINE Normal 0 1104 32 1104
PIN 0 1104 LEFT 36
PINATTR PinName pause_req
PINATTR Polarity IN
LINE Wide 0 1136 32 1136
PIN 0 1136 LEFT 36
PINATTR PinName pause_val[15:0]
PINATTR Polarity IN
LINE Normal 0 1296 32 1296
PIN 0 1296 LEFT 36
PINATTR PinName speed_is_10_100
PINATTR Polarity OUT
LINE Wide 576 1040 544 1040
PIN 576 1040 RIGHT 36
PINATTR PinName gmii_txd[7:0]
PINATTR Polarity OUT
LINE Wide 576 1200 544 1200
PIN 576 1200 RIGHT 36
PINATTR PinName gmii_rxd[7:0]
PINATTR Polarity IN
LINE Normal 576 1232 544 1232
PIN 576 1232 RIGHT 36
PINATTR PinName gmii_rx_dv
PINATTR Polarity IN
LINE Normal 0 1392 32 1392
PIN 0 1392 LEFT 36
PINATTR PinName dcm_locked
PINATTR Polarity IN
LINE Normal 576 1360 544 1360
PIN 576 1360 RIGHT 36
PINATTR PinName an_interrupt
PINATTR Polarity OUT
LINE Normal 0 1424 32 1424
PIN 0 1424 LEFT 36
PINATTR PinName signal_detect
PINATTR Polarity IN
LINE Wide 0 1456 32 1456
PIN 0 1456 LEFT 36
PINATTR PinName phyad[4:0]
PINATTR Polarity IN
LINE Normal 576 1392 544 1392
PIN 576 1392 RIGHT 36
PINATTR PinName encommaalign
PINATTR Polarity OUT
LINE Normal 576 1424 544 1424
PIN 576 1424 RIGHT 36
PINATTR PinName loopbackmsb
PINATTR Polarity OUT
LINE Normal 576 1456 544 1456
PIN 576 1456 RIGHT 36
PINATTR PinName mgt_rx_reset
PINATTR Polarity OUT
LINE Normal 576 1488 544 1488
PIN 576 1488 RIGHT 36
PINATTR PinName mgt_tx_reset
PINATTR Polarity OUT
LINE Normal 576 1520 544 1520
PIN 576 1520 RIGHT 36
PINATTR PinName powerdown
PINATTR Polarity OUT
LINE Normal 576 1552 544 1552
PIN 576 1552 RIGHT 36
PINATTR PinName sync_acq_status
PINATTR Polarity OUT
LINE Wide 0 1488 32 1488
PIN 0 1488 LEFT 36
PINATTR PinName rxclkcorcnt[2:0]
PINATTR Polarity IN
LINE Wide 0 1520 32 1520
PIN 0 1520 LEFT 36
PINATTR PinName rxbufstatus[1:0]
PINATTR Polarity IN
LINE Normal 0 1552 32 1552
PIN 0 1552 LEFT 36
PINATTR PinName rxchariscomma
PINATTR Polarity IN
LINE Normal 0 1584 32 1584
PIN 0 1584 LEFT 36
PINATTR PinName rxcharisk
PINATTR Polarity IN
LINE Normal 0 1616 32 1616
PIN 0 1616 LEFT 36
PINATTR PinName rxdisperr
PINATTR Polarity IN
LINE Normal 0 1648 32 1648
PIN 0 1648 LEFT 36
PINATTR PinName rxnotintable
PINATTR Polarity IN
LINE Normal 0 1680 32 1680
PIN 0 1680 LEFT 36
PINATTR PinName rxrundisp
PINATTR Polarity IN
LINE Normal 0 1712 32 1712
PIN 0 1712 LEFT 36
PINATTR PinName txbuferr
PINATTR Polarity IN
LINE Normal 576 1584 544 1584
PIN 576 1584 RIGHT 36
PINATTR PinName txchardispmode
PINATTR Polarity OUT
LINE Normal 576 1616 544 1616
PIN 576 1616 RIGHT 36
PINATTR PinName txchardispval
PINATTR Polarity OUT
LINE Normal 576 1648 544 1648
PIN 576 1648 RIGHT 36
PINATTR PinName txcharisk
PINATTR Polarity OUT
