library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity tracking_concentrator is
port(

    vfat2_clk_i         : in std_logic;
    reset_i             : in std_logic;
    
    en_i                : in std_logic_vector(7 downto 0);
    data_i              : in array192(7 downto 0);
    
    fifo_read_o         : out std_logic;
    fifo_valid_i        : in std_logic;
    fifo_underflow_i    : in std_logic;
    fifo_data_i         : in std_logic_vector(31 downto 0);
    
    en_o                : out std_logic;
    data_o              : out std_logic_vector(223 downto 0)
    
);
end tracking_concentrator;

architecture Behavioral of tracking_concentrator is
begin  
    
    process(vfat2_clk_i)
    
        variable state      : integer range 0 to 3 := 0;
        
        variable cnt        : integer range 0 to 7 := 0;
        
        variable bx_data    : std_logic_vector(31 downto 0) := (others => '0');
    
    begin
    
        if (rising_edge(vfat2_clk_i)) then
        
            if (reset_i = '1') then
            
                fifo_read_o <= '0';
            
                en_o <= '0';
                
                state := 0;
            
            else
            
                -- Request BX number
                if (state = 0) then
                
                    fifo_read_o <= '1';
                
                    en_o <= '0';
                    
                    state := 1;
                    
                elsif (state = 1) then
                    
                    fifo_read_o <= '0';
                   
                    if (fifo_valid_i = '1') then
                    
                        bx_data := fifo_data_i;
                        
                        state := 2;
                        
                    elsif (fifo_underflow_i = '1') then
                        
                        state := 0;
                        
                    end if;
                
                -- Wait for tracking data to arrive
                elsif (state = 2) then
                
                    if (en_i /= "00000000") then
                        
                        cnt := 0;
                        
                        state := 3;
                    
                    end if;
                    
                -- Collect tracking data
                elsif (state = 3) then
                
                    -- Reject empty packets
                    if ((data_i(cnt)(191 downto 188) /= "1111") and (data_i(cnt)(191 downto 188) /= "0000")) then
                
                        data_o <= bx_data & data_i(cnt);
                    
                        en_o <= '1';
                        
                    else
                    
                        en_o <= '0';
                        
                    end if;
                    
                    if (cnt = 7) then
                    
                        state := 0;
                    
                    else
                    
                        cnt := cnt + 1;
                        
                    end if;
                    
                else
            
                    fifo_read_o <= '0';
                
                    en_o <= '0';
                    
                    state := 0;

                end if;
                
            end if;
        
        end if;
    
    end process; 
    
end Behavioral;

