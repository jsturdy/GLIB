library ieee;
use ieee.std_logic_1164.all;
 
library work; 
 
entity sim_link_tracking is
end sim_link_tracking;
 
architecture behavior of sim_link_tracking is 

    --inputs
    signal vfat2_clk_i          : std_logic := '0';
    signal gtp_clk_i            : std_logic := '0';
    signal reset_i              : std_logic := '0';
    signal rx_error_i           : std_logic := '0';
    signal rx_kchar_i           : std_logic_vector(1 downto 0) := (others => '0');
    signal rx_data_i            : std_logic_vector(15 downto 0) := (others => '0');
    signal vfat2_dvalid_i       : std_logic_vector(1 downto 0) := (others => '0');
    signal vfat2_data_0_i       : std_logic := '0';
    signal vfat2_data_1_i       : std_logic := '0';
    signal vfat2_data_2_i       : std_logic := '0';
    signal vfat2_data_3_i       : std_logic := '0';
    signal vfat2_data_4_i       : std_logic := '0';
    signal vfat2_data_5_i       : std_logic := '0';
    signal vfat2_data_6_i       : std_logic := '0';
    signal vfat2_data_7_i       : std_logic := '0';
    signal vfat2_sda_i          : std_logic_vector(1 downto 0) := (others => '0');

    --outputs
    signal tx_kchar_o           : std_logic_vector(1 downto 0) := (others => '0');
    signal tx_data_o            : std_logic_vector(15 downto 0) := (others => '0');
    signal vfat2_sda_o          : std_logic_vector(1 downto 0) := (others => '0');
    signal vfat2_sda_t          : std_logic_vector(1 downto 0) := (others => '0');
    signal vfat2_scl_o          : std_logic_vector(1 downto 0) := (others => '0');

    constant vfat2_clk_period   : time := 25 ns;
    constant gtp_clk_period     : time := 6.25 ns;
 
begin

    uut : entity work.link_tracking
    port map(
        gtp_clk_i       => gtp_clk_i,
        vfat2_clk_i     => vfat2_clk_i,
        reset_i         => reset_i,
        rx_error_i      => rx_error_i,
        rx_kchar_i      => rx_kchar_i,
        rx_data_i       => rx_data_i,
        tx_kchar_o      => tx_kchar_o,
        tx_data_o       => tx_data_o,
        vfat2_sda_i     => vfat2_sda_i,
        vfat2_sda_o     => vfat2_sda_o,
        vfat2_sda_t     => vfat2_sda_t,
        vfat2_scl_o     => vfat2_scl_o,
        vfat2_dvalid_i  => vfat2_dvalid_i,
        vfat2_data_0_i  => vfat2_data_0_i,
        vfat2_data_1_i  => vfat2_data_1_i,
        vfat2_data_2_i  => vfat2_data_2_i,
        vfat2_data_3_i  => vfat2_data_3_i,
        vfat2_data_4_i  => vfat2_data_4_i,
        vfat2_data_5_i  => vfat2_data_5_i,
        vfat2_data_6_i  => vfat2_data_6_i,
        vfat2_data_7_i  => vfat2_data_7_i
    );
   
    -- clock process definitions
    vfat2_clk_process :process
    begin
        vfat2_clk_i <= '0';
        wait for vfat2_clk_period / 2;
        vfat2_clk_i <= '1';
        wait for vfat2_clk_period / 2;
    end process;

    -- clock process definitions
    gtp_clk_process :process
    begin
        gtp_clk_i <= '0';
        wait for gtp_clk_period / 2;
        gtp_clk_i <= '1';
        wait for gtp_clk_period / 2;
    end process;
 
    -- VFAT2 tracking data    
    process(vfat2_clk_i)
        variable cnt    : integer range 0 to 400 := 0;
        variable data   : std_logic_vector(191 downto 0) := x"A123456789012345678901234567890123456789ABCDEF01";
    begin
        if (rising_edge(vfat2_clk_i)) then
            if (cnt = 0) then
                cnt := 400;
            else
                cnt := cnt - 1;
            end if;
            
            if (cnt < 192) then
                vfat2_dvalid_i <= "11";
                vfat2_data_0_i <= data(cnt);
            else
                vfat2_dvalid_i <= "00";
                vfat2_data_0_i <= '0';
            end if;
        end if;
    end process;
    
    -- Requests
    process(gtp_clk_i)
        variable cnt : integer range 0 to 20_000 := 0;
    begin
        if (rising_edge(gtp_clk_i)) then
            if (cnt = 20_000) then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            
            -- I2C
            if (cnt = 1) then
                rx_data_i <= x"01BC";
                rx_kchar_i <= "01";
            elsif (cnt = 2) then
                rx_data_i <= "00101000" & "00001000";
                rx_kchar_i <= "00";
            elsif (cnt = 3) then
                rx_data_i <= "00000000" & x"21";
                rx_kchar_i <= "00";
            -- Regs write
            elsif (cnt = 1_000) then
                rx_data_i <= x"03BC";
                rx_kchar_i <= "01";
            elsif (cnt = 1_001) then
                rx_data_i <= "00000000" & "00000000";
                rx_kchar_i <= "00";
            elsif (cnt = 1_002) then
                rx_data_i <= "00000000" & "11111000";
                rx_kchar_i <= "00";
            elsif (cnt = 1_003) then
                rx_data_i <= "00000100" & "11111111";
                rx_kchar_i <= "00";
            -- Regs read
            elsif (cnt = 1_200) then
                rx_data_i <= x"03BC";
                rx_kchar_i <= "01";
            elsif (cnt = 1_201) then
                rx_data_i <= "00000000" & "00000000";
                rx_kchar_i <= "00";
            elsif (cnt = 1_202) then
                rx_data_i <= "00000000" & "00000000";
                rx_kchar_i <= "00";
            elsif (cnt = 1_203) then
                rx_data_i <= "11111100" & "11111111";
                rx_kchar_i <= "00";
            -- Other
            else    
                rx_data_i <= x"00BC";
                rx_kchar_i <= "00";
            end if;
        end if;
    end process; 

end;
