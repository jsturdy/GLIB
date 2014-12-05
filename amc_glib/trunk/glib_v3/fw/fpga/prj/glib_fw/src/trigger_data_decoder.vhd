library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity trigger_data_decoder is
port(

    gtx_clk_i       : in std_logic;
    reset_i         : in std_logic;
  
    rx_kchar_i      : in std_logic_vector(1 downto 0);
    rx_data_i       : in std_logic_vector(15 downto 0);
    
    trigger_en_o    : out std_logic;
    trigger_data_o  : out std_logic_vector(47 downto 0)
    
);
end trigger_data_decoder;

architecture Behavioral of trigger_data_decoder is
begin

    process(gtx_clk_i) 
    
        -- State machine
        variable state          : integer range 0 to 3 := 0;
    
        -- Incomming data
        variable data           : std_logic_vector(47 downto 0) := (others => '0');
        variable data_cnt       : integer range 0 to 3 := 0;
    
    begin
    
        if (rising_edge(gtx_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                trigger_en_o <= '0';
                
                state := 0;
                
            else
                    
                -- Wait for packet
                if (state = 0) then

                    -- Set the data
                    trigger_data_o <= data(47 downto 0);
                
                    -- Storbe
                    trigger_en_o <= '1';
                
                    -- Detect data package
                    if (rx_kchar_i = "01") then
                    
                        -- VFAT2 I2C data packet
                        if (rx_data_i = def_gtx_trigger & x"BC") then
                            
                            data_cnt := 3;
                            
                            state := 1;
                            
                        end if; 
                        
                    end if;
                   
                -- Receive data
                elsif (state = 1) then
                
                    trigger_en_o <= '0';
                
                    if (rx_kchar_i = "00") then
                
                        -- Receive data
                        data((data_cnt * 16 - 1) downto ((data_cnt - 1) * 16)) := rx_data_i;
                        
                        if (data_cnt = 1) then
                            
                            state := 0;
                    
                        else
                            
                            data_cnt := data_cnt - 1;
                            
                        end if;
                        
                    else
                    
                        state := 0;
                    
                    end if;
                    
                -- Out of FSM
                else
                
                    trigger_en_o <= '0';
                
                    state := 0;
                    
                end if;
                
            end if;
                
            
        end if;
        
    end process;
    
end Behavioral;

