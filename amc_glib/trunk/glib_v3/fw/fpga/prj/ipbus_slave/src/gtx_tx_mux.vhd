library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity gtx_tx_mux is
port(
    gtx_clk_i           : in std_logic;
    reset_i             : in std_logic;
    
    ipb_vfat2_en_i      : in std_logic;
    ipb_vfat2_data_i    : in std_logic_vector(31 downto 0);
    
    tx_kchar_o          : out std_logic_vector(1 downto 0);
    tx_data_o           : out std_logic_vector(15 downto 0)
);
end gtx_tx_mux;

architecture Behavioral of gtx_tx_mux is
begin
   
    process(gtx_clk_i) 
        
        -- State for sending
        variable state : integer range 0 to 2 := 0;
        
        -- Data
        variable data : std_logic_vector(31 downto 0) := (others => '0');
    
        -- Last kchar sent
        variable kchar_count : integer range 0 to 7 := 0;

    begin
    
        if (rising_edge(gtx_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                -- TX signals
                tx_data_o <= def_gtx_idle & x"BC"; -- Idle state
                tx_kchar_o <= "00";
                
                state := 0;
                kchar_count := 0;
                
            else
            
                -- Ready to send state
                if (state = 0) then
                
                    -- Check for VFAT2 IPBus strobes
                    if (ipb_vfat2_en_i = '1') then
                       
                        -- Get data
                        data(31 downto 0) := ipb_vfat2_data_i;
                        
                        -- Set GTX data
                        tx_data_o <= def_gtx_vfat2_request & x"BC"; -- VFAT2 code
                        
                        -- Set KChar
                        tx_kchar_o <= "01";
                        
                        -- State 1 for next IPBus VFAT2 data
                        state := 1;
                        
                    else
                    
                        -- Set GTX data
                        tx_data_o <= def_gtx_idle & x"BC"; -- Idle code
                        
                        -- Determine if kchar must be sent
                        if (kchar_count = 7) then
                        
                            -- Set kchar
                            tx_kchar_o <= "01";
                            
                            kchar_count := 0;
                        
                        else
                        
                            -- Clear kchar
                            tx_kchar_o <= "00";
                            
                            kchar_count := kchar_count + 1;
                            
                        end if;
                        
                    end if;
                
                -- VFAT2 state 1
                elsif (state = 1) then
                
                    -- Set TX datac
                    tx_data_o <= data(31 downto 16);
                    
                    tx_kchar_o <= "00";
                    
                    -- Next state
                    state := 2;
                    
                -- VFAT2 state 2
                elsif (state = 2) then
                
                    -- Set TX data
                    tx_data_o <= data(15 downto 0);
                    
                    tx_kchar_o <= "00";
                    
                    -- Next state
                    state := 0;      
                    
                -- Out of FSM
                else
                
                    -- Set GTX data
                    tx_data_o <= def_gtx_idle & x"BC"; -- Idle code
                    
                    tx_kchar_o <= "00";
                
                    state := 0;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;

end Behavioral;