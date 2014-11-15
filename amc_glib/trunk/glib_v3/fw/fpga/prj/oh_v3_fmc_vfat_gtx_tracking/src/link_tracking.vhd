library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity link_tracking is
port(

    -- Clocks and reset

    gtp_clk_i       : in std_logic;
    vfat2_clk_i     : in std_logic;
    reset_i         : in std_logic;

    -- GTP signals

    rx_error_i      : in std_logic;
    rx_kchar_i      : in std_logic_vector(1 downto 0);
    rx_data_i       : in std_logic_vector(15 downto 0);

    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0);

    -- Global requets
  
    request_write_o : out array32(63 downto 0);
    request_tri_o   : out std_logic_vector(63 downto 0);
    request_read_i  : in array32(63 downto 0);

    -- IIC signals

    vfat2_sda_i     : in std_logic_vector(1 downto 0);
    vfat2_sda_o     : out std_logic_vector(1 downto 0);
    vfat2_sda_t     : out std_logic_vector(1 downto 0);
    vfat2_scl_o     : out std_logic_vector(1 downto 0);

    -- VFAT2 data lines

    vfat2_dvalid_i  : in std_logic_vector(1 downto 0);

    vfat2_data_0_i  : in std_logic;
    vfat2_data_1_i  : in std_logic;
    vfat2_data_2_i  : in std_logic;
    vfat2_data_3_i  : in std_logic;
    vfat2_data_4_i  : in std_logic;
    vfat2_data_5_i  : in std_logic;
    vfat2_data_6_i  : in std_logic;
    vfat2_data_7_i  : in std_logic

);
end link_tracking;

architecture Behavioral of link_tracking is

    -- VFAT2 I2C signals

    signal vi2c_rx_en               : std_logic := '0';
    signal vi2c_rx_data             : std_logic_vector(31 downto 0) := (others => '0');
    signal vi2c_tx_ready            : std_logic := '0';
    signal vi2c_tx_done             : std_logic := '0';
    signal vi2c_tx_data             : std_logic_vector(31 downto 0) := (others => '0');

    -- Tracking signals

    signal track_tx_ready           : std_logic := '0';
    signal track_tx_done            : std_logic := '0';
    signal track_tx_data            : std_logic_vector(191 downto 0) := (others => '0');

    -- Registers requests

    signal regs_rx_en               : std_logic := '0';
    signal regs_rx_data             : std_logic_vector(47 downto 0) := (others => '0');
    signal regs_tx_ready            : std_logic := '0';
    signal regs_tx_done             : std_logic := '0';
    signal regs_tx_data             : std_logic_vector(47 downto 0) := (others => '0');
    
    signal regs_req_write           : array32(127 downto 0);
    signal regs_req_tri             : std_logic_vector(127 downto 0);
    signal regs_req_read            : array32(127 downto 0);

    -- Local requests

    signal request_write            : array32(63 downto 0) := (others => (others => '0'));
    signal request_tri              : std_logic_vector(63 downto 0);
    signal request_read             : array32(63 downto 0) := (others => (others => '0'));

    -- Registers

    signal registers_write          : array32(7 downto 0) := (others => (others => '0'));
    signal registers_tri            : std_logic_vector(7 downto 0);
    signal registers_read           : array32(7 downto 0) := (others => (others => '0'));

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
    signal cs_icon1                 : std_logic_vector(35 downto 0);
    signal cs_in                    : std_logic_vector(31 downto 0);
    signal cs_out                   : std_logic_vector(31 downto 0);
    signal cs_ila0                  : std_logic_vector(31 downto 0);
    signal cs_ila1                  : std_logic_vector(31 downto 0);

