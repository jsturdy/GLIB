library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
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

    constant FABRIC_CLK_FREQ : integer := 160000000;

    -- External
    signal ext_trigger  : std_logic := '0';

    -- Clocks
    signal fabric_clk   : std_logic := '0';
    signal vfat2_clk    : std_logic := '0';
    signal gtx_clk      : std_logic := '0';

    -- VFAT2
    
    signal vfat2_t1                 : std_logic := '0';
    signal vfat2_sda_i              : std_logic_vector(5 downto 0) := (others => '0');
    signal vfat2_sda_o              : std_logic_vector(5 downto 0) := (others => '0');
    signal vfat2_sda_t              : std_logic_vector(5 downto 0) := (others => '0');
    signal vfat2_scl_o              : std_logic_vector(5 downto 0) := (others => '0');

    signal vfat2_dvalid_i      : std_logic_vector(5 downto 0) := (others  => '0');
	 
    signal vfat2_data_8_i      : std_logic_vector(8 downto 0); -- 7 downto 0 = S bits, 8 = data_out (tracking)
    signal vfat2_data_9_i      : std_logic_vector(8 downto 0) := (others  => '0');
    signal vfat2_data_10_i     : std_logic_vector(8 downto 0) := (others  => '0');
    signal vfat2_data_11_i     : std_logic_vector(8 downto 0) := (others  => '0');
    signal vfat2_data_12_i     : std_logic_vector(8 downto 0) := (others  => '0');
    signal vfat2_data_13_i     : std_logic_vector(8 downto 0) := (others  => '0');
    signal vfat2_data_14_i     : std_logic_vector(8 downto 0) := (others  => '0');
    signal vfat2_data_15_i     : std_logic_vector(8 downto 0) := (others  => '0');
	 
    -- GTP
    
    signal rx_error                 : std_logic_vector(3 downto 0) := (others => '0');
    signal rx_kchar                 : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_data                  : std_logic_vector(63 downto 0) := (others => '0');
    signal tx_kchar                 : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_data                  : std_logic_vector(63 downto 0) := (others => '0');
    
    -- Registers requests
    
    signal request_write            : array32(63 downto 0) := (others => (others => '0'));
    signal request_tri              : std_logic_vector(63 downto 0);
    signal request_read             : array32(63 downto 0) := (others => (others => '0'));
    
    -- T1 signals
    
    signal t1_lv1a                  : std_logic := '0';
    signal t1_calpulse              : std_logic := '0';
    signal t1_resync                : std_logic := '0';
    signal t1_bc0                   : std_logic := '0';
    
    -- ADC
    
    signal adc_data                 : array32(1 downto 0) := (others => (others => '0'));

    -- Registers

    signal registers_write          : array32(7 downto 0) := (others => (others => '0'));
    signal registers_tri            : std_logic_vector(7 downto 0);
    signal registers_read           : array32(7 downto 0) := (others => (others => '0'));

    -- Counters

    signal lv1a_counter             : std_logic_vector(31 downto 0) := (others => '0');
    signal calpulse_counter         : std_logic_vector(31 downto 0) := (others => '0');
    signal resync_counter           : std_logic_vector(31 downto 0) := (others => '0');
    signal bc0_counter              : std_logic_vector(31 downto 0) := (others => '0');
    
    signal lv1a_counter_reset       : std_logic := '0';
    signal calpulse_counter_reset   : std_logic := '0';
    signal resync_counter_reset     : std_logic := '0';
    signal bc0_counter_reset        : std_logic := '0';
   
    signal CONTROL0: STD_LOGIC_VECTOR(35 DOWNTO 0);
    
