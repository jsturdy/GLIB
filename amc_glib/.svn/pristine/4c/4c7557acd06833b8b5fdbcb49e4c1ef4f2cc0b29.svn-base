library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--! Specific packages:
library unisim;
use unisim.vcomponents.all;
--! System packages:
use work.ipbus.all;
use work.system_package.all;
use work.wb_package.all;
use work.system_flash_sram_package.all;
use work.system_pcie_package.all;
--! User packages:
use work.user_package.all;
use work.sys_v3_only_pkg.all;

entity glib_top is
port
(
   --================================--
	-- MGT CLOCKS 
	--================================--  
   clk125_2_p					            : in	  std_logic;
   clk125_2_n					            : in	  std_logic;
   --================================--   
	-- FABRIC CLOCKS  
	--================================--      
	xpoint_4x4_out3_p				         : in	  std_logic;
	xpoint_4x4_out3_n				         : in	  std_logic;
	--================================--   
	-- GBE PHY  -- ok
	--================================--   
	gbe_tx_p						            : out	  std_logic;
	gbe_tx_n						            : out	  std_logic;
	gbe_rx_p						            : in	  std_logic;
	gbe_rx_n						            : in	  std_logic;
	gbe_reset_n					            : out	  std_logic;	
	gbe_int_n					            : in	  std_logic;	
	gbe_scl					           	 	: inout std_logic;
	gbe_sda				            		: inout std_logic;
   --================================--
	-- FMC2 RESERVED MGT -- ok
	--================================--
	fmc2_tx_p					            : out	  std_logic;
	fmc2_tx_n					            : out	  std_logic;
	fmc2_rx_p					            : in	  std_logic;
	fmc2_rx_n					            : in	  std_logic;   
	--================================--
	-- AMC PORTS -- ok
	--================================--
	amc_port_tx_p				            : out	  std_logic_vector(0 to 0);
	amc_port_tx_n				            : out	  std_logic_vector(0 to 0);
	amc_port_rx_p				            : in	  std_logic_vector(0 to 0);
	amc_port_rx_n				            : in	  std_logic_vector(0 to 0);
	--================================--
	-- CLK CIRCUITRY
	--================================--
	xpoint_4x4_s40	   		            : out	  std_logic;
	xpoint_4x4_s41	   	               : out	  std_logic;
	xpoint_4x4_s30	   	               : out	  std_logic;
	xpoint_4x4_s31	   	               : out	  std_logic;
	xpoint_4x4_s20	   	               : out	  std_logic;
	xpoint_4x4_s21	   	               : out	  std_logic;
	xpoint_4x4_s10	   	               : out	  std_logic;
	xpoint_4x4_s11	   	               : out	  std_logic;
	-------           
	xpoint_2x2_s0	 			            : out	  std_logic;
	xpoint_2x2_s1	 			            : out	  std_logic;
	------------------------------------  
	ics874003_fsel	 		               : out	  std_logic;
	ics874003_mr	 			            : out	  std_logic;
	ics874003_oe	 			            : out	  std_logic;
	------------------------------------  
	tclkb_dr_en				               : out	  std_logic;
	------------------------------------  
	cdce_pwr_down				            : out	  std_logic;	
	cdce_ref_sel				            : out	  std_logic;	
	cdce_sync					            : out	  std_logic;	
	cdce_spi_clk				            : out	  std_logic;	
	cdce_spi_le					            : out	  std_logic;	
	cdce_spi_mosi				            : out	  std_logic;	
	cdce_pll_lock				            : in	  std_logic;	
	cdce_spi_miso				            : in	  std_logic; 
	--================================--
	-- SFP QUAD -- ok
	--================================--
	sfp_mod_abs					            : in	  std_logic_vector(1 to 4);		
	sfp_rxlos					            : in	  std_logic_vector(1 to 4);		
	sfp_txfault					            : in	  std_logic_vector(1 to 4);				
	--================================--
	-- FMC
	--================================--
	fmc1_present_l				            : in	  std_logic;
	fmc2_present_l				            : in	  std_logic;
	--================================--
	-- MEMORIES (FLASH & SRAMs)
	--================================--
	sram1_addr					            : out	  std_logic_vector(20 downto 0);
	sram1_data					            : inout std_logic_vector(35 downto 0);
	------------------------------------
	sram1_adv_ld_l				            : out	  std_logic;	
	sram1_ce1_l					            : out	  std_logic;				
	sram1_cen_l					            : out	  std_logic;		
	sram1_clk					            : out	  std_logic;
	sram1_mode					            : out	  std_logic;
	sram1_oe_l	   			            : out	  std_logic;
	sram1_we_l					            : out	  std_logic;
   ------------------------------------
	sram2_addr					            : out	  std_logic_vector(20 downto 0);	
	sram2_data					            : inout std_logic_vector(35 downto 0);	
   ------------------------------------
   fpga_rs0	 		  			            : out	  std_logic;				
	fpga_rs1  					            : out	  std_logic;	
	------------------------------------
	sram2_adv_ld_l				            : out	  std_logic;	
	sram2_ce1_l					            : out	  std_logic;				
	sram2_cen_l					            : out	  std_logic;		
	sram2_clk					            : out	  std_logic;
	sram2_mode					            : out	  std_logic;
	sram2_oe_l	   			            : out	  std_logic;
	sram2_we_l					            : out	  std_logic;
	sram2_ce2					            : out	  std_logic;	
   --================================--
	-- VARIOUS
	--================================--
	fpga_reset_b	 			            : in	  std_logic;				
	fpga_power_on_reset_b	            : in	  std_logic;
   ------------------------------------
	fpga_scl  					            : inout std_logic;				
	fpga_sda						            : inout std_logic;			
   ------------------------------------
	fpga_clkout	  				            : out	  std_logic;
	v6_cpld						            : inout std_logic_vector(0 to 5)
);                    	
end glib_top;
							
