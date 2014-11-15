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
use work.vendor_specific_gbt_bank_package.all;

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

    -- Global signals

    signal gbt_clk          : std_logic := '0';
    signal cdce_out0        : std_logic;
    signal REFCLOCK_OUT_240        : std_logic;
	 signal FABRIC_CLOCK_OUT_40        : std_logic;
	 signal zeros : std_logic_vector(31 downto 0) := (others => '0');

    -- "ex"-GTX signals
    
    signal rx_error         : std_logic_vector(3 downto 0) := (others => '0');
    signal rx_kchar_i         : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_data_i          : std_logic_vector(63 downto 0) := (others => '0');
    signal tx_kchar_o         : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_data_o          : std_logic_vector(63 downto 0) := (others => '0');

    -- Fast priority pulses
    
    signal fast_signals_i     : std_logic_vector(6 downto 0) := (others => '0');
    
    -- VFAT2 signals
    
    signal vfat2_tx_en      : std_logic := '0';
    signal vfat2_tx_ack     : std_logic := '0';
    signal vfat2_tx_data    : std_logic_vector(31 downto 0) := (others => '0');
    signal vfat2_rx_en      : std_logic := '0';
    signal vfat2_rx_data    : std_logic_vector(31 downto 0) := (others => '0');
    signal vfat2_tx_en_oof      : std_logic := '0';
	 signal vfat2_tx_data_oof    : std_logic_vector(31 downto 0) := (others => '0');
    -- OH Regs signals
    
    signal regs_tx_en       : std_logic := '0';
    signal regs_tx_ack      : std_logic := '0';
    signal regs_tx_data     : std_logic_vector(31 downto 0) := (others => '0');
    signal regs_rx_en       : std_logic := '0';
    signal regs_rx_data     : std_logic_vector(31 downto 0) := (others => '0');
    
    -- Tracking signals
    
    signal tracking_rx_en   : std_logic := '0';
    signal tracking_rx_data : std_logic_vector(15 downto 0) := (others => '0');
   --================================ Signal Declarations ================================--

   --===============--
   -- General reset --
   --===============--
   
   signal generalReset_from_orGate                   : std_logic;         

   --==============--      
   -- GLIB control --      
   --==============--            

   signal userCdceLocked_r                           : std_logic;              

   --====================--                     
   -- GLIB clocks scheme --                     
   --====================--   
   
   -- Fabric clock:
   ----------------
   
   signal fabricClk_from_xpSw1clk3Ibufgds            : std_logic;
   
   -- MGT(GTX) reference clock:     
   ---------------------------- 
   
   signal mgtRefClk_from_cdceOut0IbufdsGtxe1         : std_logic;
   
   --=========================--
   -- GBT Bank example design --
   --=========================--
   
   -- Control:
   -----------
   
   signal generalReset_from_user                     : std_logic;      
   signal manualResetTx_from_user                    : std_logic; 
   signal manualResetRx_from_user                    : std_logic; 
   signal clkMuxSel_from_user                        : std_logic;       
   signal testPatterSel_from_user                    : std_logic_vector(1 downto 0); 
   signal loopBack_from_user                         : std_logic_vector(2 downto 0); 
   signal resetDataErrorSeenFlag_from_user           : std_logic; 
   signal resetGbtRxReadyLostFlag_from_user          : std_logic; 
   signal txIsDataSel_from_user                      : std_logic;   
   --------------------------------------------------       
   signal latOptGbtBankTx_from_gbtExmplDsgn          : std_logic;
   signal latOptGbtBankRx_from_gbtExmplDsgn          : std_logic;
   signal txFrameClkPllLocked_from_gbtExmplDsgn      : std_logic;
   signal mgtReady_from_gbtExmplDsgn                 : std_logic; 
   signal rxBitSlipNbr_from_gbtExmplDsgn             : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   signal rxWordClkReady_from_gbtExmplDsgn           : std_logic; 
   signal rxFrameClkReady_from_gbtExmplDsgn          : std_logic; 
   signal gbtRxReady_from_gbtExmplDsgn               : std_logic;    
   signal rxIsData_from_gbtExmplDsgn                 : std_logic;        
   signal gbtRxReadyLostFlag_from_gbtExmplDsgn       : std_logic; 
   signal rxDataErrorSeen_from_gbtExmplDsgn          : std_logic; 
   signal rxExtrDataWidebusErSeen_from_gbtExmplDsgn  : std_logic; 
   signal rxExtrDataGbt8b10bErSeen_from_gbtExmplDsgn : std_logic;
   
   -- Data:
   --------
   
   signal txData_from_gbtExmplDsgn                   : std_logic_vector(83 downto 0);
   signal rxData_from_gbtExmplDsgn                   : std_logic_vector(83 downto 0);
	signal txData_to_gbtExmplDsgn_from_user           : std_logic_vector(83 downto 0); -- Erik was here
   --------------------------------------------------       
   signal txExtraDataWidebus_from_gbtExmplDsgn       : std_logic_vector(31 downto 0);
   signal rxExtraDataWidebus_from_gbtExmplDsgn       : std_logic_vector(31 downto 0);
   -------------------------------------------------- 
   signal txExtraDataGbt8b10b_from_gbtExmplDsgn      : std_logic_vector( 3 downto 0);
   signal rxExtraDataGbt8b10b_from_gbtExmplDsgn      : std_logic_vector( 3 downto 0);  
   
   --===========--
   -- Chipscope --
   --===========--
   
   signal vioControl_from_icon                       : std_logic_vector(35 downto 0); 
   signal txIlaControl_from_icon                     : std_logic_vector(35 downto 0); 
   signal rxIlaControl_from_icon                     : std_logic_vector(35 downto 0); 
   -------------------------------------------------- 
   signal sync_from_vio                              : std_logic_vector(11 downto 0);
   signal async_to_vio                               : std_logic_vector(17 downto 0);
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   signal txFrameClk_from_gbtExmplDsgn               : std_logic;
   signal txWordClk_from_gbtExmplDsgn                : std_logic;
   signal rxFrameClk_from_gbtExmplDsgn               : std_logic;
   signal rxWordClk_from_gbtExmplDsgn                : std_logic;
   --------------------------------------------------                                     
   signal txMatchFlag_from_gbtExmplDsgn              : std_logic;
   signal rxMatchFlag_from_gbtExmplDsgn              : std_logic;
   
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
    ip_addr_o <= x"c0a80073";  -- 192.168.0.115
    mac_addr_o <= x"080030F100a" & amc_slot_i;  -- 08:00:30:F1:00:0[A0:AF] 
   --==================================== User Logic =====================================--
   
   --===============--
   -- General reset -- 
   --===============--
   
   generalReset_from_orGate                          <= RESET_I or generalReset_from_user;   
   
   --===============--
   -- Clocks scheme -- 
   --===============--   

   -- Fabric clock:
   ----------------       
   
   xpSw1clk3Ibufgds: IBUFGDS
      generic map (
         IBUF_LOW_PWR                                => FALSE,
         IOSTANDARD                                  => "LVDS_25")
      port map (                 
         O                                           => fabricClk_from_xpSw1clk3Ibufgds,   -- Comment: By default this clock is set to 40MHz.
         I                                           => XPOINT1_CLK3_P,
         IB                                          => XPOINT1_CLK3_N
      );
      
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: Note!! CDCE_OUT0 must be set to 240 MHz for the LATENCY-OPTIMIZED GBT Bank.   
   
   cdceOut0IbufdsGtxe1: ibufds_gtxe1
      port map (
         I                                           => CDCE_OUT0_P,
         IB                                          => CDCE_OUT0_N,
         O                                           => mgtRefClk_from_cdceOut0IbufdsGtxe1,
         ceb                                         => '0'
      );

    ----------------------------------
    -- GBT                          --
    ---------------------------------- 

   gbtExmplDsgn: entity work.xlx_v6_gbt_example_design
      generic map (
         GBTBANK_RESET_CLK_FREQ                       => 40e6)
      port map (
         -- Resets scheme:      
         GENERAL_RESET_I                              => generalReset_from_orGate,
         ---------------------------------------------
         MANUAL_RESET_TX_I                            => manualResetTx_from_user,
         MANUAL_RESET_RX_I                            => manualResetRx_from_user,         
         -- Clocks scheme:                            
         FABRIC_CLK_I                                 => fabricClk_from_xpSw1clk3Ibufgds,
         MGT_REFCLK_I                                 => mgtRefClk_from_cdceOut0IbufdsGtxe1,          
         -- Serial lanes:                             
         MGT_TX_P                                     => SFP_TX_P(1),                
         MGT_TX_N                                     => SFP_TX_N(1),                
         MGT_RX_P                                     => SFP_RX_P(1),                 
         MGT_RX_N                                     => SFP_RX_N(1),
         -- General control:                       
         LOOPBACK_I                                   => loopBack_from_user,
         TX_ISDATA_SEL_I                              => txIsDataSel_from_user,                 
         ---------------------------------------------                          
         LATOPT_GBTBANK_TX_O                          => latOptGbtBankTx_from_gbtExmplDsgn,             
         LATOPT_GBTBANK_RX_O                          => latOptGbtBankRx_from_gbtExmplDsgn,             
         TX_FRAMECLK_PLL_LOCKED_O                     => txFrameClkPllLocked_from_gbtExmplDsgn,
         MGT_READY_O                                  => mgtReady_from_gbtExmplDsgn,             
         RX_BITSLIP_NUMBER_O                          => rxBitSlipNbr_from_gbtExmplDsgn,            
         RX_WORDCLK_READY_O                           => rxWordClkReady_from_gbtExmplDsgn,           
         RX_FRAMECLK_READY_O                          => rxFrameClkReady_from_gbtExmplDsgn,            
         GBT_RX_READY_O                               => gbtRxReady_from_gbtExmplDsgn,
         RX_ISDATA_FLAG_O                             => rxIsData_from_gbtExmplDsgn,        
         -- GBT Bank data:                            
         TX_DATA_O                                    => txData_from_gbtExmplDsgn,            
         TX_EXTRA_DATA_WIDEBUS_O                      => txExtraDataWidebus_from_gbtExmplDsgn,
         TX_EXTRA_DATA_GBT8B10B_O                     => txExtraDataGbt8b10b_from_gbtExmplDsgn,
			TX_DATA_IN                                   => txData_to_gbtExmplDsgn_from_user, -- Erik was here
         ---------------------------------------------       
         RX_DATA_O                                    => rxData_from_gbtExmplDsgn,           
         RX_EXTRA_DATA_WIDEBUS_O                      => rxExtraDataWidebus_from_gbtExmplDsgn,
         RX_EXTRA_DATA_GBT8B10B_O                     => rxExtraDataGbt8b10b_from_gbtExmplDsgn,
         -- Test control:                    
         TEST_PATTERN_SEL_I                           => testPatterSel_from_user,        
         ---------------------------------------------                          
         RESET_GBTRXREADY_LOST_FLAG_I                 => resetGbtRxReadyLostFlag_from_user,     
         RESET_DATA_ERRORSEEN_FLAG_I                  => resetDataErrorSeenFlag_from_user,     
         GBTRXREADY_LOST_FLAG_O                       => gbtRxReadyLostFlag_from_gbtExmplDsgn,       
         RXDATA_ERRORSEEN_FLAG_O                      => rxDataErrorSeen_from_gbtExmplDsgn,      
         RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O         => rxExtrDataWidebusErSeen_from_gbtExmplDsgn,
         RXEXTRADATA_GBT8B10B_ERRORSEEN_FLAG_O        => rxExtrDataGbt8b10bErSeen_from_gbtExmplDsgn,
         -- Latency measurement:                      
         TX_FRAMECLK_O                                => txFrameClk_from_gbtExmplDsgn,        
         TX_WORDCLK_O                                 => txWordClk_from_gbtExmplDsgn,          
         RX_FRAMECLK_O                                => rxFrameClk_from_gbtExmplDsgn,         
         RX_WORDCLK_O                                 => rxWordClk_from_gbtExmplDsgn,          
         ---------------------------------------------                      
         TX_MATCHFLAG_O                               => txMatchFlag_from_gbtExmplDsgn,          
         RX_MATCHFLAG_O                               => rxMatchFlag_from_gbtExmplDsgn           
      );
	 
