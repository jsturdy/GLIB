library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity registers is
port(

    fabric_clk_i    : in std_logic;
    reset_i         : in std_logic;

    wbus_i          : in registers_wbus;
    rbus_o          : out registers_rbus

);
end registers;

architecture Behavioral of registers is
begin

    process(fabric_clk_i)

        variable registers  : registers_array := (others => (others => '0'));

    begin

        if (rising_edge(fabric_clk_i)) then

            if (reset_i = '1') then

                registers := (others => (others => '0'));

            else

                for i in 0 to 255
                loop

                    if (wbus_i.en(i) = '1') then

                        registers(i) := wbus_i.data(i);

                    end if;

                end loop;

            end if;

            rbus_o.data <= registers;

        end if;

    end process;

end Behavioral;