begin 
    
    ip_addr_o <= x"c0a80078";  -- 192.168.0.120
    mac_addr_o <= x"080030F100a" & amc_slot_i;  -- 08:00:30:F1:00:0[A0:AF] 
    user_v6_led_o(1) <= user_cdce_locked_i;
    user_v6_led_o(2) <= reset_i;

    clocking_inst : entity work.clk_wiz_v3_5
    port map(
        gtx_clk_160     => gtx_clk,     -- 160 MHz No Buffer
        fabric_clk      => fabric_clk,  -- 160 MHz  BUFG
		  vfat2_clk       => vfat2_clk    -- 40 MHz  BUFG
    );
	 
    gtx_wrapper_inst : entity work.gtx_wrapper
    port map(
        gtx_clk_o       => gtx_clk,
        reset_i         => reset_i,
        rx_error_o      => rx_error,
        rx_kchar_o      => rx_kchar,
        rx_data_o       => rx_data,
        tx_kchar_i      => tx_kchar,
        tx_data_i       => tx_data,
        rx_n_i          => sfp_rx_n,
        rx_p_i          => sfp_rx_p,
        tx_n_o          => sfp_tx_n,
        tx_p_o          => sfp_tx_p,
        gtp_refclk_n_i  => cdce_out1_n,
        gtp_refclk_p_i  => cdce_out1_p
    );

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
    -- T1 handling
    --================================--
    
    ext_lv1a_inst : entity work.monostable port map(fabric_clk_i => gtx_clk, en_i => fmc2_io_pin.la_p(10), en_o => ext_trigger);
    
    t1_handler_inst : entity work.t1_handler 
    port map(
        gtp_clk_i   => gtx_clk,
        vfat2_clk_i => vfat2_clk,
        reset_i     => reset_i,
        lv1a_i      => t1_lv1a,
        calpulse_i  => t1_calpulse,
        resync_i    => t1_resync,
        bc0_i       => t1_bc0,
        t1_o        => vfat2_t1  
    );

    --================================--
    -- Registers
    --================================--

    global_registers_inst : entity work.registers
    generic map(SIZE => 8)
    port map(
        fabric_clk_i    => gtx_clk,
        reset_i         => reset_i,
        wbus_i          => registers_write,
        wbus_t          => registers_tri,
        rbus_o          => registers_read
    );
        
    --================================--
    -- Counters registers
    --================================--

    lv1a_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => lv1a_counter_reset, en_i => t1_lv1a, data_o => lv1a_counter);
    calpulse_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => calpulse_counter_reset, en_i => t1_calpulse, data_o => calpulse_counter);
    resync_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => resync_counter_reset, en_i => t1_resync, data_o => resync_counter);
    bc0_counter_inst : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => bc0_counter_reset, en_i => t1_bc0, data_o => bc0_counter);
    
    --================================--
    -- Request & register mapping
    --================================--
    
    -- T1 operations 3 downto 0
    
    t1_lv1a <= request_tri(0) or ext_trigger; -- 0 _ write _ send LV1A
    
    t1_calpulse <= request_tri(1); -- 1 _ write _ send Calpulse
    
    t1_resync <= request_tri(2); -- 2 _ write _ send Resync
    
    t1_bc0 <= request_tri(3); -- 3 _ write _ send BC0
    
    -- T1 counters : 7 downto 3
    
    request_read(4) <= lv1a_counter; -- 4 _ read _ # of LV1As
    
    request_read(5) <= calpulse_counter; -- 5 _ read _ # of Calpulses
    
    request_read(6) <= resync_counter; -- 6 _ read _ # of Resyncs
    
    request_read(7) <= bc0_counter; -- 7 _ read _ # of BC0s 
    
    -- T1 counters reset : 11 downto 8
    
    lv1a_counter_reset <= request_tri(8); -- 8 _ write _ reset LV1A counter
    
    calpulse_counter_reset <= request_tri(9); -- 9 _ write _ reset Calpulse counter
    
    resync_counter_reset <= request_tri(10); -- 10 _ write _ reset Resync counter
    
    bc0_counter_reset <= request_tri(11); -- 11 _ write _ reset BC0 counter
    
