library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity tracking_core is
port(

    gtp_clk_i       : in std_logic;
    vfat2_clk_i     : in std_logic;
    reset_i         : in std_logic;
    
    tx_ready_o      : out std_logic;
    tx_done_i       : in std_logic;
    tx_data_o       : out std_logic_vector(223 downto 0);
    
    lv1a_sent_i     : in std_logic;
    bx_counter_i    : in std_logic_vector(31 downto 0);
    
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
end tracking_core;

architecture Behavioral of tracking_core is

    signal track_en                 : std_logic_vector(7 downto 0) := (others => '0');
    signal track_data               : array192(7 downto 0);
    
    signal data_fifo_wr             : std_logic := '0';
    signal data_fifo_din            : std_logic_vector(223 downto 0) := (others => '0');
    signal data_fifo_rd             : std_logic := '0';
    signal data_fifo_valid          : std_logic := '0';
    signal data_fifo_underflow      : std_logic := '0';
    signal data_fifo_dout           : std_logic_vector(223 downto 0) := (others => '0');
    
    signal trigger_fifo_rd          : std_logic := '0';
    signal trigger_fifo_valid       : std_logic := '0';
    signal trigger_fifo_underflow   : std_logic := '0';
    signal trigger_fifo_dout        : std_logic_vector(31 downto 0) := (others => '0');

begin  

    --================================--
    -- BX accepted FIFO
    --================================--  
    
    tracking_bx_fifo_inst : entity work.tracking_bx_fifo
    port map(
        rst         => reset_i,
        wr_clk      => gtp_clk_i,
        wr_en       => lv1a_sent_i,
        din         => bx_counter_i,
        rd_clk      => vfat2_clk_i,
        rd_en       => trigger_fifo_rd,
        valid       => trigger_fifo_valid,
        underflow   => trigger_fifo_underflow,
        dout        => trigger_fifo_dout,
        empty       => open,
        full        => open
    );
    
    --================================--
    -- Tracking decoder
    --================================--  

    track_0_inst : entity work.tracking_decoder port map(vfat2_clk_i => vfat2_clk_i, reset_i => reset_i, en_i => vfat2_dvalid_i(0), data_i => vfat2_data_0_i, en_o => track_en(0), data_o => track_data(0));
    track_1_inst : entity work.tracking_decoder port map(vfat2_clk_i => vfat2_clk_i, reset_i => reset_i, en_i => vfat2_dvalid_i(0), data_i => vfat2_data_1_i, en_o => track_en(1), data_o => track_data(1));
    track_2_inst : entity work.tracking_decoder port map(vfat2_clk_i => vfat2_clk_i, reset_i => reset_i, en_i => vfat2_dvalid_i(0), data_i => vfat2_data_2_i, en_o => track_en(2), data_o => track_data(2));
    track_3_inst : entity work.tracking_decoder port map(vfat2_clk_i => vfat2_clk_i, reset_i => reset_i, en_i => vfat2_dvalid_i(1), data_i => vfat2_data_3_i, en_o => track_en(3), data_o => track_data(3)); -- Should be 0
    track_4_inst : entity work.tracking_decoder port map(vfat2_clk_i => vfat2_clk_i, reset_i => reset_i, en_i => vfat2_dvalid_i(1), data_i => vfat2_data_4_i, en_o => track_en(4), data_o => track_data(4)); 
    track_5_inst : entity work.tracking_decoder port map(vfat2_clk_i => vfat2_clk_i, reset_i => reset_i, en_i => vfat2_dvalid_i(1), data_i => vfat2_data_5_i, en_o => track_en(5), data_o => track_data(5));
    track_6_inst : entity work.tracking_decoder port map(vfat2_clk_i => vfat2_clk_i, reset_i => reset_i, en_i => vfat2_dvalid_i(1), data_i => vfat2_data_6_i, en_o => track_en(6), data_o => track_data(6));
    track_7_inst : entity work.tracking_decoder port map(vfat2_clk_i => vfat2_clk_i, reset_i => reset_i, en_i => vfat2_dvalid_i(1), data_i => vfat2_data_7_i, en_o => track_en(7), data_o => track_data(7));

    --================================--
    -- Concentrator
    --================================--  
    
    tracking_concentrator_inst : entity work.tracking_concentrator
    port map(
        vfat2_clk_i         => vfat2_clk_i,
        reset_i             => reset_i,
        en_i                => track_en,
        data_i              => track_data,
        fifo_read_o         => trigger_fifo_rd,
        fifo_valid_i        => trigger_fifo_valid,
        fifo_underflow_i    => trigger_fifo_underflow,
        fifo_data_i         => trigger_fifo_dout,
        en_o                => data_fifo_wr,
        data_o              => data_fifo_din
    );
    
    --================================--
    -- Tracking data FIFO
    --================================--  
   
    tracking_data_fifo_inst : entity work.tracking_data_fifo
    port map(
        rst         => reset_i,
        wr_clk      => vfat2_clk_i,
        wr_en       => data_fifo_wr,
        din         => data_fifo_din,
        rd_clk      => gtp_clk_i,
        rd_en       => data_fifo_rd,
        valid       => data_fifo_valid,
        underflow   => data_fifo_underflow,
        dout        => data_fifo_dout,
        empty       => open,
        full        => open
    );
    
    --================================--
    -- Data access
    --================================--  
    
    tracking_readout_inst : entity work.tracking_readout
    port map(
        gtp_clk_i           => gtp_clk_i,
        reset_i             => reset_i,
        fifo_read_o         => data_fifo_rd,
        fifo_valid_i        => data_fifo_valid,
        fifo_underflow_i    => data_fifo_underflow,
        fifo_data_i         => data_fifo_dout,
        tx_ready_o          => tx_ready_o,
        tx_done_i           => tx_done_i,
        tx_data_o           => tx_data_o
    );
    
end Behavioral;

