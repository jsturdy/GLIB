----------------------------------------------------------------------------------------------------------
--
-- Filename: 		gbt_wrapper.vhd
-- Author: 		Erik Verhagen
-- Created: 		08 Nov 2014
-- For: 		IIHE Brussels
--
-- Description: 	Wrapper to instantiate the GBT core inside the arch GEM project
--                some inspiration came from the gbt_fpga project
--
-- History: 
--			[08-11-2014] File created
--
----------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.gbt_banks_user_setup.all;
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;

entity gbt_wrapper is   
   generic (
      FABRIC_CLK_FREQ                           : integer := 125e6 
   );
   port (   
      
      --===============--
      -- Resets scheme --
      --===============-- 
      
      GENERAL_RESET_I                           : in  std_logic;
      
      --===============--
      -- Clocks scheme --
      --===============--
      
      FABRIC_CLK_I                              : in  std_logic; 
      MGT_REFCLKS_I                             : in  gbtLinkMgtRefClks_R; 
      TX_OUTCLK_O                               : out std_logic; 
      
      --==============--
      -- Serial lanes --
      --==============--
      
      MGT_TX_P                                  : out std_logic; 
      MGT_TX_N                                  : out std_logic; 
      MGT_RX_P                                  : in  std_logic;
      MGT_RX_N                                  : in  std_logic;      
     
      --===============--
      -- GBT Link data -- 
      --===============--
      
      -- TX data:
      -----------
      TX_ISDATA_SEL_I                           : in  std_logic; -- MAYBE THE HOLY GRAIL !!!!!!! (ERIK)
		TX_DATA_I                                 : in std_logic_vector(83 downto 0);  
      
      -- RX data:
      -----------
      RX_ISDATA_FLAG_O                          : out std_logic;
      RX_DATA_O                                 : out std_logic_vector(83 downto 0);
     
      CONTROL_REGISTER_O                        : out std_logic_vector(31 downto 0)
   );
end gbt_wrapper;

architecture Structural of gbt_wrapper is

   --===============--
   -- Resets scheme --
   --===============--
   
   signal mgt_txReset_from_gbtLinkRst           : std_logic; 
   signal mgt_rxReset_from_gbtLinkRst           : std_logic; 
   signal gbt_txReset_from_gbtLinkRst           : std_logic;
   signal gbt_rxReset_from_gbtLinkRst           : std_logic;   
         
   --===============--
   -- Clocks scheme --    
   --===============--    
         
   signal rxFrameClk_from_rxFrameClkPhaAl       : std_logic; 
   signal phaseAlignDone_from_rxPll             : std_logic;   
	
   --=====================--
   -- GBT Link (SFP quad) --    
   --=====================--    
         
   signal clks_to_gbtLink                       : gbtLinkClks_i_R;                          
   signal clks_from_gbtLink                     : gbtLinkClks_o_R;
   ---------------------------------------------         
   signal to_gbtTx                              : gbtTx_i_R_A(1 to NUM_GBT_LINK); 
   ---------------------------------------------         
   signal to_mgt                                : mgt_i_R_A  (1 to NUM_GBT_LINK);
   signal from_mgt                              : mgt_o_R_A  (1 to NUM_GBT_LINK); 
   ---------------------------------------------         
   signal to_gbtRx                              : gbtRx_i_R_A(1 to NUM_GBT_LINK); 
   signal from_gbtRx                            : gbtRx_o_R_A(1 to NUM_GBT_LINK);

   --================--
   -- GBT Link cnfig --
   --================--     

   signal TX_WORDCLK_I                          : std_logic := '0';
	signal LOOPBACK_I                            : std_logic_vector(2 downto 0) := "000"; -- No loopback, normal operation
	signal TX_ENCODING_SEL_I                     : std_logic_vector(1 downto 0) := "00";  -- no extended data frame
   signal RX_ENCODING_SEL_I                     : std_logic_vector(1 downto 0) := "00";  -- no extended data frame

   --================--
   -- GBT Link status --
   --================--     
		
   signal LATENCY_OPT_GBTLINK_O                 : std_logic;
   signal MGT_READY_O                           : std_logic;
   signal RX_HEADER_LOCKED_O                    : std_logic;  
   signal RX_BITSLIP_NUMBER_O                   : std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);      
   signal RX_WORDCLK_ALIGNED_O                  : std_logic;
   signal RX_FRAMECLK_ALIGNED_O                 : std_logic;
   signal RX_GBT_READY_O                        : std_logic;        
      
   signal RX_GBT_READY_LOST_FLAG_O              : std_logic;
   signal COMMONDATA_ERROR_SEEN_FLAG_O          : std_logic;
   signal WIDEBUSDATA_ERROR_SEEN_FLAG_O         : std_logic;

