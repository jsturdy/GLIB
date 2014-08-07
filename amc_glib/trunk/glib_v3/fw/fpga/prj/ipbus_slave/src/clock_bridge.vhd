library ieee;
use ieee.std_logic_1164.all;

entity clock_bridge is
port(
    reset_i     : in std_logic;
    
    m_clk_i     : in std_logic;
    m_en_i      : in std_logic;
    m_data_i    : in std_logic_vector;
    
    s_clk_i     : in std_logic;
    s_en_o      : out std_logic;
    s_data_o    : out std_logic_vector
);
end clock_bridge;

architecture behavioral of clock_bridge is

    -- Strobes count
    signal cnt_in : integer range 0 to 3 := 0;
    signal cnt_out : integer range 0 to 3 := 0;
    
begin

    -- Input clock
    process(m_clk_i)
    begin
    
        if (rising_edge(m_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                cnt_in <= 0;
                
            else
            
                -- Input strobe
                if (m_en_i = '1') then
                    
                    -- Check if the module is busy
                    if (cnt_in = cnt_out) then
                        
                        -- increment the strobe counter
                        if (cnt_in = 3) then
                        
                            cnt_in <= 0;
                            
                        else
                        
                            cnt_in <= cnt_in + 1;
                            
                        end if;
                        
                        -- and register the data
                        s_data_o <= m_data_i;
                        
                    end if;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;
    
    -- Output clock
    process(s_clk_i)
    begin
    
        if (rising_edge(s_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                s_en_o <= '0';
                
                cnt_out <= 0;
                
            else       

                -- Check if a strobe is waiting
                if (cnt_in /= cnt_out) then
                    
                    -- If so, set an output strobe
                    s_en_o <= '1';
                    
                    -- Increment the output strobe counter
                    if (cnt_out = 3) then
                    
                        cnt_out <= 0;
                        
                    else
                    
                        cnt_out <= cnt_out + 1;
                        
                    end if;
                
                -- Otherwhise
                else
                    
                    -- and the strobe
                    s_en_o <= '0';
                    
                end if;
                
            end if;
            
        end if;
        
    end process;    

end behavioral;