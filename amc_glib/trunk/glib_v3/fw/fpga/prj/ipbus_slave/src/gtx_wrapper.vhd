library ieee;
use ieee.std_logic_1164.all;

library work;

library unisim;
use unisim.vcomponents.all;

entity gtx_wrapper is
port(
    --===========================================--
    -- Clocking
    --===========================================--
    clk160MHz_p_i           : in std_logic;
    clk160MHz_n_i           : in std_logic;
    reset                   : in std_logic;

    --===========================================--
    -- GTX0
    --===========================================--
    gtx0_rx_kchar_o         : out std_logic_vector(1 downto 0);
    gtx0_rx_error_o         : out std_logic_vector(1 downto 0);
    gtx0_rx_comma_det_o     : out std_logic;
    gtx0_rx_data_o          : out std_logic_vector(15 downto 0);
    gtx0_rx_n_i             : in std_logic;
    gtx0_rx_p_i             : in std_logic;
    gtx0_rx_lossofsync_o    : out std_logic_vector(1 downto 0);
    gtx0_rx_reset_i         : in std_logic;
    gtx0_pll_rx_reset_i     : in std_logic;
    gtx0_rx_pll_locked_o    : out std_logic;
    gtx0_rx_reset_done_o    : out std_logic;
    gtx0_tx_kchar_i         : in std_logic_vector(1 downto 0);
    gtx0_tx_data_i          : in std_logic_vector(15 downto 0);
    gtx0_tx_n_o             : out std_logic;
    gtx0_tx_p_o             : out std_logic;
    gtx0_tx_reset_i         : in std_logic;
    gtx0_tx_reset_done_o    : out std_logic;
    
    --===========================================--
    -- GTX1
    --===========================================--
    gtx1_rx_kchar_o         : out std_logic_vector(1 downto 0);
    gtx1_rx_error_o         : out std_logic_vector(1 downto 0);
    gtx1_rx_comma_det_o     : out std_logic;
    gtx1_rx_data_o          : out std_logic_vector(15 downto 0);
    gtx1_rx_n_i             : in std_logic;
    gtx1_rx_p_i             : in std_logic;
    gtx1_rx_lossofsync_o    : out std_logic_vector(1 downto 0);
    gtx1_rx_reset_i         : in std_logic;
    gtx1_pll_rx_reset_i     : in std_logic;
    gtx1_rx_pll_locked_o    : out std_logic;
    gtx1_rx_reset_done_o    : out std_logic;
    gtx1_tx_kchar_i         : in std_logic_vector(1 downto 0);
    gtx1_tx_data_i          : in std_logic_vector(15 downto 0);
    gtx1_tx_n_o             : out std_logic;
    gtx1_tx_p_o             : out std_logic;
    gtx1_tx_reset_i         : in std_logic;
    gtx1_tx_reset_done_o    : out std_logic
);
end gtx_wrapper;

architecture Behavioral of gtx_wrapper is

    --===========================================--
    -- Parameter
    --===========================================--
    constant DLY : time := 1 ns;

    --===========================================--
    -- GTX0
    --===========================================--
    signal gtx0_rxdisperr_r         : std_logic_vector(1 downto 0);
    signal gtx0_rxnotintable_r      : std_logic_vector(1 downto 0);
    signal gtx0_prbs_rx_error_r     : std_logic;
    signal gtx0_rxrecclk_r          : std_logic;
    signal gtx0_txoutclk_r          : std_logic;

    --===========================================--
    -- GTX1
    --===========================================--
    signal gtx1_rxdisperr_r         : std_logic_vector(1 downto 0);
    signal gtx1_rxnotintable_r      : std_logic_vector(1 downto 0);
    signal gtx1_prbs_rx_error_r     : std_logic;
    signal gtx1_rxrecclk_r          : std_logic;
    signal gtx1_txoutclk_r          : std_logic;

    --===========================================--
    -- User signals
    --===========================================--
    ----------------------------- User Clocks ---------------------------------
    signal gtx_usrclk2_r            : std_logic;
    signal gtx_refclk_r             : std_logic;
    
    ----------------------------- PLL -----------------------------------------
    signal clk160MHz_r              : std_logic;
    signal clk320MHz_r              : std_logic;
    signal pll_locked_r             : std_logic;
    
    ----------------------------- Zero signals --------------------------------
    signal tied_to_ground           : std_logic_vector(2 downto 0);
    signal tied_to_vcc              : std_logic_vector(2 downto 0);
    
