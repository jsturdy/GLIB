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
    
    -- IPBus signals
    
    signal vfat2_tx_en      : std_logic := '0';
    signal vfat2_tx_data    : std_logic_vector(31 downto 0) := (others => '0');
    signal vfat2_rx_en      : std_logic := '0';
    signal vfat2_rx_data    : std_logic_vector(31 downto 0) := (others => '0');
    signal chipscope_tx_en  : std_logic_vector(0 downto 0);
    signal chipscope_rx_en  : std_logic_vector(0 downto 0);
 
    -- IIC
    
    signal sda_i            : std_logic_vector(0 downto 0) := (others => '1');
    signal sda_o            : std_logic_vector(0 downto 0) := (others => '1');
    signal sda_t            : std_logic_vector(0 downto 0) := (others => '1');
    signal scl_o            : std_logic_vector(0 downto 0) := (others => '1');

    signal user_clk5MHz     : std_logic;
    signal user_clk2500kHz  : std_logic;
    signal user_clk1250kHz  : std_logic;
    signal user_clk625kHz  : std_logic;
    signal user_clk312kHz  : std_logic;
    signal user_clk156kHz  : std_logic;
    
    signal CONTROL0: STD_LOGIC_VECTOR(35 DOWNTO 0);
  
    
begin 

    clk_5MHz : entity work.clk_wiz_v3_6
    port map (
        -- Clock in ports
        CLK_IN1 => user_clk125_i,
        -- Clock out ports
        CLK_OUT1 => user_clk5MHz,
        -- Status and control signals
        RESET  => '0',
        LOCKED => OPEN
    );
    
    ip_addr_o <= x"c0a80079";  -- 192.168.0.121
    mac_addr_o <= x"080030F100a" & amc_slot_i;  -- 08:00:30:F1:00:0[A0:AF] 
    user_v6_led_o(1) <= user_cdce_locked_i;
    user_v6_led_o(2) <= user_cdce_locked_i;
    
    ----------------------------------
    -- IPBus VFAT2                  --
    ----------------------------------
    
    ipb_vfat2_inst : entity work.ipb_vfat2
    port map(
        ipb_clk_i       => ipb_clk_i,
        fabric_clk_i    => user_clk1250kHz,    
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_mosi_i(ipbus_vfat2),
        ipb_miso_o      => ipb_miso_o(ipbus_vfat2),
        tx_en_o         => vfat2_tx_en,
        tx_data_o       => vfat2_tx_data,
        rx_en_i         => vfat2_rx_en,
        rx_data_i       => vfat2_rx_data
    );

    ----------------------------------
    -- I2C Core                     --
    ----------------------------------
    
    i2c_core_inst : entity work.i2c_core_vfat2
    generic map(
        FABRIC_CLK_FREQ => 1250000
    )
    port map(
        fabric_clk_i    => user_clk1250kHZ,
        reset_i         => reset_i,
        rx_en_i         => vfat2_tx_en,
        rx_data_i       => vfat2_tx_data,
        tx_en_o         => vfat2_rx_en,  
        tx_data_o       => vfat2_rx_data,
        sda_i           => sda_i,
        sda_o           => sda_o,
        sda_t           => sda_t,
        scl_o           => scl_o
    );  
   
    my_clk_divider_2 : entity work.clk_divider
    port map(
        clk_in  => user_clk5MHz,
        clk_out => user_clk2500kHz
    );
    
    
    my_clk_divider_4 : entity work.clk_divider
    port map(
        clk_in  => user_clk2500kHz,
        clk_out => user_clk1250kHz
    );
    
    my_clk_divider_8 : entity work.clk_divider
    port map(
        clk_in  => user_clk1250kHz,
        clk_out => user_clk625kHz
    );
    
    my_clk_divider_16 : entity work.clk_divider
    port map(
        clk_in  => user_clk625kHz,
        clk_out => user_clk312kHz
    );
    
    my_clk_divider_32 : entity work.clk_divider
    port map(
        clk_in  => user_clk312kHz,
        clk_out => user_clk156kHz
    );
    
--    chipscope_tx_en(0) <= vfat2_tx_en;
--    chipscope_rx_en(0) <= vfat2_rx_en;
--    
--    chipscope_ila_inst : entity work.chipscope_ila
--    port map (
--      CONTROL => CONTROL0,
--      CLK => user_clk1250kHZ,
--      TRIG0 => chipscope_tx_en,
--      TRIG1 => vfat2_tx_data,
--      TRIG2 => chipscope_rx_en,
--      TRIG3 => vfat2_rx_data
--    );
--    
--    chipscope_icon_inst : entity work.chipscope_icon
--    port map (
--      CONTROL0 => CONTROL0
--    );
    
    ----------------------------------
    -- Buffers                      --
    ----------------------------------
    
    IOBUF_SDA: IOBUF
    port map (
      I => sda_o(0),
      O => sda_i(0),
      T => sda_t(0),
      IO => fmc2_io_pin.la_n(27)
    );
    
    IOBUF_SCL: IOBUF
    port map (
      I => scl_o(0),
      O => OPEN,
      T => '0',
      IO => fmc2_io_pin.la_p(27)
    );
    
    
    --BUFG(fabric_clk_i, buf_clk125);
    --sda_i(0) <= sda_io(0) when sda_t(0) = '1' else 'Z';
    --sda_io(0) <= sda_o(0) when sda_t(0) = '0' else 'Z';
    --scl_io(0) <= scl_o(0);  
    
    --sda_i(0) <= fmc2_io_pin.la_n(27) when sda_t(0) = '1' else 'Z'; -- LA27N -> SDA   LA27P -> SCL
    --fmc2_io_pin.la_n(27) <= sda_o(0) when sda_t(0) = '0' else 'Z';
    --fmc2_io_pin.la_p(27) <= scl_o(0);  
   
   --fmc2_io_pin.la_p(27) <= user_clk5MHz;  
    --fmc2_io_pin.la_p(27) <= user_clk156kHz;  

    fmc2_io_pin.la_n(16) <= '1';-- when sda_t(0) = '0' else 'Z';
    fmc2_io_pin.la_p(15) <= '1';  

end user_logic_arch;