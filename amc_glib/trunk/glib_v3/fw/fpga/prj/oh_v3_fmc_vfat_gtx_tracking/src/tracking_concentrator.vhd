library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity tracking_concentrator is
port(

    vfat2_clk_i : in std_logic;
    reset_i     : in std_logic;
    
    en_i        : in std_logic_vector(7 downto 0);
    data_i      : in array192(7 downto 0);
    
    en_o        : out std_logic;
    data_o      : out std_logic_vector(191 downto 0)
    
);
end tracking_concentrator;

architecture Behavioral of tracking_concentrator is
begin  
    
    process(vfat2_clk_i)
    
        variable state  : integer range 0 to 1 := 0;
        variable cnt    : integer range 0 to 7 := 0;
    
    begin
    
        if (rising_edge(vfat2_clk_i)) then
        
            if (reset_i = '1') then
            
                en_o <= '0';
                
                state := 0;
            
            else
            
                if (state = 0) then
                
                    en_o <= '0';
                
                    if (en_i /= "00000000") then
                        
                        cnt := 0;
                        
                        state := 1;
                    
                    end if;
                    
                elsif (state = 1) then
                
                    -- Reject empty packets
                    if ((data_i(cnt)(191 downto 188) /= "1111") and (data_i(cnt)(191 downto 188) /= "0000")) then
                
                        data_o <= data_i(cnt);
                    
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
                
                    en_o <= '0';
                    
                    state := 0;

                end if;
                
            end if;
        
        end if;
    
    end process; 
    
end Behavioral;