architecture sys_v3_only_arch of glib_top is                    	


--##########################################--
--##############    SIGNAL    ##############--
--############## DECLARATIONS ##############--                              
--##########################################--


signal user_reset                      : std_logic;
---------------------------------------
signal user_clk125_2  		            : std_logic;
signal user_clk125_2_bufg              : std_logic;
signal user_pri_clk					      : std_logic;
---------------------------------------
signal sec_clk                         : std_logic;
signal user_ipb_clk					      : std_logic;
signal sys_pcie_mgt_refclk             : std_logic;
signal user_sys_pcie_dma_clk           : std_logic;
---------------------------------------
signal cdce_out0_gtxe1                 : std_logic; 
signal cdce_out3_gtxe1                 : std_logic;   
---------------------------------------
signal user_cdce_sel					      : std_logic;
signal user_cdce_sync				      : std_logic;
---------------------------------------
--signal user_mac_addr 			         : std_logic_vector(47 downto 0);
--signal user_ip_addr	   		         : std_logic_vector(31 downto 0);
---------------------------------------
signal user_mac_syncacqstatus		      : std_logic_vector(0 to 3);
signal user_mac_serdes_locked		      : std_logic_vector(0 to 3);
---------------------------------------
signal sys_eth_amc_p1_tx_p	            : std_logic;
signal sys_eth_amc_p1_tx_n		         : std_logic;
signal sys_eth_amc_p1_rx_p             : std_logic;
signal sys_eth_amc_p1_rx_n		         : std_logic;
---------------------------------------
signal user_slv_to_sys_pcie		      : R_slv_to_ezdma2;									
signal user_slv_from_sys_pcie          : R_slv_from_ezdma2;         						
signal user_dma_to_sys_pcie		      : R_userDma_to_ezdma2_array   (1 to 7); 		
signal user_dma_from_sys_pcie          : R_userDma_from_ezdma2_array (1 to 7); 		
signal user_int_to_sys_pcie     	      : R_int_to_ezdma2;									
signal user_int_from_sys_pcie	         : R_int_from_ezdma2;         																					 						
signal user_cfg_from_sys_pcie          : R_cfg_from_ezdma2;									
---------------------------------------
signal sys_pcie_amc_tx_p               : std_logic_vector(0 to 3);
signal sys_pcie_amc_tx_n               : std_logic_vector(0 to 3);
signal sys_pcie_amc_rx_p               : std_logic_vector(0 to 3);
signal sys_pcie_amc_rx_n               : std_logic_vector(0 to 3);
---------------------------------------
signal user_sram_control			      : userSramControlR_array(1 to 2);
signal user_sram_addr				      : array_2x21bit;
signal user_sram_wdata				      : array_2x36bit;
signal user_sram_rdata				      : array_2x36bit;
---------------------------------------
signal user_wb_miso					      : wb_miso_bus_array(0 to number_of_wb_slaves-1);
signal user_wb_mosi					      : wb_mosi_bus_array(0 to number_of_wb_slaves-1);
---------------------------------------
signal user_ipb_miso					      : ipb_rbus_array	(0 to number_of_ipb_slaves-1);
signal user_ipb_mosi					      : ipb_wbus_array	(0 to number_of_ipb_slaves-1);
	