begin

    --================================--
    -- GTP
    --================================--

    gtp_rx_mux_inst : entity work.gtp_rx_mux
    port map(
        gtp_clk_i   => gtp_clk_i,
        reset_i     => reset_i,
        vi2c_en_o   => vi2c_rx_en,
        vi2c_data_o => vi2c_rx_data,
        regs_en_o   => regs_rx_en,
        regs_data_o => regs_rx_data,
        rx_kchar_i  => rx_kchar_i,
        rx_data_i   => rx_data_i
    );

    gtp_tx_mux_inst : entity work.gtp_tx_mux
    port map(
        gtp_clk_i       => gtp_clk_i,
        reset_i         => reset_i,
        vi2c_ready_i    => vi2c_tx_ready,
        vi2c_done_o     => vi2c_tx_done,
        vi2c_data_i     => vi2c_tx_data,
        regs_ready_i    => regs_tx_ready,
        regs_done_o     => regs_tx_done,
        regs_data_i     => regs_tx_data,
        track_ready_i   => track_tx_ready,
        track_done_o    => track_tx_done,
        track_data_i    => track_tx_data,
        tx_kchar_o      => tx_kchar_o,
        tx_data_o       => tx_data -- tx_data_o
    );

    tx_data_o <= tx_data;

    --================================--
    -- VFAT2 I2C
    --================================--

    vi2c_core_inst : entity work.vi2c_core
    port map(
        fabric_clk_i    => gtp_clk_i,
        reset_i         => reset_i,
        rx_en_i         => vi2c_rx_en,
        rx_data_i       => vi2c_rx_data,
        tx_ready_o      => vi2c_tx_ready,
        tx_done_i       => vi2c_tx_done,
        tx_data_o       => vi2c_tx_data,
        sda_i           => vfat2_sda_i,
        sda_o           => vfat2_sda_o,
        sda_t           => vfat2_sda_t,
        scl_o           => vfat2_scl_o
    );

    --================================--
    -- Tracking path
    --================================--

    tracking_core_inst : entity work.tracking_core
    port map(
        gtp_clk_i       => gtp_clk_i,
        vfat2_clk_i     => vfat2_clk_i,
        reset_i         => reset_i,
        tx_ready_o      => track_tx_ready,
        tx_done_i       => track_tx_done,
        tx_data_o       => track_tx_data,
        vfat2_dvalid_i  => '0' & vfat2_dvalid_i(0),
        vfat2_data_0_i  => vfat2_data_0_i,
        vfat2_data_1_i  => vfat2_data_1_i,
        vfat2_data_2_i  => vfat2_data_2_i,
        vfat2_data_3_i  => vfat2_data_3_i,
        vfat2_data_4_i  => vfat2_data_4_i,
        vfat2_data_5_i  => vfat2_data_5_i,
        vfat2_data_6_i  => vfat2_data_6_i,
        vfat2_data_7_i  => vfat2_data_7_i
    );
    
    --================================--
    -- Registers requests
    --================================--
    
    registers_core_inst : entity work.registers_core
    port map(
        fabric_clk_i    => gtp_clk_i,
        reset_i         => reset_i,
        rx_en_i         => regs_rx_en,
        rx_data_i       => regs_rx_data,
        tx_ready_o      => regs_tx_ready,
        tx_done_i       => regs_tx_done,
        tx_data_o       => regs_tx_data,
        wbus_o          => regs_req_write,
        wbus_t          => regs_req_tri,
        rbus_i          => regs_req_read
    );
    
    regs_req_read <= request_read_i & request_read;    -- Global & Local
    
    request_write_o <= regs_req_write(127 downto 64);   -- Global mapping
    request_tri_o <= regs_req_tri(127 downto 64);
    
    request_write <= regs_req_write(63 downto 0);       -- Local mapping
    request_tri <= regs_req_tri(63 downto 0);
    
    --================================--
    -- Registers
    --================================--

    registers_inst : entity work.registers
    generic map(SIZE => 8)
    port map(
        fabric_clk_i    => gtp_clk_i,
        reset_i         => reset_i,
        wbus_i          => registers_write,
        wbus_t          => registers_tri,
        rbus_o          => registers_read
    );
   
    --================================--
    -- Counters
    --================================--

    rx_error_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk_i, reset_i => rx_error_counter_reset, en_i => rx_error_i, data_o => rx_error_counter);
    vi2c_rx_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk_i, reset_i => vi2c_rx_counter_reset, en_i => vi2c_rx_en, data_o => vi2c_rx_counter);
    vi2c_tx_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk_i, reset_i => vi2c_tx_counter_reset, en_i => vi2c_tx_done, data_o => vi2c_tx_counter);
    regs_rx_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk_i, reset_i => regs_rx_counter_reset, en_i => regs_rx_en, data_o => regs_rx_counter);
    regs_tx_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk_i, reset_i => regs_tx_counter_reset, en_i => regs_tx_done, data_o => regs_tx_counter);
     
    --================================--
    -- Request & register mapping
    --================================--
    
    -- Counters : 4 downto 0
    
    request_read(0) <= rx_error_counter;
    
    request_read(1) <= vi2c_rx_counter;
    
    request_read(2) <= vi2c_tx_counter;
    
    request_read(3) <= regs_rx_counter;
    
    request_read(4) <= regs_tx_counter;
    
    -- Counters reset : 9 downto 5
    
    rx_error_counter_reset <= request_tri(5);
    
    vi2c_rx_counter_reset <= request_tri(6);
    
    vi2c_tx_counter_reset <= request_tri(7);
    
    regs_rx_counter_reset <= request_tri(8);
    
    regs_tx_counter_reset <= request_tri(9);
    
    -- Writable registers : 17 downto 10
    
    registers_write(7 downto 0) <= request_write(17 downto 10);
    registers_tri(7 downto 0) <= request_tri(17 downto 10);
    request_read(17 downto 10) <= registers_read(7 downto 0);

    -- Other registers : 63 downto 18

    --================================--
    -- ChipScope
    --================================--

    chipscope_icon_inst : entity work.chipscope_icon port map (CONTROL0 => cs_icon0);

    chipscope_ila_inst : entity work.chipscope_ila port map (CONTROL => cs_icon0, CLK => gtp_clk_i, TRIG0 => cs_ila0, TRIG1 => cs_ila1);

    cs_ila0 <= tx_data & rx_data_i;
    cs_ila1 <= x"000000" & track_tx_done & track_tx_ready & vfat2_data_4_i & vfat2_data_3_i & vfat2_data_1_i & vfat2_data_0_i & vfat2_dvalid_i(1) & vfat2_dvalid_i(0);

end Behavioral;
