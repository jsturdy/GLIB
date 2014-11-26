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

    voltage_o       : out std_logic_vector(31 downto 0);
    current_o       : out std_logic_vector(31 downto 0)

);
end adc_switch;

architecture Behavioral of adc_switch is
begin

    process(fabric_clk_i)

        variable voltage    : std_logic_vector(31 downto 0) := (others => '0');
        
        variable current    : std_logic_vector(31 downto 0) := (others => '0');
    
    begin
    
        if (rising_edge(fabric_clk_i)) then
        
            if (reset_i = '1') then
                
                voltage := (others => '0');
                
                current := (others => '0');

            else
            
                if (uart_en_i = '1') then
                
                    if (uart_data_i(7 downto 6) = "00") then
                    
                        voltage(5 downto 0) := uart_data_i(5 downto 0);
                        
                    elsif (uart_data_i(7 downto 6) = "01") then
                    
                        voltage(11 downto 6) := uart_data_i(5 downto 0);
    
                        voltage_o <= voltage;
                        
                    elsif (uart_data_i(7 downto 6) = "10") then
                    
                        current(5 downto 0) := uart_data_i(5 downto 0);
                        
                    elsif (uart_data_i(7 downto 6) = "11") then
                    
                        current(11 downto 6) := uart_data_i(5 downto 0);
                
                        current_o <= current;
                    
                    end if;
                
                end if;
            
            end if;
        
        end if;
    
    end process;

end Behavioral;
