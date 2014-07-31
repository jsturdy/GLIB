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

    signal fabric_clk       : std_logic := '0';
         
    -- VFAT2 signals
    signal vfat2_tx_en      : std_logic := '0';
    signal vfat2_tx_ack     : std_logic := '0';
    signal vfat2_tx_data    : std_logic_vector(31 downto 0) := (others => '0');
    signal vfat2_rx_en      : std_logic := '0';
    signal vfat2_rx_data    : std_logic_vector(31 downto 0) := (others => '0');
    
    -- GTX signals
    
    signal rx_error         : std_logic_vector(3 downto 0) := (others => '0');
    signal rx_error_0       : std_logic := '0';
    signal rx_error_1       : std_logic := '0';
    signal rx_error_2       : std_logic := '0';
    signal rx_error_3       : std_logic := '0';
    
    signal rx_kchar         : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_kchar_0       : std_logic_vector(1 downto 0) := (others => '0');
    signal rx_kchar_1       : std_logic_vector(1 downto 0) := (others => '0');
    signal rx_kchar_2       : std_logic_vector(1 downto 0) := (others => '0');
    signal rx_kchar_3       : std_logic_vector(1 downto 0) := (others => '0');
    
    signal rx_data          : std_logic_vector(63 downto 0) := (others => '0');
    signal rx_data_0        : std_logic_vector(15 downto 0) := (others => '0');
    signal rx_data_1        : std_logic_vector(15 downto 0) := (others => '0');
    signal rx_data_2        : std_logic_vector(15 downto 0) := (others => '0');
    signal rx_data_3        : std_logic_vector(15 downto 0) := (others => '0');
    
    signal tx_kchar         : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_kchar_0       : std_logic_vector(1 downto 0) := (others => '0');
    signal tx_kchar_1       : std_logic_vector(1 downto 0) := (others => '0');
    signal tx_kchar_2       : std_logic_vector(1 downto 0) := (others => '0');
    signal tx_kchar_3       : std_logic_vector(1 downto 0) := (others => '0');
    
    signal tx_data          : std_logic_vector(63 downto 0) := (others => '0');
    signal tx_data_0        : std_logic_vector(15 downto 0) := (others => '0');
    signal tx_data_1        : std_logic_vector(15 downto 0) := (others => '0');
    signal tx_data_2        : std_logic_vector(15 downto 0) := (others => '0');
    signal tx_data_3        : std_logic_vector(15 downto 0) := (others => '0');

    -- ChipScope
    signal cs_control_0     : std_logic_vector(35 downto 0) := (others => '0');
    signal cs_control_1     : std_logic_vector(35 downto 0) := (others => '0');
    signal cs_async_out     : std_logic_vector(47 downto 0) := (others => '0');
    signal cs_sync_out      : std_logic_vector(0 downto 0) := (others => '0');
    signal cs_trigger_0     : std_logic_vector(0 downto 0) := (others => '0');
    signal cs_trigger_1     : std_logic_vector(0 downto 0) := (others => '0');
    signal cs_trigger_2     : std_logic_vector(0 downto 0) := (others => '0');
    signal cs_trigger_3     : std_logic_vector(31 downto 0) := (others => '0');
    signal cs_trigger_4     : std_logic_vector(15 downto 0) := (others => '0');
    signal cs_trigger_5     : std_logic_vector(1 downto 0) := (others => '0');
    signal cs_trigger_6     : std_logic_vector(15 downto 0) := (others => '0');
    signal cs_trigger_7     : std_logic_vector(1 downto 0) := (others => '0');
    signal cs_trigger_8     : std_logic_vector(0 downto 0) := (others => '0');
    signal cs_trigger_9     : std_logic_vector(31 downto 0) := (others => '0');
    signal cs_trigger_10    : std_logic_vector(31 downto 0) := (others => '0');
    signal cs_trigger_11    : std_logic_vector(0 downto 0) := (others => '0');
    signal cs_trigger_12    : std_logic_vector(0 downto 0) := (others => '0');
    signal cs_trigger_13    : std_logic_vector(31 downto 0) := (others => '0');

