library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--! specific packages
library unisim;
use unisim.vcomponents.all;
--! system packages
use work.ipbus.all;
use work.system_package.all;
use work.wb_package.all;
use work.sram_package.all;
use work.flash_package.all;
--! user packages
use work.user_package.all;
use work.user_ipaddr_package.all;


entity system_core is
port
(
	clk_125_p            	: in		std_logic;										
	clk_125_n            	: in		std_logic;										
	--====================--
	-- AMC 
	--====================--
	amc_port_tx_p				: out		std_logic_vector(0 to 1);
	amc_port_tx_n				: out		std_logic_vector(0 to 1);
	amc_port_rx_p				: in		std_logic_vector(0 to 1);
	amc_port_rx_n				: in		std_logic_vector(0 to 1);
	--====================--
	-- GBE 
	--====================--
	eth_mgt_refclk_p			: in		std_logic;
	eth_mgt_refclk_n			: in		std_logic;
	
	gbe_tx_p						: out		std_logic;
	gbe_tx_n						: out		std_logic;
	gbe_rx_p						: in		std_logic;
	gbe_rx_n						: in		std_logic;
	gbe_reset_n					: out		std_logic;	
	gbe_int_n					: in		std_logic;	
	gbe_scl						: inout	std_logic;
	gbe_sda						: inout	std_logic;
	--====================--
	-- FMC2 RESERVED MGT 
	--====================--
	fmc2_tx_p					: out		std_logic;
	fmc2_tx_n					: out		std_logic;
	fmc2_rx_p					: in		std_logic;
	fmc2_rx_n					: in		std_logic;
	--====================--
	-- GLOBAL CLOCKS
	--====================--
	pri_clk_p    	      	: in		std_logic;										
	pri_clk_n    	      	: in		std_logic;										
	sec_clk_p    	      	: in		std_logic;										
	sec_clk_n    	      	: in		std_logic;										
	cdce_clkout4_p	   		: in		std_logic;
	cdce_clkout4_n				: in		std_logic;		
	--====================--
	-- CLK CIRCUITRY
	--====================--
	xpoint_4x4_s40	   		: out		std_logic;
	xpoint_4x4_s41	   	   : out		std_logic;
	xpoint_4x4_s30	   	   : out		std_logic;
	xpoint_4x4_s31	   	   : out		std_logic;
	xpoint_4x4_s20	   	   : out		std_logic;
	xpoint_4x4_s21	   	   : out		std_logic;
	xpoint_4x4_s10	   	   : out		std_logic;
	xpoint_4x4_s11	   	   : out		std_logic;
	------------------------
	xpoint_2x2_s0	 			: out		std_logic;
	xpoint_2x2_s1	 			: out		std_logic;
	------------------------
	ics874003_fsel	 		   : out		std_logic;
	ics874003_mr	 			: out		std_logic;
	ics874003_oe	 			: out		std_logic;
	------------------------
	tclka_dr_en				   : out		std_logic;
	tclkb_dr_en				   : out		std_logic;
	------------------------
	cdce_pwr_down				: out		std_logic;	
	cdce_ref_sel				: out		std_logic;	
	cdce_sync					: out		std_logic;	
	cdce_spi_clk				: out		std_logic;	
	cdce_spi_le					: out		std_logic;	
	cdce_spi_mosi				: out		std_logic;	
	cdce_pll_lock				: in		std_logic;	
	cdce_spi_miso				: in		std_logic;	
	--====================--
	-- VARIOUS
	--====================--
	fpga_rs0	 		  			:  out	std_logic;				
	fpga_rs1  					:  out	std_logic;				
	fpga_scl  					:  inout	std_logic;				
	fpga_sda						:  inout	std_logic;				
	fpga_clkout	  				:  out	std_logic;				
	fpga_reset_b	 			:  in		std_logic;				
	fpga_power_on_reset_b	:  in		std_logic;				
	------------------------
	v6_cpld						:  inout	std_logic_vector(0 to 5);
	------------------------
	sfp_mod_abs					: in		std_logic_vector(1 to 4);		
	sfp_rxlos					: in		std_logic_vector(1 to 4);		
	sfp_txfault					: in		std_logic_vector(1 to 4);	
	--====================--
	-- fmc
	--====================--
	fmc1_present_l				: in		std_logic;
	fmc2_present_l				: in		std_logic;
	------------------------
	--====================--
	-- SRAM
	--====================--
	sram1_addr					: out		std_logic_vector(24 downto 0);
	sram1_data					: inout	std_logic_vector(35 downto 0);
	sram2_addr					: out		std_logic_vector(24 downto 0);
	sram2_data					: inout	std_logic_vector(35 downto 0);
	------------------------
	sram_adv_ld_l				: out		std_logic_vector(1 to 2);	
	sram_ce1_l					: out		std_logic_vector(1 to 2);				
	sram_cen_l					: out		std_logic_vector(1 to 2);		
	sram_clk						: out		std_logic_vector(1 to 2);
	sram_mode					: out		std_logic_vector(1 to 2);
	sram_oe_l	   			: out		std_logic_vector(1 to 2);
	sram_we_l					: out		std_logic_vector(1 to 2);
	------------------------
	sram2_ce2					: out		std_logic;	
	--====================--
	-- user interface
	--====================--
	user_sram_control_i		: in 		userSramControlR_array(1 to 2);
	user_sram_addr_i			: in 		array_2x21bit;
	user_sram_wdata_i			: in 		array_2x36bit;
	user_sram_rdata_o			: out 	array_2x36bit;
	------------------------
	user_cdce_sel_i			: in		std_logic;
	user_cdce_sync_i			: in		std_logic;
	------------------------
	user_mac_syncacqstatus_o: out		std_logic_vector(0 to 3);
	user_mac_serdes_locked_o: out		std_logic_vector(0 to 3);
	------------------------
	user_wb_miso_i				: in 		wb_miso_bus_array(0 to number_of_wb_slaves-1);
	user_wb_mosi_o				: out 	wb_mosi_bus_array(0 to number_of_wb_slaves-1);
	------------------------
	user_ipb_clk_o				: out		std_logic;
	user_ipb_miso_i			: in 		ipb_rbus_array(0 to number_of_ipb_slaves-1);
	user_ipb_mosi_o			: out 	ipb_wbus_array(0 to number_of_ipb_slaves-1);
	------------------------
	user_reset_o				: out		std_logic;
	user_cdce_clkout4			: out		std_logic;
	user_clk_125_o				: out		std_logic;
	user_pri_clk_o				: out		std_logic;
	user_sec_clk_o				: out		std_logic
);                    	
end system_core;
							
