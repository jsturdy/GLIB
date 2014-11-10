library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
port(
    
    fabric_clk_i    : in std_logic;
    reset_i         : in std_logic;
    
    en_i            : in std_logic;
    data_o          : out std_logic_vector(31 downto 0)
    
);
end counter;

architecture Behavioral of counter is
begin

    process(fabric_clk_i)
    
        variable count  : unsigned(31 downto 0) := (others => '0');
    
    begin

        if (rising_edge(fabric_clk_i)) then
        
            if (reset_i = '1') then
            
                count := (others => '0');
                
            else
            
                if (en_i = '1') then
                
                    count := count + 1;
                    
                end if;
                
                data_o <= std_logic_vector(count);
                
            end if;
        
        end if;
    
    end process;

end Behavioral;
