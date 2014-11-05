library ieee;
use ieee.std_logic_1164.all;

package user_package is

	--=== system options ========--
   constant sys_eth_p1_enable       		: boolean  := false;
   constant sys_pcie_enable         		: boolean  := false;

	--=== i2c master components ==--
	constant i2c_master_enable				: boolean  := true;
	constant auto_eeprom_read_enable		: boolean  := true;

	--=== wishbone slaves ========--
	constant number_of_wb_slaves			: positive := 1;

	constant user_wb_regs					: integer  := 0;
--	constant user_wb_timer					: integer  := 1;

	--=== ipb slaves =============--
	constant number_of_ipb_slaves			: positive := 2;

	constant ipb_glib_global_regs			: integer  := 0;
	constant ipb_glib_tracking_link0_regs	: integer  := 1;
	constant ipb_glib_tracking_link1_regs	: integer  := 2;
	constant ipb_glib_tracking_link2_regs	: integer  := 3;

	--=== custom types ===========--
	type registers_array is array(255 downto 0) of std_logic_vector(31 downto 0);

	type registers_rbus is
	record
		data 	: registers_array;
	end record;

	type registers_wbus is
	record
		en 		: std_logic_vector(255 downto 0);
		data 	: registers_array;
	end record;

end user_package;

package body user_package is
end user_package;