architecture system_core_arch of system_core is                    	


--##########################################--
--##############     signal   ##############--
--############## declarations ##############--                              
--##########################################--

attribute keep: boolean;

signal reset, rst_mac, rst_gtx			: std_logic;

--signal eth_clk								: std_logic;
signal clk_125     							: std_logic;
signal eth_mgt_refclk						: std_logic;
signal gbe_mgt_resetdone 					: std_logic;
signal pri_clk, sec_clk   					: std_logic;

---------------------------------------

signal clk_125_from_glib_pll				: std_logic;
signal clk_62_5_A_from_glib_pll			: std_logic;
signal clk_62_5_B_from_glib_pll			: std_logic;
signal clk_62_5_C_from_glib_pll			: std_logic;
signal clk_inv_62_5_from_glib_pll		: std_logic;
signal clk_200_from_glib_pll				: std_logic;
signal locked_from_glib_pll				: std_logic;

signal ipb_clk_sram1							: std_logic;
signal ipb_clk_sram2							: std_logic;

signal ipb_clk									: std_logic;
signal ipb_rst									: std_logic_vector(3 downto 0);
signal ipb_inv_clk							: std_logic;
signal ipb_to_fabric							: ipb_wbus;
signal ipb_from_fabric						: ipb_rbus;
signal ipb_from_masters						: ipb_wbus_array(3 downto 0);
signal ipb_to_masters						: ipb_rbus_array(3 downto 0);
constant number_of_slaves					: positive:= 8; --> sys_regs, sram1, sram2, flash, user_ipb, user_wb, drp, icap

signal ipb_to_slaves							: ipb_wbus_array(number_of_slaves-1 downto 0);
signal ipb_from_slaves						: ipb_rbus_array(number_of_slaves-1 downto 0);

signal mac_clk125_o							: std_logic_vector(0 to 3);
signal mac_clk125								: std_logic_vector(0 to 3);
signal mac_rxd									: array_4x8bit;
signal mac_rxclko								: std_logic_vector(0 to 3);
signal mac_rxdvld								: std_logic_vector(0 to 3);
signal mac_rxgoodframe						: std_logic_vector(0 to 3);
signal mac_rxbadframe						: std_logic_vector(0 to 3);
signal mac_txd									: array_4x8bit;
signal mac_txdvld								: std_logic_vector(0 to 3);
signal mac_txack								: std_logic_vector(0 to 3);
signal mac_syncacqstatus					: std_logic_vector(0 to 3);
signal mac_serdes_locked					: std_logic_vector(0 to 3);

constant amc_p0								: integer:= 0 ;
constant amc_p1								: integer:= 1 ;
constant phy									: integer:= 2 ;
constant fmc2									: integer:= 3 ;

attribute keep of mac_clk125				: signal is true;
attribute keep of ipb_clk					: signal is true;
---------------------------------------
signal sram_w									: wSramR_array(1 to 2);
attribute keep of sram_w					: signal is true;
signal sram_r									: rSramR_array(1 to 2);
attribute keep of sram_r					: signal is true;

signal flash_w									: wFlashR;
attribute keep of flash_w					: signal is true;
signal flash_r									: rFlashR;
attribute keep of flash_r					: signal is true;  
---------------------------------------
signal regs_to_ipbus			            : array_32x32bit;			
signal regs_from_ipbus		            : array_32x32bit;			

signal reg_ctrl								: std_logic_vector(31 downto 0); -- 4
signal reg_ctrl_2								: std_logic_vector(31 downto 0); -- 5
signal reg_status								: std_logic_vector(31 downto 0);	-- 7
signal reg_status_2							: std_logic_vector(31 downto 0); -- 8
signal reg_ctrl_sram							: std_logic_vector(31 downto 0); -- 6
signal reg_status_sram						: std_logic_vector(31 downto 0);	-- 9
signal reg_spi_command						: std_logic_vector(31 downto 0); --10
signal reg_spi_txdata						: std_logic_vector(31 downto 0); --11
signal reg_spi_rxdata						: std_logic_vector(31 downto 0); --12
signal reg_i2c_settings						: std_logic_vector(31 downto 0);	--13
signal reg_i2c_command						: std_logic_vector(31 downto 0); --14
signal reg_i2c_reply							: std_logic_vector(31 downto 0); --15

signal mac_addr								: std_logic_vector(47 downto 0);
signal ip_addr									: std_logic_vector(31 downto 0);

signal cdce_sync_done						: std_logic;
signal cdce_sync_busy						: std_logic;
signal cdce_sync_clk							: std_logic;
signal cdce_sync_cmd							: std_logic;

signal cdce_phase_mon_exp_signature		: std_logic_vector(143 downto 0);
signal cdce_phase_mon_acq_signature		: std_logic_vector(143 downto 0);
signal cdce_phase_mon_signature_mask	: std_logic_vector(143 downto 0);
signal cdce_phase_mon_signature_match	: std_logic;
signal cdce_phase_mon_signature_mismatch:std_logic;
signal cdce_phase_mon_signature_valid	:std_logic;
signal cdce_phase_mon_error_count 		: std_logic_vector( 11 downto 0);
signal cdce_phase_mon_retries				: std_logic_vector(  3 downto 0);
signal cdce_phase_mon_resync				: std_logic;

signal cdce_clkout4							: std_logic;

signal cdce_forbid_retry					: std_logic;
	
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--
begin -- architecture
--@@@@@@@@@@@@@@@@@@@@@@--                              
--@@@@@@@@@@@@@@@@@@@@@@--
--@@@@@@@@@@@@@@@@@@@@@@--





--=============================--
	gbe_fclk_ibufgds: ibufgds
