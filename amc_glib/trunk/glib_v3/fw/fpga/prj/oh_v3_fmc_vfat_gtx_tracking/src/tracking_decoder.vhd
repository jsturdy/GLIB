library ieee;
use ieee.std_logic_1164.all;

entity tracking_decoder is
port(

    vfat2_clk_i     : in std_logic;
    reset_i         : in std_logic;
    
    en_i            : in std_logic;
    data_i          : in std_logic;
    
    en_o            : out std_logic;
    data_o          : out std_logic_vector(191 downto 0)
    
);
end tracking_decoder;

architecture Behavioral of tracking_decoder is
begin

    process(vfat2_clk_i)
    
        variable state      : integer range 0 to 3 := 0;
    
        variable data       : std_logic_vector(191 downto 0) := (others => '0'); -- MSB sent first
        variable data_cnt   : integer range 0 to 192 := 0;
        
    begin
    
        if (rising_edge(vfat2_clk_i)) then
        
            if (reset_i = '1') then
            
                en_o <= '0';
                
                state := 0;      
                
            else
            
                -- Wait state
                if (state = 0) then
                
                    en_o <= '0';
                
                    if (en_i = '1') then
                    
                        data(191) := data_i;
                        
                        data_cnt := 190;
                    
                        state := 1;
                        
                    end if;
                
                -- Collect data
                elsif (state = 1) then
                
                    if (en_i = '1') then
                    
                        data(data_cnt) := data_i;
                        
                        if (data_cnt = 0) then
                        
                            state := 2;
                            
                        else
                        
                            data_cnt := data_cnt - 1;
                            
                        end if;
                    
                    else
                    
                        state := 0;
                        
                    end if;
                
                -- Data ready
                elsif (state = 2) then
                
                    data_o <= data;
                
                    en_o <= '1';
                    
                    state := 0;
                    
                else
                
                    en_o <= '0';
                
                    state := 0;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;
    
end Behavioral;