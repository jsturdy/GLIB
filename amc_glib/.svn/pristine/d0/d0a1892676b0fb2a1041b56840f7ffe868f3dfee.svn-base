library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;

entity cpld_sch is
port
(
	mclk_cpld 							: inout	std_logic;  
	-------------------------------
	pgood_2v5 						   : in		std_logic;  
	pgood_3v3 						   : in		std_logic;  
	pgood_1v0 						   : in		std_logic;  
	pgood_1v5 						   : in		std_logic;  
	-------------------------------
	v6_cpld_4 						   : inout	std_logic;  
	v6_cpld_3 						   : inout	std_logic;  
	v6_cpld_5 						   : inout	std_logic;  
	v6_cpld_0 						   : inout	std_logic;  
	v6_cpld_1 						   : inout	std_logic;  
	v6_cpld_2 						   : inout	std_logic;  
	-------------------------------
	fpga_reset_b 					   : inout	std_logic;  
	unnamed_7_rsmd0402_i413_b 	   : inout	std_logic;  --fpga_done
	unnamed_7_rsmd0402_i412_b 	   : inout	std_logic;  --fpga_init_b
	unnamed_7_rsmd0402_i411_b 	   : inout	std_logic;  --fpga_program_b
	-------------------------------
	sw1 								   : inout	std_logic;  
	sw2 								   : inout	std_logic;  
	sw3 								   : inout	std_logic;  
	sw4 								   : inout	std_logic;  
	-------------------------------
	fmcx_pg_c2m 					   : inout	std_logic;  
	fmc1_pg_m2c 					   : inout	std_logic;  
	fmc2_pg_m2c 					   : inout	std_logic;  
	fmc1_prsnt_m2c_l 				   : inout	std_logic;  
	fmc2_prsnt_m2c_l 				   : inout	std_logic;  
	-------------------------------
	mmc_low_voltage_pok 				: inout	std_logic;  
	mmc_master_init_done 			: inout	std_logic;  
	mmc_slave_init_done 				: inout	std_logic;  
	mmc_reset_fpga_n 					: inout	std_logic;  
	mmc_reload_fpgas_n 				: inout	std_logic;  
	mmc_pg4 								: inout	std_logic;  
	mmc_pa6 							   : inout	std_logic;  
	mmc_pa5 							   : inout	std_logic;  
	mmc_pa4 							   : inout	std_logic;  
	mmc_pa3 								: inout	std_logic;	    					
	mmc_pa2 								: inout	std_logic;  
	-------------------------------
	unnamed_7_rsmd0402_i431_a 	   : in		std_logic;  --mmc_tdi
	mmc_tdo 							   : in		std_logic;  
	mmc_tms 							   : in		std_logic;  
	mmc_tck 							   : in		std_logic;
	-------------------------------
	amc_tck 								: inout	std_logic;  
	amc_tms 								: inout	std_logic;  
	amc_tdo 								: inout	std_logic;  
	amc_trst_b 							: inout	std_logic;  
	unnamed_7_rsmd0402_i421_a 		: inout	std_logic;  --amc_tdi
	-------------------------------
	gbe_tdo 								: inout	std_logic;  
	unnamed_7_rsmd0402_i398_b 		: inout	std_logic;  --gbe_trst_b
	unnamed_7_rsmd0402_i399_b 	   : inout	std_logic;  --gbe_tck
	unnamed_7_rsmd0402_i400_b 	   : inout	std_logic;  --gbe_tdi
	unnamed_7_rsmd0402_i402_b 	   : inout	std_logic;  --gbe_tms
	-------------------------------
	unnamed_7_rsmd0402_i441_a 	   : inout	std_logic;  --fmc1_trst_l
	unnamed_7_rsmd0402_i436_a 	   : inout	std_logic;  --fmc1_tms
	unnamed_7_rsmd0402_i437_a 		: inout	std_logic;  --fmc1_tdi
	unnamed_7_rsmd0402_i438_a 	   : inout	std_logic;  --fmc1_tck
	fmc1_tdo 						   : inout	std_logic;  
	-------------------------------
	fmc2_tdo 						   : inout	std_logic;  
	unnamed_7_rsmd0402_i434_a 	   : inout	std_logic;  --fmc2_tck
	unnamed_7_rsmd0402_i435_a 	   : inout	std_logic;  --fmc2_tdi
	unnamed_7_rsmd0402_i439_a 	   : inout	std_logic;  --fmc2_trst_l
	unnamed_7_rsmd0402_i440_a 	   : inout	std_logic;  --fmc2_tms
	-------------------------------
	sram1_tdo 						   : inout	std_logic;  
	unnamed_7_rsmd0402_i416_b 	   : inout	std_logic;  --sram1_tck
	unnamed_7_rsmd0402_i415_b 	   : inout	std_logic;  --sram1_tms
	unnamed_7_rsmd0402_i414_b 	   : inout	std_logic;  --sram1_tdi
	-------------------------------
	sram2_tdo 						   : inout	std_logic;  
	unnamed_7_rsmd0402_i419_b 		: inout	std_logic;  --sram2_tck
	unnamed_7_rsmd0402_i418_b 	   : inout	std_logic;  --sram2_tms
	unnamed_7_rsmd0402_i417_b 	   : inout	std_logic;  --sram2_tdi
	-------------------------------
	unnamed_7_rsmd0402_i395_b 		: out		std_logic;  --fpga_tms
	unnamed_7_rsmd0402_i397_b 		: out		std_logic;  --fpga_tck
	unnamed_7_rsmd0402_i396_b 		: out		std_logic;  --fpga_tdi
	fpga_tdo 							: in		std_logic;  
	-------------------------------
	unnamed_7_rsmd0402_i445_a 	   : out		std_logic;  --jtag_header_tdi
	jtag_header_tdo 				   : in		std_logic;  
	jtag_header_tck 				   : in		std_logic;  
	jtag_header_tms 				   : in		std_logic
);                    	         
end cpld_sch;                    
                                 
                    	
architecture cpld_sch_arch of cpld_sch is                    	

