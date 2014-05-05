library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testGtx is
port(
    clk         : in std_logic;
    tx_strobe   : out std_logic;
    tx_kchar    : out std_logic_vector(1 downto 0);
    tx_data     : out std_logic_vector(15 downto 0)
);
end testGtx;

architecture Behavioral of testGtx is
begin

    process(clk)
        variable state : integer range 0 to 1023 := 0;
    begin
        if (rising_edge(clk)) then
            if (state mod 4 = 0) then
                tx_data <= std_logic_vector(to_unsigned(state, 8)) & x"BC";
                tx_kchar <= "01";
                tx_strobe <= '1';
            else
                tx_strobe <= '0';
            end if;
        
            if (state = 1023) then
                state := 0;
            else
                state := state + 1;
            end if;
        end if;
    end process;

end Behavioral;

