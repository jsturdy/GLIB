library ieee;
use ieee.std_logic_1164.all;

entity trigger_sbits is
port(

    sbits_i         : in std_logic_vector(5 downto 0);

    sbit_config_i   : in std_logic_vector(2 downto 0);

    to_tdc_o        : out std_logic

);
end trigger_sbits;

architecture Behavioral of trigger_sbits is

    signal orbits   : std_logic_vector(5 downto 0) := (others => '0');

begin

    to_tdc_o <= sbits_i(0) when sbit_config_i = "000" else
                sbits_i(1) when sbit_config_i = "001" else
                sbits_i(2) when sbit_config_i = "010" else
                sbits_i(3) when sbit_config_i = "011" else
                sbits_i(4) when sbit_config_i = "100" else
                sbits_i(5) when sbit_config_i = "101" else
                '0';

end Behavioral;

