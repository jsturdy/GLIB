--
-- This entity forwards the data signals to the OptoHybrid. The fast signals interrupt the normal flow of data and are send whenever
-- they are set high. If multiple IPBus cores (like the VFAT2) are implemented, their signals will never cross as IPBus only sends 
-- one request at the time. Therefore, we do not need to priorities them.
--
--
-- Ways to improve: -
--
-- Modifications needed for V2: -
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity gtx_tx_mux is
port(
    gtx_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    vfat2_en_i      : in std_logic;
    vfat2_data_i    : in std_logic_vector(31 downto 0);  
    
    regs_en_i       : in std_logic;
    regs_data_i     : in std_logic_vector(31 downto 0);  
    
    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0);
   
    fast_signals_i  : in std_logic_vector(6 downto 0)
);
end gtx_tx_mux;

architecture Behavioral of gtx_tx_mux is
begin
   
    process(gtx_clk_i) 
        
        -- State for sending
        variable state          : integer range 0 to 3 := 0;
        
        -- Data to send
        variable data           : std_logic_vector(31 downto 0) := (others => '0');
    
        -- Last kchar sent
        variable kchar_count    : integer range 0 to 1023 := 0;

    begin
    
        if (rising_edge(gtx_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                tx_kchar_o <= "00";
                
                tx_data_o <= def_gtx_idle & x"BC";
                
                state := 0;
                
                kchar_count := 0;
                
            else
            
                -- Handle fast signals
                if (fast_signals_i /= "0000000") then
                
                    -- Set kchar
                    tx_kchar_o <= "01";
                
                    -- LV1A
                    if (fast_signals_i(0) = '1') then
                        tx_data_o <= def_gtx_lv1a & x"BC";
                    -- CalPulse
                    elsif (fast_signals_i(1) = '1') then
                        tx_data_o <= def_gtx_calpulse & x"BC";
                    -- Resync
                    elsif (fast_signals_i(2) = '1') then
                        tx_data_o <= def_gtx_resync & x"BC";
                    -- BC0
                    elsif (fast_signals_i(3) = '1') then
                        tx_data_o <= def_gtx_bc0 & x"BC";
                    -- OptoHybrid reset
                    elsif (fast_signals_i(4) = '1') then
                        tx_data_o <= def_gtx_oh_res & x"BC";
                    -- VFAT2 hard reset
                    elsif (fast_signals_i(5) = '1') then
                        tx_data_o <= def_gtx_v_hres & x"BC";
                    -- VFAT2 soft reset
                    elsif (fast_signals_i(6) = '1') then
                        tx_data_o <= def_gtx_v_bres & x"BC"; 
                    end if;
            
                -- Normal state machine ("slower" signals)
                else
                
                    -- Ready to send data
                    if (state = 0) then
                    
                        -- VFAT2 core's data is ready
                        if (vfat2_en_i = '1') then
                    
                            -- Get the data
                            data := vfat2_data_i;
                        
                            -- Set TX kchar
                            tx_kchar_o <= "01";
                            
                            -- Set the TX data
                            tx_data_o <= def_gtx_vfat2 & x"BC"; 
                        
                            -- Change state to send the data
                            state := 1;
                            
                        -- OH Regs core's data is ready
                        elsif (regs_en_i = '1') then
                    
                            -- Get the data
                            data := regs_data_i;
                        
                            -- Set TX kchar
                            tx_kchar_o <= "01";
                            
                            -- Set the TX data
                            tx_data_o <= def_gtx_oh_regs & x"BC"; 
                        
                            -- Change state to send the data
                            state := 1;
                        
                        -- Otherwise send idle codes and from time to time send a comma character (usefull to synchronize the boards)
                        else
                        
                            -- Determine if comma must be sent
                            if (kchar_count = 1023) then
                            
                                -- Set kchar
                                tx_kchar_o <= "01";
                                
                                kchar_count := 0;
                                
                            else
                           
                                -- Clear kchar
                                tx_kchar_o <= "00";
                                
                                kchar_count := kchar_count + 1;
                                
                            end if;   
                            
                            tx_data_o <= def_gtx_idle & x"BC"; -- Idle code
                            
                        end if;        
                        
                   -- Data 1
                    elsif (state = 1) then
                    
                        -- Set TX kchar
                        tx_kchar_o <= "00";
                        
                        -- Set the TX data
                        tx_data_o <= data(31 downto 16);
                        
                        -- Next state
                        state := 2;
                        
                    -- Data 2
                    elsif (state = 2) then
                    
                        -- Set TX kchar
                        tx_kchar_o <= "00";
                        
                        -- Set the TX data
                        tx_data_o <= data(15 downto 0);
                        
                        -- Reset state
                        state := 0;
                        
                    -- Out of FSM
                    else
                
                        tx_kchar_o <= "00";
                        
                        tx_data_o <= def_gtx_idle & x"BC";
                        
                        state := 0;
                        
                        kchar_count := 0;
                        
                    end if;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;

end Behavioral;