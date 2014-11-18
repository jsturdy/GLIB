library ieee;
use ieee.std_logic_1164.all;

package user_package is

	--=== system options ========--
    
   constant sys_eth_p1_enable           : boolean  := false;
   constant sys_pcie_enable             : boolean  := false;

	--=== i2c master components ==--
    
	constant i2c_master_enable          : boolean  := true;
	constant auto_eeprom_read_enable    : boolean  := true;

	--=== wishbone slaves ========--
    
	constant number_of_wb_slaves        : positive := 1;

	constant user_wb_regs               : integer  := 0;

	--=== ipb slaves =============--
    
	constant number_of_ipb_slaves       : positive := 13;
    
    constant ipb_vi2c_0                 : integer := 0;
    constant ipb_vi2c_1                 : integer := 1;
    constant ipb_vi2c_2                 : integer := 2;
    
    constant ipb_track_0                : integer := 3;
    constant ipb_track_1                : integer := 4;
    constant ipb_track_2                : integer := 5;
    
    constant ipb_regs_0                 : integer := 6;
    constant ipb_regs_1                 : integer := 7;
    constant ipb_regs_2                 : integer := 8;
    
    constant ipb_info_0                 : integer := 9;
    constant ipb_info_1                 : integer := 10;
    constant ipb_info_2                 : integer := 11;
    
    constant ipb_trigger                : integer := 12;

    --=== Package types ==========--
    
    constant def_gtx_idle               : std_logic_vector(7 downto 0) := x"00";  
    constant def_gtx_vi2c               : std_logic_vector(7 downto 0) := x"01";  
    constant def_gtx_tracks             : std_logic_vector(7 downto 0) := x"02";  
    constant def_gtx_regs               : std_logic_vector(7 downto 0) := x"03"; 
    constant def_gtx_trigger            : std_logic_vector(7 downto 0) := x"04"; 

    type array32 is array(integer range <>) of std_logic_vector(31 downto 0);    

end user_package;

package body user_package is
end user_package;