--    -- ADC : 13 downto 12
--
--    request_read(13 downto 12) <= adc_data(1 downto 0); -- 12 & 13 _ read _ ADC values
--
--    -- Fixed registers : 14
    
    request_read(14) <= x"20141210"; -- 14 _ read _ firmware version
    
--    request_read(15) <= (0 => fpga_pll_locked, others => '0'); -- 15 _ read _ FPGA PLL Locked
	 request_read(15) <= (others => '0'); -- 15 _ read _ FPGA PLL Locked
    
    request_read(16) <= (0 => user_cdce_locked_i, others => '0'); -- 16 _ read _ CDCE Locked
    
    -- Writable registers : 24 downto 17
    
    registers_tri(7 downto 0) <= request_tri(24 downto 17);
    registers_write(7 downto 0) <= request_write(24 downto 17);
    request_read(24 downto 17) <= registers_read(7 downto 0);
    
    -- Other registers : 63 downto 25
   
    ----------------------------------
    -- Buffers                      --
    ----------------------------------
    
    IOBUF_SDA: IOBUF
    port map (
      I => vfat2_sda_o(2),
      O => vfat2_sda_i(2),
      T => vfat2_sda_t(2),
      IO => fmc2_io_pin.la_n(27)
    );

    fmc2_io_pin.la_p(27) <= vfat2_scl_o(2);
    
    
    --BUFG(fabric_clk_i, buf_clk125);
    --sda_i(0) <= sda_io(0) when sda_t(0) = '1' else 'Z';
    --sda_io(0) <= sda_o(0) when sda_t(0) = '0' else 'Z';
    --scl_io(0) <= scl_o(0);  
    
    --sda_i(0) <= fmc2_io_pin.la_n(27) when sda_t(0) = '1' else 'Z'; -- LA27N -> SDA   LA27P -> SCL
    --fmc2_io_pin.la_n(27) <= sda_o(0) when sda_t(0) = '0' else 'Z';
    --fmc2_io_pin.la_p(27) <= scl_o(0);  
   
   --fmc2_io_pin.la_p(27) <= user_clk5MHz;  
    --fmc2_io_pin.la_p(27) <= user_clk156kHz;  

    fmc2_io_pin.la_n(16) <= '1';
    fmc2_io_pin.la_p(15) <= '1';  

    DATA_VALID_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_dvalid_i(2),
              IB => fmc2_io_pin.la_n(22),
				  I => fmc2_io_pin.la_p(22) 
             );    

	 DATA_LINE_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(8),
              IB => fmc2_io_pin.la_n(21),
				  I => fmc2_io_pin.la_p(21) 
             );
				 
	 S8_BIT_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(7),
              IB => fmc2_io_pin.la_n(25),
				  I => fmc2_io_pin.la_p(25) 
             );
				 
	 S7_BIT_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(6),
              IB => fmc2_io_pin.la_n(24),
				  I => fmc2_io_pin.la_p(24) 
             );

	 S6_BIT_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(5),
              IB => fmc2_io_pin.la_n(29),
				  I => fmc2_io_pin.la_p(29) 
             );

	 S5_BIT_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(4),
              IB => fmc2_io_pin.la_n(28),
				  I => fmc2_io_pin.la_p(28) 
             );

	 S4_BIT_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(3),
              IB => fmc2_io_pin.la_n(31),
				  I => fmc2_io_pin.la_p(31) 
             );

	 S3_BIT_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(2),
              IB => fmc2_io_pin.la_n(30),
				  I => fmc2_io_pin.la_p(30) 
             );

	 S2_BIT_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(1),
              IB => fmc2_io_pin.la_n(33),
				  I => fmc2_io_pin.la_p(33) 
             );

	 S1_BIT_BUFFER:IBUFDS_LVDS_25
    port map(
              O => vfat2_data_8_i(0),
              IB => fmc2_io_pin.la_n(32),
				  I => fmc2_io_pin.la_p(32) 
             );

end user_logic_arch;