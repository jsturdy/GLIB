library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity tracking_readout is
port(

    gtp_clk_i           : in std_logic;
    reset_i             : in std_logic;
    
    fifo_read_o         : out std_logic;
    fifo_valid_i        : in std_logic;
    fifo_underflow_i    : in std_logic;
    fifo_data_i         : in std_logic_vector(223 downto 0);
    
    tx_ready_o          : out std_logic;
    tx_done_i           : in std_logic;
    tx_data_o           : out std_logic_vector(223 downto 0)
    
);
end tracking_readout;

architecture Behavioral of tracking_readout is
begin  

    process(gtp_clk_i)
        
        variable state      : integer range 0 to 3 := 0;
        
        variable data       : std_logic_vector(223 downto 0) := (others => '0');    
    
    begin
    
        if (rising_edge(gtp_clk_i)) then
        
            if (reset_i = '1') then
            
                fifo_read_o <= '0';
            
                tx_ready_o <= '0';
                
                state := 0;
                
            else
            
                -- Request data
                if (state = 0) then
                
                    fifo_read_o <= '1';
                    
                    state := 1;
                
                -- Wait for valid
                elsif (state = 1) then
                
                    fifo_read_o <= '0';
                   
                    if (fifo_valid_i = '1') then
                    
                        data := fifo_data_i;
                        
                        state := 2;
                        
                    elsif (fifo_underflow_i = '1') then
                        
                        state := 0;
                        
                    end if;
                                        
                -- Set data ready
                elsif (state = 2) then
                
                    tx_data_o <= data;
                
                    tx_ready_o <= '1'; 
                    
                    if (tx_done_i = '1') then
                    
                        state := 3;
                        
                    end if;
                    
                -- Reset ready
                elsif (state = 3) then
                
                    tx_ready_o <= '0'; 
                    
                    state := 0;
                    
                else
            
                    fifo_read_o <= '0';
                
                    tx_ready_o <= '0';
                    
                    state := 0;
                    
                end if;
            
            end if;
        
        end if;
    
    end process;
    
end Behavioral;

