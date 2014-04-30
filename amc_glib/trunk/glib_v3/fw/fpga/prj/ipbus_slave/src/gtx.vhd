library ieee;
use ieee.std_logic_1164.all;

library work;

entity gtx_wrapper_li is
port(
    clk160MHz       : in std_logic;
    reset           : in std_logic;
    rx_valid_o      : out std_logic;
    rx_data_o       : out std_logic_vector(15 downto 0);
    rx_n_i          : in std_logic;
    rx_p_i          : in std_logic;
    tx_strobe_i     : in std_logic;
    tx_data_i       : in std_logic_vector(15 downto 0);
    tx_n_o          : out std_logic;
    tx_p_o          : out std_logic
);
end gtx_wrapper_li;

architecture Behavioral of gtx_wrapper_li is
    
    signal tx_data : std_logic_vector(15 downto 0);    

    signal tied_to_ground           : std_logic_vector(2 downto 0);
    signal tied_to_vcc              : std_logic_vector(2 downto 0);
    
begin

	--===========================================--
    -- Mapping
	--===========================================--
    tied_to_ground <= "000";
    tied_to_vcc <= "111";  
  
    tx_data(15 downto 0) <= tx_data_i(15 downto 0) when tx_strobe_i = '1' else x"00BC";   

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
        GTX0_RXCHARISK_OUT      => open,                    -- High if the data is a control character
                                                            -- Bit 0 is for 7:0 data
                                                            -- Bit 1 is for 15:8 data
        GTX0_RXDISPERR_OUT      => open,                    -- High if there is a disparity error
                                                            -- Bit 0 is for 7:0 data
                                                            -- Bit 1 is for 15:8 data
        GTX0_RXNOTINTABLE_OUT   => open,                    -- High if the character is not in the decoding table
                                                            -- Bit 0 is for 7:0 data
                                                            -- Bit 1 is for 15:8 data
                                                            
        --------------- Receive Ports - Comma Detection and Alignment --------------
        GTX0_RXCOMMADET_OUT     => rx_valid_o,              -- High when a comma is detected
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
        GTX0_RXPRBSERR_OUT      => open,                    -- High when a PRBS error occurs
        
        ------------------- Receive Ports - RX Data Path interface -----------------
        GTX0_RXDATA_OUT         => rx_data_o,               -- Received data
        GTX0_RXRECCLK_OUT       => open,                    -- Recommended fabric clock
        GTX0_RXUSRCLK2_IN       => clk160MHz,               -- Clock to synchronize the FPGA and the RX (must be positive-edge aligned)
        
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        GTX0_RXN_IN             => rx_n_i,                  -- RX_N signal
        GTX0_RXP_IN             => rx_p_i,                  -- RX_P signal
        
        --------------- Receive Ports - RX Loss-of-sync State Machine --------------
        GTX0_RXLOSSOFSYNC_OUT   => open,                    -- State of the internal state machine 
                                                            -- Bit 1 is high if the sync is lost
                                                            -- Bit 0 is high if the system is in the resync state
        
        ------------------------ Receive Ports - RX PLL Ports ----------------------
        GTX0_GTXRXRESET_IN      => reset,                   -- Asserted high and then deasseted to start the RX reset sequence
        GTX0_MGTREFCLKRX_IN     => clk160MHz,               -- Clock for the RX system
        GTX0_PLLRXRESET_IN      => reset,                   -- Reset the PLL (active High)
        GTX0_RXPLLLKDET_OUT     => open,                    -- High when the PLL is locked
        GTX0_RXRESETDONE_OUT    => open,                    -- Goes high when the reset sequence is done
        
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        GTX0_TXCHARISK_IN       => tied_to_ground(1 downto 0),  -- Set high if the TXDATA is a K character
                                                            -- Bit 0 is for 7:0 data
                                                            -- Bit 1 is for 15:8 data
        
        ------------------ Transmit Ports - TX Data Path interface -----------------
        GTX0_TXDATA_IN          => tx_data,                 -- Output data
        GTX0_TXOUTCLK_OUT       => open,                    -- Recommended fabric clock
        GTX0_TXUSRCLK2_IN       => clk160MHz,               -- Clock to synchronize the FPGA and the TX (must be positive-edge aligned)
        
        ---------------- Transmit Ports - TX Driver and OOB signaling --------------
        GTX0_TXN_OUT            => tx_n_o,                  -- TX_N signal
        GTX0_TXP_OUT            => tx_p_o,                  -- TX_P signal
        
        ----------------------- Transmit Ports - TX PLL Ports ----------------------
        GTX0_GTXTXRESET_IN      => reset,                   -- Asserted high and then deasseted to start the TX reset sequence
        GTX0_TXRESETDONE_OUT    => open,                    -- Goes high when the reset sequence is done
        
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
        GTX0_TXPRBSFORCEERR_IN  => tied_to_ground(0)        -- When set high, errors are forced in the PRBS
    );

end Behavioral;