begin

	--===========================================--
    -- Mapping
	--===========================================--
    tied_to_ground <= "000";
    tied_to_vcc <= "111";
    
    gtx_usrclk2_r <= clk160MHz_r;
    gtx_refclk_r <= clk320MHz_r;
   
    gtx0_rx_error_o <= gtx1_rxdisperr_r or gtx0_rxnotintable_r; 
    gtx1_rx_error_o <= gtx1_rxdisperr_r or gtx0_rxnotintable_r;   

	--===========================================--
    -- Clocks
	--===========================================--   
    clk160MHz_inst : IBUFDS_GTXE1
    port map(
        O       => clk160MHz_r,
        ODIV2   => open,
        CEB     => tied_to_ground(0),
        I       => clk160MHz_p_i,
        IB      => clk160MHz_n_i
    );

	--===========================================--
    -- PLL
	--===========================================--    
    gtx_pll_inst : entity work.gtx_pll
    port map(
        CLK_IN1     => clk160MHz_r,
        CLK_OUT1    => clk320MHz_r,
        RESET       => reset,
        LOCKED      => pll_locked_r
    );  

	--===========================================--
    -- High speed GTX
	--===========================================--
    high_speed_inst : entity work.high_speed
    generic map(
        -- Simulation attributes
        WRAPPER_SIM_GTXRESET_SPEEDUP => 0 -- Set to 1 to speed up sim reset
    )
    port map(
        --===========================================--
        -- GTX0
        --===========================================--
        ------------------------ Loopback and Powerdown Ports ----------------------
        GTX0_LOOPBACK_IN        => tied_to_ground,          -- Defines the loopback mode if any
                                                            -- 000  Normal operation
                                                            -- 001  Near-End PCS Loopback
                                                            -- 010  Near-End PMA Loopback
                                                            -- 011  Reserved
                                                            -- 100  Far-End PMA Loopbback
                                                            -- 101  Reserved
                                                            -- 110  Far-End PCS Loopback
                                                        
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        GTX0_RXCHARISK_OUT      => gtx0_rx_kchar_o,         -- High if the data is a control character
                                                            -- Bit 0 is for 7:0 data
                                                            -- Bit 1 is for 15:8 data
        GTX0_RXDISPERR_OUT      => gtx0_rxdisperr_r,        -- High if there is a disparity error
                                                            -- Bit 0 is for 7:0 data
                                                            -- Bit 1 is for 15:8 data
        GTX0_RXNOTINTABLE_OUT   => gtx0_rxnotintable_r,     -- High if the character is not in the decoding table
                                                            -- Bit 0 is for 7:0 data
                                                            -- Bit 1 is for 15:8 data
                                                            
        --------------- Receive Ports - Comma Detection and Alignment --------------
        GTX0_RXCOMMADET_OUT     => gtx0_rx_comma_det_o,     -- High when a comma is detected
        GTX0_RXENMCOMMAALIGN_IN => tied_to_vcc(0),          -- High to activate the alignment on the Minus Comma
        GTX0_RXENPCOMMAALIGN_IN => tied_to_vcc(0),          -- High to activate the alignment on the Plus Comma
        
        ----------------------- Receive Ports - PRBS Detection ---------------------
        GTX0_PRBSCNTRESET_IN    => tied_to_ground(0),       -- Reset the PRBS error counter
        GTX0_RXENPRBSTST_IN     => tied_to_ground,          -- Defines the PRBS mode if any
                                                            -- 000  Standard, no PRBS check
                                                            -- 001  PRBS-7
                                                            -- 010  PRBS-15
                                                            -- 011  PRBS-23
                                                            -- 100  PRBS-31
        GTX0_RXPRBSERR_OUT      => gtx0_prbs_rx_error_r,    -- High when a PRBS error occurs
        
        ------------------- Receive Ports - RX Data Path interface -----------------
        GTX0_RXDATA_OUT         => gtx0_rx_data_o,          -- Received data
        GTX0_RXRECCLK_OUT       => gtx0_rxrecclk_r,         -- Recommended fabric clock
        GTX0_RXUSRCLK2_IN       => gtx_usrclk2_r,           -- Clock to synchronize the FPGA and the RX (must be positive-edge aligned)
        
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        GTX0_RXN_IN             => gtx0_rx_n_i,             -- RX_N signal
        GTX0_RXP_IN             => gtx0_rx_p_i,             -- RX_P signal
        
        --------------- Receive Ports - RX Loss-of-sync State Machine --------------
        GTX0_RXLOSSOFSYNC_OUT   => gtx0_rx_lossofsync_o,    -- State of the internal state machine 
                                                            -- Bit 1 is high if the sync is lost
                                                            -- Bit 0 is high if the system is in the resync state
        
        ------------------------ Receive Ports - RX PLL Ports ----------------------
        GTX0_GTXRXRESET_IN      => gtx0_rx_reset_i,         -- Asserted high and then deasseted to start the RX reset sequence
        GTX0_MGTREFCLKRX_IN     => gtx_refclk_r,            -- Clock for the RX system
        GTX0_PLLRXRESET_IN      => gtx0_pll_rx_reset_i,     -- Reset the PLL (active High)
        GTX0_RXPLLLKDET_OUT     => gtx0_rx_pll_locked_o,    -- High when the PLL is locked
        GTX0_RXRESETDONE_OUT    => gtx0_rx_reset_done_o,    -- Goes high when the reset sequence is done
        
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        GTX0_TXCHARISK_IN       => gtx0_tx_kchar_i,         -- Set high if the TXDATA is a K character
                                                            -- Bit 0 is for 7:0 data
                                                            -- Bit 1 is for 15:8 data
        
        ------------------ Transmit Ports - TX Data Path interface -----------------
        GTX0_TXDATA_IN          => gtx0_tx_data_i,          -- Output data
        GTX0_TXOUTCLK_OUT       => gtx0_txoutclk_r,         -- Recommended fabric clock
        GTX0_TXUSRCLK2_IN       => gtx_usrclk2_r,           -- Clock to synchronize the FPGA and the TX (must be positive-edge aligned)
        
        ---------------- Transmit Ports - TX Driver and OOB signaling --------------
        GTX0_TXN_OUT            => gtx0_tx_n_o,             -- TX_N signal
        GTX0_TXP_OUT            => gtx0_tx_p_o,             -- TX_P signal
        
        ----------------------- Transmit Ports - TX PLL Ports ----------------------
        GTX0_GTXTXRESET_IN      => gtx0_tx_reset_i,         -- Asserted high and then deasseted to start the TX reset sequence
        GTX0_TXRESETDONE_OUT    => gtx0_tx_reset_done_o,    -- Goes high when the reset sequence is done
        
        --------------------- Transmit Ports - TX PRBS Generator -------------------
        GTX0_TXENPRBSTST_IN     => tied_to_ground,          -- Operation mode for the PRBS if any 
                                                            -- 000  No PRBS
                                                            -- 001  PRBS-7
                                                            -- 010  PRBS-15
                                                            -- 011  PRBS-23
                                                            -- 100  PRBS-31
                                                            -- 101  PCIe pattern
                                                            -- 110  Square wave with 2 UI
                                                            -- 111  Square wave with 16 UI
        GTX0_TXPRBSFORCEERR_IN  => tied_to_ground(0),       -- When set high, errors are forced in the PRBS
        

        --===========================================--
        -- GTX1
        --===========================================--
        GTX1_LOOPBACK_IN        => tied_to_ground, 
        GTX1_RXCHARISK_OUT      => gtx1_rx_kchar_o,
        GTX1_RXDISPERR_OUT      => gtx1_rxdisperr_r,
        GTX1_RXNOTINTABLE_OUT   => gtx1_rxnotintable_r,
        GTX1_RXCOMMADET_OUT     => gtx1_rx_comma_det_o,
        GTX1_RXENMCOMMAALIGN_IN => tied_to_vcc(0),
        GTX1_RXENPCOMMAALIGN_IN => tied_to_vcc(0),
        GTX1_PRBSCNTRESET_IN    => tied_to_ground(0),
        GTX1_RXENPRBSTST_IN     => tied_to_ground, 
        GTX1_RXPRBSERR_OUT      => gtx1_prbs_rx_error_r,
        GTX1_RXDATA_OUT         => gtx1_rx_data_o,  
        GTX1_RXRECCLK_OUT       => gtx1_rxrecclk_r,  
        GTX1_RXUSRCLK2_IN       => gtx_usrclk2_r,
        GTX1_RXN_IN             => gtx1_rx_n_i,
        GTX1_RXP_IN             => gtx1_rx_p_i,
        GTX1_RXLOSSOFSYNC_OUT   => gtx1_rx_lossofsync_o,
        GTX1_GTXRXRESET_IN      => gtx1_rx_reset_i,
        GTX1_MGTREFCLKRX_IN     => gtx_refclk_r,
        GTX1_PLLRXRESET_IN      => gtx1_pll_rx_reset_i,
        GTX1_RXPLLLKDET_OUT     => gtx1_rx_pll_locked_o,
        GTX1_RXRESETDONE_OUT    => gtx1_rx_reset_done_o,
        GTX1_TXCHARISK_IN       => gtx1_tx_kchar_i,
        GTX1_TXDATA_IN          => gtx1_tx_data_i,
        GTX1_TXOUTCLK_OUT       => gtx1_txoutclk_r,
        GTX1_TXUSRCLK2_IN       => gtx_usrclk2_r,   
        GTX1_TXN_OUT            => gtx1_tx_n_o, 
        GTX1_TXP_OUT            => gtx1_tx_p_o,
        GTX1_GTXTXRESET_IN      => gtx1_tx_reset_i, 
        GTX1_TXRESETDONE_OUT    => gtx1_tx_reset_done_o, 
        GTX1_TXENPRBSTST_IN     => tied_to_ground,
        GTX1_TXPRBSFORCEERR_IN  => tied_to_ground(0)
    );

end Behavioral;
