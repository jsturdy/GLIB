library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity link_tracking is
port(

    gtx_clk_i       : in std_logic;
    ipb_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    rx_error_i      : in std_logic;
    rx_kchar_i      : in std_logic_vector(1 downto 0);
    rx_data_i       : in std_logic_vector(15 downto 0);
    
    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0);
    
	ipb_vi2c_i      : in ipb_wbus;
	ipb_vi2c_o      : out ipb_rbus;
    
	ipb_track_i     : in ipb_wbus;
	ipb_track_o     : out ipb_rbus;
    
	ipb_regs_i      : in ipb_wbus;
	ipb_regs_o      : out ipb_rbus;
    
	ipb_info_i      : in ipb_wbus;
	ipb_info_o      : out ipb_rbus
    
);
end link_tracking;

architecture Behavioral of link_tracking is

    -- VFAT2 signals
    
    signal vi2c_tx_en               : std_logic := '0';
    signal vi2c_tx_data             : std_logic_vector(31 downto 0) := (others => '0');
    signal vi2c_rx_en               : std_logic := '0';
    signal vi2c_rx_data             : std_logic_vector(31 downto 0) := (others => '0');
    
    -- Track data
    
    signal track_rx_en              : std_logic := '0';
    signal track_rx_data            : std_logic_vector(191 downto 0) := (others => '0');
    signal track_occupancy          : std_logic_vector(5 downto 0) := (others => '0');
         
    -- Registers signals
    
    signal regs_tx_en               : std_logic := '0';
    signal regs_tx_data             : std_logic_vector(47 downto 0) := (others => '0');
    signal regs_rx_en               : std_logic := '0';
    signal regs_rx_data             : std_logic_vector(47 downto 0) := (others => '0');
    
    -- Info signals

    signal regs_req_write           : array32(255 downto 0) := (others => (others => '0'));
    signal regs_req_tri             : std_logic_vector(255 downto 0);
    signal regs_req_read            : array32(255 downto 0) := (others => (others => '0'));

    -- Counters

    signal rx_error_counter         : std_logic_vector(31 downto 0) := (others => '0');
    signal vi2c_rx_counter          : std_logic_vector(31 downto 0) := (others => '0');
    signal vi2c_tx_counter          : std_logic_vector(31 downto 0) := (others => '0');
    signal regs_rx_counter          : std_logic_vector(31 downto 0) := (others => '0');
    signal regs_tx_counter          : std_logic_vector(31 downto 0) := (others => '0');

    signal rx_error_counter_reset   : std_logic := '0';
    signal vi2c_rx_counter_reset    : std_logic := '0';
    signal vi2c_tx_counter_reset    : std_logic := '0';
    signal regs_rx_counter_reset    : std_logic := '0';
    signal regs_tx_counter_reset    : std_logic := '0';

    -- ChipScope signals

    signal tx_data                  : std_logic_vector(15 downto 0);

    signal cs_icon0                 : std_logic_vector(35 downto 0);
    signal cs_ila0                  : std_logic_vector(31 downto 0);
    signal cs_ila1                  : std_logic_vector(31 downto 0);
    
    
