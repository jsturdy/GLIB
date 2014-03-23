library ieee;
use ieee.std_logic_1164.all;

package fmc_package is


	--===========--
	type fmc_io_pin_type is
	--===========--
	record
		la_p				: std_logic_vector(0 to 33);
		la_n				: std_logic_vector(0 to 33);
		ha_p				: std_logic_vector(0 to 23);
		ha_n				: std_logic_vector(0 to 23);
		hb_p				: std_logic_vector(0 to 21);
		hb_n				: std_logic_vector(0 to 21);
	end record;
	--===========--
	

	--===========--
	type fmc_from_fabric_to_pin_type is
	--===========--
	record
		la_lvds			: std_logic_vector(0 to 33);
		ha_lvds			: std_logic_vector(0 to 23);
		hb_lvds			: std_logic_vector(0 to 21);
		la_lvds_oe_l	: std_logic_vector(0 to 33);
		ha_lvds_oe_l	: std_logic_vector(0 to 23);
		hb_lvds_oe_l	: std_logic_vector(0 to 21);
		
		la_cmos_p		: std_logic_vector(0 to 33);
		ha_cmos_p		: std_logic_vector(0 to 23);
		hb_cmos_p		: std_logic_vector(0 to 21);
		la_cmos_p_oe_l	: std_logic_vector(0 to 33);
		ha_cmos_p_oe_l	: std_logic_vector(0 to 23);
		hb_cmos_p_oe_l	: std_logic_vector(0 to 21);

		la_cmos_n		: std_logic_vector(0 to 33);
		ha_cmos_n		: std_logic_vector(0 to 23);
		hb_cmos_n		: std_logic_vector(0 to 21);
		la_cmos_n_oe_l	: std_logic_vector(0 to 33);
		ha_cmos_n_oe_l	: std_logic_vector(0 to 23);
		hb_cmos_n_oe_l	: std_logic_vector(0 to 21);

	end record;
	--===========--


	--===========--
	type fmc_from_pin_to_fabric_type is
	--===========--
	record
		la_lvds			: std_logic_vector(0 to 33);
		ha_lvds			: std_logic_vector(0 to 23);
		hb_lvds			: std_logic_vector(0 to 21);
		
		la_cmos_p		: std_logic_vector(0 to 33);
		ha_cmos_p		: std_logic_vector(0 to 23);
		hb_cmos_p		: std_logic_vector(0 to 21);

		la_cmos_n		: std_logic_vector(0 to 33);
		ha_cmos_n		: std_logic_vector(0 to 23);
		hb_cmos_n		: std_logic_vector(0 to 21);

	end record;
	--===========--


	type fmc_la_io_settings_array	is array (0 to 34*3-1) of string(1 to 4); 
	type fmc_ha_io_settings_array	is array (0 to 24*3-1) of string(1 to 4); 
	type fmc_hb_io_settings_array	is array (0 to 22*3-1) of string(1 to 4);

	constant fmc_la_io_settings_defaults:fmc_la_io_settings_array:=
	(
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--fmc1_la00_cc 
		"cmos", "in__", "in__",		--fmc1_la01_cc 
		"cmos", "in__", "in__",		--fmc1_la02 
		"cmos", "in__", "in__",		--fmc1_la03 
		"cmos", "in__", "in__",		--fmc1_la04 
		"cmos", "in__", "in__",		--fmc1_la05 
		"cmos", "in__", "in__",		--fmc1_la06 
		"cmos", "in__", "in__",		--fmc1_la07 
		"cmos", "in__", "in__",		--fmc1_la08 
		"cmos", "in__", "in__",		--fmc1_la09 
		"cmos", "in__", "in__",		--fmc1_la10 
		"cmos", "in__", "in__",		--fmc1_la11 
		"cmos", "in__", "in__",		--fmc1_la12 
		"cmos", "in__", "in__",		--fmc1_la13 
		"cmos", "in__", "in__",		--fmc1_la14 
		"cmos", "in__", "in__",		--fmc1_la15 
		"cmos", "in__", "in__",		--fmc1_la16 
		"cmos", "in__", "in__",		--fmc1_la17_cc 
		"cmos", "in__", "in__",		--fmc1_la18_cc
		"cmos", "in__", "in__",		--fmc1_la19 
		"cmos", "in__", "in__",		--fmc1_la20 
		"cmos", "in__", "in__",		--fmc1_la21 
		"cmos", "in__", "in__",		--fmc1_la22 
		"cmos", "in__", "in__",		--fmc1_la23 
		"cmos", "in__", "in__",		--fmc1_la24 
		"cmos", "in__", "in__",		--fmc1_la25 
		"cmos", "in__", "in__",		--fmc1_la26 
		"cmos", "in__", "in__",		--fmc1_la27 
		"cmos", "in__", "in__",		--fmc1_la28 
		"cmos", "in__", "in__",		--fmc1_la29 
		"cmos", "in__", "in__",		--fmc1_la30 
		"cmos", "in__", "in__",		--fmc1_la31 
		"cmos", "in__", "in__",		--fmc1_la32 
		"cmos", "in__", "in__"		--fmc1_la33 
	);         	
              	
	constant fmc_ha_io_settings_defaults:fmc_ha_io_settings_array:=
	(
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--fmc1_ha00_cc 
		"cmos", "in__", "in__",		--fmc1_ha01_cc 
		"cmos", "in__", "in__",		--fmc1_ha02 
		"cmos", "in__", "in__",		--fmc1_ha03 
		"cmos", "in__", "in__",		--fmc1_ha04 
		"cmos", "in__", "in__",		--fmc1_ha05 
		"cmos", "in__", "in__",		--fmc1_ha06 
		"cmos", "in__", "in__",		--fmc1_ha07 
		"cmos", "in__", "in__",		--fmc1_ha08 
		"cmos", "in__", "in__",		--fmc1_ha09 
		"cmos", "in__", "in__",		--fmc1_ha10 
		"cmos", "in__", "in__",		--fmc1_ha11 
		"cmos", "in__", "in__",		--fmc1_ha12 
		"cmos", "in__", "in__",		--fmc1_ha13 
		"cmos", "in__", "in__",		--fmc1_ha14 
		"cmos", "in__", "in__",		--fmc1_ha15 
		"cmos", "in__", "in__",		--fmc1_ha16 
		"cmos", "in__", "in__",		--fmc1_ha17_cc 
		"cmos", "in__", "in__",		--fmc1_ha18 
		"cmos", "in__", "in__",		--fmc1_ha19 
		"cmos", "in__", "in__",		--fmc1_ha20 
		"cmos", "in__", "in__",		--fmc1_ha21 
		"cmos", "in__", "in__",		--fmc1_ha22 
		"cmos", "in__", "in__"		--fmc1_ha23 
	);        

	constant fmc_hb_io_settings_defaults:fmc_hb_io_settings_array:=
	( 
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--fmc1_hb00_cc 
		"cmos", "in__", "in__",		--fmc1_hb01 
		"cmos", "in__", "in__",		--fmc1_hb02 
		"cmos", "in__", "in__",		--fmc1_hb03 
		"cmos", "in__", "in__",		--fmc1_hb04 
		"cmos", "in__", "in__",		--fmc1_hb05 
		"cmos", "in__", "in__",		--fmc1_hb06_cc 
		"cmos", "in__", "in__",		--fmc1_hb07 
		"cmos", "in__", "in__",		--fmc1_hb08 
		"cmos", "in__", "in__",		--fmc1_hb09 
		"cmos", "in__", "in__",		--fmc1_hb10 
		"cmos", "in__", "in__",		--fmc1_hb11 
		"cmos", "in__", "in__",		--fmc1_hb12 
		"cmos", "in__", "in__",		--fmc1_hb13 
		"cmos", "in__", "in__",		--fmc1_hb14 
		"cmos", "in__", "in__",		--fmc1_hb15 
		"cmos", "in__", "in__",		--fmc1_hb16 
		"cmos", "in__", "in__",		--fmc1_hb17_cc 
		"cmos", "in__", "in__",		--fmc1_hb18 
		"cmos", "in__", "in__",		--fmc1_hb19 
		"cmos", "in__", "in__",		--fmc1_hb20 
		"cmos", "in__", "in__"	   --fmc1_hb21
	);      






							
--	type record_type_array 	is array(natural range <>) of record_type;
end fmc_package;
   
package body fmc_package is
end fmc_package;