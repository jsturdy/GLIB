library ieee;
use ieee.std_logic_1164.all;

entity trigger_sbits is
port(

    vfat2_0_sbits   : in std_logic_vector(7 downto 0);
    vfat2_1_sbits   : in std_logic_vector(7 downto 0);
    vfat2_2_sbits   : in std_logic_vector(7 downto 0);
    vfat2_3_sbits   : in std_logic_vector(7 downto 0);
    vfat2_4_sbits   : in std_logic_vector(7 downto 0);
    vfat2_5_sbits   : in std_logic_vector(7 downto 0);

    sbit_config_i   : in std_logic_vector(2 downto 0);

    to_tdc_o        : out std_logic

);
end trigger_sbits;

architecture Behavioral of trigger_sbits is

    signal orbits   : std_logic_vector(5 downto 0) := (others => '0');

begin

    orbits(0) <= vfat2_0_sbits(0) or vfat2_0_sbits(1) or vfat2_0_sbits(2) or vfat2_0_sbits(3) or vfat2_0_sbits(4) or vfat2_0_sbits(5) or vfat2_0_sbits(6) or vfat2_0_sbits(7);
    orbits(1) <= vfat2_1_sbits(0) or vfat2_1_sbits(1) or vfat2_1_sbits(2) or vfat2_1_sbits(3) or vfat2_1_sbits(4) or vfat2_1_sbits(5) or vfat2_1_sbits(6) or vfat2_1_sbits(7);
    orbits(2) <= vfat2_2_sbits(0) or vfat2_2_sbits(1) or vfat2_2_sbits(2) or vfat2_2_sbits(3) or vfat2_2_sbits(4) or vfat2_2_sbits(5) or vfat2_2_sbits(6) or vfat2_2_sbits(7);
    orbits(3) <= vfat2_3_sbits(0) or vfat2_3_sbits(1) or vfat2_3_sbits(2) or vfat2_3_sbits(3) or vfat2_3_sbits(4) or vfat2_3_sbits(5) or vfat2_3_sbits(6) or vfat2_3_sbits(7);
    orbits(4) <= vfat2_4_sbits(0) or vfat2_4_sbits(1) or vfat2_4_sbits(2) or vfat2_4_sbits(3) or vfat2_4_sbits(4) or vfat2_4_sbits(5) or vfat2_4_sbits(6) or vfat2_4_sbits(7);
    orbits(5) <= vfat2_5_sbits(0) or vfat2_5_sbits(1) or vfat2_5_sbits(2) or vfat2_5_sbits(3) or vfat2_5_sbits(4) or vfat2_5_sbits(5) or vfat2_5_sbits(6) or vfat2_5_sbits(7);

    to_tdc_o <= orbits(0) when sbit_config_i = "000" else
                orbits(1) when sbit_config_i = "001" else
                orbits(2) when sbit_config_i = "010" else
                orbits(3) when sbit_config_i = "011" else
                orbits(4) when sbit_config_i = "100" else
                orbits(5) when sbit_config_i = "101" else
                '0';

end Behavioral;