--=============================--
  	generic map (capacitance => "dont_care", diff_term => true, ibuf_delay_value => "0", ibuf_low_pwr => true, iostandard => "lvds_25")	
   port map 	(i => CLK_125_P, ib => CLK_125_N, o => clk_125);	
--=============================--


--=============================--
	gbe_refclk_ibufds_gtxe1:   ibufds_gtxe1 
--=============================--
	port map ( i => ETH_MGT_REFCLK_P, ib => ETH_MGT_REFCLK_N, ceb => '0', o => eth_mgt_refclk);
--=============================--


--=============================--
--	eth_clk_bufg:   bufg 
--=============================--
--	port map ( i => eth_mgt_refclk, o => eth_clk);
--=============================--


--=============================--
	pri_clk_ibufgds: ibufgds
--=============================--
  	generic map (capacitance => "dont_care", diff_term => true, ibuf_delay_value => "0", ibuf_low_pwr => true, iostandard => "lvds_25")	
   port map 	(i => PRI_CLK_P, ib => PRI_CLK_N, o => pri_clk);	
--=============================--


--=============================--
	sec_clk_ibufgds: ibufgds
--=============================--
  	generic map (capacitance => "dont_care", diff_term => true, ibuf_delay_value => "0", ibuf_low_pwr => true, iostandard => "lvds_25")	
   port map 	(i => SEC_CLK_P, ib => SEC_CLK_N,  o => sec_clk);	
--=============================--






--=============================--
--#############################--
--#############################--
--#############################--
--#############################--
--#############################--
--#############################--
--=============================--
rst: entity work.reset_ctrl
--=============================--
port map
(
	clk					   	=> ipb_clk,
	ext_reset1_b				=> locked_from_glib_pll,
	ext_reset2_b				=> FPGA_POWER_ON_RESET_B,
	rst_mac_o					=> rst_mac,
	rst_gtx_o					=> rst_gtx,
	rst_fabric_o     			=> reset
);
--=============================--

	gbe_reset_n 				<= not reset;

--=============================--
glib_pll:entity work.mmcm_no_ibufg
--=============================--
port map
(
  RESET 		    				=> '0',
  CLK_IN1         			=> clk_125, 		  				-- no ibufg
  CLK_OUT1       				=> clk_125_from_glib_pll,
  CLK_OUT2        			=> clk_62_5_A_from_glib_pll, 
  CLK_OUT3         			=> clk_62_5_B_from_glib_pll,	-- no bufg
  CLK_OUT4         			=> clk_62_5_C_from_glib_pll,	-- no bufg
  CLK_OUT5      				=> clk_inv_62_5_from_glib_pll,       
  CLK_OUT6      				=> clk_200_from_glib_pll,
  LOCKED          			=> locked_from_glib_pll  
);
--=============================--

	ipb_clk						<= clk_62_5_A_from_glib_pll;
	ipb_clk_sram1				<= clk_62_5_B_from_glib_pll;
	ipb_clk_sram2				<= clk_62_5_C_from_glib_pll;
	ipb_inv_clk					<= clk_inv_62_5_from_glib_pll;
	
	
	mac_clk125(amc_p0) 		<= clk_125; --clk_125_from_glib_pll;			
	mac_clk125(amc_p1) 		<= clk_125; --clk_125_from_glib_pll;			
	mac_clk125(phy) 			<= clk_125; --clk_125_from_glib_pll;			
	mac_clk125(fmc2) 			<= clk_125; --clk_125_from_glib_pll;			



	
	
	
	
--	mac_addr0 <= glib_mac_addr(47 downto 8) & glib_id(6 downto 0) & '0';
--	mac_addr1 <= glib_mac_addr(47 downto 8) & glib_id(6 downto 0) & '1';

	mac_addr <= glib_mac_addr(47 downto 8) & glib_id;
	ipaddr_table: entity work.ipaddr_lut port map ( address	=> glib_id(3 downto 0), data => ip_addr);



