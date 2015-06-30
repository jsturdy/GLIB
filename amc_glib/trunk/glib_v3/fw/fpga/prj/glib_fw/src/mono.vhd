library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mono is
generic(
    COUNT   : integer := 50_000_000
);
port(
    clk_i   : in std_logic;
    en_i    : in std_logic;
    en_o    : out std_logic
);
end mono;

architecture Behavioral of mono is

    -- Counter used to divide the clock
    signal counter  : unsigned(31 downto 0) := (others => '0');

begin

    process(clk_i)
    begin
    
        if (rising_edge(clk_i)) then

            -- The clock is high for half the time
            if (counter > COUNT / 2) then
                en_o <= '1';
            -- And low the remaining half
            else
                en_o <= '0';
            end if;
            
            -- Increment the counter and reset it when the limit is reached
            if (counter = 0) then
                if (en_i = '1') then
                    counter <= to_unsigned(COUNT, 32);
                end if;
            else
                counter <= counter - 1;
            end if;
            
        end if;

    end process;

end Behavioral;