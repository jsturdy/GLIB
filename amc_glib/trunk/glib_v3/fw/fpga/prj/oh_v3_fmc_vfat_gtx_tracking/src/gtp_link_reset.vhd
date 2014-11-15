library ieee;
use ieee.std_logic_1164.all;

entity gtp_link_reset is
port(

    gtp_clk_i       : in std_logic;
    reset_i         : in std_logic;
    reset_done_i    : in std_logic;
    isaligned_i     : in std_logic;
    
    reset_o         : out std_logic

);
end gtp_link_reset;

architecture Behavioral of gtp_link_reset is
begin

    process(gtp_clk_i)
    
        variable state      : integer range 0 to 7 := 0;
    
        variable counter    : integer range 0 to 255 := 0;
    
    begin
        if (rising_edge(gtp_clk_i)) then
        
            if (reset_i = '1') then
            
                reset_o <= '1';
            
                state := 0;
           
            else
            
                if (reset_done_i = '1') then
                
                    if (isaligned_i = '1') then
                    
                        reset_o <= '0';
                    
                        counter := 0;
                        
                    else
                    
                        if (counter = 255) then
                        
                            reset_o <= '1';
                            
                            counter := 0;
                            
                        else
                        
                            reset_o <= '0';
                        
                            counter := counter + 1;
                            
                        end if;
                    
                    end if;
                
                else
                    
                    reset_o <= '0';
                    
                    state := 0;
                    
                end if;
                
            end if;
                
        end if;
    end process;

end Behavioral;

