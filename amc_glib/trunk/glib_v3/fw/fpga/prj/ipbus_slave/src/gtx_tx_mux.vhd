library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity gtx_tx_mux is
port(
    gtx_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    vfat2_en_o      : out std_logic;
    vfat2_ack_i     : in std_logic;
    vfat2_data_i    : in std_logic_vector(31 downto 0);  
    
    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0)
);
end gtx_tx_mux;

architecture Behavioral of gtx_tx_mux is
begin
   
    process(gtx_clk_i) 
        
        -- State for sending
        variable state          : integer range 0 to 7 := 0;
        
        -- Data
        variable data           : std_logic_vector(31 downto 0) := (others => '0');
    
        -- Last kchar sent
        variable kchar_count    : integer range 0 to 1023 := 0;

    begin
    
        if (rising_edge(gtx_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                vfat2_en_o <= '0';
            
                tx_kchar_o <= "00";
                
                tx_data_o <= def_gtx_idle & x"BC";
                
                state := 0;
                
                kchar_count := 0;
                
            else
            
                -- Ready to send state
                if (state = 0) then
                
                    -- Request data
                    vfat2_en_o <= '1';
                    
                    -- Data is ready
                    if (vfat2_ack_i = '1') then
                
                        -- Get data
                        data(31 downto 0) := vfat2_data_i;
                    
                        -- Change state
                        state := 1;
                        
                    end if;
                    
                    -- Determine if kchar must be sent
                    if (kchar_count = 1023) then
                    
                        -- Set kchar
                        tx_kchar_o <= "01";
                        
                        tx_data_o <= def_gtx_idle & x"BC"; -- Idle code
                        
                        kchar_count := 0;
                        
                    else
                   
                        -- Clear kchar
                        tx_kchar_o <= "00";
                    
                        tx_data_o <= def_gtx_idle & x"BC"; -- Idle code
                        
                        kchar_count := kchar_count + 1;
                        
                    end if;
                
                -- VFAT2 data 1
                elsif (state = 1) then
                
                    vfat2_en_o <= '0';
                
                    -- Set TX data
                    tx_kchar_o <= "01";
                    
                    tx_data_o <= def_gtx_vfat2 & x"BC";
                    
                    -- Next state
                    state := 2;
                    
               -- VFAT2 data 2
                elsif (state = 2) then
                
                    -- Set TX data
                    tx_kchar_o <= "00";
                    
                    tx_data_o <= data(31 downto 16);
                    
                    -- Next state
                    state := 3;
                    
                -- VFAT2 data 3
                elsif (state = 3) then
                
                    -- Set TX data
                    tx_kchar_o <= "00";
                    
                    tx_data_o <= data(15 downto 0);
                    
                    -- Next state
                    state := 0;
                    
                -- Out of FSM
                else
                
                    vfat2_en_o <= '0';
            
                    tx_kchar_o <= "00";
                    
                    tx_data_o <= def_gtx_idle & x"BC";
                    
                    state := 0;
                    
                    kchar_count := 0;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;

end Behavioral;