begin

primitives : entity work.cpld_unisim
port map
(
	mclk_cpld							=> mclk_cpld,
	dipswitch(4)						=> sw4,
	dipswitch(3)						=> sw3,
	dipswitch(2)						=> sw2,
	dipswitch(1)						=> sw1,
	------------------------------
	ltm_powergood(0)					=> pgood_1v0,  	
	ltm_powergood(1)					=> pgood_1v5,  	
	ltm_powergood(2)					=> pgood_2v5,  	
	ltm_powergood(3)					=> pgood_3v3,  	
	fmc_pg_m2c(0)						=> fmc1_pg_m2c,
	fmc_pg_m2c(1)						=> fmc2_pg_m2c,
	fmc_prsnt_m2c_b(0)				=> fmc1_prsnt_m2c_l,	
	fmc_prsnt_m2c_b(1)				=> fmc2_prsnt_m2c_l,	
	fmcx_pg_c2m							=> fmcx_pg_c2m,
	------------------------------
	jtag_header_tck 				   => jtag_header_tck,
	jtag_header_tms 				   => jtag_header_tms,  
	jtag_header_tdo					=> jtag_header_tdo,
	jtag_header_tdi					=> unnamed_7_rsmd0402_i445_a,
	------------------------------
	v6_tck 				   			=> unnamed_7_rsmd0402_i397_b,
	v6_tms 				   			=> unnamed_7_rsmd0402_i395_b,
	v6_tdo								=> fpga_tdo,
	v6_tdi								=> unnamed_7_rsmd0402_i396_b,
	------------------------------
	sram1_tck							=> unnamed_7_rsmd0402_i416_b,
	sram1_tms							=> unnamed_7_rsmd0402_i415_b,
	sram1_tdo							=> sram1_tdo,
	sram1_tdi							=> unnamed_7_rsmd0402_i414_b,
	-------------------------------
	sram2_tck							=> unnamed_7_rsmd0402_i419_b,
	sram2_tms							=> unnamed_7_rsmd0402_i418_b,
	sram2_tdo							=> sram2_tdo,
	sram2_tdi							=> unnamed_7_rsmd0402_i417_b,
	-------------------------------
	gbe_tdo 								=> gbe_tdo, 
	gbe_trst_b							=> unnamed_7_rsmd0402_i398_b,
	gbe_tck								=> unnamed_7_rsmd0402_i399_b, 
	gbe_tdi								=> unnamed_7_rsmd0402_i400_b,
	gbe_tms								=> unnamed_7_rsmd0402_i402_b,
	-------------------------------
	mmc_cpld(10) 						=> mmc_low_voltage_pok,				 				
	mmc_cpld(9) 						=> mmc_master_init_done, 			
	mmc_cpld(8) 						=> mmc_slave_init_done, 				
	mmc_cpld(7) 						=> mmc_reset_fpga_n, 					
	mmc_cpld(6) 						=> mmc_reload_fpgas_n, 				
	mmc_cpld(5) 						=> mmc_pg4, 								
	mmc_cpld(4) 						=> mmc_pa6, 							   
	mmc_cpld(3) 						=> mmc_pa5, 							   
	mmc_cpld(2) 						=> mmc_pa4, 							   
	mmc_cpld(1) 						=> mmc_pa3, 								   					
	mmc_cpld(0) 						=> mmc_pa2, 								
	------------------------------
	v6_cpld(0)							=> v6_cpld_0,
	v6_cpld(1)							=> v6_cpld_1,
	v6_cpld(2)							=> v6_cpld_2,
	v6_cpld(3)							=> v6_cpld_3,
	v6_cpld(4)							=> v6_cpld_4,
	v6_cpld(5)							=> v6_cpld_5
);

end cpld_sch_arch;