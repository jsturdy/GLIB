library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.user_package.all;

entity optohybrid_top is
port(

    -- OptoHybrid signals

    fpga_clk_i          : in std_logic;
    fpga_rx_i           : in std_logic;
    fpga_tx_o           : out std_logic;
    enable_gtp_o        : out std_logic; 
    fpga_test_io        : inout std_logic_vector(5 downto 0);
    leds_o              : out std_logic_vector(3 downto 0);
    
    -- CDCE signals
    
    cdce_le_o           : out std_logic;
    cdce_miso_i         : in std_logic;
    cdce_mosi_o         : out std_logic;
    cdce_sclk_o         : out std_logic;
    
    cdce_auxout_i       : in std_logic;
    cdce_pll_locked_i   : in std_logic;
    cdce_powerdown_o    : out std_logic;
    cdce_ref_o          : out std_logic;
    cdce_sync_o         : out std_logic;
    cdce_pri_p_o        : out std_logic;
    cdce_pri_n_o        : out std_logic;
    
    -- VFAT2 common lines
    
    vfat2_resets_o      : out std_logic_vector(1 downto 0);
    vfat2_mclk_p_o      : out std_logic;
    vfat2_mclk_n_o      : out std_logic;
    vfat2_t1_p_o        : out std_logic;
    vfat2_t1_n_o        : out std_logic;
    vfat2_sda_io        : inout std_logic_vector(5 downto 0);
    vfat2_scl_o         : inout std_logic_vector(5 downto 0);
    vfat2_dvalid_i      : in std_logic_vector(5 downto 0);

    -- VFAT2 signal lines
    
    vfat2_data_0_i      : in std_logic_vector(8 downto 0); -- 7 downto 0 = S bits, 8 = data_out (tracking)
    vfat2_data_1_i      : in std_logic_vector(8 downto 0);
    vfat2_data_2_i      : in std_logic_vector(8 downto 0);
    vfat2_data_3_i      : in std_logic_vector(8 downto 0);
    vfat2_data_4_i      : in std_logic_vector(8 downto 0);
    vfat2_data_5_i      : in std_logic_vector(8 downto 0);
    vfat2_data_6_i      : in std_logic_vector(8 downto 0);
    vfat2_data_7_i      : in std_logic_vector(8 downto 0);
    vfat2_data_8_i      : in std_logic_vector(8 downto 0); 
    vfat2_data_9_i      : in std_logic_vector(8 downto 0);
    vfat2_data_10_i     : in std_logic_vector(8 downto 0);
    vfat2_data_11_i     : in std_logic_vector(8 downto 0);
    vfat2_data_12_i     : in std_logic_vector(8 downto 0);
    vfat2_data_13_i     : in std_logic_vector(8 downto 0);
    vfat2_data_14_i     : in std_logic_vector(8 downto 0);
    vfat2_data_15_i     : in std_logic_vector(8 downto 0);
    vfat2_data_16_i     : in std_logic_vector(8 downto 0);
    vfat2_data_17_i     : in std_logic_vector(8 downto 0);
    vfat2_data_18_i     : in std_logic_vector(8 downto 0);
    vfat2_data_19_i     : in std_logic_vector(8 downto 0);
    vfat2_data_20_i     : in std_logic_vector(8 downto 0);
    vfat2_data_21_i     : in std_logic_vector(8 downto 0);
    vfat2_data_22_i     : in std_logic_vector(8 downto 0);
    vfat2_data_23_i     : in std_logic_vector(8 downto 0);
    
    -- GTP signals
    
    rx_p_i              : in std_logic_vector(3 downto 0);
    rx_n_i              : in std_logic_vector(3 downto 0);
    tx_p_o              : out std_logic_vector(3 downto 0);
    tx_n_o              : out std_logic_vector(3 downto 0);
    
    gtp_refclk_p_i      : in std_logic_vector(3 downto 0);
    gtp_refclk_n_i      : in std_logic_vector(3 downto 0)
    
);
end optohybrid_top;