signal amc_slot								: std_logic_vector(3 downto 0);	
	
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--
begin-- ARCHITECTURE
--@@@@@@@@@@@@@@@@@@@@@@--                              
--@@@@@@@@@@@@@@@@@@@@@@--
--@@@@@@@@@@@@@@@@@@@@@@--


--===================================================--
system: entity work.system_core
--===================================================--
port map
(
   --================================--
	-- SYSTEM MGT REFCLKs 
	--================================--  
	-- BANK_114(Q2): 
   clk125_2_p            	            => clk125_2_p             ,										
	clk125_2_n            	            => clk125_2_n             ,					
   --================================--            
	-- SYSTEM FABRIC CLOCKS             
	--================================-- 					           
	pri_clk_p            	            => xpoint_4x4_out3_p	 	  ,										
	pri_clk_n            	            => xpoint_4x4_out3_n   	  ,	
	--================================--               
	-- AMC                                 
	--================================--               
	sys_eth_amc_p0_tx_p		            => amc_port_tx_p(0)       ,
	sys_eth_amc_p0_tx_n		            => amc_port_tx_n(0)	     ,
	sys_eth_amc_p0_rx_p		            => amc_port_rx_p(0)	     ,
	sys_eth_amc_p0_rx_n		            => amc_port_rx_n(0)	     ,
   ------------------------------------	         
	sys_eth_amc_p1_tx_p		            => sys_eth_amc_p1_tx_p    ,  -- (from user_logic)
	sys_eth_amc_p1_tx_n		            => sys_eth_amc_p1_tx_n    ,  -- (from user_logic)
	sys_eth_amc_p1_rx_p		            => sys_eth_amc_p1_rx_p    ,  -- (from user_logic)
	sys_eth_amc_p1_rx_n		            => sys_eth_amc_p1_rx_n    ,  -- (from user_logic)
   ------------------------------------	         
   sys_pcie_amc_tx_p		               => sys_pcie_amc_tx_p	     ,  -- (from user_logic)
   sys_pcie_amc_tx_n		               => sys_pcie_amc_tx_n	     ,  -- (from user_logic)
   sys_pcie_amc_rx_p		               => sys_pcie_amc_rx_p	     ,  -- (from user_logic)
   sys_pcie_amc_rx_n		               => sys_pcie_amc_rx_n	     ,  -- (from user_logic)   
   --================================--         
	-- GBE PHY        
	--================================--         
	gbe_tx_p						            => gbe_tx_p					  ,
	gbe_tx_n						            => gbe_tx_n					  ,
	gbe_rx_p						            => gbe_rx_p					  ,
	gbe_rx_n						            => gbe_rx_n					  ,
	gbe_reset_n					            => gbe_reset_n				  ,	
	gbe_int_n					            => gbe_int_n				  ,	
	gbe_scl_mdc					            => gbe_scl				  	  ,
	gbe_sda_mdio				            => gbe_sda			  		  ,
	--================================--         
	-- FMC2 RESERVED MGT          
	--================================--         
	fmc2_tx_p					            => fmc2_tx_p				  ,
	fmc2_tx_n					            => fmc2_tx_n				  ,
	fmc2_rx_p					            => fmc2_rx_p				  ,
	fmc2_rx_n					            => fmc2_rx_n				  ,
	--================================--               
	-- CLK CIRCUITRY              
	--================================--               
	xpoint1_s40	   		               => xpoint_4x4_s40   		  ,
	xpoint1_s41	   	                  => xpoint_4x4_s41	   	  ,
	xpoint1_s30	   	                  => xpoint_4x4_s30	   	  ,
	xpoint1_s31	   	                  => xpoint_4x4_s31	   	  ,
	xpoint1_s20	   	                  => xpoint_4x4_s20	   	  ,
	xpoint1_s21	   	                  => xpoint_4x4_s21	   	  ,
	xpoint1_s10	   	                  => xpoint_4x4_s10	   	  ,
	xpoint1_s11	   	                  => xpoint_4x4_s11	   	  ,
	-----------                         
	xpoint2_s10	 			               => xpoint_2x2_s0			  ,
	xpoint2_s11	 			               => xpoint_2x2_s1			  ,
	------------------------------------               
	ics874003_fsel	 		               => ics874003_fsel	 		  ,
	ics874003_mr	 			            => ics874003_mr	 		  ,
	ics874003_oe	 			            => ics874003_oe	 		  ,
	------------------------------------               
	tclkb_dr_en				               => tclkb_dr_en				  ,
	------------------------------------         
   cdce_pwr_down				            => cdce_pwr_down			  ,	
	cdce_ref_sel				            => cdce_ref_sel			  ,	
	cdce_sync					            => cdce_sync				  ,	
	cdce_spi_clk				            => cdce_spi_clk			  ,	
	cdce_spi_le					            => cdce_spi_le				  ,	
	cdce_spi_mosi				            => cdce_spi_mosi			  ,	
	cdce_pll_lock				            => cdce_pll_lock			  ,	
	cdce_spi_miso				            => cdce_spi_miso			  ,	
   --------------                   
	cdce_sec_ref_p			               => open , --cdce_sec_ref_p		     ,
   cdce_sec_ref_n			               => open , --cdce_sec_ref_n		     ,   
	--================================--         
	-- VARIOUS        
	--================================--         	
	fpga_scl  					            => fpga_scl  				  ,
	fpga_sda						            => fpga_sda					  , 
   ------------------------------------            
	fpga_reset_b	 			            => fpga_reset_b	 		  ,
	fpga_power_on_reset_b	            => fpga_power_on_reset_b  ,
	------------------------------------         
	sys_v6_led_3                        => open, --v6_led(3)              ,
   ------------------------------------   
   v6_cpld						            => v6_cpld					  ,
	------------------------------------         
   sfp_mod_abs					            => sfp_mod_abs				  ,
	sfp_rxlos					            => sfp_rxlos				  ,
	sfp_txfault					            => sfp_txfault				  ,
	--================================--         
	-- FMC PRESENT       
	--================================--         
	fmc1_present_l				            => fmc1_present_l			  ,
	fmc2_present_l				            => fmc2_present_l			  ,
	--================================--         
	-- MEMORIES (FLASH & SRAMs)                         
	--================================--         
	sram1_addr					            => sram1_addr				  ,
	sram1_data					            => sram1_data				  ,
	sram2_addr					            => sram2_addr				  ,
	sram2_data					            => sram2_data				  ,
	------------------------------------
   fpga_a22 			                  => open, --fpga_a22		 ,
   fpga_a21				                  => open, --fpga_a21 		 ,
   fpga_rs0				                  => fpga_rs0 		 			,	
   fpga_rs1 			                  => fpga_rs1 		 			,
  	------------------------------------         
	sram_adv_ld_l(1)			            => sram1_adv_ld_l			  ,
	sram_adv_ld_l(2)			            => sram2_adv_ld_l			  ,
	sram_ce1_l(1)				            => sram1_ce1_l				  ,			
	sram_ce1_l(2)				            => sram2_ce1_l				  ,			
	sram_cen_l(1)				            => sram1_cen_l				  ,	
	sram_cen_l(2)				            => sram2_cen_l				  ,	
	sram_clk(1)		   		            => sram1_clk				  ,
	sram_clk(2)		   		            => sram2_clk				  ,
	sram_mode(1)				            => sram1_mode				  ,
	sram_mode(2)				            => sram2_mode				  ,
	sram_oe_l(1)				            => sram1_oe_l				  , 
	sram_oe_l(2)				            => sram2_oe_l				  , 
	sram_we_l(1)				            => sram1_we_l				  ,
	sram_we_l(2)				            => sram2_we_l				  ,
   ------------------------------------			         
	sram2_ce2					            =>	sram2_ce2				  ,	
	--================================--         
	-- USER INTERFACE       
	--================================--         
   user_reset_o				            => user_reset				  ,
	------------------------------------         
	user_clk125_2_o                     => user_clk125_2          ,
   user_clk125_2_bufg_o                => user_clk125_2_bufg     ,
	user_pri_clk_o				            => user_pri_clk			  ,
	---------               
   sec_clk_i              	            => sec_clk                ,  -- (from user_logic)
   sys_pcie_mgt_refclk_i	            => sys_pcie_mgt_refclk    ,  -- (from user_logic) 
   user_sys_pcie_dma_clk_o             => user_sys_pcie_dma_clk  ,     
   ------------------------------------         
	user_sram_control_i		            => user_sram_control		  ,	
	user_sram_addr_i			            => user_sram_addr			  , 
	user_sram_wdata_i			            => user_sram_wdata		  , 
	user_sram_rdata_o			            => user_sram_rdata		  ,
	------------------------------------         
	cdce_out0_gtxe1_i		               => cdce_out0_gtxe1        ,
   cdce_out3_gtxe1_i		               => cdce_out3_gtxe1        ,
   ------------------------------------   
   user_cdce_sel_i			            => user_cdce_sel			  ,
	user_cdce_sync_i			            => user_cdce_sync			  , 
	------------------------------------ 
   user_mac_addr_i 			            => user_mac_addr	     	  ,         
   user_ip_addr_i				            => user_ip_addr		     ,           
   ------------------------------------         
	user_mac_syncacqstatus_o            => user_mac_syncacqstatus ,
	user_mac_serdes_locked_o            => user_mac_serdes_locked ,
	------------------------------------   
   user_sys_pcie_slv_i	               => user_slv_to_sys_pcie	  ,  
	user_sys_pcie_slv_o	               => user_slv_from_sys_pcie ,  
	user_sys_pcie_dma_i	               => user_dma_to_sys_pcie	  ,  
	user_sys_pcie_dma_o                 => user_dma_from_sys_pcie ,  
	user_sys_pcie_int_i                 => user_int_to_sys_pcie   ,  
	user_sys_pcie_int_o                 => user_int_from_sys_pcie ,	
	user_sys_pcie_cfg_o 		            => user_cfg_from_sys_pcie ,  	
	------------------------------------   
	user_wb_miso_i				            => user_wb_miso			  ,
	user_wb_mosi_o				            => user_wb_mosi			  ,
	------------------------------------         
	user_ipb_clk_o				            => user_ipb_clk			  ,
	user_ipb_miso_i			            => user_ipb_miso			  ,
	user_ipb_mosi_o			            => user_ipb_mosi			
);                    	
--===================================================--
  	
end sys_v3_only_arch;