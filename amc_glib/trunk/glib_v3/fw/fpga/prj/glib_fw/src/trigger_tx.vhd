library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity trigger_tx is
port(

    gtx_clk_i   : in std_logic;
    reset_i     : in std_logic;

    tx_kchar_o  : out std_logic_vector(1 downto 0);
    tx_data_o   : out std_logic_vector(15 downto 0)
    
);
end trigger_tx;

architecture Behavioral of trigger_tx is
begin
   
    process(gtx_clk_i) 
    
        -- Last kchar sent
        variable kchar_count    : integer range 0 to 1023 := 0;

    begin
    
        if (rising_edge(gtx_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                tx_kchar_o <= "00";
                
                tx_data_o <= def_gtx_idle & x"BC";
                
                kchar_count := 0;
                
            else
            
                tx_data_o <= def_gtx_idle & x"BC"; -- Idle code
                
                if (kchar_count = 1023) then
                
                    -- Set kchar
                    tx_kchar_o <= "01";
                    
                    kchar_count := 0;
                    
                else
               
                    -- Clear kchar
                    tx_kchar_o <= "00";
                    
                    kchar_count := kchar_count + 1;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;

end Behavioral;