eth_A: if crate_operation=true generate

	--=============================--
	amc_p0_eth: entity work.eth_v6_basex 
	--=============================--
	port map
	(
		clk125_i 					=> mac_clk125(amc_p0),
		clk125_o 					=> open,	--mac_clk125_o(amc_p0),
		rst_mac						=> rst_mac, 
		rst_gtx						=> rst_gtx, 
		----------------------
		basex_clk 					=> eth_mgt_refclk, 			
		basex_txp 					=> AMC_PORT_TX_P(0),				
		basex_txn 					=> AMC_PORT_TX_N(0),				
		basex_rxp 					=> AMC_PORT_RX_P(0),				
		basex_rxn 					=> AMC_PORT_RX_N(0),				
		----------------------
		sync_acq 					=> mac_syncacqstatus(amc_p0),	
		locked 						=> mac_serdes_locked(amc_p0),			
		----------------------
		txd 							=> mac_txd(amc_p0),
		txdvld 						=> mac_txdvld(amc_p0),
		txack 						=> mac_txack(amc_p0),
		----------------------
		rxd 							=> mac_rxd(amc_p0),
		rxclko						=> mac_rxclko(amc_p0),
		rxdvld 						=> mac_rxdvld(amc_p0),
		rxgoodframe 				=> mac_rxgoodframe(amc_p0),
		rxbadframe 					=> mac_rxbadframe(amc_p0)
	);
	--=============================--

	ipb_rst(amc_p0)				<= '1' 	when rst_mac = '1'						else
											'1'	when mac_syncacqstatus(amc_p0)='0'	else
											'1'	when mac_serdes_locked(amc_p0)='0'	else		
											'0';
	
	--=============================--
	amc_p0_ipb_ctrl: entity work.ipbus_ctrl 
	--=============================--
	port map
	(
		ipb_clk 						=> ipb_clk,			
		rst 							=> ipb_rst(amc_p0),
		-----------------------
		mac_txclk 					=> mac_clk125(amc_p0),		
		mac_txd 						=> mac_txd(amc_p0),
		mac_txdvld 					=> mac_txdvld(amc_p0),
		mac_txack 					=> mac_txack(amc_p0),
		---------------
		mac_rxclk 					=> mac_clk125(amc_p0), 			--mac_rxclko(amc_p0),
		mac_rxd 						=> mac_rxd(amc_p0),
		mac_rxdvld 					=> mac_rxdvld(amc_p0),
		mac_rxgoodframe			=> mac_rxgoodframe(amc_p0),
		mac_rxbadframe 			=> mac_rxbadframe(amc_p0),
		---------------
		mac_addr 					=> mac_addr, 
		ip_addr 						=> ip_addr,  
		---------------
		ipb_out 						=> ipb_from_masters(amc_p0),
		ipb_in 						=> ipb_to_masters(amc_p0)
	);
	--=============================--


	--=============================--
	amc_p1_eth: entity work.eth_v6_basex 
	--=============================--
	port map
	(
		clk125_i 					=> mac_clk125(amc_p1),
		clk125_o 					=> open,								--mac_clk125_o(amc_p1),
		rst_mac						=> rst_mac, 
		rst_gtx						=> rst_gtx, 
		----------------------
		basex_clk 					=> eth_mgt_refclk, 			
		basex_txp 					=> AMC_PORT_TX_P(1),				
		basex_txn 					=> AMC_PORT_TX_N(1),				
		basex_rxp 					=> AMC_PORT_RX_P(1),				
		basex_rxn 					=> AMC_PORT_RX_N(1),				
		----------------------
		sync_acq 					=> mac_syncacqstatus(amc_p1),	
		locked 						=> mac_serdes_locked(amc_p1),			
		----------------------
		txd 							=> mac_txd(amc_p1),
		txdvld 						=> mac_txdvld(amc_p1),
		txack 						=> mac_txack(amc_p1),
		----------------------
		rxd 							=> mac_rxd(amc_p1),
		rxclko						=> open, 							--mac_rxclko(amc_p1),
		rxdvld 						=> mac_rxdvld(amc_p1),
		rxgoodframe 				=> mac_rxgoodframe(amc_p1),
		rxbadframe 					=> mac_rxbadframe(amc_p1)
	);
	--=============================--

	ipb_rst(amc_p1)				<= '1' 	when rst_mac = '1' 						else
											'1'	when mac_syncacqstatus(amc_p1)='0'	else
											'1'	when mac_serdes_locked(amc_p1)='0'	else		
											'0';

	--=============================--
	amc_p1_ipb_ctrl: entity work.ipbus_ctrl 
	--=============================--
	port map
	(
		ipb_clk 						=> ipb_clk,			
		rst 							=> ipb_rst(amc_p1),
		-----------------------
		mac_txclk 					=> mac_clk125(amc_p1),		
		mac_txd 						=> mac_txd(amc_p1),
		mac_txdvld 					=> mac_txdvld(amc_p1),
		mac_txack 					=> mac_txack(amc_p1),
		---------------
		mac_rxclk 					=> mac_clk125(amc_p1), 			--mac_rxclko(amc_p1),
		mac_rxd 						=> mac_rxd(amc_p1),
		mac_rxdvld 					=> mac_rxdvld(amc_p1),
		mac_rxgoodframe			=> mac_rxgoodframe(amc_p1),
		mac_rxbadframe 			=> mac_rxbadframe(amc_p1),
		---------------
		mac_addr 					=> mac_addr,
		ip_addr 						=> ip_addr,
		---------------
		ipb_out 						=> ipb_from_masters(amc_p1),
		ipb_in 						=> ipb_to_masters(amc_p1)
	);
	--=============================--

	ipb_from_masters(phy).ipb_strobe 	<= '0';
	ipb_from_masters(fmc2).ipb_strobe 	<= '0';

end generate;