architecture Behavioral of optohybrid_top is
    
    -- Resets
    
    signal reset                        : std_logic := '0';
    
    -- External signals through LEMOs
    
    signal vfat2_clk_ext                : std_logic := '0';
    signal ext_lv1a                     : std_logic := '0';
    signal ext_sbits                    : std_logic := '0';
    
    -- VFAT2
    
    signal vfat2_t1                     : std_logic := '0';
    
    signal vfat2_sda_i                  : std_logic_vector(5 downto 0) := (others => '0');
    signal vfat2_sda_o                  : std_logic_vector(5 downto 0) := (others => '0');
    signal vfat2_sda_t                  : std_logic_vector(5 downto 0) := (others => '0');
    
    -- Clocking
    
    signal fpga_clk                     : std_logic := '0';
    signal vfat2_clk_fpga               : std_logic := '0';
    signal fpga_pll_locked              : std_logic := '0';
    
    signal rec_clk                      : std_logic := '0';
    signal cdce_clk_rec                 : std_logic := '0';
    signal rec_pll_locked               : std_logic := '0';
    
    signal vfat2_clk_muxed              : std_logic := '0';
    signal cdce_clk_muxed               : std_logic := '0';
    
    signal gtp_clk                      : std_logic := '0';
    signal vfat2_clk                    : std_logic := '0';
    
    signal vfat2_src_select             : std_logic := '0';
    signal vfat2_fallback               : std_logic := '0';
    signal vfat2_reset_src              : std_logic := '0';
    
    signal cdce_src_select              : std_logic_vector(1 downto 0) := (others => '0');
    signal cdce_fallback                : std_logic := '0';
    signal cdce_reset_src               : std_logic := '0';
    
    -- GTP
    
    signal rx_error                     : std_logic_vector(3 downto 0) := (others => '0');
    signal rx_kchar                     : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_data                      : std_logic_vector(63 downto 0) := (others => '0');
    signal tx_kchar                     : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_data                      : std_logic_vector(63 downto 0) := (others => '0');
    
    -- Registers requests
    
    signal request_write                : array32(63 downto 0) := (others => (others => '0'));
    signal request_tri                  : std_logic_vector(63 downto 0);
    signal request_read                 : array32(63 downto 0) := (others => (others => '0'));
    
    -- Sbits
   
    signal sbits_configuration          : std_logic_vector(2 downto 0) := (others => '0');
    
    -- T1 signals
    
    signal delayed_enable               : std_logic := '0';
    signal delayed_configuration        : std_logic_vector(31 downto 0) := (others => '0');
    signal delayed_lv1a                 : std_logic := '0';
    signal delayed_calpulse             : std_logic := '0';
    
    signal req_lv1a                     : std_logic := '0';
    signal req_calpulse                 : std_logic := '0';
    signal req_resync                   : std_logic := '0';
    signal req_bc0                      : std_logic := '0';
    
    signal trigger_configuration        : std_logic_vector(1 downto 0) := (others => '0');
    
    signal t1_lv1a                      : std_logic := '0';
    signal t1_calpulse                  : std_logic := '0';
    signal t1_resync                    : std_logic := '0';
    signal t1_bc0                       : std_logic := '0';
    
    -- ADC
    
    signal adc_voltage_value            : std_logic_vector(31 downto 0) := (others => '0');
    signal adc_current_value            : std_logic_vector(31 downto 0) := (others => '0');

    -- Counters

    signal ext_lv1a_counter             : std_logic_vector(31 downto 0) := (others => '0');
    signal int_lv1a_counter             : std_logic_vector(31 downto 0) := (others => '0');
    signal del_lv1a_counter             : std_logic_vector(31 downto 0) := (others => '0');
    signal lv1a_counter                 : std_logic_vector(31 downto 0) := (others => '0');
    signal int_calpulse_counter         : std_logic_vector(31 downto 0) := (others => '0');
    signal del_calpulse_counter         : std_logic_vector(31 downto 0) := (others => '0');
    signal calpulse_counter             : std_logic_vector(31 downto 0) := (others => '0');
    signal resync_counter               : std_logic_vector(31 downto 0) := (others => '0');
    signal bc0_counter                  : std_logic_vector(31 downto 0) := (others => '0');
    signal bx_x4_counter                : std_logic_vector(31 downto 0) := (others => '0');
    signal bx_counter                   : std_logic_vector(31 downto 0) := (others => '0');
    
    signal ext_lv1a_counter_reset       : std_logic := '0';
    signal int_lv1a_counter_reset       : std_logic := '0';
    signal del_lv1a_counter_reset       : std_logic := '0';
    signal lv1a_counter_reset           : std_logic := '0';
    signal int_calpulse_counter_reset   : std_logic := '0';
    signal del_calpulse_counter_reset   : std_logic := '0';
    signal calpulse_counter_reset       : std_logic := '0';
    signal resync_counter_reset         : std_logic := '0';
    signal bc0_counter_reset            : std_logic := '0';
    signal bx_counter_reset             : std_logic := '0';
    
