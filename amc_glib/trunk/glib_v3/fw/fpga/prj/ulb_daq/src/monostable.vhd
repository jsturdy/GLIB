library ieee;
use ieee.std_logic_1164.all;

entity monostable is
port(

    fabric_clk_i    : in std_logic;
    en_i            : in std_logic;

    en_o            : out std_logic

);
end monostable;

architecture Behavioral of monostable is
begin

    process(fabric_clk_i)

        variable last   : std_logic := '0';

    begin

        if (rising_edge(fabric_clk_i)) then

            if (en_i = '1' and last = '0') then

                en_o <= '1';

            else

                en_o <= '0';

            end if;

            last := en_i;

        end if;

    end process;

end Behavioral;

