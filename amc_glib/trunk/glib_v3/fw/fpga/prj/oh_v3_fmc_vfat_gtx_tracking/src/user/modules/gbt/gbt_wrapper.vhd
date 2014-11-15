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

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_wrapper is   
   generic (
      FABRIC_CLK_FREQ                           : integer := 125e6 
   );
   port (   
      GENERAL_RESET_I                           : in  std_logic;
      
      FABRIC_CLK_I                              : in  std_logic; 
      MGT_REFCLK_I                              : in  std_logic;
      TX_OUTCLK_O                               : out std_logic;
		
      --==============--
      -- Serial lanes --
      --==============--
      
      MGT_TX_P                                  : out std_logic; 
      MGT_TX_N                                  : out std_logic; 
      MGT_RX_P                                  : in  std_logic;
      MGT_RX_N                                  : in  std_logic;      
      
      TX_ISDATA_SEL_I                           : in  std_logic;
      TX_DATA_I                                 : in std_logic_vector(83 downto 0);

      RX_ISDATA_FLAG_O                          : out std_logic;
      RX_DATA_O                                 : out std_logic_vector(83 downto 0);
      
      CONTROL_REGISTER_O                        : out std_logic_vector(31 downto 0)
   );
end gbt_wrapper;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_wrapper is  
   
   --================================ Signal Declarations ================================--   
  
   --========================--  
   -- GBT Bank resets scheme --
   --========================--
   
   signal mgtTxReset_from_gbtBankRst            : std_logic; 
   signal mgtRxReset_from_gbtBankRst            : std_logic; 
   signal gbtTxReset_from_gbtBankRst            : std_logic;
   signal gbtRxReset_from_gbtBankRst            : std_logic; 
   
   --========================--
   -- GBT Bank clocks scheme -- 
   --========================--   
   
   signal txPllRefClk_from_mgtRefClkBufg        : std_logic;
   ---------------------------------------------
   signal txFrameClk_from_txPll                 : std_logic;   
   ---------------------------------------------  
   signal pllLocked_from_rxFrmClkPhAlgnr        : std_logic; 
   signal phaseAlignDone_from_rxFrmClkPhAlgnr   : std_logic;   
   signal rxFrameClkReady_from_orGate           : std_logic; 
   signal rxFrameClk_from_rxFrmClkPhAlgnr       : std_logic;

   --==========--
   -- GBT Bank --
   --==========--   
   
   -- Comment: Note!! Only ONE GBT Bank with ONE link can be used in this example design.
   
   -- GBT Bank 1:
   --------------
   
   signal to_gbtBank_1_clks                     : gbtBankClks_i_R;                          
   signal from_gbtBank_1_clks                   : gbtBankClks_o_R;
   ---------------------------------------------        
   signal to_gbtBank_1_gbtTx                    : gbtTx_i_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   signal from_gbtBank_1_gbtTx                  : gbtTx_o_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   ---------------------------------------------        
   signal to_gbtBank_1_mgt                      : mgt_i_R;
   signal from_gbtBank_1_mgt                    : mgt_o_R; 
   ---------------------------------------------        
   signal to_gbtBank_1_gbtRx                    : gbtRx_i_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   signal from_gbtBank_1_gbtRx                  : gbtRx_o_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);

   signal TX_WORDCLK_I                          : std_logic := '0';
   signal LOOPBACK_I                            : std_logic_vector(2 downto 0) := "001"; -- No loopback, normal operation
   signal TX_ENCODING_SEL_I                     : std_logic_vector(1 downto 0) := "00";  -- no extended data frame^M
   signal RX_ENCODING_SEL_I                     : std_logic_vector(1 downto 0) := "00";  -- no extended data frame

   signal LATENCY_OPT_GBTLINK_O                 : std_logic;
   signal MGT_READY_O                           : std_logic;
   signal RX_HEADER_LOCKED_O                    : std_logic;
   signal RX_BITSLIP_NUMBER_O                   : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   signal RX_WORDCLK_READY_O                    : std_logic;
   signal RX_FRAMECLK_ALIGNED_O                 : std_logic;
   signal GBT_RX_READY_O                        : std_logic;
   signal TX_FRAMECLK_PLL_LOCKED_O              : std_logic;
	signal LATOPT_GBTBANK_TX_O                   : std_logic;
   signal LATOPT_GBTBANK_RX_O                   : std_logic;
   signal RX_GBT_READY_LOST_FLAG_O              : std_logic;
   signal COMMONDATA_ERROR_SEEN_FLAG_O          : std_logic;
   signal WIDEBUSDATA_ERROR_SEEN_FLAG_O         : std_logic;
   
	signal dff :std_logic;
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   CONTROL_REGISTER_O(12 downto 0) <= TX_FRAMECLK_PLL_LOCKED_O & LATOPT_GBTBANK_TX_O & LATOPT_GBTBANK_RX_O & MGT_READY_O 
	                                 & RX_HEADER_LOCKED_O & RX_BITSLIP_NUMBER_O
                                    & RX_WORDCLK_READY_O & RX_FRAMECLK_ALIGNED_O & GBT_RX_READY_O;
	TX_WORDCLK_I <= '0';
   LOOPBACK_I <= "000"; -- No loopback, normal operation
   TX_ENCODING_SEL_I <= "00";  -- no extended data frame
   RX_ENCODING_SEL_I <= "00";  -- no extended data frame
	
	flip_flop:process(FABRIC_CLK_I, GENERAL_RESET_I)
	begin
	  if GENERAL_RESET_I = '1' then
	    dff <= '0';
	  elsif rising_edge(FABRIC_CLK_I) then
	    dff <= not dff ;
	  end if;
	end process;
	
   --========================--
   -- GBT Bank resets scheme --
   --========================--
   
   -- Comment:  * GENERAL_RESET_I is used to reset the GBT Bank sequentially.
   --             (see the timing diagram as a comment in the "gbtBankRst" module)  
   --
   --           * Manual reset is used to reset the TX and the RX independently:
   --
   --             - MANUAL_RESET_TX_I resets GBT_TX and MGT_TX.
   --
   --             - MANUAL_RESET_RX_I resets GBT_RX and MGT_RX.
   
   gbtBankRst: entity work.gbt_bank_reset    
      generic map (
         RX_INIT_FIRST                          => false,
         INITIAL_DELAY                          => 1 * FABRIC_CLK_FREQ,  -- Comment: * 1s  
         TIME_N                                 => 1 * FABRIC_CLK_FREQ,  --          * 1s
         GAP_DELAY                              => 1 * FABRIC_CLK_FREQ)  --          * 1s
      port map (     
         CLK_I                                  => FABRIC_CLK_I,                                               
         ---------------------------------------
         GENERAL_RESET_I                        => GENERAL_RESET_I,                                                                 
         MANUAL_RESET_TX_I                      => dff,
         MANUAL_RESET_RX_I                      => dff,
         ---------------------------------------     
         MGT_TX_RESET_O                         => mgtTxReset_from_gbtBankRst,                              
         MGT_RX_RESET_O                         => mgtRxReset_from_gbtBankRst,                             
         GBT_TX_RESET_O                         => gbtTxReset_from_gbtBankRst,                                      
         GBT_RX_RESET_O                         => gbtRxReset_from_gbtBankRst,                              
         ---------------------------------------      
         BUSY_O                                 => open,                                                                         
         DONE_O                                 => open                                                                          
      );          
   
   to_gbtBank_1_gbtTx(1).reset                  <= gbtTxReset_from_gbtBankRst;   
   to_gbtBank_1_mgt.mgtLink(1).tx_reset         <= mgtTxReset_from_gbtBankRst;
   to_gbtBank_1_mgt.mgtLink(1).rx_reset         <= mgtRxReset_from_gbtBankRst;   
   to_gbtBank_1_gbtRx(1).reset                  <= gbtRxReset_from_gbtBankRst;  
   
   --========================--
   -- GBT Bank clocks scheme --
   --========================-- 
   
   -- MGT reference clock: 
   -----------------------
   
   to_gbtBank_1_clks.mgt_clks.tx_refClk         <= MGT_REFCLK_I;
   to_gbtBank_1_clks.mgt_clks.rx_refClk         <= MGT_REFCLK_I;
   
   -- Comment: In this example design, MGT_REFCLK_I is used to generate the reference clock of the txPll. If available, the TTC CLK could be used instead.    
   
   mgtRefClkBufg: bufg
      port map (
         O                                      => txPllRefClk_from_mgtRefClkBufg, 
         I                                      => MGT_REFCLK_I
      );    

   -- TX_WORDCLK & TX_FRAMECLK:
   ----------------------------
    
   -- Comment: Note!! In order to save clocking resources, it is strongly recommended that all GBT Links of the GBT Bank share the same "tx_wordClk_noBuff"
   --                 (e.g. In a GBT Bank composed by GBT Links 1,2 and 3, all GBT Links use "tx_wordClk_noBuff(1)", using just one clock buffer to feed
   --                  "tx_wordClk(1)", "tx_wordClk(2)" and "tx_wordClk(3)").

   txWordClkBufg: bufg
      port map (
         O                                      => to_gbtBank_1_clks.mgt_clks.tx_wordClk(1), 
         I                                      => from_gbtBank_1_clks.mgt_clks.tx_wordClk_noBuff(1)
      ); 
   
   -- Comment: * The txPll (MMCM) does not have input buffer.
   --      
   --          * TX_FRAMECLK frequency: 40MHz
   --
   --          * Note!! The 40MHz output of the "txPll" is shifter 90deg in order to sample correctly when using the latency-optimized GBT Bank.
   
   txPll: entity work.xlx_v6_tx_mmcm_FABRIC
      port map (
         -- Clock in ports:
         CLK_IN1                                => FABRIC_CLK_I, -- txPllRefClk_from_mgtRefClkBufg,
         -- Clock out ports:               
         CLK_OUT1                               => txFrameClk_from_txPll,   -- Comment: Note!! 40MHz output shifted 90deg.
         -- Status and control signals:
         RESET                                  => '0',
         LOCKED                                 => TX_FRAMECLK_PLL_LOCKED_O
      );    
   
   -- Comment: Note!! In order to save clocking resources, it is strongly recommended that all GBT Links of the GBT Bank share the same "tx_frameClk"
   --                 (e.g. In a GBT Bank composed by GBT Links 1,2 and 3, all GBT Links use "txFrameClk_from_txPll" to feed "to_gbtBank_1_clks.tx_frameClk(1)",
   --                   "to_gbtBank_1_clks.tx_frameClk(2)" and  "to_gbtBank_1_clks.tx_frameClk(3)").   
   
   to_gbtBank_1_clks.tx_frameClk(1)             <= txFrameClk_from_txPll;     
   
   -- RX_WORDCLK & RX_FRAMECLK:
   ----------------------------
   
   -- Comment: * Due to the Clock & Data Recovery (CDR), the "rx_wordClk" of each GBT Link of the GBT Bank should clocked by its own  
   --            "rx_wordClk_noBuff" using a dedicated clock buffer. 
   --
   --          * Each latency-optimized GBT Link of the GBT Bank should have its own RX_FRAMECLK aligner. 
   
   rxWordClkBufg: bufg
      port map (
         O                                      => to_gbtBank_1_clks.mgt_clks.rx_wordClk(1), 
         I                                      => from_gbtBank_1_clks.mgt_clks.rx_wordClk_noBuff(1) 
      );   
     
   -- Comment: * This phase aligner uses the header of the incoming data stream as a reference point for matching the rising
   --            edge of the recovered RX_FRAMECLK with the rising edge of the TX_FRAMECLK of the TRANSMITTER BOARD.
   -- 
   --          * Note!! The phase alignment is only triggered when LATENCY-OPTIMIZED GBT Bank RX is used.  
   --
   --          * The PLL (MMCM) does not have input buffer.
   --      
   --          * RX_FRAMECLK frequency: 40MHz   
   
   rxFrmClkPhAlgnr: entity work.gbt_rx_frameclk_phalgnr
      port map (
         RESET_I                                => gbtRxReset_from_gbtBankRst,
         ---------------------------------------      
         RX_WORDCLK_I                           => to_gbtBank_1_clks.mgt_clks.rx_wordClk(1),
         RX_FRAMECLK_O                          => rxFrameClk_from_rxFrmClkPhAlgnr,         
         ---------------------------------------      
         SYNC_ENABLE_I                          => from_gbtBank_1_gbtRx(1).latOptGbtBank_rx and from_gbtBank_1_mgt.mgtLink(1).rxWordClkReady,
         SYNC_I                                 => from_gbtBank_1_gbtRx(1).header_flag,
         ---------------------------------------
         PLL_LOCKED_O                           => pllLocked_from_rxFrmClkPhAlgnr,
         DONE_O                                 => phaseAlignDone_from_rxFrmClkPhAlgnr
      );                      
   
   rxFrameClkReady_from_orGate                  <=    (pllLocked_from_rxFrmClkPhAlgnr      and (not from_gbtBank_1_gbtRx(1).latOptGbtBank_rx))
                                                   or (phaseAlignDone_from_rxFrmClkPhAlgnr and      from_gbtBank_1_gbtRx(1).latOptGbtBank_rx);
                                                   
   to_gbtBank_1_gbtRx(1).rxFrameClkReady        <= rxFrameClkReady_from_orGate;
