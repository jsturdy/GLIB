library ieee;
use ieee.std_logic_1164.all;

entity clock_bridge_strobes is
port(

    reset_i : in std_logic;
    
    m_clk_i : in std_logic;
    m_en_i  : in std_logic_vector;
    
    s_clk_i : in std_logic;
    s_en_o  : out std_logic_vector
    
);
end clock_bridge_strobes;

architecture behavioral of clock_bridge_strobes is

    -- Status registers
    signal in_status    : std_logic_vector(m_en_i'length - 1 downto 0) := (others => '0');
    signal out_status   : std_logic_vector(m_en_i'length - 1 downto 0) := (others => '0');
    
begin

    -- Input clock
    process(m_clk_i)
    begin
    
        -- Work only at the rising edge
        if (rising_edge(m_clk_i)) then
        
            -- Reset signal
            if (reset_i = '1') then
            
                in_status <= (others => '0');
                
            else
            
                -- Loop over the signals
                for i in 0 to (m_en_i'length - 1)
                loop
                
                    -- Detect an input strobe
                    if (m_en_i(i) = '1') then
                    
                        -- Check if the module is busy
                        if (in_status(i) = out_status(i)) then
                        
                            -- If not, change the status
                            in_status(i) <= not in_status(i);
                            
                        end if;
                        
                    end if;
                    
                end loop;   
                
            end if;
            
        end if;
        
    end process;
    
    -- Output clock
    process(s_clk_i)
    begin
    
        -- Work only at the rising edge
        if (rising_edge(s_clk_i)) then
        
            -- Reset signal
            if (reset_i = '1') then
            
                s_en_o <= (others => '0');
                
                out_status <= (others => '0');
                
            else   
            
                -- Loop over the signals
                for i in 0 to (m_en_i'length - 1)
                loop  
                
                    -- Check if a strobe is waiting
                    if (in_status(i) /= out_status(i)) then
                    
                        -- If so, set an output strobe
                        s_en_o(i) <= '1';
                        
                        -- Change the status
                        out_status(i) <= not out_status(i);
                        
                    -- Otherwhise
                    else
                    
                        -- reset the strobe
                        s_en_o(i) <= '0';
                        
                    end if;
                    
                end loop;
                
            end if;
            
        end if;
        
    end process;    

end behavioral;