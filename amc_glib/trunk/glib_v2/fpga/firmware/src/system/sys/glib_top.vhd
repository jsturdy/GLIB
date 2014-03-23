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
--! user packages
use work.user_package.all;



entity glib_top is
port
(
	--=====================--
	-- GBE 
	--=====================--
	gbe_refclk_p				:in		std_logic;
	gbe_refclk_n				:in		std_logic;
	gbe_tx_p						:out		std_logic;
	gbe_tx_n						:out		std_logic;
	gbe_rx_p						:in		std_logic;
	gbe_rx_n						:in		std_logic;
	gbe_reset_n					:out		std_logic;	
	gbe_int_n					:in		std_logic;	
	gbe_scl						:inout	std_logic;
	gbe_sda						:inout	std_logic;
	--=====================--
	-- FMC2 RESERVED MGT 
	--=====================--
	fmc2_tx_p					:out		std_logic;
	fmc2_tx_n					:out		std_logic;
	fmc2_rx_p					:in		std_logic;
	fmc2_rx_n					:in		std_logic;
	--=====================--
	-- GLOBAL CLOCKS
	--=====================--
	clk125_0_p	            :in		std_logic;										
	clk125_0_n	            :in		std_logic;						
	-------------------------
	mclk_0_n						:in		std_logic;	
	mclk_0_p						:in		std_logic;	
	-------------------------
	fmc1_clk1_m2c_p			:in		std_logic;	
	fmc1_clk1_m2c_n			:in		std_logic;	
	-------------------------
	fmc2_clk1_m2c_p			:in		std_logic;	
	fmc2_clk1_m2c_n			:in		std_logic;	
	-------------------------
	xpoint_4x4_out3_p			:in		std_logic;
	xpoint_4x4_out3_n			:in		std_logic;
	-------------------------
	cdce_clkout4_p	   		:in		std_logic;
	cdce_clkout4_n				:in		std_logic;
	-------------------------
	cdce_auxout_p	   		:in		std_logic;	
	cdce_auxout_n	   		:in		std_logic;
	-------------------------
	xpoint_2x2_out1_p			:in		std_logic;
	xpoint_2x2_out1_n			:in		std_logic;
	--=====================--
	-- USER MGT REFCLK
	--=====================--
	sfp_refclk_p				:in		std_logic_vector(0 to 1);	
	sfp_refclk_n				:in		std_logic_vector(0 to 1);	
	-------------------------
	ext_fat_pipe_refclk_p	:in		std_logic_vector(0 to 1);	
	ext_fat_pipe_refclk_n	:in		std_logic_vector(0 to 1);	
	-------------------------
	fat_pipe_refclk_p		 	:in		std_logic_vector(0 to 1);	
	fat_pipe_refclk_n		   :in		std_logic_vector(0 to 1);
	-------------------------
	fmc1_refclk_p				:in		std_logic_vector(0 to 1);	
	fmc1_refclk_n				:in		std_logic_vector(0 to 1);	
	--=====================--
	-- AMC 
	--=====================--
	amc_port_tx_p				:out		std_logic_vector(0 to 15);
	amc_port_tx_n				:out		std_logic_vector(0 to 15);
	amc_port_rx_p				:in		std_logic_vector(0 to 15);
	amc_port_rx_n				:in		std_logic_vector(0 to 15);
	-------------------------
	amc_port_tx_out			:out		std_logic_vector(17 to 20);	
	amc_port_tx_in				:in		std_logic_vector(17 to 20);		
	amc_port_tx_de				:out		std_logic_vector(17 to 20);	
	amc_port_rx_out			:out		std_logic_vector(17 to 20);	
	amc_port_rx_in				:in		std_logic_vector(17 to 20);	
	amc_port_rx_de				:out		std_logic_vector(17 to 20);	
	--=====================--
	-- CLK CIRCUITRY
	--=====================--
	xpoint_4x4_s40	   		:out		std_logic;
	xpoint_4x4_s41	   	   :out		std_logic;
	xpoint_4x4_s30	   	   :out		std_logic;
	xpoint_4x4_s31	   	   :out		std_logic;
	xpoint_4x4_s20	   	   :out		std_logic;
	xpoint_4x4_s21	   	   :out		std_logic;
	xpoint_4x4_s10	   	   :out		std_logic;
	xpoint_4x4_s11	   	   :out		std_logic;
	--
	xpoint_2x2_s0	 			:out		std_logic;
	xpoint_2x2_s1	 			:out		std_logic;
	-------------------------
	ics874003_fsel	 		   :out		std_logic;
	ics874003_mr	 			:out		std_logic;
	ics874003_oe	 			:out		std_logic;
	-------------------------
	tclka_dr_en				   :out		std_logic;
	tclkb_dr_en				   :out		std_logic;
	-------------------------
	cdce_pwr_down				:out		std_logic;	
	cdce_ref_sel				:out		std_logic;	
	cdce_sync					:out		std_logic;	
	cdce_spi_clk				:out		std_logic;	
	cdce_spi_le					:out		std_logic;	
	cdce_spi_mosi				:out		std_logic;	
	cdce_pll_lock				:in		std_logic;	
	cdce_spi_miso				:in		std_logic;	
	--=====================--
	-- SFP QUAD
	--=====================--
	sfp_tx_p						:out		std_logic_vector(1 to 4);
	sfp_tx_n						:out		std_logic_vector(1 to 4);
	sfp_rx_p						:in		std_logic_vector(1 to 4);
	sfp_rx_n						:in		std_logic_vector(1 to 4);
	sfp_mod_abs					:in		std_logic_vector(1 to 4);		
	sfp_rxlos					:in		std_logic_vector(1 to 4);		
	sfp_txfault					:in		std_logic_vector(1 to 4);				
	--=====================--
	-- FMC MGT, IO & CTRL
	--=====================--
	fmc1_tx_p					:out		std_logic_vector(1 to 4);
	fmc1_tx_n               :out		std_logic_vector(1 to 4);
	fmc1_rx_p               :in		std_logic_vector(1 to 4);
	fmc1_rx_n               :in		std_logic_vector(1 to 4);
	-------------------------
	fmc1_la_p					:inout	std_logic_vector(0 to 33);
	fmc1_la_n					:inout	std_logic_vector(0 to 33);
	fmc1_ha_p					:inout	std_logic_vector(0 to 23);
	fmc1_ha_n					:inout	std_logic_vector(0 to 23);
	fmc1_hb_p					:inout	std_logic_vector(0 to 21);
	fmc1_hb_n					:inout	std_logic_vector(0 to 21);
	fmc1_clk_c2m_p				:out		std_logic_vector(0 to 1);
	fmc1_clk_c2m_n				:out		std_logic_vector(0 to 1);
	fmc1_present_l				:in		std_logic;
	-------------------------
	fmc2_la_p	   			:inout	std_logic_vector(0 to 33);
	fmc2_la_n	  				:inout	std_logic_vector(0 to 33);
	fmc2_ha_p					:inout	std_logic_vector(0 to 23);
	fmc2_ha_n					:inout	std_logic_vector(0 to 23);
	fmc2_hb_p					:inout	std_logic_vector(0 to 21);
	fmc2_hb_n					:inout	std_logic_vector(0 to 21);
	-------------------------
	fmc2_clk_c2m_p				:out		std_logic_vector(0 to 1);
	fmc2_clk_c2m_n				:out		std_logic_vector(0 to 1);
	fmc2_present_l				:in		std_logic;
	--=====================--
	-- SRAM
	--=====================--
	sram1_addr					: out		std_logic_vector(24 downto 0);
	sram1_data					: inout	std_logic_vector(35 downto 0);
	------------------------
	sram1_adv_ld_l				: out		std_logic;	
	sram1_ce1_l					: out		std_logic;				
	sram1_cen_l					: out		std_logic;		
	sram1_clk					: out		std_logic;
	sram1_mode					: out		std_logic;
	sram1_oe_l	   			: out		std_logic;
	sram1_we_l					: out		std_logic;
	------------------------
	sram2_addr					: out		std_logic_vector(24 downto 0);	
	sram2_data					: inout	std_logic_vector(35 downto 0);	
	------------------------
	sram2_adv_ld_l				: out		std_logic;	
	sram2_ce1_l					: out		std_logic;				
	sram2_cen_l					: out		std_logic;		
	sram2_clk					: out		std_logic;
	sram2_mode					: out		std_logic;
	sram2_oe_l	   			: out		std_logic;
	sram2_we_l					: out		std_logic;
	sram2_ce2					: out		std_logic;	
	--=====================--
	-- VARIOUS
	--=====================--
	fpga_rs0	 		  			:out		std_logic;				
	fpga_rs1  					:out		std_logic;				
	fpga_scl  					:inout	std_logic;				
	fpga_sda						:inout	std_logic;				
	fpga_clkout	  				:out		std_logic;				
	fpga_reset_b	 			:in		std_logic;				
	fpga_power_on_reset_b	:in		std_logic;				
	-------------------------
	v6_cpld						:inout	std_logic_vector(0 to 5)
);                    	
end glib_top;
							