--   simplified_gbt_core_inst : entity work.gbt_wrapper
--   generic map (
--      FABRIC_CLK_FREQ => 40000000
--   )
--   port map (   
--
--      GENERAL_RESET_I     => reset_i,
--      
--      FABRIC_CLK_I        => FABRIC_CLOCK_OUT_40,
--      MGT_REFCLK_I       => cdce_out0,
--      TX_OUTCLK_O         => gbt_clk,
--
--      MGT_TX_P            => sfp_tx_p(1),
--      MGT_TX_N            => sfp_tx_n(1),
--      MGT_RX_P            => sfp_rx_p(1),
--      MGT_RX_N            => sfp_rx_n(1),
--     
--      TX_ISDATA_SEL_I     => vfat2_tx_en,
--		TX_DATA_I           => vfat2_tx_data (19 downto 0) & vfat2_tx_data & vfat2_tx_data,
--      
--      RX_ISDATA_FLAG_O    => vfat2_rx_en,
--      RX_DATA_O           => data_out,
--     
--      CONTROL_REGISTER_O  => control_reg
--   );
--   vfat2_rx_data <= data_out(31 downto 0);

    gtx_rx_mux_inst : entity work.gtx_rx_mux
    port map(
        gtx_clk_i       => rxFrameClk_from_gbtExmplDsgn,
        reset_i         => reset_i,
        
        vfat2_en_o      => vfat2_rx_en,
        vfat2_data_o    => vfat2_rx_data,
        
        regs_en_o       => open,
        regs_data_o     => open,
        
        rx_kchar_i      => rxData_from_gbtExmplDsgn(17 downto 16), --rx_kchar_i,
        rx_data_i       => rxData_from_gbtExmplDsgn(15 downto 0) --rx_data_i
    );   
    