begin
    
    --================================--
    -- External signals
    --================================--

    -- LV1A
    ext_lv1a_inst : entity work.monostable port map(fabric_clk_i => gtp_clk, en_i => fpga_test_io(3), en_o => ext_lv1a);
    
    --================================--
    -- VFAT2 
    --================================--
    
    -- Resets 
    vfat2_resets_o <= "11";
  
    -- T1
    t1_obufds : obufds port map(i => vfat2_t1, o => vfat2_t1_p_o, ob => vfat2_t1_n_o);
    
    -- I2C
    vfat2_sda_0_iobuf : iobuf port map (o => vfat2_sda_i(0), io => vfat2_sda_io(0), i => vfat2_sda_o(0), t => vfat2_sda_t(0));  
    
    --================================--
    -- Clocking
    --================================--
    
    -- FPGA clock
    fpga_clk_pll_inst : entity work.fpga_clk_pll port map(fpga_clk_i => fpga_clk_i, fpga_clk_o => fpga_clk, vfat2_clk_fpga_o => vfat2_clk_fpga, fpga_pll_locked_o => fpga_pll_locked);    
    
    -- VFAT2 clock
    vfat2_buf_clk_inst : bufg port map(i => vfat2_clk_fpga, o => vfat2_clk);
    
    vfat2_clk_obufds : obufds port map(i => vfat2_clk_fpga, o => vfat2_mclk_p_o, ob => vfat2_mclk_n_o);
    
    --================================--
    -- GTX
    --================================--
    
    gtx_wrapper_inst : entity work.gtx_wrapper
    port map(
        gtx_clk_o       => gtx_clk,
        reset_i         => reset_i,
        rx_error_o      => rx_error,
        rx_kchar_o      => rx_kchar,
        rx_data_o       => rx_data,
        rx_n_i          => sfp_rx_n,
        rx_p_i          => sfp_rx_p,
        tx_kchar_i      => tx_kchar,
        tx_data_i       => tx_data,
        tx_n_o          => sfp_tx_n,
        tx_p_o          => sfp_tx_p,
        gtp_refclk_n_i  => cdce_out1_n,
        gtp_refclk_p_i  => cdce_out1_p
    );   
    
    --================================--
    -- Tracking Link
    --================================--
    
    link_tracking_1_inst : entity work.link_tracking
    port map(
        gtp_clk_i       => gtp_clk,
        vfat2_clk_i     => vfat2_clk,
        reset_i         => reset,
        rx_error_i      => rx_error(1),
        rx_kchar_i      => rx_kchar(3 downto 2),
        rx_data_i       => rx_data(31 downto 16),
        tx_kchar_o      => tx_kchar(3 downto 2),
        tx_data_o       => tx_data(31 downto 16),
        request_write_o => request_write,
        request_tri_o   => request_tri,
        request_read_i  => request_read,
        lv1a_sent_i     => t1_lv1a,
        bx_counter_i    => bx_counter,
        vfat2_sda_i     => vfat2_sda_i(3 downto 2),
        vfat2_sda_o     => vfat2_sda_o(3 downto 2),
        vfat2_sda_t     => vfat2_sda_t(3 downto 2),
        vfat2_scl_o     => vfat2_scl_o(3 downto 2),
        vfat2_dvalid_i  => vfat2_dvalid_i(3 downto 2),
        vfat2_data_0_i  => vfat2_data_8_i(8),
        vfat2_data_1_i  => vfat2_data_9_i(8),
        vfat2_data_2_i  => vfat2_data_10_i(8),
        vfat2_data_3_i  => vfat2_data_11_i(8),
        vfat2_data_4_i  => vfat2_data_12_i(8),
        vfat2_data_5_i  => vfat2_data_13_i(8),
        vfat2_data_6_i  => vfat2_data_14_i(8),
        vfat2_data_7_i  => vfat2_data_15_i(8)
    );
    
    --================================--
    -- Trigger Link : simplified version for Test Beam
    --================================--
    
    link_trigger_inst : entity work.link_trigger
    port map(
        gtp_clk_i       => gtp_clk,
        vfat2_clk_i     => vfat2_clk,
        reset_i         => reset,
        rx_error_i      => rx_error(3),
        rx_kchar_i      => rx_kchar(7 downto 6),
        rx_data_i       => rx_data(63 downto 48),
        tx_kchar_o      => tx_kchar(7 downto 6),
        tx_data_o       => tx_data(63 downto 48),
        bx_counter_i    => bx_counter,
        vfat2_data_0_i  => vfat2_data_0_i(7 downto 0),
        vfat2_data_1_i  => vfat2_data_1_i(7 downto 0),
        vfat2_data_2_i  => vfat2_data_2_i(7 downto 0),
        vfat2_data_3_i  => vfat2_data_3_i(7 downto 0),
        vfat2_data_4_i  => vfat2_data_4_i(7 downto 0),
        vfat2_data_5_i  => vfat2_data_5_i(7 downto 0),
        vfat2_data_6_i  => vfat2_data_6_i(7 downto 0),
        vfat2_data_7_i  => vfat2_data_7_i(7 downto 0),
        vfat2_data_8_i  => vfat2_data_8_i(7 downto 0),
        vfat2_data_9_i  => vfat2_data_9_i(7 downto 0),
        vfat2_data_10_i => vfat2_data_10_i(7 downto 0),
        vfat2_data_11_i => vfat2_data_11_i(7 downto 0),
        vfat2_data_12_i => vfat2_data_12_i(7 downto 0),
        vfat2_data_13_i => vfat2_data_13_i(7 downto 0),
        vfat2_data_14_i => vfat2_data_14_i(7 downto 0),
        vfat2_data_15_i => vfat2_data_15_i(7 downto 0),
        vfat2_data_16_i => vfat2_data_16_i(7 downto 0),
        vfat2_data_17_i => vfat2_data_17_i(7 downto 0),
        vfat2_data_18_i => vfat2_data_18_i(7 downto 0),
        vfat2_data_19_i => vfat2_data_19_i(7 downto 0),
        vfat2_data_20_i => vfat2_data_20_i(7 downto 0),
        vfat2_data_21_i => vfat2_data_21_i(7 downto 0),
        vfat2_data_22_i => vfat2_data_22_i(7 downto 0),
        vfat2_data_23_i => vfat2_data_23_i(7 downto 0)
    );
        
    --================================--
    -- SBits : for Test Beam only
    --================================--
    
    trigger_sbits_inst : entity work.trigger_sbits
    port map(
        vfat2_0_sbits   => vfat2_data_8_i(7 downto 0),
        vfat2_1_sbits   => vfat2_data_9_i(7 downto 0),
        vfat2_2_sbits   => vfat2_data_10_i(7 downto 0),
        vfat2_3_sbits   => vfat2_data_11_i(7 downto 0),
        vfat2_4_sbits   => vfat2_data_12_i(7 downto 0),
        vfat2_5_sbits   => vfat2_data_13_i(7 downto 0),
        sbit_config_i   => sbits_configuration,
        to_tdc_o        => ext_sbits
    );
    
    --================================--
    -- T1 handling
    --================================--
    
    t1_delayed_inst : entity work.t1_delayed
    port map(
        fabric_clk_i    => gtp_clk,
        reset_i         => reset,
        en_i            => delayed_enable,
        delay_i         => delayed_configuration, 
        lv1a_o          => delayed_lv1a,
        calpulse_o      => delayed_calpulse
    );
        
    trigger_handler_inst : entity work.trigger_handler
    port map(
        fabric_clk_i        => gtp_clk,
        reset_i             => reset,
        req_trigger_i       => req_lv1a,
        delayed_trigger_i   => delayed_lv1a,
        ext_trigger_i       => ext_lv1a,
        trigger_config_i    => trigger_configuration,
        lv1a_o              => t1_lv1a
    );
    
    t1_calpulse <= req_calpulse or delayed_calpulse;
    
    t1_resync <= req_resync;
    
    t1_bc0 <= req_bc0;

    t1_handler_inst : entity work.t1_handler 
    port map(
        fabric_clk_i    => gtp_clk,
        vfat2_clk_i     => vfat2_clk,
        reset_i         => reset,
        lv1a_i          => t1_lv1a,
        calpulse_i      => t1_calpulse,
        resync_i        => t1_resync,
        bc0_i           => t1_bc0,
        t1_o            => vfat2_t1  
    );
  
    --================================--
    -- ADC
    --================================--
    
    adc_handler_inst : entity work.adc_handler
    port map(
        fabric_clk_i    => gtp_clk,
        reset_i         => reset,
        uart_rx_i       => fpga_rx_i,
        voltage_o       => adc_voltage_value,
        current_o       => adc_current_value
    );
    
    --================================--
    -- Counters registers
    --================================--

    ext_lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => ext_lv1a_counter_reset, en_i => ext_lv1a, data_o => ext_lv1a_counter);
    int_lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => int_lv1a_counter_reset, en_i => req_lv1a, data_o => int_lv1a_counter);
    del_lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => del_lv1a_counter_reset, en_i => delayed_lv1a, data_o => del_lv1a_counter);
    lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => lv1a_counter_reset, en_i => t1_lv1a, data_o => lv1a_counter);
    
    int_calpulse_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => int_calpulse_counter_reset, en_i => req_calpulse, data_o => int_calpulse_counter);
    del_calpulse_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => del_calpulse_counter_reset, en_i => delayed_calpulse, data_o => del_calpulse_counter);
    calpulse_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => calpulse_counter_reset, en_i => t1_calpulse, data_o => calpulse_counter);
    
    resync_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => resync_counter_reset, en_i => t1_resync, data_o => resync_counter);
    
    bc0_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => bc0_counter_reset, en_i => t1_bc0, data_o => bc0_counter);
    
    bx_counter_inst : entity work.counter port map(fabric_clk_i => gtp_clk, reset_i => bx_counter_reset, en_i => '1', data_o => bx_x4_counter);
    bx_counter <= "00" & bx_x4_counter(31 downto 2);
        

        
    --================================--
    -- Requests mapping
    --================================--
    
    
    
    -- T1 operations : 3 downto 0
    
    req_lv1a <= request_tri(0); -- write _ send LV1A
    
    req_calpulse <= request_tri(1); -- write _ send Calpulse
    
    req_resync <= request_tri(2); -- write _ send Resync
    
    req_bc0 <= request_tri(3); -- write _ send BC0
    bx_counter_reset <= request_tri(3);  
    
    -- T1 delayed operations : 4 -- write _ Send a delayed LV1A and Calpulse signal
    
    delayed_enable <= request_tri(4);
    delayed_configuration <= request_write(4);
    
    -- Trigger configuration : 5 -- read / write _ Change the trigger source

    trigger_configuration_reg : entity work.reg port map(fabric_clk_i => gtp_clk, reset_i => reset, wbus_i => request_write(5), wbus_t => request_tri(5), rbus_o => request_read(5));        
    trigger_configuration <= request_read(5)(1 downto 0);

    -- S Bits configuration : 6 -- read / write _ Controls the Sbits to send to the TDC
    
    sbits_configuration_reg : entity work.reg port map(fabric_clk_i => gtp_clk, reset_i => reset, wbus_i => request_write(6), wbus_t => request_tri(6), rbus_o => request_read(6));        
    sbits_configuration <= request_read(6)(2 downto 0); 
   
    -- Reserved : 10 downto 7 
    
    request_read(10 downto 7) <= (others => (others => '0'));
   


    -- VFAT2 clock selection : 12 downto 11
   
    vfat2_clk_reg : entity work.reg port map(fabric_clk_i => gtp_clk, reset_i => vfat2_reset_src, wbus_i => request_write(11), wbus_t => request_tri(11), rbus_o => request_read(11));         
    vfat2_src_select <= request_read(11)(0); -- 11 -- read / write _ Select VFAT2 input clock
    
    vfat2_fallback_reg : entity work.reg port map(fabric_clk_i => gtp_clk, reset_i => reset, wbus_i => request_write(12), wbus_t => request_tri(12), rbus_o => request_read(12));        
    vfat2_fallback <= request_read(12)(0); -- 12 -- read / write _ Allow automatic fallback of VFAT2         
    
    -- CDCE clock selection : 14 downto 13
    
    cdce_clk_reg : entity work.reg port map(fabric_clk_i => gtp_clk, reset_i => cdce_reset_src, wbus_i => request_write(13), wbus_t => request_tri(13), rbus_o => request_read(13));        
    cdce_src_select <= request_read(13)(1 downto 0); -- 13 _ read / write _ Select CDCE input clock

    cdce_fallback_reg : entity work.reg port map(fabric_clk_i => gtp_clk, reset_i => reset, wbus_i => request_write(14), wbus_t => request_tri(14), rbus_o => request_read(14));        
    cdce_fallback <= request_read(14)(0); -- 14 -- read / write _ Allow automatic fallback of CDCE clocks    
    
    -- PLL status : 17 downto 15
    
    request_read(15) <= (0 => fpga_pll_locked, others => '0'); -- read _ FPGA PLL locked
   
    request_read(16) <= (0 => cdce_pll_locked_i, others => '0'); -- read _ CDCE Locked
    
    request_read(17) <= (0 => rec_pll_locked, others => '0'); -- read _ GTP recovered clock PLL locked
    
    -- Reserved : 20 downto 18 
    
    request_read(20 downto 18) <= (others => (others => '0'));
    
    
    
    -- ADC : 22 downto 21

    request_read(21) <= adc_voltage_value; -- read _ ADC voltage value
    
    request_read(22) <= adc_current_value; -- read _ ADC current value
    
    -- Fixed registers : 23 -- read _ firmware version
    
    request_read(23) <= x"20141117"; 
    
    -- Reserved : 25 downto 24
    
    request_read(25 downto 24) <= (others => (others => '0'));
    
    
    
    -- Counters : 35 downto 26
    
    request_read(26) <= ext_lv1a_counter;
   
    request_read(27) <= int_lv1a_counter;
    
    request_read(28) <= del_lv1a_counter;
    
    request_read(29) <= lv1a_counter;
    
    request_read(30) <= int_calpulse_counter;
    
    request_read(31) <= del_calpulse_counter;
    
    request_read(32) <= calpulse_counter;
    
    request_read(33) <= resync_counter;
    
    request_read(34) <= bc0_counter;
    
    request_read(35) <= bx_counter;
    
    -- Reserved : 37 downto 36
    
    request_read(37 downto 36) <= (others => (others => '0'));
    
    
    -- T1 counters reset : 46 downto 38
    
    ext_lv1a_counter_reset <= request_tri(38);
    
    int_lv1a_counter_reset <= request_tri(39);
    
    del_lv1a_counter_reset <= request_tri(40);
    
    lv1a_counter_reset <= request_tri(41);
    
    int_calpulse_counter_reset <= request_tri(42);
    
    del_calpulse_counter_reset <= request_tri(43);
    
    calpulse_counter_reset <= request_tri(44);
    
    resync_counter_reset <= request_tri(45);
    
    bc0_counter_reset <= request_tri(46);
    
    -- Reserved : 47
    
    request_read(47) <= (others => '0');
    
    
    
    -- Other registers : 63 downto 48
    
end Behavioral;