architecture glib_top_arch of glib_top is                    	


--##########################################--
--##############     signal   ##############--
--############## declarations ##############--                              
--##########################################--


signal regs_to_ipbus			      : array_16x32bit;			
signal regs_from_ipbus		      : array_16x32bit;			

signal user_reset						: std_logic;
signal user_clk_125					: std_logic;
signal user_pri_clk					: std_logic;
signal user_sec_clk					: std_logic;
signal user_cdce_clkout4			: std_logic;
signal user_cdce_sel					: std_logic;
signal user_cdce_sync				: std_logic;

signal user_mac_syncacqstatus		: std_logic_vector(0 to 3);
signal user_mac_serdes_locked		: std_logic_vector(0 to 3);

signal user_sram_control			: userSramControlR_array(1 to 2);
signal user_sram_addr				: array_2x21bit;
signal user_sram_wdata				: array_2x36bit;
signal user_sram_rdata				: array_2x36bit;

signal user_wb_miso					: wb_miso_bus_array(0 to number_of_wb_slaves-1);
signal user_wb_mosi					: wb_mosi_bus_array(0 to number_of_wb_slaves-1);

signal user_ipb_clk					: std_logic;
signal user_ipb_miso					: ipb_rbus_array	(0 to number_of_ipb_slaves-1);
signal user_ipb_mosi					: ipb_wbus_array	(0 to number_of_ipb_slaves-1);
		
		
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--
begin -- architecture
--@@@@@@@@@@@@@@@@@@@@@@--                              
--@@@@@@@@@@@@@@@@@@@@@@--
--@@@@@@@@@@@@@@@@@@@@@@--






