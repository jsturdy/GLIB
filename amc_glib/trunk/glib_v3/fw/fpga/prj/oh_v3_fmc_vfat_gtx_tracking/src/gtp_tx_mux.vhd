library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity gtp_tx_mux is
port(

    gtp_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    vi2c_ready_i    : in std_logic;
    vi2c_done_o     : out std_logic;
    vi2c_data_i     : in std_logic_vector(31 downto 0);  
    
    regs_ready_i    : in std_logic;
    regs_done_o     : out std_logic;
    regs_data_i     : in std_logic_vector(47 downto 0);  
    
    track_ready_i   : in std_logic;
    track_done_o    : out std_logic;
    track_data_i    : in std_logic_vector(191 downto 0);  
    
    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0)
    
);
end gtp_tx_mux;

architecture Behavioral of gtp_tx_mux is
begin
   
    process(gtp_clk_i) 
        
        -- State for sending
        variable state          : integer range 0 to 3 := 0;
        
        -- Data
        variable header         : std_logic_vector(7 downto 0) := (others => '0');
        variable data           : std_logic_vector(191 downto 0) := (others => '0');
        variable data_cnt       : integer range 0 to 15 := 0;
    
        -- Last kchar sent
        variable kchar_count    : integer range 0 to 255 := 0;

    begin
    
        if (rising_edge(gtp_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                tx_kchar_o <= "00";
                
                tx_data_o <= def_gtp_idle & x"BC";
                
                vi2c_done_o <= '0';
                
                regs_done_o <= '0';
                
                track_done_o <= '0';
                
                state := 0;
                
                kchar_count := 0;
                
            else
            
                -- Ready to send state
                if (state = 0) then
                    
                    tx_data_o <= def_gtp_idle & x"BC"; -- Idle code
                    
                    if (kchar_count = 255) then
                    
                        -- Set kchar
                        tx_kchar_o <= "01";
                        
                        kchar_count := 0;
                        
                    else
                   
                        -- Clear kchar
                        tx_kchar_o <= "00";
                        
                        kchar_count := kchar_count + 1;
                        
                    end if;
                
                    -- VFAT2 I2C data is available
                    if (vi2c_ready_i = '1') then
                    
                        header := def_gtp_vi2c;
                    
                        data(31 downto 0) := vi2c_data_i;
                        
                        data_cnt := 2;
                        
                        vi2c_done_o <= '1';
                        
                        state := 1;
                        
                    -- Registers data is available
                    elsif (regs_ready_i = '1') then
                    
                        header := def_gtp_regs;
                    
                        data(47 downto 0) := regs_data_i;
                        
                        data_cnt := 3;
                        
                        regs_done_o <= '1';
                        
                        state := 1;
                        
                    -- Tracking data is available
                    elsif (track_ready_i = '1') then
                    
                        header := def_gtp_tracks;
                    
                        data(191 downto 0) := track_data_i;
                        
                        data_cnt := 12;
                        
                        track_done_o <= '1';
                        
                        state := 1;
                        
                    end if;
                    
                -- Send header
                elsif (state = 1) then
                
                    vi2c_done_o <= '0';
                    
                    regs_done_o <= '0';
                        
                    track_done_o <= '0';
                    
                    -- Set the TX data
                    tx_data_o <= header & x"BC";
                    
                    -- Set TX kchar
                    tx_kchar_o <= "01";
                    
                    state := 2;
                
               -- Send body
                elsif (state = 2) then
                    
                    -- Set TX kchar
                    tx_kchar_o <= "00";
                    
                    -- Set the TX data
                    tx_data_o <= data((data_cnt * 16 - 1) downto ((data_cnt - 1) * 16));
                    
                    if (data_cnt = 1) then
                    
                        state := 0;
                        
                    else
                        
                        data_cnt := data_cnt - 1;
                        
                    end if;
                    
                -- Out of FSM
                else
            
                    tx_kchar_o <= "00";
                    
                    tx_data_o <= def_gtp_idle & x"BC";
                
                    vi2c_done_o <= '0';
                    
                    regs_done_o <= '0';
                    
                    track_done_o <= '0';
                    
                    state := 0;
                    
                    kchar_count := 0;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;

end Behavioral;