library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! xilinx packages
library unisim;
use unisim.vcomponents.all;

--! system packages
library work;
use work.system_flash_sram_package.all;
use work.system_pcie_package.all;
use work.system_package.all;
use work.fmc_package.all;
use work.wb_package.all;
use work.ipbus.all;

--! user packages
use work.user_package.all;
use work.user_version_package.all;

entity user_logic is
port(
    --================================--
    -- USER MGT REFCLKs
    --================================--
    -- BANK_112(Q0):
    clk125_1_p                  : in std_logic;
    clk125_1_n                  : in std_logic;
    cdce_out0_p                 : in std_logic;
    cdce_out0_n                 : in std_logic;
    -- BANK_113(Q1):
    fmc2_clk0_m2c_xpoint2_p     : in std_logic;
    fmc2_clk0_m2c_xpoint2_n     : in std_logic;
    cdce_out1_p                 : in std_logic; -- GTX clock speed must be 160 MHz
    cdce_out1_n                 : in std_logic; -- GTX clock speed must be 160 MHz
    -- BANK_114(Q2):
    pcie_clk_p                  : in std_logic;
    pcie_clk_n                  : in std_logic;
    cdce_out2_p                 : in std_logic;
    cdce_out2_n                 : in std_logic;
    -- BANK_115(Q3):
    clk125_2_i                  : in std_logic;
    fmc1_gbtclk1_m2c_p          : in std_logic;
    fmc1_gbtclk1_m2c_n          : in std_logic;
    -- BANK_116(Q4):
    fmc1_gbtclk0_m2c_p          : in std_logic;
    fmc1_gbtclk0_m2c_n          : in std_logic;
    cdce_out3_p                 : in std_logic;
    cdce_out3_n                 : in std_logic;
    --================================--
    -- USER FABRIC CLOCKS
    --================================--
    xpoint1_clk3_p              : in std_logic;
    xpoint1_clk3_n              : in std_logic;
    ------------------------------------
    cdce_out4_p                 : in std_logic;
    cdce_out4_n                 : in std_logic;
    ------------------------------------
    amc_tclkb_o                 : out std_logic;
    ------------------------------------
    fmc1_clk0_m2c_xpoint2_p     : in std_logic;
    fmc1_clk0_m2c_xpoint2_n     : in std_logic;
    fmc1_clk1_m2c_p             : in std_logic;
    fmc1_clk1_m2c_n             : in std_logic;
    fmc1_clk2_bidir_p           : in std_logic;
    fmc1_clk2_bidir_n           : in std_logic;
    fmc1_clk3_bidir_p           : in std_logic;
    fmc1_clk3_bidir_n           : in std_logic;
    ------------------------------------
    fmc2_clk1_m2c_p             : in std_logic;
    fmc2_clk1_m2c_n             : in std_logic;
    --================================--
    -- GBT PHASE MONITORING MGT REFCLK
    --================================--
    cdce_out0_gtxe1_o           : out std_logic;
    cdce_out3_gtxe1_o           : out std_logic;
    --================================--
    -- AMC PORTS
    --================================--
    amc_port_tx_p               : out std_logic_vector(1 to 15);
    amc_port_tx_n               : out std_logic_vector(1 to 15);
    amc_port_rx_p               : in std_logic_vector(1 to 15);
    amc_port_rx_n               : in std_logic_vector(1 to 15);
    ------------------------------------
    amc_port_tx_out             : out std_logic_vector(17 to 20);
    amc_port_tx_in              : in std_logic_vector(17 to 20);
    amc_port_tx_de              : out std_logic_vector(17 to 20);
    amc_port_rx_out             : out std_logic_vector(17 to 20);
    amc_port_rx_in              : in std_logic_vector(17 to 20);
    amc_port_rx_de              : out std_logic_vector(17 to 20);
    --================================--
    -- SFP QUAD
    --================================--
    sfp_tx_p                    : out std_logic_vector(1 to 4);
    sfp_tx_n                    : out std_logic_vector(1 to 4);
    sfp_rx_p                    : in std_logic_vector(1 to 4);
    sfp_rx_n                    : in std_logic_vector(1 to 4);
    sfp_mod_abs                 : in std_logic_vector(1 to 4);
    sfp_rxlos                   : in std_logic_vector(1 to 4);
    sfp_txfault                 : in std_logic_vector(1 to 4);
    --================================--
    -- FMC1
    --================================--
    fmc1_tx_p                   : out std_logic_vector(1 to 4);
    fmc1_tx_n                   : out std_logic_vector(1 to 4);
    fmc1_rx_p                   : in std_logic_vector(1 to 4);
    fmc1_rx_n                   : in std_logic_vector(1 to 4);
    ------------------------------------
    fmc1_io_pin                 : inout fmc_io_pin_type;
    ------------------------------------
    fmc1_clk_c2m_p              : out std_logic_vector(0 to 1);
    fmc1_clk_c2m_n              : out std_logic_vector(0 to 1);
    fmc1_present_l              : in std_logic;
    --================================--
    -- FMC2
    --================================--
    fmc2_io_pin                 : inout fmc_io_pin_type;
    ------------------------------------
    fmc2_clk_c2m_p              : out std_logic_vector(0 to 1);
    fmc2_clk_c2m_n              : out std_logic_vector(0 to 1);
    fmc2_present_l              : in std_logic;
    --================================--
    -- SYSTEM GBE
    --================================--
    sys_eth_amc_p1_tx_p         : in std_logic;
    sys_eth_amc_p1_tx_n         : in std_logic;
    sys_eth_amc_p1_rx_p         : out std_logic;
    sys_eth_amc_p1_rx_n         : out std_logic;
    ------------------------------------
    user_mac_syncacqstatus_i    : in std_logic_vector(0 to 3);
    user_mac_serdes_locked_i    : in std_logic_vector(0 to 3);
    --================================--
    -- SYSTEM PCIe
    --================================--
    sys_pcie_mgt_refclk_o       : out std_logic;
    user_sys_pcie_dma_clk_i     : in std_logic;
    ------------------------------------
    sys_pcie_amc_tx_p           : in std_logic_vector(0 to 3);
    sys_pcie_amc_tx_n           : in std_logic_vector(0 to 3);
    sys_pcie_amc_rx_p           : out std_logic_vector(0 to 3);
    sys_pcie_amc_rx_n           : out std_logic_vector(0 to 3);
    ------------------------------------
    user_sys_pcie_slv_o         : out R_slv_to_ezdma2;
    user_sys_pcie_slv_i         : in R_slv_from_ezdma2;
    user_sys_pcie_dma_o         : out R_userDma_to_ezdma2_array  (1 to 7);
    user_sys_pcie_dma_i         : in R_userDma_from_ezdma2_array(1 to 7);
    user_sys_pcie_int_o         : out R_int_to_ezdma2;
    user_sys_pcie_int_i         : in R_int_from_ezdma2;
    user_sys_pcie_cfg_i         : in R_cfg_from_ezdma2;
    --================================--
    -- SRAMs
    --================================--
    user_sram_control_o         : out userSramControlR_array(1 to 2);
    user_sram_addr_o            : out array_2x21bit;
    user_sram_wdata_o           : out array_2x36bit;
    user_sram_rdata_i           : in array_2x36bit;
    ------------------------------------
    sram1_bwa                   : out std_logic;
    sram1_bwb                   : out std_logic;
    sram1_bwc                   : out std_logic;
    sram1_bwd                   : out std_logic;
    sram2_bwa                   : out std_logic;
    sram2_bwb                   : out std_logic;
    sram2_bwc                   : out std_logic;
    sram2_bwd                   : out std_logic;
    --================================--
    -- CLK CIRCUITRY
    --================================--
    fpga_clkout_o               : out std_logic;
    ------------------------------------
    sec_clk_o                   : out std_logic;
    ------------------------------------
    user_cdce_locked_i          : in std_logic;
    user_cdce_sync_done_i       : in std_logic;
    user_cdce_sel_o             : out std_logic;
    user_cdce_sync_o            : out std_logic;
    --================================--
    -- USER BUS
    --================================--
    wb_miso_o                   : out wb_miso_bus_array(0 to number_of_wb_slaves-1);
    wb_mosi_i                   : in wb_mosi_bus_array(0 to number_of_wb_slaves-1);
    ------------------------------------
    ipb_clk_i                   : in std_logic;
    ipb_miso_o                  : out ipb_rbus_array(0 to number_of_ipb_slaves-1);
    ipb_mosi_i                  : in ipb_wbus_array(0 to number_of_ipb_slaves-1);
    --================================--
    -- VARIOUS
    --================================--
    reset_i                     : in std_logic;
    user_clk125_i               : in std_logic;
    user_clk200_i               : in std_logic;
    ------------------------------------
    sn                          : in std_logic_vector(7 downto 0);
    -------------------------------------
    amc_slot_i                  : in std_logic_vector( 3 downto 0);
    mac_addr_o                  : out std_logic_vector(47 downto 0);
    ip_addr_o                   : out std_logic_vector(31 downto 0);
    ------------------------------------
    user_v6_led_o               : out std_logic_vector(1 to 2)
);
end user_logic;

