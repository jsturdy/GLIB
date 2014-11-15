library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity adc_switch is
port(

    fabric_clk_i    : in std_logic;
    reset_i         : in std_logic;

    uart_en_i       : in std_logic;
    uart_data_i     : in std_logic_vector(7 downto 0);

    wbus_o          : out array32(1 downto 0)

);
end adc_switch;

architecture Behavioral of adc_switch is

    signal data : array32(1 downto 0) := (others => (others => '0'));

begin

    process(fabric_clk_i)
    begin
    
        if (rising_edge(fabric_clk_i)) then
        
            if (reset_i = '1') then
                
            else
            
                if (uart_en_i = '1') then
                
                    if (uart_data_i(7 downto 6) = "00") then
                    
                        data(0)(5 downto 0) <= uart_data_i(5 downto 0);
                        
                    elsif (uart_data_i(7 downto 6) = "01") then
                    
                        data(0)(11 downto 6) <= uart_data_i(5 downto 0);
                        
                    elsif (uart_data_i(7 downto 6) = "10") then
                    
                        data(1)(5 downto 0) <= uart_data_i(5 downto 0);
                        
                    elsif (uart_data_i(7 downto 6) = "11") then
                    
                        data(1)(11 downto 6) <= uart_data_i(5 downto 0);
                    
                    end if;
                
                end if;
            
            end if;
        
        end if;
    
    end process;
    
    wbus_o <= data;

end Behavioral;
