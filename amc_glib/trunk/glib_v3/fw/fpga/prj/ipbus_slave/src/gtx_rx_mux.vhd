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
    
    rx_kchar_i          : in std_logic_vector(1 downto 0);
    rx_data_i           : in std_logic_vector(15 downto 0)
);
end gtx_rx_mux;

architecture Behavioral of gtx_rx_mux is
begin
      
    process(gtx_clk_i) 
    
        -- State machine
        variable state : integer range 0 to 2 := 0;
    
        -- Incomming data
        variable data : std_logic_vector(31 downto 0) := (others => '0');
    
    begin
    
        if (rising_edge(gtx_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                -- Reset the strobe
                ipb_vfat2_en_o <= '0';
                
                state := 0;
                
            else
            
                -- Wait for kchar
                if (state = 0) then
                    
                    -- Kchar detected
                    if (rx_kchar_i = "01") then
                    
                        -- Check package type
                        
                        -- VFAT2 data packet
                        if (rx_data_i = def_gtx_vfat2_request & x"BC") then
                        
                            -- Go to state 1
                            state := 1;
                            
                        end if;
                        
                    end if;
                    
                    -- Reset the strobes
                    ipb_vfat2_en_o <= '0';
                    
                -- VFAT 1
                elsif (state = 1) then
                
                    -- Save the data
                    data(31 downto 16) := rx_data_i;
                    
                    -- Next state
                    state := 2;
                    
                -- VFAT 2
                elsif (state = 2) then
                
                    -- Save the data
                    data(15 downto 0) := rx_data_i; 
                    
                    -- Set the ipbus data
                    ipb_vfat2_data_o <= data;
                    
                    -- Storbe
                    ipb_vfat2_en_o <= '1';
                    
                    -- Reset state
                    state := 0;
                
                -- Out of FSM
                else
                
                    ipb_vfat2_en_o <= '0';
                
                    state := 0;

                end if;
                
            end if;
            
        end if;
        
    end process;
    
end Behavioral;