begin 
    
    ip_addr_o <= x"c0a80073";  -- 192.168.0.115
    mac_addr_o <= x"080030F100a" & amc_slot_i;  -- 08:00:30:F1:00:0[A0:AF] 
    user_v6_led_o(1) <= '1';
    user_v6_led_o(2) <= '1';   
    
    ----------------------------------
    -- ChipScope                    --
    ---------------------------------- 
    
    chipscope_icon_inst : entity work.chipscope_icon
    port map(
        CONTROL0    => cs_control_0,
        CONTROL1    => cs_control_1
    );    
    
    chipscope_vio_inst : entity work.chipscope_vio
    port map(
        CONTROL     => cs_control_1,
        CLK         => fabric_clk,
        ASYNC_OUT   => cs_async_out,
        SYNC_OUT    => cs_sync_out
    );

    chipscope_ila_inst : entity work.chipscope_ila
    port map(
        CONTROL => cs_control_0,
        CLK     => fabric_clk,
        TRIG0   => cs_trigger_0,
        TRIG1   => cs_trigger_1,
        TRIG2   => cs_trigger_2,
        TRIG3   => cs_trigger_3,
        TRIG4   => cs_trigger_4,
        TRIG5   => cs_trigger_5,
        TRIG6   => cs_trigger_6,
        TRIG7   => cs_trigger_7,
        TRIG8   => cs_trigger_8,
        TRIG9   => cs_trigger_9,
        TRIG10  => cs_trigger_10,
        TRIG11  => cs_trigger_11,
        TRIG12  => cs_trigger_12,
        TRIG13  => cs_trigger_13
    );    
    
    cs_trigger_0(0) <= ipb_mosi_i(ipbus_vfat2_request_0).ipb_strobe;
    cs_trigger_1(0) <= vfat2_tx_en;
    cs_trigger_2(0) <= vfat2_tx_ack;
    cs_trigger_3 <= vfat2_tx_data;
    cs_trigger_4 <= tx_data_0;
    cs_trigger_5 <= tx_kchar_0;
    cs_trigger_6 <= rx_data_0;
    cs_trigger_7 <= rx_kchar_0;
    cs_trigger_8(0) <= vfat2_rx_en;
    cs_trigger_9 <= vfat2_rx_data;
    cs_trigger_10 <= (others => '0');
    cs_trigger_11 <= (others => '0');
    cs_trigger_12 <= (others => '0');
    cs_trigger_13 <= (others => '0');

    ----------------------------------
    -- GTX                          --
    ---------------------------------- 
    
    gtx_wrapper_inst : entity work.gtx_wrapper
    port map(
        fabric_clk_o    => fabric_clk,
        reset_i         => reset_i,
        rx_error_o      => open,
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
    
    tx_kchar <= tx_kchar_3 & tx_kchar_2 & tx_kchar_1 & tx_kchar_0;
    tx_data <= tx_data_3 & tx_data_2 & tx_data_1 & tx_data_0;
    
    rx_error_0 <= rx_error(0);
    rx_error_1 <= rx_error(1);
    rx_error_2 <= rx_error(2);
    rx_error_3 <= rx_error(3);
    
    rx_kchar_0 <= rx_kchar(1 downto 0);
    rx_kchar_1 <= rx_kchar(3 downto 2);
    rx_kchar_2 <= rx_kchar(5 downto 4);
    rx_kchar_3 <= rx_kchar(7 downto 6);
    
    rx_data_0 <= rx_data(15 downto 0);
    rx_data_1 <= rx_data(31 downto 16);
    rx_data_2 <= rx_data(47 downto 32);
    rx_data_3 <= rx_data(63 downto 48);
    
    ----------------------------------
    -- GTX RX                       --
    ----------------------------------
    
    gtx_rx_mux_inst : entity work.gtx_rx_mux
    port map(
        gtx_clk_i       => fabric_clk,
        reset_i         => reset_i,
        vfat2_en_o      => vfat2_rx_en,
        vfat2_data_o    => vfat2_rx_data,
        rx_kchar_i      => rx_kchar_0,
        rx_data_i       => rx_data_0
    );   
    
    ----------------------------------
    -- GTX TX                       --
    ----------------------------------
    
    gtx_tx_mux_inst : entity work.gtx_tx_mux
    port map(
        gtx_clk_i       => fabric_clk,
        reset_i         => reset_i,
        vfat2_en_o      => vfat2_tx_en,
        vfat2_ack_i     => vfat2_tx_ack,
        vfat2_data_i    => vfat2_tx_data,
        tx_kchar_o      => tx_kchar_0,
        tx_data_o       => tx_data_0
    );  
    
    ----------------------------------
    -- Sub-cores                    --
    ----------------------------------
    
    -- VFAT2 request   
    ipb_vfat2_request_inst : entity work.ipb_vfat2_request
    port map(
        ipb_clk_i       => ipb_clk_i,
        fabric_clk_i    => fabric_clk,    
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_mosi_i(ipbus_vfat2_request_0),
        ipb_miso_o      => ipb_miso_o(ipbus_vfat2_request_0),
        tx_en_i         => vfat2_tx_en,
        tx_ack_o        => vfat2_tx_ack,
        tx_data_o       => vfat2_tx_data
    );   
    
    -- VFAT2 response   
    ipb_vfat2_response_inst : entity work.ipb_vfat2_response
    port map(
        ipb_clk_i       => ipb_clk_i,
        fabric_clk_i    => fabric_clk,    
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_mosi_i(ipbus_vfat2_response_0),
        ipb_miso_o      => ipb_miso_o(ipbus_vfat2_response_0),
        rx_en_i         => vfat2_rx_en,
        rx_data_i       => vfat2_rx_data
    );    
    
end user_logic_arch;