begin 

	CONTROL_REGISTER_O(10 downto 0) <= LATENCY_OPT_GBTLINK_O & MGT_READY_O & RX_HEADER_LOCKED_O & RX_BITSLIP_NUMBER_O
		                    & RX_WORDCLK_ALIGNED_O & RX_FRAMECLK_ALIGNED_O & RX_GBT_READY_O;
   
   clks_to_gbtLink.mgt_refClks                  <= MGT_REFCLKS_I;
   TX_OUTCLK_O                                  <= from_mgt(1).usrBuf_txOutClk;
   to_mgt(1).usrBuf_txUsrClk2                   <= TX_WORDCLK_I;
   clks_to_gbtLink.tx_frameClk                  <= FABRIC_CLK_I;
   clks_to_gbtLink.rx_frameClk                  <= rxFrameClk_from_rxFrameClkPhaAl;
	
   -- GBT Link reset:
   ------------------ 
   
   -- Comment: The GBT Link needs to be reset sequentially.
   --          (see the timing diagram as a comment in the "gbtLink_rst" module)  
   
   gbtLink_rst: entity work.gbt_link_reset    
      generic map (
         RX_INIT_FIRST                          => false,
         INITIAL_DELAY                          => 1 * FABRIC_CLK_FREQ,  -- Comment: * 1s  
         TIME_N                                 => 1 * FABRIC_CLK_FREQ,  --          * 1s
         GAP_DELAY                              => 1 * FABRIC_CLK_FREQ)  --          * 1s
      port map (     
         CLK_I                                  => FABRIC_CLK_I,                                               
         RESET_I                                => GENERAL_RESET_I,                                                                 
         ---------------------------------------     
         MGT_TXRESET_O                          => mgt_txReset_from_gbtLinkRst,                              
         MGT_RXRESET_O                          => mgt_rxReset_from_gbtLinkRst,                             
         GBT_TXRESET_O                          => gbt_txReset_from_gbtLinkRst,                                      
         GBT_RXRESET_O                          => gbt_rxReset_from_gbtLinkRst,                              
         ---------------------------------------      
         BUSY_O                                 => open,                                                                         
         DONE_O                                 => open                                                                          
      );          
         
   to_mgt(1).tx_reset                           <= mgt_txReset_from_gbtLinkRst;
   to_mgt(1).rx_reset                           <= mgt_rxReset_from_gbtLinkRst;
   to_gbtTx(1).reset                            <= gbt_txReset_from_gbtLinkRst;
   to_gbtRx(1).reset                            <= gbt_rxReset_from_gbtLinkRst;
         
   -- Unit Under Test - GBT Link:
   ------------------------------
   
   glib_core_inst: entity work.gbt_bank                        
      port map (                     
         CLKS_I                                 => clks_to_gbtLink,                                  
         CLKS_O                                 => clks_from_gbtLink,               
         ---------------------------------------       
         GBT_TX_I                               => to_gbtTx,             
         ---------------------------------------       
         MGT_I                                  => to_mgt,              
         MGT_O                                  => from_mgt,              
         ---------------------------------------       
         GBT_RX_I                               => to_gbtRx,              
         GBT_RX_O                               => from_gbtRx         
      );       
   
   -- Signal assignments:
   ----------------------
   
   -- Comment: Note!! Only one GBT Link is used in this reference design.

   RX_DATA_O                                    <= from_gbtRx(1).data;
   
   to_mgt(1).rx_p                               <= MGT_RX_P;   
   to_mgt(1).rx_n                               <= MGT_RX_N;
   MGT_TX_P                                     <= from_mgt(1).tx_p;
   MGT_TX_N                                     <= from_mgt(1).tx_n;     
   
   to_gbtTx(1).data                             <= TX_DATA_I;   
   to_gbtTx(1).widebusExtraData                 <= (others => '0');
   
   to_gbtTx(1).encodingSel                      <= TX_ENCODING_SEL_I;
   to_gbtRx(1).encodingSel                      <= RX_ENCODING_SEL_I;
   to_gbtTx(1).isDataSel                        <= TX_ISDATA_SEL_I;  
   RX_ISDATA_FLAG_O                             <= from_gbtRx(1).isDataFlag;    
   
   to_mgt(1).loopBack                           <= LOOPBACK_I;
   to_mgt(1).tx_syncReset                       <= '0';
   to_mgt(1).rx_syncReset                       <= '0';
   to_mgt(1).conf_diff                          <= "1000";    -- Comment: 810 mVppd
   to_mgt(1).conf_pstEmph                       <= "00000";   -- Comment: 0.18 dB (default)
   to_mgt(1).conf_preEmph                       <= "0000";    -- Comment: 0.15 dB (default)
   to_mgt(1).conf_eqMix                         <= "000";     -- Comment: 12 dB (default)
   to_mgt(1).conf_txPol                         <= '0';       -- Comment: Not inverted
   to_mgt(1).conf_rxPol                         <= '0';       -- Comment: Not inverted        
         
   LATENCY_OPT_GBTLINK_O                        <= from_mgt(1).latOptGbtLink;
   MGT_READY_O                                  <= from_mgt(1).ready;
   RX_WORDCLK_ALIGNED_O                         <= from_mgt(1).rx_wordClk_aligned;   
   RX_HEADER_LOCKED_O                           <= from_gbtRx(1).header_lockedFlag;
   RX_BITSLIP_NUMBER_O                          <= from_gbtRx(1).bitSlip_nbr;
   
   -- Comment: The fabric clock scheme of the RX MGT(GTX) (RX_USRCLK2) is generated within the 
   --          GBT Link.   
   
   to_mgt(1).usrBuf_rxUsrClk2                   <= '0';   
   
   -- Comment: * The manual phase alignment control of the MGT(GTX) transceivers is not used in this reference
   --            design (auto phase alignment is used instead).
   --
   --          * Note!! The manual phase alignment control of the MGT(GTX) MUST be synchronous with "rx_word_clk"
   --                   (this clock is forwarded out from the GBT Link through the record port "CLKS_O").
   
   to_mgt(1).rx_slide_enable                    <= '1'; 
   to_mgt(1).rx_slide_ctrl                      <= '0'; 
   to_mgt(1).rx_slide_nbr                       <= "00000";
   to_mgt(1).rx_slide_run                       <= '0';
   
   -- Comment: * The DRP port of the MGT(GTX) transceiver is not used in this design.   
   
   to_mgt(1).drp_dClk                           <= '0';
   to_mgt(1).drp_dAddr                          <= x"00";
   to_mgt(1).drp_dEn                            <= '0';
   to_mgt(1).drp_dI                             <= x"0000";
   to_mgt(1).drp_dWe                            <= '0';

   -- Comment: The built-in PRBS generator/checker of the MGT(GTX) transceiver is not used in this design.

   to_mgt(1).prbs_txEn                          <= "000";
   to_mgt(1).prbs_rxEn                          <= "000";
   to_mgt(1).prbs_forcErr                       <= '0';
   to_mgt(1).prbs_errCntRst                     <= '0';            

   --==============================--
   -- RX frame clock phase aligner --
   --==============================--
   
   -- Comment: * This phase aligner uses the header of the gbt frame as a reference point for matching the rising
   --            edge of the recovered rx frame clock with the rising edge of the tx frame clock of the TRANSMITTER
   --            BOARD when using the latency-optimized MGT(GTX).  
   -- 
   --          * Note!! The phase alignment is only triggered when LATENCY-OPTIMIZED GBT Link.
   
   rxFrameClkPhaAl: entity work.xlx_v6_rxframeclk_ph_alig
      port map (
         RESET_I                                => gbt_rxReset_from_gbtLinkRst,
         ---------------------------------------      
         RX_WORDCLK_I                           => clks_from_gbtLink.rx_wordClk(1),
         RX_FRAMECLK_O                          => rxFrameClk_from_rxFrameClkPhaAl,         
         ---------------------------------------      
         SYNC_I                                 => from_gbtRx(1).header_flag and from_mgt(1).latOptGbtLink,
         ---------------------------------------
         DONE_O                                 => phaseAlignDone_from_rxPll
      );          
            
   RX_FRAMECLK_ALIGNED_O                        <= phaseAlignDone_from_rxPll;
            




end architecture;		