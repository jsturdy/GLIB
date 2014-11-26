library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
port(

    fabric_clk_i    : in std_logic;
    reset_i         : in std_logic;
    
    uart_rx_i       : in std_logic;
    
    en_o            : out std_logic;
    data_o          : out std_logic_vector(7 downto 0)  
    
);
end uart_rx;

architecture Behavioral of uart_rx is
begin

    process(fabric_clk_i)
    
        variable state  : integer range 0 to 3 := 0;
        
        variable timer  : integer range 0 to 32767 := 0;
        
        variable exec   : std_logic := '0';
        
        variable cnt    : integer range 0 to 7 := 0;
        
        variable data   : std_logic_vector(7 downto 0) := (others => '0');
        
    begin
    
        if (rising_edge(fabric_clk_i)) then
        
            if (reset_i = '1') then
            
                en_o <= '0';
                
                state := 0;
                
                timer := 0;
                
            else
            
                -- Handle clock division
                if (timer = 16666) then
                
                    timer := 0;
                    
                    exec := '1';
                    
                else
                
                    timer := timer + 1;
                    
                    exec := '0';
                    
                end if;
            
                if (state = 0) then   
                
                    en_o <= '0';
                    
                    if (exec = '1') then
                    
                        if (uart_rx_i = '0') then
                        
                            cnt := 0;
                    
                            state := 1;
                        
                        end if;
                        
                    end if;
                    
                -- Incomming bits
                elsif (state = 1) then        
                
                    if (exec = '1') then
                    
                        data(cnt) := uart_rx_i;
                    
                        if (cnt = 7) then
                        
                            state := 2;
                            
                        else
                    
                            cnt := cnt + 1;
                            
                        end if;
                        
                    end if;
                    
                -- End of the signal
                elsif (state = 2) then
                
                    data_o <= data;
   
                    if (exec = '1') then
                    
                        if (uart_rx_i = '1') then
                        
                            en_o <= '1';
                            
                        end if;
                    
                        state := 0;
                        
                    end if;
                    
                -- Out of FSM
                else
            
                    en_o <= '0';
                    
                    state := 0;
                    
                    timer := 0;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;
    
end Behavioral;