eth_B: if crate_operation=false generate

	--=============================--
	phy_eth: entity work.eth_v6_sgmii 
	--=============================--
	port map
	(
		clk125_i 					=> mac_clk125(phy),
		clk125_o 					=> open,								--mac_clk125_o(phy),
		rst 							=> reset,
		------------------------
		sgmii_clk 					=> eth_mgt_refclk, 		
		sgmii_txp 					=> GBE_TX_P,					
		sgmii_txn 					=> GBE_TX_N,					
		sgmii_rxp 					=> GBE_RX_P,					
		sgmii_rxn 					=> GBE_RX_N,					
		------------------------
		sync_acq 					=> mac_syncacqstatus(phy),	
		locked 						=> mac_serdes_locked(phy),	
		------------------------
		txd 							=> mac_txd(phy),
		txdvld 						=> mac_txdvld(phy),
		txack 						=> mac_txack(phy),
		------------------------
		rxd 							=> mac_rxd(phy),
		rxclko						=> open,								--mac_rxclko(phy),
		rxdvld 						=> mac_rxdvld(phy),
		rxgoodframe 				=> mac_rxgoodframe(phy),
		rxbadframe 					=> mac_rxbadframe(phy)
	);
	----=============================--

	ipb_rst(phy)					<= '1' 	when rst_mac = '1' 					else
											'1'	when mac_syncacqstatus(phy)='0'	else
											'1'	when mac_serdes_locked(phy)='0'	else		
											'0';

	--=============================--
	phy_ipb_ctrl: entity work.ipbus_ctrl 
	--=============================--
	port map
	(
		ipb_clk 						=> ipb_clk,			
		rst 							=> ipb_rst(phy),
		-----------------------
		mac_txclk 					=> mac_clk125(phy),		
		mac_txd 						=> mac_txd(phy),
		mac_txdvld 					=> mac_txdvld(phy),
		mac_txack 					=> mac_txack(phy),
		---------------
		mac_rxclk 					=> mac_clk125(phy),		--mac_rxclko(phy),
		mac_rxd 						=> mac_rxd(phy),
		mac_rxdvld 					=> mac_rxdvld(phy),
		mac_rxgoodframe			=> mac_rxgoodframe(phy),
		mac_rxbadframe 			=> mac_rxbadframe(phy),
		---------------
		mac_addr 					=> mac_addr,
		ip_addr 						=> ip_addr,
		---------------
		ipb_out 						=> ipb_from_masters(phy),
		ipb_in 						=> ipb_to_masters(phy)
	);
	--=============================--


	--=============================--
	fmc2_eth: entity work.eth_v6_basex 
	--=============================--
	port map
	(
		clk125_i 					=> mac_clk125(fmc2),
		clk125_o 					=> open,							--mac_clk125_o(fmc2),
		rst_mac						=> rst_mac, 
		rst_gtx						=> rst_gtx, 
		----------------------
		basex_clk 					=> eth_mgt_refclk, 
		basex_txp 					=> FMC2_TX_P,				
		basex_txn 					=> FMC2_TX_N,				
		basex_rxp 					=> FMC2_RX_P,				
		basex_rxn 					=> FMC2_RX_N,				
		----------------------
		sync_acq 					=> mac_syncacqstatus(fmc2),	
		locked 						=> mac_serdes_locked(fmc2),			
		----------------------
		txd 							=> mac_txd(fmc2),
		txdvld 						=> mac_txdvld(fmc2),
		txack 						=> mac_txack(fmc2),
		----------------------
		rxd 							=> mac_rxd(fmc2),
		rxclko						=> open,							--mac_rxclko(fmc2),
		rxdvld 						=> mac_rxdvld(fmc2),
		rxgoodframe 				=> mac_rxgoodframe(fmc2),
		rxbadframe 					=> mac_rxbadframe(fmc2)
	);
	--=============================--

	--	fmc2_rate_sel				<= '0';	--> has to be done inside the user logic
	--	fmc2_tx_disable			<= '0';	--> has to be done inside the user logic

	ipb_rst(fmc2)					<= '1' 	when rst_mac = '1' 					else
											'1'	when mac_syncacqstatus(fmc2)='0'	else
											'1'	when mac_serdes_locked(fmc2)='0'	else		
											'0';

	--=============================--
	fmc2_ipb_ctrl: entity work.ipbus_ctrl 
	--=============================--
	port map
	(
		ipb_clk 						=> ipb_clk,			
		rst 							=> ipb_rst(fmc2),
		-----------------------
		mac_txclk 					=> mac_clk125(fmc2),		
		mac_txd 						=> mac_txd(fmc2),
		mac_txdvld 					=> mac_txdvld(fmc2),
		mac_txack 					=> mac_txack(fmc2),
		---------------
		mac_rxclk 					=> mac_clk125(fmc2),			--mac_rxclko(fmc2),
		mac_rxd 						=> mac_rxd(fmc2),
		mac_rxdvld 					=> mac_rxdvld(fmc2),
		mac_rxgoodframe			=> mac_rxgoodframe(fmc2),
		mac_rxbadframe 			=> mac_rxbadframe(fmc2),
		---------------
		mac_addr 					=> mac_addr,
		ip_addr 						=> ip_addr,
		---------------
		ipb_out 						=> ipb_from_masters(fmc2),
		ipb_in 						=> ipb_to_masters(fmc2)
	);
	--=============================--

	ipb_from_masters(amc_p0).ipb_strobe <= '0';
	ipb_from_masters(amc_p1).ipb_strobe <= '0';

end generate;

--=============================--
arb: entity work.ipbus_master_arb
--=============================--
port map
(
	ipb_clk						=> ipb_clk,			
	rst							=> reset,
	ipb_from_masters			=> ipb_from_masters,
	ipb_to_masters				=> ipb_to_masters,
	ipb_from_fabric			=> ipb_from_fabric,
	ipb_to_fabric				=> ipb_to_fabric
);
--=============================--


--=============================--
ipb_fabric: entity work.ipbus_fabric
--=============================--
generic map (NSLV => number_of_slaves) 
port map
(
	ipb_clk						=> ipb_clk						,
	rst							=> reset							,
	------------------
	ipb_in						=> ipb_to_fabric				,
	ipb_out						=> ipb_from_fabric			,
	------------------
	ipb_to_slaves				=> ipb_to_slaves				,
	ipb_from_slaves			=> ipb_from_slaves
);
--=============================--



--=============================--
ipb_usr_fabric: entity work.ipbus_user_fabric
--=============================--
generic map (NSLV => number_of_ipb_slaves)
port map
(
	ipb_clk					=> ipb_clk							,
	rst						=> reset								,
	------------------
	ipb_in					=> ipb_to_slaves(user_ipb)		,
	ipb_out					=> ipb_from_slaves(user_ipb) 	,
	------------------
	ipb_to_slaves			=> USER_IPB_MOSI_O				,
	ipb_from_slaves		=> USER_IPB_MISO_I
);
	USER_IPB_CLK_O			<= ipb_clk;
--=============================--
	


--=============================--
wb_bridge: entity work.ipbus_to_wb_bridge
--=============================--
port map
(
	ipb_clk					=> ipb_clk							,
	rst						=> reset								,
	ipb_in					=> ipb_to_slaves(user_wb)		,
	ipb_out					=> ipb_from_slaves(user_wb)	,
	---------------------
	wb_to_slaves			=> USER_WB_MOSI_O					,
	wb_from_slaves			=> USER_WB_MISO_I
);
--=============================--



--=============================--
ipb_sys_regs: entity work.system_regs
--=============================--
port map
(
	clk						=> ipb_clk							,
	reset						=> reset								,
	------------------
	ipbus_in					=> ipb_to_slaves(sys_regs)		,
	ipbus_out				=> ipb_from_slaves(sys_regs)	,
	------------------
	regs_o					=> regs_from_ipbus				,
	regs_i					=> regs_to_ipbus				
);
--=============================--