--	 rx_kchar_i <= rxData_from_gbtExmplDsgn(17 downto 16);
--	 rx_data_i <= rxData_from_gbtExmplDsgn(15 downto 0);

    clock_bridge_gbt_inst : entity work.clock_bridge_data
    port map(
        reset_i     => reset_i,
        m_clk_i     => rxFrameClk_from_gbtExmplDsgn,
        m_en_i      => vfat2_tx_en_oof,
        m_data_i    => vfat2_tx_data_oof,        
        s_clk_i     => txFrameClk_from_gbtExmplDsgn,
        s_en_o      => vfat2_tx_en,
        s_data_o    => vfat2_tx_data
    );    
	 
    gtx_tx_mux_inst : entity work.gtx_tx_mux
    port map(
        gtx_clk_i       => txFrameClk_from_gbtExmplDsgn,
        reset_i         => reset_i,
        
        vfat2_en_i      => vfat2_tx_en,
        vfat2_data_i    => vfat2_tx_data,
        
        regs_en_i       => '0',
        regs_data_i     => zeros,
        
        tx_kchar_o      => txData_to_gbtExmplDsgn_from_user(17 downto 16), --tx_kchar_o,
        tx_data_o       => txData_to_gbtExmplDsgn_from_user(15 downto 0), --tx_data_o,
        
        fast_signals_i  => fast_signals_i
    );
	
