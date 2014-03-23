library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--! xilinx packages
library unisim;
use unisim.vcomponents.all;
--! system packages
use work.system_package.all;
use work.ipbus.all;
use work.wb_package.all;
use work.sram_package.all;
use work.fmc_package.all;
--! user packages
use work.user_package.all;

entity user_logic is
port
(
	reset							: in		std_logic;										
	--====================--
	-- global clocks
	--====================--
	clk_125		            : in		std_logic;										
	pri_clk		            : in		std_logic;										
	sec_clk		            : in		std_logic;										
	------------------------
	fmc1_clk1_m2c_p			: in		std_logic;	
	fmc1_clk1_m2c_n			: in		std_logic;	
	------------------------
	fmc2_clk1_m2c_p			: in		std_logic;	
	fmc2_clk1_m2c_n			: in		std_logic;	
	------------------------
	cdce_clkout4				: in		std_logic;
	------------------------
	cdce_auxout_p	   		: in		std_logic;	
	cdce_auxout_n	   		: in		std_logic;
	------------------------
	xpoint_2x2_out1_p			: in		std_logic;
	xpoint_2x2_out1_n			: in		std_logic;
	--====================--
	-- user mgt refclk
	--====================--
	sfp_refclk_p				: in		std_logic_vector(0 to 1);	
	sfp_refclk_n				: in		std_logic_vector(0 to 1);	
	------------------------
	ext_fat_pipe_refclk_p	: in		std_logic_vector(0 to 1);	
	ext_fat_pipe_refclk_n	: in		std_logic_vector(0 to 1);	
	------------------------
	fat_pipe_refclk_p		 	: in		std_logic_vector(0 to 1);	
	fat_pipe_refclk_n		   : in		std_logic_vector(0 to 1);
	------------------------
	fmc1_refclk_p				: in		std_logic_vector(0 to 1);	
	fmc1_refclk_n				: in		std_logic_vector(0 to 1);	
	--====================--
	-- amc 
	--====================--
	amc_port_tx_p				: out		std_logic_vector(2 to 15);
	amc_port_tx_n				: out		std_logic_vector(2 to 15);
	amc_port_rx_p				: in		std_logic_vector(2 to 15);
	amc_port_rx_n				: in		std_logic_vector(2 to 15);
	------------------------
	amc_port_tx_out			: out		std_logic_vector(17 to 20);	
	amc_port_tx_in				: in		std_logic_vector(17 to 20);		
	amc_port_tx_de				: out		std_logic_vector(17 to 20);	
	amc_port_rx_out			: out		std_logic_vector(17 to 20);	
	amc_port_rx_in				: in		std_logic_vector(17 to 20);	
	amc_port_rx_de				: out		std_logic_vector(17 to 20);	
	--====================--
	-- sfp quad
	--====================--
	sfp_tx_p						: out		std_logic_vector(1 to 4);
	sfp_tx_n						: out		std_logic_vector(1 to 4);
	sfp_rx_p						: in		std_logic_vector(1 to 4);
	sfp_rx_n						: in		std_logic_vector(1 to 4);
	sfp_mod_abs					: in		std_logic_vector(1 to 4);		
	sfp_rxlos					: in		std_logic_vector(1 to 4);		
	sfp_txfault					: in		std_logic_vector(1 to 4);				
	--====================--
	-- fmc1 
	--====================--
	fmc1_tx_p					: out		std_logic_vector(1 to 4);
	fmc1_tx_n               : out		std_logic_vector(1 to 4);
	fmc1_rx_p               : in		std_logic_vector(1 to 4);
	fmc1_rx_n               : in		std_logic_vector(1 to 4);
	------------------------
	fmc1_io_pin					: inout	fmc_io_pin_type;
	------------------------
	fmc1_clk_c2m_p				: out		std_logic_vector(0 to 1);
	fmc1_clk_c2m_n				: out		std_logic_vector(0 to 1);
	fmc1_present_l				: in		std_logic;
	--====================--
	-- fmc2 io & ctrl
	--====================--
	fmc2_io_pin					: inout	fmc_io_pin_type;
	------------------------
	fmc2_clk_c2m_p				: out		std_logic_vector(0 to 1);
	fmc2_clk_c2m_n				: out		std_logic_vector(0 to 1);
	fmc2_present_l				: in		std_logic;
	--====================--
	-- sram
	--====================--
	user_sram_control_o		: out		userSramControlR_array(1 to 2);
	user_sram_addr_o			: out		array_2x21bit;
	user_sram_wdata_o			: out		array_2x36bit;
	user_sram_rdata_i			: in 		array_2x36bit;
	------------------------
	cdce_pll_lock_i			: in 		std_logic;
	cdce_sel_o					: out		std_logic;
	cdce_sync_o					: out		std_logic;
	------------------------
	mac_syncacqstatus_i		: in		std_logic_vector(0 to 3);
	mac_serdes_locked_i		: in		std_logic_vector(0 to 3);
	------------------------
	wb_miso_o					: out		wb_miso_bus_array(0 to number_of_wb_slaves-1);
	wb_mosi_i					: in 		wb_mosi_bus_array(0 to number_of_wb_slaves-1);
	------------------------
	ipb_clk_i					: in 		std_logic;
	ipb_miso_o					: out		ipb_rbus_array(0 to number_of_ipb_slaves-1);
	ipb_mosi_i					: in 		ipb_wbus_array(0 to number_of_ipb_slaves-1)
);                         	
end user_logic;
							
architecture user_logic_arch of user_logic is                    	

--signal regs_to_u1		: array_32x32bit;
--signal regs_from_u1	: array_32x32bit;

begin -- architecture

	cdce_sel_o					<= '1'; -- at least one output has to be driven to avoid compilation errors


--------------------------------------------
---- small example of implementing registers
--------------------------------------------
--	u1: entity work.wb_user_regs
--	port map
--	(
--		wb_mosi			=> wb_mosi_i(user_wb_regs),
--		wb_miso			=> wb_miso_o(user_wb_regs),
--		---------------
--		regs_o			=> regs_from_u1,
--		regs_i			=> regs_to_u1
--	);
--
--	regs_to_u1(0) 	<= x"00112233";
--	regs_to_u1(1) 	<= x"44556677";
--	regs_to_u1(2) 	<= x"8899aabb";
--	regs_to_u1(3) 	<= x"ccddeeff";
--	regs_to_u1(15) <= regs_from_u1(16);
--------------------------------------------

end user_logic_arch;