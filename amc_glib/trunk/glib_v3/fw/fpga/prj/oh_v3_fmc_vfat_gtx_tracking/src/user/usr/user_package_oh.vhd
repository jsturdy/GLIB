library ieee;
use ieee.std_logic_1164.all;
 
package user_package is

    --=== system options ========--
    constant sys_eth_p1_enable          : boolean := false;   
    constant sys_pcie_enable            : boolean := false;      

    --=== i2c master components ==--
    constant i2c_master_enable			: boolean := true;
    constant auto_eeprom_read_enable    : boolean := true;    

    --=== wishbone slaves ========--
    constant number_of_wb_slaves        : positive := 1;

    constant user_wb_regs               : integer := 0;
    constant user_wb_timer				: integer  := 1 ;


    --=== ipb slaves =============--
    constant number_of_ipb_slaves       : positive := 1;

    constant ipbus_vfat2                : integer := 0;
    --=== Package types ==========--  
    
    constant def_gtx_idle       : std_logic_vector(7 downto 0) := x"00";  
    constant def_gtx_vfat2      : std_logic_vector(7 downto 0) := x"01";  
    constant def_gtx_tracking   : std_logic_vector(7 downto 0) := x"02";  
    constant def_gtx_lv1a       : std_logic_vector(7 downto 0) := x"03";  
    constant def_gtx_calpulse   : std_logic_vector(7 downto 0) := x"04";  
    constant def_gtx_resync     : std_logic_vector(7 downto 0) := x"05";  
    constant def_gtx_bc0        : std_logic_vector(7 downto 0) := x"06";  
    constant def_gtx_oh_res     : std_logic_vector(7 downto 0) := x"07";  
    constant def_gtx_v_hres     : std_logic_vector(7 downto 0) := x"08";  
    constant def_gtx_v_bres     : std_logic_vector(7 downto 0) := x"09";  
    constant def_gtx_oh_regs    : std_logic_vector(7 downto 0) := x"0A";  
    
    --=== Package types ==========--
    constant def_gtp_idle       : std_logic_vector(7 downto 0) := x"00";  
    constant def_gtp_vi2c       : std_logic_vector(7 downto 0) := x"01";  
    constant def_gtp_tracks     : std_logic_vector(7 downto 0) := x"02";  
    constant def_gtp_regs       : std_logic_vector(7 downto 0) := x"03";  
    
    --=== Custom types ==========--    
    type array192 is array(integer range <>) of std_logic_vector(191 downto 0);    type array32 is array(integer range <>) of std_logic_vector(31 downto 0);
	 
end user_package;
   
package body user_package is
end user_package;