--===================================================--
system: entity work.system_core
--===================================================--
port map
(
	--====================--
	-- GLOBAL CLOCKS
	--====================--
	clk_125_p            	=> CLK125_0_P             ,										
	clk_125_n            	=> CLK125_0_N             ,										
	pri_clk_p            	=> MCLK_0_P       	 	  ,										
	pri_clk_n            	=> MCLK_0_N 		    	  ,										
	sec_clk_p            	=> XPOINT_4X4_OUT3_P      ,										
	sec_clk_n            	=> XPOINT_4X4_OUT3_N 	  ,	
	cdce_clkout4_p     		=> CDCE_CLKOUT4_P 		  ,
   cdce_clkout4_n     		=> CDCE_CLKOUT4_N 		  ,	
	--====================--
	-- AMC                  
	--====================--
	amc_port_tx_p				=> AMC_PORT_TX_P(0 to 1)	,
	amc_port_tx_n				=> AMC_PORT_TX_N(0 to 1)	,
	amc_port_rx_p				=> AMC_PORT_RX_P(0 to 1)	,
	amc_port_rx_n				=> AMC_PORT_RX_N(0 to 1)	,
	--====================--
	-- GBE 
	--====================--
	eth_mgt_refclk_p			=> GBE_REFCLK_P				,				
	eth_mgt_refclk_n			=> GBE_REFCLK_N				,

	gbe_tx_p						=> GBE_TX_P						,
	gbe_tx_n						=> GBE_TX_N						,
	gbe_rx_p						=> GBE_RX_P						,
	gbe_rx_n						=> GBE_RX_N						,
	gbe_reset_n					=> GBE_RESET_N					,	
	gbe_int_n					=> GBE_INT_N					,	
	gbe_scl						=> GBE_SCL						,
	gbe_sda						=> GBE_SDA						,
	--====================--
	-- FMC2 RESERVED MGT 
	--====================--
	fmc2_tx_p					=> FMC2_TX_P					,
	fmc2_tx_n					=> FMC2_TX_N					,
	fmc2_rx_p					=> FMC2_RX_P					,
	fmc2_rx_n					=> FMC2_RX_N					,
	--====================--
	-- CLK CIRCUITRY
	--====================--
	xpoint_4x4_s40	   		=> XPOINT_4X4_S40	   		,
	xpoint_4x4_s41	   	   => XPOINT_4X4_S41	   	   ,
	xpoint_4x4_s30	   	   => XPOINT_4X4_S30	   	   ,
	xpoint_4x4_s31	   	   => XPOINT_4X4_S31	   	   ,
	xpoint_4x4_s20	   	   => XPOINT_4X4_S20	   	   ,
	xpoint_4x4_s21	   	   => XPOINT_4X4_S21	   	   ,
	xpoint_4x4_s10	   	   => XPOINT_4X4_S10	   	   ,
	xpoint_4x4_s11	   	   => XPOINT_4X4_S11	   	   ,
	------------------------
	xpoint_2x2_s0	 			=> XPOINT_2X2_S0	 			,
	xpoint_2x2_s1	 			=> XPOINT_2X2_S1	 			,
	------------------------
	ics874003_fsel	 		   => ICS874003_FSEL	 		   ,
	ics874003_mr	 			=> ICS874003_MR	 			,
	ics874003_oe	 			=> ICS874003_OE	 			,
	------------------------
	tclka_dr_en				   => TCLKA_DR_EN				   ,
	tclkb_dr_en				   => TCLKB_DR_EN				   ,
	------------------------
	cdce_pwr_down				=> CDCE_PWR_DOWN				,	
	cdce_ref_sel				=> CDCE_REF_SEL				,	
	cdce_sync					=> CDCE_SYNC					,	
	cdce_spi_clk				=> CDCE_SPI_CLK				,	
	cdce_spi_le					=> CDCE_SPI_LE					,	
	cdce_spi_mosi				=> CDCE_SPI_MOSI				,	
	cdce_pll_lock				=> CDCE_PLL_LOCK				,	
	cdce_spi_miso				=> CDCE_SPI_MISO				,	
	--====================--
	-- VARIOUS
	--====================--
	fpga_rs0	 		  			=> FPGA_RS0	 		  			,
	fpga_rs1  					=> FPGA_RS1  					,
	fpga_scl  					=> FPGA_SCL  					,
	fpga_sda						=> FPGA_SDA						,
	fpga_clkout	  				=> FPGA_CLKOUT	  				,
	fpga_reset_b	 			=> FPGA_RESET_B	 			,
	fpga_power_on_reset_b	=> FPGA_POWER_ON_RESET_B	,
	------------------------
	v6_cpld						=> V6_CPLD						,
	sfp_mod_abs					=> SFP_MOD_ABS					,
	sfp_rxlos					=> SFP_RXLOS					,
	sfp_txfault					=> SFP_TXFAULT					,
	--====================--
--	-- fmc
--	--====================--
	fmc1_present_l				=> fmc1_present_l				,
	fmc2_present_l				=> fmc2_present_l				,
	--====================--
	-- SRAM                 
	--====================--
	sram1_addr					=> sram1_addr					,
	sram1_data					=> sram1_data					,
	sram2_addr					=> sram2_addr					,
	sram2_data					=> sram2_data					,
	------------------------
	sram_adv_ld_l(1)			=> sram1_adv_ld_l				,
	sram_adv_ld_l(2)			=> sram2_adv_ld_l				,
	sram_ce1_l(1)				=> sram1_ce1_l					,			
	sram_ce1_l(2)				=> sram2_ce1_l					,			
	sram_cen_l(1)				=> sram1_cen_l					,	
	sram_cen_l(2)				=> sram2_cen_l					,	
	sram_clk(1)		   		=> sram1_clk					,
	sram_clk(2)		   		=> sram2_clk					,
	sram_mode(1)				=> sram1_mode					,
	sram_mode(2)				=> sram2_mode					,
	sram_oe_l(1)				=> sram1_oe_l					, 
	sram_oe_l(2)				=> sram2_oe_l					, 
	sram_we_l(1)				=> sram1_we_l					,
	sram_we_l(2)				=> sram2_we_l					,
	------------------------			
	sram2_ce2					=>	sram2_ce2					,	
	--====================--
	-- interface to user
	--====================--
	user_sram_control_i		=> user_sram_control			,	
	user_sram_addr_i			=> user_sram_addr				, 
	user_sram_wdata_i			=> user_sram_wdata			, 
	user_sram_rdata_o			=> user_sram_rdata			,
	------------------------
	user_reset_o				=> user_reset					,
	------------------------
	user_clk_125_o				=> user_clk_125				,
	user_pri_clk_o				=> user_pri_clk				,
	user_sec_clk_o				=> user_sec_clk				,
	user_cdce_clkout4			=> user_cdce_clkout4			,
	------------------------
	user_cdce_sel_i			=> user_cdce_sel				,
	user_cdce_sync_i			=> user_cdce_sync				,
	------------------------
	user_mac_syncacqstatus_o=> user_mac_syncacqstatus	,
	user_mac_serdes_locked_o=> user_mac_serdes_locked	,
	------------------------
	user_wb_miso_i				=> user_wb_miso				,
	user_wb_mosi_o				=> user_wb_mosi				,
	------------------------
	user_ipb_clk_o				=> user_ipb_clk				,
	user_ipb_miso_i			=> user_ipb_miso				,
	user_ipb_mosi_o			=> user_ipb_mosi				
);                    	
--===================================================--



