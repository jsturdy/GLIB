library ieee;
--! standard packages
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--! specific packages
library unisim;
use unisim.vcomponents.all;
--! custom packages
library work;
--use work.custom_data_types.all;

entity cpld_unisim is

--generic
--(
--);
port
(
	mclk_cpld							: in		std_logic;
	dipswitch							: in		std_logic_vector(4 downto 1);  	
	--- power --------------------
	ltm_powergood						: in		std_logic_vector(3 downto 0);
	fmc_pg_m2c							: in		std_logic_vector(1 downto 0);
	fmc_prsnt_m2c_b					: in		std_logic_vector(1 downto 0);
	fmcx_pg_c2m							: out		std_logic;	
	--- jtag master --------------
	jtag_header_tck 				   : in		std_logic;  
	jtag_header_tms 				   : in		std_logic;  
	jtag_header_tdo					: in		std_logic;  
	jtag_header_tdi					: out		std_logic;  
	--- jtag slave  --------------
	v6_tck 				   			: out		std_logic;  
	v6_tms 				   			: out		std_logic;  
	v6_tdo								: in		std_logic;  
	v6_tdi								: out		std_logic;
	--- jtag slave  --------------
	sram1_tck 			   			: out		std_logic;  
	sram1_tms			   			: out		std_logic;  
	sram1_tdo							: in		std_logic;  
	sram1_tdi							: out		std_logic;
	--- jtag slave  --------------
	sram2_tck 			   			: out		std_logic;  
	sram2_tms			   			: out		std_logic;  
	sram2_tdo							: in		std_logic;  
	sram2_tdi							: out		std_logic;
	--- jtag slave  --------------
	gbe_tck 			   				: out		std_logic;  
	gbe_tms			   				: out		std_logic;  
	gbe_tdo								: in		std_logic;  
	gbe_tdi								: out		std_logic;
	gbe_trst_b							: out		std_logic;
	--- mmc cpld bus  ------------
	mmc_cpld								: inout	std_logic_vector(10 downto 0);	
	--- v6_cpld bus  -------------
	v6_cpld								: inout	std_logic_vector(5 downto 0)	
); 
                   	
end cpld_unisim;
               	
architecture cpld_unisim_arch of cpld_unisim is                    	

--component cpld_core is
--port
--(
--	clk					: in		std_logic;
--	---------------
--	addr_data_b			: out		std_logic;
--	read_write_b		: out		std_logic;
--	data_from_core		: out		std_logic_vector(3 downto 0);
--	data_to_core		: in		std_logic_vector(3 downto 0);	
--	---------------
--	chain_conf_sw		: in		std_logic_vector(3 downto 0);
--	--- jtag master --------------
--	master_tck		 	: in		std_logic_vector(0 downto 0);
--	master_tms 			: in		std_logic_vector(0 downto 0);
--	master_tdo			: in		std_logic_vector(0 downto 0);  
--	master_tdi			: out		std_logic_vector(0 downto 0);  
--	--- jtag slave  --------------
--	slave_tck 			: out		std_logic_vector(3 downto 0); 
--	slave_tms 			: out		std_logic_vector(3 downto 0); 
--	slave_tdo			: in		std_logic_vector(3 downto 0); 
--	slave_tdi			: out		std_logic_vector(3 downto 0)
--);                    	
--end component;

signal chain_conf_sw : std_logic_vector(3 downto 0);	

signal master_tck		: std_logic_vector(0 downto 0);
signal master_tms		: std_logic_vector(0 downto 0);
signal master_tdo		: std_logic_vector(0 downto 0);
signal master_tdi		: std_logic_vector(0 downto 0);

signal slave_tck		: std_logic_vector(3 downto 0);
signal slave_tms		: std_logic_vector(3 downto 0);
signal slave_tdo		: std_logic_vector(3 downto 0);
signal slave_tdi		: std_logic_vector(3 downto 0);

signal clk				: std_logic;
signal addr_data_b	: std_logic;
signal read_write_b	: std_logic;
signal data_from_core: std_logic_vector(3 downto 0);
signal data_to_core	: std_logic_vector(3 downto 0);

begin


