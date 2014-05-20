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

    -- Clocks
    signal gtx_clk              : std_logic;
    signal rx_ref_clk           : std_logic;
    signal tx_ref_clk           : std_logic;
    
    -- IPBus VFAT2 signals
    signal ipb_vfat2_tx_en      : std_logic := '0';
    signal ipb_vfat2_tx_ack     : std_logic := '0';
    signal ipb_vfat2_tx_data    : std_logic_vector(31 downto 0);
    signal ipb_vfat2_rx_en      : std_logic := '0';
    signal ipb_vfat2_rx_ack     : std_logic := '0';
    signal ipb_vfat2_rx_data    : std_logic_vector(31 downto 0);      
    
    -- TX signals
    signal tx_kchar             : std_logic_vector(1 downto 0);
    signal tx_data              : std_logic_vector(15 downto 0);
    
    -- RX signals
    signal rx_kchar             : std_logic_vector(1 downto 0);
    signal rx_data              : std_logic_vector(15 downto 0);

    -- Chip Scope
    signal cs_control           : std_logic_vector(35 downto 0);
    signal cs_trigger_0         : std_logic_vector(0 downto 0);
    signal cs_trigger_1         : std_logic_vector(31 downto 0);
    signal cs_trigger_2         : std_logic_vector(15 downto 0);
    signal cs_trigger_3         : std_logic_vector(1 downto 0);
    signal cs_trigger_4         : std_logic_vector(15 downto 0);
    signal cs_trigger_5         : std_logic_vector(1 downto 0);
    signal cs_trigger_6         : std_logic_vector(0 downto 0);
    signal cs_trigger_7         : std_logic_vector(31 downto 0);

begin 
 
    -- ChipScope
    chipscope_icon_inst : entity work.chipscope_icon
    port map(
        CONTROL0 => cs_control
    );    
    

    chipscope_ila_inst : entity work.chipscope_ila
    port map(
        CONTROL => cs_control,
        CLK => gtx_clk,
        TRIG0 => cs_trigger_0,
        TRIG1 => cs_trigger_1,
        TRIG2 => cs_trigger_2,
        TRIG3 => cs_trigger_3,
        TRIG4 => cs_trigger_4,
        TRIG5 => cs_trigger_5,
        TRIG6 => cs_trigger_6,
        TRIG7 => cs_trigger_7
    );    
    
    cs_trigger_0(0) <= ipb_vfat2_tx_en;
    cs_trigger_1 <= ipb_vfat2_tx_data;
    cs_trigger_2 <= tx_data;
    cs_trigger_3 <= tx_kchar;
    cs_trigger_4 <= rx_data;
    cs_trigger_5 <= rx_kchar;
    cs_trigger_6(0) <= ipb_vfat2_rx_en;
    cs_trigger_7 <= ipb_vfat2_rx_data;
    
    --
    ip_addr_o <= x"c0a80073";  -- 192.168.0.115
    mac_addr_o <= x"080030F100a" & amc_slot_i;  -- 08:00:30:F1:00:0[A0:AF] 
    user_v6_led_o(1) <= '1';
    user_v6_led_o(2) <= '0';   

    -- VFAT2 IPBus slave     
    ipb_vfat2_inst : entity work.ipb_vfat2
    port map(
        ipb_clk_i       => ipb_clk_i,
        tx_clk_i        => tx_ref_clk,
        rx_clk_i        => rx_ref_clk,
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_mosi_i(ipbus_vfat2_slave_nb),
        ipb_miso_o      => ipb_miso_o(ipbus_vfat2_slave_nb),
        tx_en_o         => ipb_vfat2_tx_en,
        tx_data_o       => ipb_vfat2_tx_data,
        rx_en_i         => ipb_vfat2_rx_en,
        rx_data_i       => ipb_vfat2_rx_data
    );    
    
--    tx_ref_clk <= gtx_clk;
--    rx_ref_clk <= gtx_clk;
--    ipb_vfat2_rx_en <= ipb_vfat2_tx_en;
--    ipb_vfat2_rx_data <= ipb_vfat2_tx_data;

	-- GTX TX mux  
    gtx_tx_mux_inst : entity work.gtx_tx_mux
    port map(
        gtx_clk_i           => tx_ref_clk,
        reset_i             => reset_i,
        ipb_vfat2_en_i      => ipb_vfat2_tx_en,
        ipb_vfat2_data_i    => ipb_vfat2_tx_data,
        tx_kchar_o          => tx_kchar,
        tx_data_o           => tx_data
    );    
    
	-- GTX RX mux 
    gtx_rx_mux_inst : entity work.gtx_rx_mux
    port map(
        gtx_clk_i           => rx_ref_clk,
        reset_i             => reset_i,
        ipb_vfat2_en_o      => ipb_vfat2_rx_en,
        ipb_vfat2_data_o    => ipb_vfat2_rx_data,
        rx_kchar_i          => rx_kchar,
        rx_data_i           => rx_data
    );   
    
--    tx_ref_clk <= gtx_clk;
--    rx_ref_clk <= gtx_clk;
--    rx_kchar <= tx_kchar;    
--    rx_data <= tx_data;
    
    -- High speed
    gtx_wrapper_inst : entity work.gtx_wrapper
    port map(
        clk         => gtx_clk,
        rx_ref_clk  => open, --rx_ref_clk,
        tx_ref_clk  => open, --tx_ref_clk,
        reset       => reset_i,
        rx_error_o  => open,
        rx_kchar_o  => rx_kchar,
        rx_data_o   => rx_data,
        rx_n_i      => sfp_rx_n(1),
        rx_p_i      => sfp_rx_p(1),
        tx_kchar_i  => tx_kchar,
        tx_data_i   => tx_data,
        tx_n_o      => sfp_tx_n(1),
        tx_p_o      => sfp_tx_p(1)
    );
 
    tx_ref_clk <= gtx_clk;
    rx_ref_clk <= gtx_clk;
 
    -- GTX Clock at 160MHz
    gtx_clocking_inst : entity work.gtx_clocking
    port map(
        gtx_clk_p   => cdce_out1_p,
        gtx_clk_n   => cdce_out1_n,
        gtx_clk     => gtx_clk
    );    
	
end user_logic_arch;