architecture user_logic_arch of user_logic is
    
    -- External signals through LEMOs
    
    signal ext_sbits                    : std_logic := '0';
    signal ext_lv1a                     : std_logic := '0';
    
    -- VFAT2
    
    signal vfat2_t1                     : std_logic := '0';
    
    signal vfat2_sda_i                  : std_logic_vector(5 downto 0) := (others => '0');
    signal vfat2_sda_o                  : std_logic_vector(5 downto 0) := (others => '0');
    signal vfat2_sda_t                  : std_logic_vector(5 downto 0) := (others => '0');
    signal vfat2_scl_o                  : std_logic_vector(5 downto 0) := (others => '0');
    
    signal vfat2_dvalid_i               : std_logic_vector(5 downto 0) := (others => '0');
      
    signal vfat2_data_0_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_1_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_2_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_3_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_4_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_5_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_6_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_7_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_8_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_9_i               : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_10_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_11_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_12_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_13_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_14_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_15_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_16_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_17_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_18_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_19_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_20_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_21_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_22_i              : std_logic_vector(8 downto 0) := (others => '0');
    signal vfat2_data_23_i              : std_logic_vector(8 downto 0) := (others => '0');
    
    -- Clocking
    
    signal fpga_clk                     : std_logic := '0';
    signal vfat2_clk_fpga               : std_logic := '0';
    signal fpga_pll_locked              : std_logic := '0';
    
    signal vfat2_clk_muxed              : std_logic := '0';
    
    signal gtx_clk                      : std_logic := '0';
    signal vfat2_clk                    : std_logic := '0';
    
    signal vfat2_src_select             : std_logic := '0';
    signal vfat2_fallback               : std_logic := '0';
    signal vfat2_reset_src              : std_logic := '0';
    
    signal cdce_src_select              : std_logic_vector(1 downto 0) := (others => '0');
    signal cdce_fallback                : std_logic := '0';
    signal cdce_reset_src               : std_logic := '0';
    signal cdce_pll_locked              : std_logic := '0';
    signal rec_pll_locked               : std_logic := '0';
    
    -- GTX
    
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
    

    signal cs_icon0                 : std_logic_vector(35 downto 0) := (others => '0');
    signal cs_icon1                 : std_logic_vector(35 downto 0) := (others => '0');
    
    signal cs_async_in              : std_logic_vector(15 downto 0) := (others => '0');
    signal cs_async_out             : std_logic_vector(15 downto 0) := (others => '0');
    signal cs_sync_in               : std_logic_vector(15 downto 0) := (others => '0');
    signal cs_sync_out              : std_logic_vector(15 downto 0) := (others => '0');
    
    signal cs_ila0                  : std_logic_vector(31 downto 0);
    signal cs_ila1                  : std_logic_vector(31 downto 0);
    signal cs_ila2                  : std_logic_vector(31 downto 0);
    signal cs_ila3                  : std_logic_vector(31 downto 0);
    
    
