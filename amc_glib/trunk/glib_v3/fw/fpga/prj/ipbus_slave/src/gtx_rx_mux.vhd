library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity gtx_rx_mux is
port(
    gtx_clk_i           : in std_logic;
    reset_i             : in std_logic;
    
    ipb_vfat2_en_o      : out std_logic;
    ipb_vfat2_data_o    : out std_logic_vector(31 downto 0);
  
    ipb_opto_en_o       : out std_logic;
    ipb_opto_data_o     : out std_logic_vector(31 downto 0);
    
    ipb_tracking_en_o   : out std_logic;
    ipb_tracking_data_o : out std_logic_vector(191 downto 0);
  
    rx_kchar_i          : in std_logic_vector(1 downto 0);
    rx_data_i           : in std_logic_vector(15 downto 0)
);
end gtx_rx_mux;

architecture Behavioral of gtx_rx_mux is
begin
      
    process(gtx_clk_i) 
    
        -- State machine
        variable state          : integer range 0 to 2 := 0;
    
        -- Incomming data
        variable data           : std_logic_vector(191 downto 0) := (others => '0');
        
        -- Output slave
        variable last_slave     : integer range 0 to 3 := 0;
        variable tracking_data  : integer range 0 to 11 := 0;
    
    begin
    
        if (rising_edge(gtx_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                -- Reset the strobe
                ipb_vfat2_en_o <= '0';
                ipb_opto_en_o <= '0';
                ipb_tracking_en_o <= '0';
                
                state := 0;
                last_slave := 0;
                tracking_data := 0;
                
            else
            
                -- Wait for kchar
                if (state = 0) then
                
                    -- Detect Idle package
                    if (rx_kchar_i = "01") then
                    
                        -- VFAT2 data packet
                        if (rx_data_i(11 downto 8) = def_gtx_vfat2_request) then
                        
                            -- Select slave
                            last_slave := 0;
                        
                        -- OptoHybrid data packet
                        elsif (rx_data_i(11 downto 8) = def_gtx_optohybrid_request) then
                        
                            -- Select slave
                            last_slave := 1;
                        
                        -- Tracking
                        elsif (rx_data_i(11 downto 8) = def_gtx_tracking_data) then
                        
                            -- Select slave
                            last_slave := 2;
                        
                        else
                        
                            -- Nothing
                            last_slave := 3;
                            
                        end if;     

                    -- Data package
                    else
                    
                        data(191 downto 176) := rx_data_i;
                        
                        -- 2 times 16 bits
                        if (last_slave = 0 or last_slave = 1) then
                            
                            state := 1;
                        
                        -- Tracking
                        elsif (last_slave = 2) then
                        
                            state := 2;
                            
                            tracking_data := 1;
                        
                        else
                            
                            state := 0;
                        
                        end if;
                        
                    end if;
                    
                    -- Reset the strobes
                    ipb_vfat2_en_o <= '0';
                    ipb_opto_en_o <= '0';
                    ipb_tracking_en_o <= '0';
                    
                -- Data 1
                elsif (state = 1) then
                
                    -- Save the data
                    data(175 downto 160) := rx_data_i;
                    
                    if (last_slave = 0) then
                    
                        -- Set the ipbus data
                        ipb_vfat2_data_o <= data(191 downto 160);
                    
                        -- Storbe
                        ipb_vfat2_en_o <= '1';
                        
                    elsif (last_slave = 1) then

                        -- Set the ipbus data
                        ipb_opto_data_o <= data(191 downto 160);
                    
                        -- Storbe
                        ipb_opto_en_o <= '1';
                    
                    end if;
                    
                    state := 0;
                    
                -- Tracking data
                elsif (state = 2) then
                
                    data((191 - tracking_data * 16) downto (191 - tracking_data * 16 - 15)) := rx_data_i;
                    
                    if (tracking_data = 11) then
                    
                        ipb_tracking_data_o <= data;
                    
                        ipb_tracking_en_o <= '1';
                    
                        tracking_data := 0;
                        
                        state := 0;
                        
                    else
                    
                        tracking_data := tracking_data + 1;
                    
                    end if;
                    
                
                -- Out of FSM
                else
                
                    ipb_vfat2_en_o <= '0';
                    ipb_opto_en_o <= '0';
                    ipb_tracking_en_o <= '0';
                
                    state := 0;
                    tracking_data := 0;

                end if;
                
            end if;
            
        end if;
        
    end process;
    
end Behavioral;