--===================================================--
usr: entity work.user_logic
--===================================================--
port map
(
	reset							=> user_reset					,
	--====================--
	-- GLOBAL CLOCKS
	--====================--
	clk_125		            => user_clk_125				,		
	pri_clk		            => user_pri_clk				,		
	sec_clk		            => user_sec_clk				,		
	------------------------  
	fmc1_clk1_m2c_p			=> FMC1_CLK1_M2C_P			,
	fmc1_clk1_m2c_n			=> FMC1_CLK1_M2C_N			,
	------------------------  
	fmc2_clk1_m2c_p			=> FMC2_CLK1_M2C_P			,
	fmc2_clk1_m2c_n			=> FMC2_CLK1_M2C_N			,
	------------------------  
	cdce_clkout4	   		=> user_cdce_clkout4  		,						
	------------------------  
	cdce_auxout_p	   		=> CDCE_AUXOUT_P	   		,
	cdce_auxout_n	   		=> CDCE_AUXOUT_N	   		,
	------------------------  
	xpoint_2x2_out1_p			=> XPOINT_2X2_OUT1_P			,
	xpoint_2x2_out1_n			=> XPOINT_2X2_OUT1_N			,
	--====================--
	-- USER MGT REFCLK      
	--====================--
	sfp_refclk_p				=> SFP_REFCLK_P				,
	sfp_refclk_n				=> SFP_REFCLK_N				,
	------------------------
	ext_fat_pipe_refclk_p	=> EXT_FAT_PIPE_REFCLK_P	,
	ext_fat_pipe_refclk_n	=> EXT_FAT_PIPE_REFCLK_N	,
	------------------------
	fat_pipe_refclk_p		 	=> FAT_PIPE_REFCLK_P		 	,
	fat_pipe_refclk_n		   => FAT_PIPE_REFCLK_N		   ,
	------------------------
	fmc1_refclk_p				=> FMC1_REFCLK_P				,
	fmc1_refclk_n				=> FMC1_REFCLK_N				,
	--====================--
	-- AMC                  
	--====================--
	amc_port_tx_p				=> AMC_PORT_TX_P(2 to 15)	,
	amc_port_tx_n				=> AMC_PORT_TX_N(2 to 15)	,
	amc_port_rx_p				=> AMC_PORT_RX_P(2 to 15)	,
	amc_port_rx_n				=> AMC_PORT_RX_N(2 to 15)	,
	------------------------
	amc_port_tx_out			=> AMC_PORT_TX_OUT			,
	amc_port_tx_in				=> AMC_PORT_TX_IN				,
	amc_port_tx_de				=> AMC_PORT_TX_DE				,
	amc_port_rx_out			=> AMC_PORT_RX_OUT			,
	amc_port_rx_in				=> AMC_PORT_RX_IN				,
	amc_port_rx_de				=> AMC_PORT_RX_DE				,
	--====================--
	-- SFP QUAD             
	--====================--
	sfp_tx_p						=> SFP_TX_P						,
	sfp_tx_n						=> SFP_TX_N						,
	sfp_rx_p						=> SFP_RX_P						,
	sfp_rx_n						=> SFP_RX_N						,
	sfp_mod_abs					=> SFP_MOD_ABS					,
	sfp_rxlos					=> SFP_RXLOS					,
	sfp_txfault					=> SFP_TXFAULT					,
	--====================--
	-- fmc1
	--====================--
	fmc1_tx_p					=> FMC1_TX_P					,
	fmc1_tx_n               => FMC1_TX_N               ,
	fmc1_rx_p               => FMC1_RX_P               ,
	fmc1_rx_n               => FMC1_RX_N               ,
	------------------------
	fmc1_io_pin.la_p			=> FMC1_LA_P					,
	fmc1_io_pin.la_n			=> FMC1_LA_N					,
	fmc1_io_pin.ha_p			=> FMC1_HA_P					,
	fmc1_io_pin.ha_n			=> FMC1_HA_N					,
	fmc1_io_pin.hb_p			=> FMC1_HB_P					,
	fmc1_io_pin.hb_n			=> FMC1_HB_N					,
	------------------------
	fmc1_clk_c2m_p				=> FMC1_CLK_C2M_P				,
	fmc1_clk_c2m_n				=> FMC1_CLK_C2M_N				,
	fmc1_present_l				=> FMC1_PRESENT_L				,
	--====================--
	-- fmc2
	--====================--
	fmc2_io_pin.la_p			=> FMC2_LA_P					,
	fmc2_io_pin.la_n			=> FMC2_LA_N					,
	fmc2_io_pin.ha_p			=> FMC2_HA_P					,
	fmc2_io_pin.ha_n			=> FMC2_HA_N					,
	fmc2_io_pin.hb_p			=> FMC2_HB_P					,
	fmc2_io_pin.hb_n			=> FMC2_HB_N					,
	------------------------
	fmc2_clk_c2m_p				=> FMC2_CLK_C2M_P				,
	fmc2_clk_c2m_n				=> FMC2_CLK_C2M_N				,
	fmc2_present_l				=> FMC2_PRESENT_L				,
	--====================--
	-- SRAM interface
	--====================--
	user_sram_control_o		=> user_sram_control			,
	user_sram_addr_o			=> user_sram_addr				, 
	user_sram_wdata_o			=> user_sram_wdata			, 
	user_sram_rdata_i			=> user_sram_rdata			,
	------------------------
	cdce_pll_lock_i			=> CDCE_PLL_LOCK				,
	cdce_sel_o					=> user_cdce_sel				,
	cdce_sync_o					=> user_cdce_sync				,
	------------------------
	mac_syncacqstatus_i		=> user_mac_syncacqstatus	,
	mac_serdes_locked_i		=> user_mac_serdes_locked	,
	------------------------
	wb_miso_o					=> user_wb_miso	         ,
	wb_mosi_i					=> user_wb_mosi	         ,
	------------------------
	ipb_clk_i					=> user_ipb_clk	         ,
	ipb_miso_o					=> user_ipb_miso	         ,
	ipb_mosi_i					=> user_ipb_mosi	         	
);                    	
end glib_top_arch;