--=============================--
sram1_if: entity work.glib_sram_interface_wrapper
--=============================--
generic map
(		
	-- Built Int Self Test(BIST):
	bist_maxaddresswrite		=> 2*(2**20)-1, -- = 2M memory locations
	bist_initialdelay			=> 200
)					
port map
(			
	reset_i 						=> reset						 				,	
	user_select_i 				=> reg_ctrl_sram(0)						,  -- 0: ipbus, 1: user
	------------------------
	ipbus_clk_i 				=> ipb_clk_sram1					 		,			
	ipbus_i 						=> ipb_to_slaves(sram1)					,
	ipbus_o						=> ipb_from_slaves(sram1)           ,	
	ipbus_bist_i 				=> (reg_ctrl_sram(1), '0')				,
	------------------------	
	user_control_i				=> USER_SRAM_CONTROL_I(sram1)   		,	
	user_addr_i 				=> USER_SRAM_ADDR_I(sram1)				,
	user_data_i 				=> USER_SRAM_WDATA_I(sram1)			,
	user_data_o 				=> USER_SRAM_RDATA_O(sram1)			,
	user_bist_i 				=> ('0', '0')								,	-- bist start from user	
	------------------------	
	bist_seed_i 				=> SEED_CONSTANTS(1)						,
	bist_test_o.startErrInj => open										,
	bist_test_o.testDone 	=> reg_status_sram(0)					,
	bist_test_o.testResult 	=> reg_status_sram(1)					,
	bist_test_o.errCounter( 7 downto 0)	=> reg_status_sram(11 downto 4),
	bist_test_o.errCounter(20 downto 8)	=> open                 ,		
	------------------------	
	sram_i						=> sram_r(sram1)							, 
	sram_o 						=> sram_w(sram1)							
);
--=============================--	


--=============================--
sram2_if: entity work.glib_sram_interface_wrapper
--=============================--
generic map
(		
	-- Built Int Self Test(BIST):
	bist_maxaddresswrite		=> 2*(2**20)-1, -- = 2M memory locations
	bist_initialdelay			=> 200
)					
port map
(			
	reset_i 						=> reset						 				,	
	user_select_i 				=> reg_ctrl_sram(16)						,  -- 0: ipbus, 1: user
	------------------------
	ipbus_clk_i 				=> ipb_clk_sram2			 				,			
	ipbus_i 						=> ipb_to_slaves(sram2)					,
	ipbus_o						=> ipb_from_slaves(sram2)           ,	
	ipbus_bist_i 				=> (reg_ctrl_sram(17), '0')			,
	------------------------	
	user_control_i				=> USER_SRAM_CONTROL_I(sram2)   		,			
	user_addr_i 				=> USER_SRAM_ADDR_I(sram2)				,
	user_data_i 				=> USER_SRAM_WDATA_I(sram2)			,
	user_data_o 				=> USER_SRAM_RDATA_O(sram2)			,	
	user_bist_i 				=> ('0', '0')								,	-- bist start from user	
	------------------------	
	bist_seed_i 				=> SEED_CONSTANTS(2)						,
	bist_test_o.startErrInj => open										,
	bist_test_o.testDone 	=> reg_status_sram(16)					,
	bist_test_o.testResult 	=> reg_status_sram(17)					,
	bist_test_o.errCounter( 7 downto 0)	=> reg_status_sram(27 downto 20),
	bist_test_o.errCounter(20 downto 8)	=> open                 ,		
	------------------------	
	sram_i						=> sram_r(sram2)							, 
	sram_o 						=> sram_w(sram2)							
);
--=============================--	


--=============================--
flash_if: entity work.flash_interface_wrapper 
--=============================--
port map
(
	reset_i 						=> reset                            ,
	------------------------
	ipbus_clk_i 				=> ipb_clk                          ,
	ipbus_i 						=> ipb_to_slaves(flash)             ,
	ipbus_o 						=> ipb_from_slaves(flash)           ,
	------------------------
	flash_i 						=> flash_r                          ,
	flash_o 						=> flash_w
);
--=============================--


--=============================--
buffers: entity work.sram_flash_buffers
--=============================--
port map 
(
	reset_i 						=> reset                            ,
	flash_select_i				=> reg_ctrl_sram(20)                ,	-- 0: sram2, 1: flash
	------------------------
	sram1_i 						=> sram_w(sram1)                    ,
	sram1_o 						=> sram_r(sram1)                    ,
	------------------------
	sram2_i 						=> sram_w(sram2)                    ,
	sram2_o 						=> sram_r(sram2)                    ,
	------------------------
	flash_i 						=> flash_w                          ,
	flash_o 						=> flash_r                          ,	
	------------------------
	sram1_addr_o 				=> SRAM1_ADDR    							,
	sram1_data_io				=> SRAM1_DATA      						,
	sram2_addr_o 				=> SRAM2_ADDR    							,
	sram2_data_io				=> SRAM2_DATA	    						,	
	sram_clk_o 					=> SRAM_CLK           					,
	sram_ce1_b_o				=> SRAM_CE1_L      						,
	sram_cen_b_o 				=> SRAM_CEN_L      						,
	sram_oe_b_o 				=> SRAM_OE_L       						,
	sram_we_b_o 				=> SRAM_WE_L       						,
	sram_mode_o 				=> SRAM_MODE       						,
	sram_adv_ld_o 				=> SRAM_ADV_LD_L							,	
	sram2_ce2_o 				=> SRAM2_CE2	
);	
--=============================--



--=============================--
icap_if: entity work.icap_interface_wrapper 
--=============================--
port map
(
	reset_i						=> reset                            ,				
	conf_trigg_i				=> reg_ctrl_2(4)                    ,                      			 				
	fsm_conf_page_i			=> reg_ctrl_2(1 downto 0)           ,                      			 				
	------------------------	
	ipbus_clk_i					=> ipb_clk                          ,			
	ipbus_inv_clk_i			=> ipb_inv_clk            				,
	ipbus_i						=> ipb_to_slaves(icap)              ,				
	ipbus_o	   				=> ipb_from_slaves(icap)
);
--=============================--



--=============================--
i2c: entity work.i2c_master
--=============================--
port map
(
	reset							=> reset,
	clk							=> ipb_clk, 
	------------------------------
	settings						=> reg_i2c_settings(12 downto 0),
	command						=> reg_i2c_command, 				-- reg_i2c_command[31:28] clears automatically
	reply							=> reg_i2c_reply,
	------------------------------
	scl(0)						=> FPGA_SCL,
	scl(1)						=> GBE_SCL,
	sda(0)						=> FPGA_SDA,				
	sda(1)						=> GBE_SDA				
	); 			
--=============================--



