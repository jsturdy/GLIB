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
        
        variable en         : std_logic_vector(7 downto 0) := (others => '0');
        variable data       : array192(7 downto 0) := (others => (others => '0'));
        
        variable cnt        : integer range 0 to 7 := 0;
        
        variable bx_data    : std_logic_vector(31 downto 0) := (others => '0');
    
    begin
    
        if (rising_edge(vfat2_clk_i)) then
        
            if (reset_i = '1') then
            
                fifo_read_o <= '0';
            
                en_o <= '0';
                
                state := 0;
            
            else
            
                -- Buffer incoming data
                if (state = 0) then
                
                    en_o <= '0';
                           
                    if (en_i /= "00000000") then
                        
                        en := en_i;
                        data := data_i;
                        
                        cnt := 0;
                        
                        state := 1;
                    
                    end if;
                    
                -- Request BX number
                elsif (state = 1) then
                
                    fifo_read_o <= '1';
                    
                    state := 2;
                    
                elsif (state = 2) then
                    
                    fifo_read_o <= '0';
                   
                    if (fifo_valid_i = '1') then
                    
                        bx_data := fifo_data_i;
                        
                        state := 3;
                        
                    elsif (fifo_underflow_i = '1') then
                        
                        bx_data := (others => '0');
                        
                        state := 3;
                        
                    end if;
                    
                -- Collect tracking data
                elsif (state = 3) then
                
                    -- Reject empty packets
                    if (en(cnt) = '1') then
                
                        data_o <= bx_data & data(cnt);
                    
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

