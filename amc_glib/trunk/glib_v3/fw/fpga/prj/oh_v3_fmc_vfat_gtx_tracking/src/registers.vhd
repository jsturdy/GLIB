library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity registers is
generic(
    SIZE            : integer := 128
);
port(

    fabric_clk_i    : in std_logic;
    reset_i         : in std_logic;

    wbus_i          : in array32((SIZE - 1) downto 0);
    wbus_t          : in std_logic_vector((SIZE - 1) downto 0);
    rbus_o          : out array32((SIZE - 1) downto 0)

);
end registers;

architecture Behavioral of registers is

    signal registers    : array32((SIZE - 1) downto 0) := (others => (others => '0'));
    
begin

    process(fabric_clk_i)
    begin

        if (rising_edge(fabric_clk_i)) then

            if (reset_i = '1') then

                registers <= (others => (others => '0'));

            else

                for i in 0 to (SIZE - 1)
                loop

                    if (wbus_t(i) = '1') then

                        registers(i) <= wbus_i(i);

                    end if;

                end loop;

            end if;

        end if;

    end process;
    
    rbus_o <= registers;

end Behavioral;