--	txData_to_gbtExmplDsgn_from_user <= x"4552494b" & (others => '0') & tx_kchar_o & tx_data_o ;
	txIsDataSel_from_user <= '1';
	
   ipb_vfat2_inst : entity work.ipb_vfat2
    port map(
        ipb_clk_i       => ipb_clk_i,
        gtx_clk_i       => rxFrameClk_from_gbtExmplDsgn,--rxFrameClk_from_gbtExmplDsgn,    
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_mosi_i(ipbus_vfat2_0),
        ipb_miso_o      => ipb_miso_o(ipbus_vfat2_0),
        tx_en_o         => vfat2_tx_en_oof,
        tx_data_o       => vfat2_tx_data_oof,
        rx_en_i         => vfat2_rx_en,
        rx_data_i       => vfat2_rx_data
    );
	 
--   ipb_vfat2_inst : entity work.ipb_vfat2
--    port map(
--        ipb_clk_i       => ipb_clk_i,
--        gtx_clk_i       => rxFrameClk_from_gbtExmplDsgn,    
--        reset_i         => reset_i,
--        ipb_mosi_i      => ipb_mosi_i(ipbus_vfat2_0),
--        ipb_miso_o      => ipb_miso_o(ipbus_vfat2_0),
--        tx_en_o         => txIsDataSel_from_user,--vfat2_tx_en,
--        tx_data_o       => txData_to_gbtExmplDsgn_from_user(31 downto 0), --vfat2_tx_data,
--        rx_en_i         => rxIsData_from_gbtExmplDsgn,--vfat2_tx_en,
--        rx_data_i       => rxData_from_gbtExmplDsgn(31 downto 0)--vfat2_tx_data
--    );


   --==============--   
   -- Test control --   
   --==============--      
   
   -- Registered CDCE62005 locked input port:
   ------------------------------------------ 

   cdceLockedReg: process(generalReset_from_orGate, fabricClk_from_xpSw1clk3Ibufgds)
   begin
      if generalReset_from_orGate = '1' then
         userCdceLocked_r                            <= '0';
      elsif rising_edge(fabricClk_from_xpSw1clk3Ibufgds) then
         userCdceLocked_r                            <= USER_CDCE_LOCKED_I;
      end if;
   end process;   
   
   -- Signals mapping:
   -------------------
   generalReset_from_user                             <= '0';          
   clkMuxSel_from_user                                <= '0';
   testPatterSel_from_user                            <= "10"; 
   loopBack_from_user                                 <= "000";
   resetDataErrorSeenFlag_from_user                   <= '0';
   resetGbtRxReadyLostFlag_from_user                  <= '0';
