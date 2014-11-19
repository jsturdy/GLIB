library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity t1_delayed is
port(

    fabric_clk_i   : in std_logic;
    reset_i     : in std_logic;

    en_i        : in std_logic;
    delay_i     : in std_logic_vector(31 downto 0);   
    
    lv1a_o      : out std_logic;
    calpulse_o  : out std_logic

);
end t1_delayed;

architecture Behavioral of t1_delayed is
begin

    process(fabric_clk_i)
    
        variable state      : integer range 0 to 3;
        
        variable counter    : unsigned(31 downto 0) := (others => '0');
    
    begin

        if (rising_edge(fabric_clk_i)) then

            if (reset_i = '1') then

                lv1a_o <= '0';
                
                calpulse_o <= '0';
                
                state := 0;

            else
            
                if (state = 0) then
                    
                    calpulse_o <= '0';
            
                    if (en_i = '1') then
                    
                        state := 1;
                        
                    end if;
                
                elsif (state = 1) then
                
                    lv1a_o <= '1';
                    
                    counter(31 downto 2) := unsigned(delay_i(29 downto 0));
                    counter(1 downto 0) := "00";
                    
                    state := 2;
                
                elsif (state = 2) then
                
                    lv1a_o <= '0';
                    
                    if (counter = 0) then
                    
                        calpulse_o <= '1';
                    
                        state := 0;
                        
                    else
                    
                        counter := counter - 1;
                        
                    end if;
                    
                else

                    lv1a_o <= '0';
                    
                    calpulse_o <= '0';
                    
                    state := 0;
                
                end if;

            end if;

        end if;

    end process;

end Behavioral;

