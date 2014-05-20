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
    --	constant user_wb_timer				: integer  := 1 ;


    --=== ipb slaves =============--
    constant number_of_ipb_slaves       : positive := 1;

    constant ipbus_vfat2_slave_nb       : integer := 0;
    
    --=== Package types ==========--
    constant def_gtx_idle               : std_logic_vector(7 downto 0) := x"08";  
    constant def_gtx_vfat2_request      : std_logic_vector(7 downto 0) := x"04";  
    
end user_package;
   
package body user_package is
end user_package;