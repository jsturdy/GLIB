library ieee;
use ieee.std_logic_1164.all;
use work.user_ipaddr_package.all;

entity ipaddr_lut is
  port ( address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(31 downto 0) );
end entity ipaddr_lut;

architecture behavioral of ipaddr_lut is
  type mem is array ( 0 to 2**4 - 1) of std_logic_vector(31 downto 0);
  constant my_Rom : mem := (
    0  => ipaddr_lut_value(0),
    1  => ipaddr_lut_value(1),
    2  => ipaddr_lut_value(2),
    3  => ipaddr_lut_value(3),
    4  => ipaddr_lut_value(4),
    5  => ipaddr_lut_value(5),
    6  => ipaddr_lut_value(6),
    7  => ipaddr_lut_value(7),
    8  => ipaddr_lut_value(8),
    9  => ipaddr_lut_value(9),
    10 => ipaddr_lut_value(10),
    11 => ipaddr_lut_value(11),
    12 => ipaddr_lut_value(12),
    13 => ipaddr_lut_value(13),
    14 => ipaddr_lut_value(14),
    15 => ipaddr_lut_value(15));
begin
   process (address)
   begin
     case address is
       when "0000" => data <= my_rom(0);
       when "0001" => data <= my_rom(1);
       when "0010" => data <= my_rom(2);
       when "0011" => data <= my_rom(3);
       when "0100" => data <= my_rom(4);
       when "0101" => data <= my_rom(5);
       when "0110" => data <= my_rom(6);
       when "0111" => data <= my_rom(7);
       when "1000" => data <= my_rom(8);
       when "1001" => data <= my_rom(9);
       when "1010" => data <= my_rom(10);
       when "1011" => data <= my_rom(11);
       when "1100" => data <= my_rom(12);
       when "1101" => data <= my_rom(13);
       when "1110" => data <= my_rom(14);
       when "1111" => data <= my_rom(15);
       when others => data <= (others=>'0');
	 end case;
  end process;
end architecture behavioral;