--=============================--
spi: entity work.spi_master
--=============================--
port map
(
	reset_i						=> reset,  
	clk_i							=> ipb_clk,
	------------
	data_i						=> reg_spi_txdata,
	enable_i						=> reg_spi_command(31),	
	ssdelay_i					=> reg_spi_command(27 downto 18),
	hold_i						=> reg_spi_command(17 downto 15),
	msbfirst_i					=> reg_spi_command(14),
	cpha_i						=> reg_spi_command(13),
	cpol_i						=> reg_spi_command(12),
	prescaler_i					=> reg_spi_command(11 downto 0),
	data_o						=> reg_spi_rxdata,
	------------
	ss_b_o						=> CDCE_SPI_LE,
	sck_o							=> CDCE_SPI_CLK,
	mosi_o 						=> CDCE_SPI_MOSI,
	miso_i 						=> CDCE_SPI_MISO
);
--=============================--




--=============================--
cdce_synch: entity work.cdce_synchronizer
--=============================--
generic map
(	
	pwrdown_delay 				=> 1000,
	sync_delay 					=> 1000000	
)
port map
(	
--	reset_i						=> reset or (not cdce_phase_mon_resync),
	reset_i						=> reset,
	--------------------
	ipbus_ctrl_i				=> (not reg_ctrl(7)), 	-- reg[5][7]: 0 -> IPBUS, 1-> USER
	ipbus_sel_i					=> reg_ctrl(5),
	ipbus_pwrdown_i			=> reg_ctrl(4),
	ipbus_sync_i				=> reg_ctrl(6), 	-- rising edge needed
	--------------------											            						
	user_sel_i					=> USER_CDCE_SEL_I,                 
	user_pwrdown_i				=> '1',                 
	user_sync_i					=> USER_CDCE_SYNC_I,
	--------------------
	pri_clk_i					=> pri_clk,
	sec_clk_i					=> sec_clk,
	pwrdown_o					=> CDCE_PWR_DOWN,
	sync_o						=> CDCE_SYNC,
	ref_sel_o					=> CDCE_REF_SEL,	
	--------------------
	sync_cmd_o					=> cdce_sync_cmd,	
	sync_clk_o					=> cdce_sync_clk,	
	sync_busy_o					=> cdce_sync_busy,	
	sync_done_o					=> cdce_sync_done	
);
--=============================--


--=============================--
	cdce_clkout4_ibufgds: ibufgds
--=============================--
  	generic map (capacitance => "dont_care", diff_term => true, ibuf_delay_value => "0", iostandard => "lvds_25")	
   port map 	(i => cdce_clkout4_p, ib => cdce_clkout4_n, o => cdce_clkout4);	
--=============================--


----=============================--
--cdcePhaseMonitoringCtrl: entity work.cdce_phase_monitoring_ctrl
----=============================--
--port map 
--(	
--	reset_i							=> reset,
--	clk_i								=> ipb_clk,
--	sync_cmd_i						=> cdce_sync_cmd,
--	monitoring_status_dv_i		=> cdce_phase_mon_signature_valid,
--	monitoring_status_i			=> cdce_phase_mon_signature_mismatch,
--	forbid_retry_i					=> cdce_forbid_retry,
--	retries_o						=> cdce_phase_mon_retries,
--	resync_o							=> cdce_phase_mon_resync
--);
----=============================--
--
--
----=============================--
--cdcePhaseMonitoring: entity work.cdce_phase_monitoring
----=============================--
--port map
--(
--	reset_i				 		=> reset,
--	--------------------
--	clk200mhz_i 				=> clk_200_from_glib_pll,
--	--------------------
--	cdce_clkin_i 				=> cdce_sync_clk,
--	cdce_clkout_i_p			=> cdce_clkout4_p,
--	cdce_clkout_i_n			=> cdce_clkout4_n,
--	cdce_sync_busy_i 			=> cdce_sync_busy,
--	cdce_sync_done_i 			=> cdce_sync_done,
--	cdce_clkout_o 				=> cdce_clkout4,
--	--------------------
--	ipbusclk_i					=> ipb_clk,
--	--
--	exp_signature_i 			=> cdce_phase_mon_exp_signature,						
--	signature_mask_i 			=> cdce_phase_mon_signature_mask,						
--	signature_o     			=> cdce_phase_mon_acq_signature,						
--	signature_match_o 		=> cdce_phase_mon_signature_match,		
--	signature_mismatch_o		=> cdce_phase_mon_signature_mismatch,
--	signature_valid_o			=> cdce_phase_mon_signature_valid,
--	error_count_o				=> cdce_phase_mon_error_count		
--);
----=============================--