core: entity work.cpld_core 
port map
(
	clk				=> clk,
	---------------
	data_to_core	=> data_to_core,	
	data_from_core	=> data_from_core,	
	addr_data_b		=> addr_data_b,	
	read_write_b	=> read_write_b,	
	---------------
	chain_conf_sw	=> chain_conf_sw,
	---------------
	ltm_powergood	=> ltm_powergood,  	-- no buffer
	fmc_pg_m2c		=> fmc_pg_m2c,			-- no buffer
	fmc_prsnt_m2c_b=> fmc_prsnt_m2c_b,	-- no buffer
	fmcx_pg_c2m		=> fmcx_pg_c2m,		-- no buffer	
	mmc_cpld			=> mmc_cpld,			-- no buffer	
	v6_cpld			=> v6_cpld,				-- no buffer
	---------------
	master_tck		=> master_tck,
	master_tms		=> master_tms,
	master_tdo		=> master_tdo,
	master_tdi		=> master_tdi,
	---------------
	slave_tck		=> slave_tck,
	slave_tms		=> slave_tms,
	slave_tdo		=> slave_tdo,
	slave_tdi		=> slave_tdi
); 


--##########################--
--##########################--
--##                      ##--   					
--##   xilinx primitives  ##--
--##                      ##--
--##########################--
--##########################--


mclk_buf			: bufg	port map (i => mclk_cpld, o => clk);

--== chain configuration switch ==-- 

sw: for i in 0 to 3
generate

chain_sw_buf: ibuf 		generic map (capacitance => "dont_care", ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos33")
								port map (i => dipswitch(i+1), o => chain_conf_sw(i));
end generate;

--== master0 -> jtag header ==-- 

jtaghdr_tck_buf: ibuf 	generic map (capacitance => "dont_care", ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos33")
								port map (i => jtag_header_tck, o => master_tck(0));
jtaghdr_tms_buf: ibuf 	generic map (capacitance => "dont_care", ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos33")
								port map (i => jtag_header_tms, o => master_tms(0));
jtaghdr_tdo_buf: ibuf 	generic map (capacitance => "dont_care", ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos33")
								port map (i => jtag_header_tdo, o => master_tdo(0));
jtaghdr_tdi_buf: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos33", slew => "slow")
								port map (i => master_tdi(0), o => jtag_header_tdi);

--== slave0 -> v6 ==-- 

v6_tck_buf		: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tck(0), o => v6_tck);
v6_tms_buf		: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tms(0), o => v6_tms);
v6_tdo_buf		: ibuf 	generic map (capacitance => "dont_care", ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos25")
								port map (i => v6_tdo, o => slave_tdo(0));
v6_tdi_buf		: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tdi(0), o => v6_tdi);

--== slave1 -> sram1 ==-- 

sram1_tck_buf	: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tck(1), o => sram1_tck);
sram1_tms_buf	: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tms(1), o => sram1_tms);
sram1_tdo_buf	: ibuf 	generic map (capacitance => "dont_care", ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos25")
								port map (i => sram1_tdo, o => slave_tdo(1));
sram1_tdi_buf	: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tdi(1), o => sram1_tdi);

--== slave2 -> sram2 ==-- 

sram2_tck_buf	: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tck(2), o => sram2_tck);
sram2_tms_buf	: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tms(2), o => sram2_tms);
sram2_tdo_buf	: ibuf 	generic map (capacitance => "dont_care", ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos25")
								port map (i => sram2_tdo, o => slave_tdo(2));
sram2_tdi_buf	: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tdi(2), o => sram2_tdi);

--== slave3 -> phy  ==-- 

phy_tck_buf		: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tck(3), o => gbe_tck);
phy_tms_buf		: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tms(3), o => gbe_tms);
phy_tdo_buf		: ibuf 	generic map (capacitance => "dont_care", ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos25")
								port map (i => gbe_tdo, o => slave_tdo(3));
phy_tdi_buf		: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => slave_tdi(3), o => gbe_tdi);
phy_trst_buf	: obuf 	generic map (capacitance => "dont_care", drive => 12, iostandard => "lvcmos25", slew => "slow")
								port map (i => chain_conf_sw(2)	, o => gbe_trst_b);  --!!!!!!!!!!



                   	        

end cpld_unisim_arch;                    	