begin

    --================================--
    -- GTX
    --================================--

    gtx_tx_mux_inst : entity work.gtx_tx_mux
    port map(
        gtx_clk_i   => gtx_clk_i,
        reset_i     => reset_i,
        vi2c_en_i   => vi2c_tx_en,
        vi2c_data_i => vi2c_tx_data,
        regs_en_i   => regs_tx_en,
        regs_data_i => regs_tx_data,
        tx_kchar_o  => tx_kchar_o,
        tx_data_o   => tx_data -- tx_data_o  
    );
    
    gtx_rx_mux_inst : entity work.gtx_rx_mux
    port map(
        gtx_clk_i       => gtx_clk_i,
        reset_i         => reset_i,
        vi2c_en_o       => vi2c_rx_en,
        vi2c_data_o     => vi2c_rx_data,
        track_en_o      => track_rx_en,
        track_data_o    => track_rx_data,
        regs_en_o       => regs_rx_en,
        regs_data_o     => regs_rx_data,
        rx_kchar_i      => rx_kchar_i,
        rx_data_i       => rx_data_i
    );
    
    tx_data_o <= tx_data;
    
    --================================--
    -- VFAT2 I2C
    --================================--
    
    ipb_vi2c_inst : entity work.ipb_vi2c
    port map(
        ipb_clk_i       => ipb_clk_i,
        gtx_clk_i       => gtx_clk_i,
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_vi2c_i,
        ipb_miso_o      => ipb_vi2c_o,
        tx_en_o         => vi2c_tx_en,
        tx_data_o       => vi2c_tx_data,
        rx_en_i         => vi2c_rx_en,
        rx_data_i       => vi2c_rx_data
    );
    
    --================================--
    -- Tracking data
    --================================--
    
    ipb_tracking_inst : entity work.ipb_tracking
    port map(
        ipb_clk_i       => ipb_clk_i,
        gtx_clk_i       => gtx_clk_i,
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_track_i,
        ipb_miso_o      => ipb_track_o,
        rx_en_i         => track_rx_en,
        rx_data_i       => track_rx_data,
        occupancy_o     => track_occupancy
    );

    --================================--
    -- Registers
    --================================--
    
    ipb_registers_inst : entity work.ipb_registers
    port map(
        ipb_clk_i       => ipb_clk_i,
        gtx_clk_i       => gtx_clk_i,
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_regs_i,
        ipb_miso_o      => ipb_regs_o,
        tx_en_o         => regs_tx_en,
        tx_data_o       => regs_tx_data,
        rx_en_i         => regs_rx_en,
        rx_data_i       => regs_rx_data
    );

    --================================--
    -- Info
    --================================--
    
    ipb_info_inst : entity work.ipb_info
    port map(
        ipb_clk_i   => ipb_clk_i,
        reset_i     => reset_i,
        ipb_mosi_i  => ipb_info_i,
        ipb_miso_o  => ipb_info_o,
        wbus_o      => regs_req_write,
        wbus_t      => regs_req_tri,
        rbus_i      => regs_req_read
    );

    --================================--
    -- Counters
    --================================--

    rx_error_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk_i, reset_i => rx_error_counter_reset, en_i => rx_error_i, data_o => rx_error_counter);
    vi2c_rx_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk_i, reset_i => vi2c_rx_counter_reset, en_i => vi2c_rx_en, data_o => vi2c_rx_counter);
    vi2c_tx_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk_i, reset_i => vi2c_tx_counter_reset, en_i => vi2c_tx_en, data_o => vi2c_tx_counter);
    regs_rx_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk_i, reset_i => regs_rx_counter_reset, en_i => regs_rx_en, data_o => regs_rx_counter);
    regs_tx_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk_i, reset_i => regs_tx_counter_reset, en_i => regs_tx_en, data_o => regs_tx_counter);

    --================================--
    -- Request & register mapping
    --================================--
    
    -- Counters : 4 downto 0
    
    regs_req_read(0) <= rx_error_counter;
    
    regs_req_read(1) <= vi2c_rx_counter;
    
    regs_req_read(2) <= vi2c_tx_counter;
    
    regs_req_read(3) <= regs_rx_counter;
    
    regs_req_read(4) <= regs_tx_counter;
    
    -- Counters reset : 9 downto 5
    
    rx_error_counter_reset <= regs_req_tri(5);
    
    vi2c_rx_counter_reset <= regs_req_tri(6);
    
    vi2c_tx_counter_reset <= regs_req_tri(7);
    
    regs_rx_counter_reset <= regs_req_tri(8);
    
    regs_tx_counter_reset <= regs_req_tri(9);
    
    -- Firmware date : 10
    
    regs_req_read(10) <= x"20141110";
    
    -- Tracking fifo occupancy : 11
    
    regs_req_read(11) <= x"000000" & "00" & track_occupancy;
    
    -- Others : 255 downto 12
    
    --================================--
    -- ChipScope
    --================================--

    chipscope_icon_inst : entity work.chipscope_icon port map (CONTROL0 => cs_icon0);
    
    chipscope_ila_inst : entity work.chipscope_ila port map (CONTROL => cs_icon0, CLK => gtx_clk_i, TRIG0 => cs_ila0, TRIG1 => cs_ila1);

    cs_ila0 <= tx_data & rx_data_i;
    cs_ila1 <= track_rx_data(191 downto 168) & "0000000" & track_rx_en;
    
end Behavioral;