--   RX_FRAMECLK_READY_O                          <= rxFrameClkReady_from_orGate;     
   TX_OUTCLK_O                                  <= rxFrameClkReady_from_orGate;
   to_gbtBank_1_clks.rx_frameClk(1)             <= rxFrameClk_from_rxFrmClkPhAlgnr;
   
   --==========--
   -- GBT Bank --
   --==========--
   
   -- Comment: Note!! Only ONE GBT Bank with ONE link can be used in this example design.    
   
   gbtBank_1: entity work.gbt_bank
      generic map (
         GBT_BANK_ID                            => 1)
      port map (                       
         CLKS_I                                 => to_gbtBank_1_clks,                                  
         CLKS_O                                 => from_gbtBank_1_clks,               
         ---------------------------------------          
         GBT_TX_I                               => to_gbtBank_1_gbtTx,             
         GBT_TX_O                               => from_gbtBank_1_gbtTx,         
         ---------------------------------------          
         MGT_I                                  => to_gbtBank_1_mgt,              
         MGT_O                                  => from_gbtBank_1_mgt,              
         ---------------------------------------          
         GBT_RX_I                               => to_gbtBank_1_gbtRx,              
         GBT_RX_O                               => from_gbtBank_1_gbtRx         
      ); 
		
   -- Serial lanes assignments:
   ----------------------------
   
   to_gbtBank_1_mgt.mgtLink(1).rx_p             <= MGT_RX_P;   
   to_gbtBank_1_mgt.mgtLink(1).rx_n             <= MGT_RX_N;
   MGT_TX_P                                     <= from_gbtBank_1_mgt.mgtLink(1).tx_p;
   MGT_TX_N                                     <= from_gbtBank_1_mgt.mgtLink(1).tx_n;     
   
   -- Data assignments:
   --------------------   

   to_gbtBank_1_gbtTx(1).isDataSel              <= TX_ISDATA_SEL_I;  
   
   to_gbtBank_1_gbtTx(1).data                   <= TX_DATA_I;   
   to_gbtBank_1_gbtTx(1).extraData_wideBus      <= (others => '0');
   to_gbtBank_1_gbtTx(1).extraData_gbt8b10b     <= (others => '0');   -- Comment: Note!! Not implemented yet.
   
   -- Control assignments:
   -----------------------  
   
   to_gbtBank_1_mgt.mgtLink(1).loopBack         <= LOOPBACK_I;

   to_gbtBank_1_mgt.mgtLink(1).tx_syncReset     <= '0';
   to_gbtBank_1_mgt.mgtLink(1).rx_syncReset     <= '0';

   -- Comment: The built-in PRBS generator/checker of the MGT(GTX) transceiver is not used in this example design.

   to_gbtBank_1_mgt.mgtLink(1).prbs_txEn        <= "000";
   to_gbtBank_1_mgt.mgtLink(1).prbs_rxEn        <= "000";
   to_gbtBank_1_mgt.mgtLink(1).prbs_forcErr     <= '0';
   to_gbtBank_1_mgt.mgtLink(1).prbs_errCntRst   <= '0';             
   
   to_gbtBank_1_mgt.mgtLink(1).conf_diff        <= "1000";    -- Comment: 810 mVppd
   to_gbtBank_1_mgt.mgtLink(1).conf_pstEmph     <= "00000";   -- Comment: 0.18 dB (default)
   to_gbtBank_1_mgt.mgtLink(1).conf_preEmph     <= "0000";    -- Comment: 0.15 dB (default)
   to_gbtBank_1_mgt.mgtLink(1).conf_eqMix       <= "000";     -- Comment: 12 dB (default)
   to_gbtBank_1_mgt.mgtLink(1).conf_txPol       <= '0';       -- Comment: Not inverted
   to_gbtBank_1_mgt.mgtLink(1).conf_rxPol       <= '0';       -- Comment: Not inverted 
   
   -- Comment: The DRP port of the MGT(GTX) transceiver is not used in this example design.   
   
   to_gbtBank_1_mgt.mgtLink(1).drp_dClk         <= '0';
   to_gbtBank_1_mgt.mgtLink(1).drp_dAddr        <= x"00";
   to_gbtBank_1_mgt.mgtLink(1).drp_dEn          <= '0';
   to_gbtBank_1_mgt.mgtLink(1).drp_dI           <= x"0000";
   to_gbtBank_1_mgt.mgtLink(1).drp_dWe          <= '0';

   -- Comment: * The manual RX_WORDCLK phase alignment control of the MGT(GTX) transceivers is not used in this 
   --            reference design (auto RX_WORDCLK phase alignment is used instead).
   --
   --          * Note!! The manual RX_WORDCLK phase alignment control of the MGT(GTX) MUST be synchronous with RX_WORDCLK
   --                   (in this example design this clock is "to_gbtBank_1_clks.mgt_clks.rx_wordClk(1)").
   
   to_gbtBank_1_mgt.mgtLink(1).rxSlide_enable   <= '1'; 
   to_gbtBank_1_mgt.mgtLink(1).rxSlide_ctrl     <= '0'; 
   to_gbtBank_1_mgt.mgtLink(1).rxSlide_nbr      <= "00000";
   to_gbtBank_1_mgt.mgtLink(1).rxSlide_run      <= '0';
   
   LATOPT_GBTBANK_TX_O                          <= from_gbtBank_1_gbtTx(1).latOptGbtBank_tx;
   LATOPT_GBTBANK_RX_O                          <= from_gbtBank_1_gbtRx(1).latOptGbtBank_rx;
   MGT_READY_O                                  <= from_gbtBank_1_mgt.mgtLink(1).ready;
   RX_WORDCLK_READY_O                           <= from_gbtBank_1_mgt.mgtLink(1).rxWordClkReady;   
   RX_BITSLIP_NUMBER_O                          <= from_gbtBank_1_gbtRx(1).bitSlipNbr;
   GBT_RX_READY_O                               <= from_gbtBank_1_gbtRx(1).ready;
   
   RX_DATA_O                                    <= from_gbtBank_1_gbtRx(1).data; 
   RX_ISDATA_FLAG_O                             <= from_gbtBank_1_gbtRx(1).isDataFlag;
	
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--