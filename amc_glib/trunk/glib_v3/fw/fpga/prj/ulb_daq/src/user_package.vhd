library ieee;
use ieee.std_logic_1164.all;
 
package user_package is
    
    --=== Package types ==========--
    
    constant def_gtp_idle       : std_logic_vector(7 downto 0) := x"00";  
    constant def_gtp_vi2c       : std_logic_vector(7 downto 0) := x"01";  
    constant def_gtp_tracks     : std_logic_vector(7 downto 0) := x"02";  
    constant def_gtp_regs       : std_logic_vector(7 downto 0) := x"03";  
    constant def_gtp_trigger    : std_logic_vector(7 downto 0) := x"04";  
    
    --=== Custom types ==========--
    
    type array192 is array(integer range <>) of std_logic_vector(191 downto 0);
    type array32 is array(integer range <>) of std_logic_vector(31 downto 0);
    
end user_package;
   
package body user_package is
end user_package;