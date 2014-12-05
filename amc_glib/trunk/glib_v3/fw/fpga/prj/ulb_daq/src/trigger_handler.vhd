library ieee;
use ieee.std_logic_1164.all;

entity trigger_handler is
port(

    fabric_clk_i        : in std_logic;
    reset_i             : in std_logic;

    req_trigger_i       : in std_logic;
    delayed_trigger_i   : in std_logic;
    ext_trigger_i       : in std_logic;
    
    trigger_config_i    : in std_logic_vector(1 downto 0);

    lv1a_o              : out std_logic

);
end trigger_handler;

architecture Behavioral of trigger_handler is
begin

    process(fabric_clk_i)
    begin
    
        if (rising_edge(fabric_clk_i)) then
        
            if (reset_i = '1') then
            
                lv1a_o <= '0';
                
            else
            
                -- Internal trigger only
                if (trigger_config_i = "00") then
                
                    lv1a_o <= req_trigger_i or delayed_trigger_i;
                    
                -- External trigger only
                elsif (trigger_config_i = "01") then
                
                    lv1a_o <= ext_trigger_i;
                
                -- Both internal and external triggers
                elsif (trigger_config_i = "10") then
            
                    lv1a_o <= req_trigger_i or delayed_trigger_i or ext_trigger_i; 
                
                -- No triggers
                else
                
                    lv1a_o <= '0';
            
                end if;
            
            end if;
        
        end if;
    
    end process;

end Behavioral;

