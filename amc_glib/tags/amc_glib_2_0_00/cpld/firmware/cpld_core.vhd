library ieee;
--! standard packages
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--! specific packages
library unisim;
use unisim.vcomponents.all;
--! custom packages
--use work.custom_data_types.all;

entity cpld_core is

--generic
--(
--);
port
(
	
	clk				: in		std_logic;
	addr_data_b		: out		std_logic;
	read_write_b	: out		std_logic;
	data_from_core	: out		std_logic_vector(3 downto 0);
	data_to_core	: in		std_logic_vector(3 downto 0);	
	---------------
	chain_conf_sw	: in		std_logic_vector(3 downto 0);
	---------------
	ltm_powergood	: in		std_logic_vector(3 downto 0);
	fmc_pg_m2c		: in		std_logic_vector(1 downto 0);
	fmc_prsnt_m2c_b: in		std_logic_vector(1 downto 0);
	fmcx_pg_c2m		: out		std_logic;
	---------------
	master_tck		: in		std_logic_vector(0 downto 0);
	master_tms		: in		std_logic_vector(0 downto 0);
	master_tdo		: in		std_logic_vector(0 downto 0);
	master_tdi		: out		std_logic_vector(0 downto 0);
	---------------
	slave_tck		: out		std_logic_vector(3 downto 0);
	slave_tms		: out		std_logic_vector(3 downto 0);
	slave_tdo		: in		std_logic_vector(3 downto 0);
	slave_tdi		: out		std_logic_vector(3 downto 0);
	---------------
	mmc_cpld			: inout	std_logic_vector(10 downto 0);
	---------------
	v6_cpld			: inout	std_logic_vector(5 downto 0)
);                    	
end cpld_core;
               	
architecture cpld_core_arch of cpld_core is                    	

signal power_good: std_logic;

begin

--=====================--
tst:process(clk)
--=====================--
variable cnt4bit:	std_logic_vector(3 downto 0);
begin
if clk'event and clk='1' then

	addr_data_b		<='0';
	read_write_b	<='0';
	data_from_core	<=cnt4bit;
	cnt4bit:=cnt4bit+1;

end if;
end process;


--=====================--
-- mmc <-> cpld
--=====================--
	mmc_cpld(10) 				<= '1' when ltm_powergood="1111" else '0'; --mmc_low_voltage_pok,				 				
	mmc_cpld(9) 				<= 'Z'; --mmc_master_init_done, 			
	mmc_cpld(8) 				<= 'Z'; --mmc_slave_init_done, 				
	mmc_cpld(7) 				<= 'Z'; --mmc_reset_fpga_n, 					
	mmc_cpld(6) 				<= 'Z'; --mmc_reload_fpgas_n, 				
	mmc_cpld(5) 				<= 'Z'; --mmc_pg4, 								
	mmc_cpld(4) 				<= 'Z'; --mmc_pa6, 							   
	mmc_cpld(3) 				<= 'Z'; --mmc_pa5, 							   
	mmc_cpld(2) 				<= 'Z'; --mmc_pa4, 							   
	mmc_cpld(1) 				<= 'Z'; --mmc_pa3, 								   					
	mmc_cpld(0) 				<= 'Z'; --mmc_pa2, 								

--=====================--
-- fpga <-> cpld
--=====================--
	v6_cpld(5) 					<= chain_conf_sw(3);
	v6_cpld(4) 					<= chain_conf_sw(2);
	v6_cpld(3) 					<= '0';
	v6_cpld(2) 					<= '0';
	v6_cpld(1) 					<= '0';
	v6_cpld(0) 					<= power_good;



--=====================--
sw:process(chain_conf_sw)
--=====================--
begin
	case chain_conf_sw(1 downto 0) is



		--==========--			--====== boundary scan test ======--
		when "11" => 			-- master: jtag connector, chain: fpga->sram1->sram2->phy	
		--==========--

			slave_tck(0)		<= master_tck(0);
			slave_tck(1)		<= master_tck(0);
			slave_tck(2)		<= master_tck(0);
			slave_tck(3)		<= master_tck(0);
			slave_tms(0)		<= master_tms(0);
			slave_tms(1)		<= master_tms(0);
			slave_tms(2)		<= master_tms(0);
			slave_tms(3)		<= master_tms(0);
			
			master_tdi(0) <= 	slave_tdo(3); 
									slave_tdi(3)<= slave_tdo(2); 
														slave_tdi(2)<= slave_tdo(1); 
																			slave_tdi(1)<= slave_tdo(0);
																								slave_tdi(0)<=	master_tdo(0);

		--==========--			--====== standard ===================--
		when others =>			-- master: jtag connector, chain: fpga
		--==========--

			slave_tck(0)		<= master_tck(0);
			slave_tck(1)		<= '0';
			slave_tck(2)		<= '0';
			slave_tms(0)		<= master_tms(0);
			slave_tms(1)		<= '1';
			slave_tms(2)		<= '1';
			
			master_tdi(0) <= 	slave_tdo(0); 
									slave_tdi(0)<=	master_tdo(0);

	end case;
end process;	

	
	fmcx_pg_c2m		<= '1'; --power_good;
	power_good		<= '1' 	when 	(ltm_powergood="1111"
									and	(((fmc_prsnt_m2c_b(0)='0') and (fmc_pg_m2c(0)='1')) or fmc_prsnt_m2c_b(0)='1') 
									and	(((fmc_prsnt_m2c_b(1)='0') and (fmc_pg_m2c(1)='1')) or fmc_prsnt_m2c_b(1)='1'))
								 	else '0';


	
end cpld_core_arch;                    	