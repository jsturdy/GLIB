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
    constant number_of_ipb_slaves       : positive := 6;

    constant ipbus_vfat2_request_0      : integer := 0;
    constant ipbus_vfat2_request_1      : integer := 1;
    constant ipbus_vfat2_request_2      : integer := 2;
    
    constant ipbus_vfat2_response_0     : integer := 3;
    constant ipbus_vfat2_response_1     : integer := 4;
    constant ipbus_vfat2_response_2     : integer := 5;
  
    
    --=== Package types ==========--
    constant def_gtx_idle               : std_logic_vector(7 downto 0) := x"00";  
    constant def_gtx_vfat2              : std_logic_vector(7 downto 0) := x"01";  
    constant def_gtx_trigger            : std_logic_vector(7 downto 0) := x"02";  
    constant def_gtx_tracking           : std_logic_vector(7 downto 0) := x"03";  
    
end user_package;
   
package body user_package is
end user_package;