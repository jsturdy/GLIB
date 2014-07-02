library ieee;
use ieee.std_logic_1164.all;

entity xclock_en is
port(
    reset_i     : in std_logic;
    clk_a_i     : in std_logic;
    clk_b_i     : in std_logic;
    en_a_i      : in std_logic;
    en_b_o      : out std_logic;
    failed_o    : out std_logic
);
end xclock_en;

architecture behavioral of xclock_en is

    -- Strobes count
    signal cnt_in   : integer range 0 to 7 := 0;
    signal cnt_out  : integer range 0 to 7 := 0;
    
begin

    -- Input clock
    process(clk_a_i)
    begin
    
        if (rising_edge(clk_a_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                failed_o <= '0';
                
                cnt_in <= 0;
                
            else
            
                -- Input strobe
                if (en_a_i = '1') then
                    
                    -- Check if the module is busy
                    if (cnt_in = cnt_out) then
                    
                        -- If not, reset the failed flag
                        failed_o <= '0';
                        
                        -- increment the strobe counter
                        cnt_in <= cnt_in + 1;
                        
                    -- Otherwhise
                    else
                    
                        -- Set the failed flag
                        failed_o <= '1';
                        
                    end if;
                    
                else
                
                    -- Reset the failed flag
                    failed_o <= '0';
                    
                end if;
                
            end if;
            
        end if;
        
    end process;
    
    -- Output clock
    process(clk_b_i)
    begin
    
        if (rising_edge(clk_b_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                en_b_o <= '0';
                
                cnt_out <= 0;
                
            else       

                -- Check if a strobe is waiting
                if (cnt_in /= cnt_out) then
                    
                    -- If so, set an output strobe
                    en_b_o <= '1';
                    
                    -- Increment the output strobe counter
                    cnt_out <= cnt_out + 1;
                
                -- Otherwhise
                else
                    
                    -- and the strobe
                    en_b_o <= '0';
                    
                end if;
                
            end if;
            
        end if;
        
    end process;    

end behavioral;