begin

    ip_addr_o <= x"c0a80073";  -- 192.168.0.115
    mac_addr_o <= x"080030F100a" & amc_slot_i;  -- 08:00:30:F1:00:0[A0:AF]
    user_v6_led_o(1) <= '0';
    user_v6_led_o(2) <= '0';

    --================================--
    -- External signals
    --================================--

    -- LV1A
    ext_lv1a_inst : entity work.monostable port map(fabric_clk_i => gtx_clk, en_i => fmc2_io_pin.la_n(10), en_o => ext_lv1a);
    fmc2_io_pin.la_p(10) <= ext_sbits;
    
    --================================--
    -- Clocking
    --================================--
    
    -- FPGA clock
    fpga_clk_pll_inst : entity work.fpga_clk_pll port map(
        clk200_i    => user_clk200_i,
        fpga_clk_o  => fpga_clk,
        vfat2_clk_o => vfat2_clk,
        mclk_o      => vfat2_clk_fpga,
        locked_o    => fpga_pll_locked
    );
    
    
    -- VFAT2 clock
    
    vfat2_clk_obufds : obufds port map(i => vfat2_clk_fpga, o => fmc2_io_pin.la_p(17), ob => fmc2_io_pin.la_n(17));
    
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
        gtp_clk_i       => gtx_clk,
        vfat2_clk_i     => vfat2_clk,
        reset_i         => reset_i,
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
        gtp_clk_i       => gtx_clk,
        vfat2_clk_i     => vfat2_clk,
        reset_i         => reset_i,
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
        fabric_clk_i    => gtx_clk,
        reset_i         => reset_i,
        en_i            => delayed_enable,
        delay_i         => delayed_configuration, 
        lv1a_o          => delayed_lv1a,
        calpulse_o      => delayed_calpulse
    );
        
    trigger_handler_inst : entity work.trigger_handler
    port map(
        fabric_clk_i        => gtx_clk,
        reset_i             => reset_i,
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
        fabric_clk_i    => gtx_clk,
        vfat2_clk_i     => vfat2_clk,
        reset_i         => reset_i,
        lv1a_i          => t1_lv1a,
        calpulse_i      => t1_calpulse,
        resync_i        => t1_resync,
        bc0_i           => t1_bc0,
        t1_o            => vfat2_t1  
    );
    
    --================================--
    -- Counters registers
    --================================--

    ext_lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => ext_lv1a_counter_reset, en_i => ext_lv1a, data_o => ext_lv1a_counter);
    int_lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => int_lv1a_counter_reset, en_i => req_lv1a, data_o => int_lv1a_counter);
    del_lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => del_lv1a_counter_reset, en_i => delayed_lv1a, data_o => del_lv1a_counter);
    lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => lv1a_counter_reset, en_i => t1_lv1a, data_o => lv1a_counter);
    
    int_calpulse_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => int_calpulse_counter_reset, en_i => req_calpulse, data_o => int_calpulse_counter);
    del_calpulse_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => del_calpulse_counter_reset, en_i => delayed_calpulse, data_o => del_calpulse_counter);
    calpulse_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => calpulse_counter_reset, en_i => t1_calpulse, data_o => calpulse_counter);
    
    resync_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => resync_counter_reset, en_i => t1_resync, data_o => resync_counter);
    
    bc0_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => bc0_counter_reset, en_i => t1_bc0, data_o => bc0_counter);
    
    bx_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => bx_counter_reset, en_i => '1', data_o => bx_x4_counter);
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

    trigger_configuration_reg : entity work.reg port map(fabric_clk_i => gtx_clk, reset_i => reset_i, wbus_i => request_write(5), wbus_t => request_tri(5), rbus_o => request_read(5));        
    trigger_configuration <= request_read(5)(1 downto 0);

    -- S Bits configuration : 6 -- read / write _ Controls the Sbits to send to the TDC
    
    sbits_configuration_reg : entity work.reg port map(fabric_clk_i => gtx_clk, reset_i => reset_i, wbus_i => request_write(6), wbus_t => request_tri(6), rbus_o => request_read(6));        
    sbits_configuration <= request_read(6)(2 downto 0); 
   
    -- Reserved : 10 downto 7 
    
    request_read(10 downto 7) <= (others => (others => '0'));
   


    -- VFAT2 clock selection : 12 downto 11
   
    vfat2_clk_reg : entity work.reg port map(fabric_clk_i => gtx_clk, reset_i => vfat2_reset_src, wbus_i => request_write(11), wbus_t => request_tri(11), rbus_o => request_read(11));         
    vfat2_src_select <= request_read(11)(0); -- 11 -- read / write _ Select VFAT2 input clock
    
    vfat2_fallback_reg : entity work.reg port map(fabric_clk_i => gtx_clk, reset_i => reset_i, wbus_i => request_write(12), wbus_t => request_tri(12), rbus_o => request_read(12));        
    vfat2_fallback <= request_read(12)(0); -- 12 -- read / write _ Allow automatic fallback of VFAT2         
    
    -- CDCE clock selection : 14 downto 13
    
    cdce_clk_reg : entity work.reg port map(fabric_clk_i => gtx_clk, reset_i => cdce_reset_src, wbus_i => request_write(13), wbus_t => request_tri(13), rbus_o => request_read(13));        
    cdce_src_select <= request_read(13)(1 downto 0); -- 13 _ read / write _ Select CDCE input clock

    cdce_fallback_reg : entity work.reg port map(fabric_clk_i => gtx_clk, reset_i => reset_i, wbus_i => request_write(14), wbus_t => request_tri(14), rbus_o => request_read(14));        
    cdce_fallback <= request_read(14)(0); -- 14 -- read / write _ Allow automatic fallback of CDCE clocks    
    
    -- PLL status : 17 downto 15
    
    request_read(15) <= (0 => fpga_pll_locked, others => '0'); -- read _ FPGA PLL locked
   
    request_read(16) <= (0 => cdce_pll_locked, others => '0'); -- read _ CDCE Locked
    
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

    
    --================================--
    -- VFAT2 
    --================================--
    
    -- Resets 
    fmc2_io_pin.la_n(16) <= '1';
    fmc2_io_pin.la_p(15) <= '1';  
  
    -- T1
    t1_obufds : obufds port map(i => vfat2_t1, o => fmc2_io_pin.la_p(19), ob => fmc2_io_pin.la_n(19));
    
    -- I2C
    vfat2_sda_2_iobuf : iobuf port map (o => vfat2_sda_i(2), io => fmc2_io_pin.la_n(27), i => vfat2_sda_o(2), t => vfat2_sda_t(2));    
    fmc2_io_pin.la_p(27) <= vfat2_scl_o(2);    
    
    
    -- Tracking data
    data_valid_buffer : ibufds_lvds_25 port map(o => vfat2_dvalid_i(2), ib => fmc2_io_pin.la_n(22), i => fmc2_io_pin.la_p(22));  
    data_line_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(8), ib => fmc2_io_pin.la_n(21), i => fmc2_io_pin.la_p(21));		

    -- Trigger data
    s8_bit_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(7), ib => fmc2_io_pin.la_n(25), i => fmc2_io_pin.la_p(25));	 
    s7_bit_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(6), ib => fmc2_io_pin.la_n(24), i => fmc2_io_pin.la_p(24));
    s6_bit_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(5), ib => fmc2_io_pin.la_n(29), i => fmc2_io_pin.la_p(29));
    s5_bit_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(4), ib => fmc2_io_pin.la_n(28), i => fmc2_io_pin.la_p(28));
    s4_bit_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(3), ib => fmc2_io_pin.la_n(31), i => fmc2_io_pin.la_p(31));
    s3_bit_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(2), ib => fmc2_io_pin.la_n(30), i => fmc2_io_pin.la_p(30));
    s2_bit_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(1), ib => fmc2_io_pin.la_n(33), i => fmc2_io_pin.la_p(33));
    s1_bit_buffer : ibufds_lvds_25 port map(o => vfat2_data_8_i(0), ib => fmc2_io_pin.la_n(32), i => fmc2_io_pin.la_p(32));
    
    --================================--
    -- ChipScope
    --================================--

    chipscope_icon_inst : entity work.chipscope_icon port map (CONTROL0 => cs_icon0, CONTROL1 => cs_icon1);

    chipscope_vio_inst : entity work.chipscope_vio port map (CONTROL => cs_icon0, CLK => gtx_clk, ASYNC_IN => cs_async_in, ASYNC_OUT => cs_async_out, SYNC_IN => cs_sync_in, SYNC_OUT => cs_sync_out);

    --gtp_reset <= cs_sync_out(3 downto 0);

    chipscope_ila_inst : entity work.chipscope_ila port map (CONTROL => cs_icon1, CLK => gtx_clk, TRIG0 => cs_ila0, TRIG1 => cs_ila1, TRIG2 => cs_ila2, TRIG3 => cs_ila3);

    cs_ila0 <= tx_data(31 downto 16) & rx_data(31 downto 16);
    cs_ila1 <= tx_data(63 downto 48) & rx_data(63 downto 48);
    
    cs_ila2 <= (0 => vfat2_dvalid_i(0), 1 => vfat2_dvalid_i(1),
                2 => vfat2_data_8_i(8), 3 => vfat2_data_9_i(8), 4 => vfat2_data_10_i(8), 5 => vfat2_data_11_i(8), 6 => vfat2_data_12_i(8), 7 => vfat2_data_13_i(8),
                others => '0');
                
    cs_ila3 <= (0 => ext_lv1a, 1 => req_lv1a, 2 => t1_lv1a, 3 => '0',
                4 => t1_calpulse, 5 => t1_resync, 6 => t1_bc0, 7 => '0',
                others => '0');
                
end user_logic_arch;