--=============================--
-- io/reg mapping
--=============================--

	USER_RESET_O						<= reset;
	USER_CLK_125_O						<= clk_125_from_glib_pll; --clk_125;
	USER_PRI_CLK_O						<= pri_clk;
	USER_SEC_CLK_O						<= sec_clk;
	USER_MAC_SYNCACQSTATUS_O		<= mac_syncacqstatus;
	USER_MAC_SERDES_LOCKED_O		<= mac_serdes_locked;
	USER_CDCE_CLKOUT4					<= cdce_clkout4;
	
	-------------------------

	reg_ctrl			  <= 	regs_from_ipbus(4)	;
								reg_ctrl_2			<= regs_from_ipbus(5)	;
	regs_to_ipbus(6) <=	reg_status											;
	regs_to_ipbus(7) <=	reg_status_2										;
								reg_ctrl_sram		<= regs_from_ipbus(8)	;
	regs_to_ipbus(9) <=	reg_status_sram									;
								reg_spi_txdata		<= regs_from_ipbus(10)	;
								reg_spi_command	<= regs_from_ipbus(11)	;
	regs_to_ipbus(12)<=	reg_spi_rxdata										;
								reg_i2c_settings	<= regs_from_ipbus(13)	;
								reg_i2c_command	<= regs_from_ipbus(14)	;
	regs_to_ipbus(15)<=	reg_i2c_reply										;

	-- cdce_phase_moninoring
	
	regs_to_ipbus(16)							<= cdce_phase_mon_acq_signature( 31 downto   0) ; 	
	regs_to_ipbus(17)							<= cdce_phase_mon_acq_signature( 63 downto  32) ; 	
	regs_to_ipbus(18)							<= cdce_phase_mon_acq_signature( 95 downto  64) ; 	
	regs_to_ipbus(19)							<= cdce_phase_mon_acq_signature(127 downto  96) ; 	
	regs_to_ipbus(20)							<= cdce_phase_mon_signature_match 						--[31]
													 & cdce_phase_mon_signature_mismatch					--[30]
													 & cdce_phase_mon_signature_valid						--[29]
													 & '0'															--[28]
													 & cdce_phase_mon_retries									--[27:24]
													 & cdce_phase_mon_error_count(7 downto 0)				--[23:16]
													 & cdce_phase_mon_acq_signature(143 downto 128) ;  --[15: 0]
													 
	cdce_phase_mon_exp_signature( 31 downto   0) 		<= regs_from_ipbus(21);						
	cdce_phase_mon_exp_signature( 63 downto  32) 		<= regs_from_ipbus(22);						
	cdce_phase_mon_exp_signature( 95 downto  64) 		<= regs_from_ipbus(23);						
	cdce_phase_mon_exp_signature(127 downto  96) 		<= regs_from_ipbus(24);						
	cdce_phase_mon_exp_signature(143 downto 128) 		<= regs_from_ipbus(25)(15 downto 0);	

	cdce_phase_mon_signature_mask( 31 downto   0) 		<= regs_from_ipbus(26);						
	cdce_phase_mon_signature_mask( 63 downto  32) 		<= regs_from_ipbus(27);						
	cdce_phase_mon_signature_mask( 95 downto  64) 		<= regs_from_ipbus(28);						
	cdce_phase_mon_signature_mask(127 downto  96) 		<= regs_from_ipbus(29);						
	cdce_phase_mon_signature_mask(143 downto 128) 		<= regs_from_ipbus(30)(15 downto 0);
	
	cdce_forbid_retry										 		<= regs_from_ipbus(30)(28);
	
	-- reg_ctrl (default:xxx0|xxxx|1111|1111|xx00|xx00|0111|x001)

	ICS874003_FSEL						<= reg_ctrl(0); 		-- default:1 (fclka jitter cleaner output frequency 125MHz)
	ICS874003_MR						<= reg_ctrl(1); 		-- default:0 (fclka jitter cleaner normal mode)
	ICS874003_OE						<= reg_ctrl(2); 		-- default:0 (fclka jitter cleaner output disabled)

--	IPBUS_PWRDOWN_I					=> reg_ctrl(4),		-- default:1 (powered up)
--	IPBUS_SEL_I							=> reg_ctrl(5), 		-- default:1 (select primary clock)
--	IPBUS_SYNC_I						=> reg_ctrl(6),		-- default:1 (disable sync mode), rising edge needed
-- IPBUS_CTRL_I						=> reg_ctrl(7))		-- default:0 (ipbus controlled)
	TCLKA_DR_EN							<= reg_ctrl(8); 		-- default:0 (disable tclka -> mlvds)
	TCLKB_DR_EN							<= reg_ctrl(9); 		-- default:0 (disable tclkb -> mlvds)
--												reg_ctrl(10); 
--												reg_ctrl(11); 
	XPOINT_2X2_S0						<= reg_ctrl(12);		-- default:0 (OUT_1 driven by IN_1)
	XPOINT_2X2_S1						<= reg_ctrl(13);		-- default:0 (OUT_1 driven by IN_1)
--												reg_ctrl(14); 
--												reg_ctrl(15); 
	XPOINT_4X4_S10						<= reg_ctrl(16); 	-- default:11 (xpoint_4x4 OUT_4 driven by IN_4)
	XPOINT_4X4_S11						<= reg_ctrl(17); 
	XPOINT_4X4_S20						<= reg_ctrl(18); 	-- default:11 (xpoint_4x4 OUT_4 driven by IN_4)
	XPOINT_4X4_S21						<= reg_ctrl(19);
	XPOINT_4X4_S30						<= reg_ctrl(20); 	-- default:11 (xpoint_4x4 OUT_4 driven by IN_4)
	XPOINT_4X4_S31						<= reg_ctrl(21); 
	XPOINT_4X4_S40						<= reg_ctrl(22); 	-- default:11 (xpoint_4x4 OUT_4 driven by IN_4)
	XPOINT_4X4_S41						<= reg_ctrl(23);
--												reg_ctrl(24); 
--												reg_ctrl(25); 
--												reg_ctrl(26); 
--												reg_ctrl(27); 
--												reg_ctrl(28); 
--												reg_ctrl(29); 
--												reg_ctrl(30); 
--												reg_ctrl(31); 
	
	-- reg_status
	
	reg_status(0)						<= SFP_MOD_ABS(1);
	reg_status(1)						<= SFP_RXLOS  (1);
	reg_status(2)						<= SFP_TXFAULT(1);
	reg_status(3)						<= '0';
	reg_status(4)						<= SFP_MOD_ABS(2);
	reg_status(5)						<= SFP_RXLOS  (2);
	reg_status(6)						<= SFP_TXFAULT(2);
	reg_status(7)						<= '0';
	reg_status(8)						<= SFP_MOD_ABS(3);
	reg_status(9)						<= SFP_RXLOS  (3);
	reg_status(10)						<= SFP_TXFAULT(3);
	reg_status(11)						<= '0';
	reg_status(12)						<= SFP_MOD_ABS(4);
	reg_status(13)						<= SFP_RXLOS  (4);
	reg_status(14)						<= SFP_TXFAULT(4);
	reg_status(15)						<= '0';
	reg_status(16) 					<= not GBE_INT_N;
	reg_status(17)						<= not FMC1_PRESENT_L;			
	reg_status(18) 					<= not FMC2_PRESENT_L;				
	reg_status(19) 					<= not FPGA_RESET_B;				
	reg_status(25 downto 20)		<=	V6_CPLD;
	reg_status(26) 					<= '0';	
	reg_status(27)						<= '0';
	reg_status(28)						<= CDCE_PLL_LOCK;
	reg_status(29)						<= not cdce_phase_mon_signature_mismatch;
	reg_status(30)						<= '0';
	reg_status(31)						<= '0';


end system_core_arch;