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
    constant number_of_ipb_slaves       : positive := 5;

    constant ipbus_optohybrid_start_nb  : integer := 0;
    constant ipbus_optohybrid_slave_nb  : integer := 1;
    constant ipbus_vfat2_slave_nb       : integer := 2;
    constant ipbus_tracking_slave_nb    : integer := 3;
    constant ipb_eff                    : integer := 4;
    
    --=== Package types ==========--
    constant def_gtx_idle               : std_logic_vector(7 downto 0) := x"08";  
    constant def_gtx_vfat2_request      : std_logic_vector(7 downto 0) := x"04";  
    constant def_gtx_optohybrid_request : std_logic_vector(7 downto 0) := x"03";  
    constant def_gtx_tracking_data      : std_logic_vector(7 downto 0) := x"00";  
    
end user_package;
   
package body user_package is
end user_package;