--   txIsDataSel_from_user                              <= vfat2_tx_en;
   manualResetTx_from_user                            <= not reset_i AND fabricClk_from_xpSw1clk3Ibufgds;
   manualResetRx_from_user                            <= not reset_i AND fabricClk_from_xpSw1clk3Ibufgds;
   
--   generalReset_from_user                             <= sync_from_vio( 0);          
--   clkMuxSel_from_user                                <= sync_from_vio( 1);
--   testPatterSel_from_user                            <= sync_from_vio( 3 downto  2); 
--   loopBack_from_user                                 <= sync_from_vio( 6 downto  4);
--   resetDataErrorSeenFlag_from_user                   <= sync_from_vio( 7);
--   resetGbtRxReadyLostFlag_from_user                  <= sync_from_vio( 8);
--   txIsDataSel_from_user                              <= sync_from_vio( 9);
--   manualResetTx_from_user                            <= sync_from_vio(10);
--   manualResetRx_from_user                            <= sync_from_vio(11);
   ---------------------------------------------------       
   async_to_vio( 0)                                   <= rxIsData_from_gbtExmplDsgn;
   async_to_vio( 1)                                   <= userCdceLocked_r and txFrameClkPllLocked_from_gbtExmplDsgn;
   async_to_vio( 2)                                   <= latOptGbtBankTx_from_gbtExmplDsgn;
   async_to_vio( 3)                                   <= mgtReady_from_gbtExmplDsgn;
   async_to_vio( 4)                                   <= rxWordClkReady_from_gbtExmplDsgn;    
   async_to_vio(10 downto 5)                          <= '0' & rxBitSlipNbr_from_gbtExmplDsgn; 
   async_to_vio(11)                                   <= rxFrameClkReady_from_gbtExmplDsgn;   
   async_to_vio(12)                                   <= gbtRxReady_from_gbtExmplDsgn;          
   async_to_vio(13)                                   <= gbtRxReadyLostFlag_from_gbtExmplDsgn;  
   async_to_vio(14)                                   <= rxDataErrorSeen_from_gbtExmplDsgn;   
   async_to_vio(15)                                   <= rxExtrDataWidebusErSeen_from_gbtExmplDsgn;
   async_to_vio(16)                                   <= rxExtrDataGbt8b10bErSeen_from_gbtExmplDsgn;
   async_to_vio(17)                                   <= latOptGbtBankRx_from_gbtExmplDsgn;
   
   -- Chipscope:
   -------------   
   
   -- Comment: * Chipscope is used to control the example design as well as for transmitted and received data analysis.
   --
   --          * Note!! TX and RX DATA do not share the same ILA module (txIla and rxIla respectively) 
   --            because when receiving RX DATA from another board with a different reference clock, the 
   --            TX_FRAMECLK/TX_WORDCLK domains are asynchronous with respect to the RX_FRAMECLK/RX_WORDCLK domains.        
   --
   --          * After FPGA configuration using Chipscope, open the project "ml605_gbt_example_design.cpj" 
   --            that can be found in:
   --            "..\example_designs\xilix_v6\ml605\chipscope_project\".  
   
   icon: entity work.xlx_v6_chipscope_icon    
      port map (     
         CONTROL0                                     => vioControl_from_icon,
         CONTROL1                                     => txIlaControl_from_icon,
         CONTROL2                                     => rxIlaControl_from_icon
      );    
            
   vio: entity work.xlx_v6_chipscope_vio            
      port map (           
         CONTROL                                      => vioControl_from_icon,
         CLK                                          => txFrameClk_from_gbtExmplDsgn,
         ASYNC_IN                                     => async_to_vio,
         SYNC_OUT                                     => sync_from_vio
      );       
         
   txIla: entity work.xlx_v6_chipscope_ila          
      port map (           
         CONTROL                                     => txIlaControl_from_icon,
         CLK                                         => txFrameClk_from_gbtExmplDsgn,
         TRIG0                                       => txData_from_gbtExmplDsgn,
         TRIG1                                       => txExtraDataWidebus_from_gbtExmplDsgn,
         TRIG2                                       => txExtraDataGbt8b10b_from_gbtExmplDsgn,
         TRIG3(0)                                    => txIsDataSel_from_user
      );          
               
   rxIla: entity work.xlx_v6_chipscope_ila          
      port map (           
         CONTROL                                     => rxIlaControl_from_icon,
         CLK                                         => rxFrameClk_from_gbtExmplDsgn,
         TRIG0                                       => rxData_from_gbtExmplDsgn,
         TRIG1                                       => rxExtraDataWidebus_from_gbtExmplDsgn,
         TRIG2                                       => rxExtraDataGbt8b10b_from_gbtExmplDsgn,
         TRIG3(0)                                    => rxIsData_from_gbtExmplDsgn
      );       

   -- On-board LEDs:             
   -----------------
   
   -- Comment: * USER_V6_LED_O(1) -> LD5 on GLIB. 
   --          * USER_V6_LED_O(2) -> LD4 on GLIB.       
   
   USER_V6_LED_O(1)                                  <= userCdceLocked_r and txFrameClkPllLocked_from_gbtExmplDsgn;          
   USER_V6_LED_O(2)                                  <= mgtReady_from_gbtExmplDsgn;
   
    ----------------------------------
    -- IPBus tests module           --
    ----------------------------------
    
    ipb_test_inst : entity work.ipb_test
    generic map(
        SIZE        => 1024
    )
    port map(
        ipb_clk_i   => ipb_clk_i,    
        reset_i     => reset_i,
        ipb_mosi_i  => ipb_mosi_i(ipbus_test),
        ipb_miso_o  => ipb_miso_o(ipbus_test)
    );
    
end user_logic_arch;