library ieee;
use ieee.std_logic_1164.all;

--! xilinx packages
library unisim;
use unisim.vcomponents.all;

library work;

entity gtx_wrapper is
port(
    clk         : in std_logic;
    rx_ref_clk  : out std_logic;
    tx_ref_clk  : out std_logic;
    reset       : in std_logic;
    rx_error_o  : out std_logic;
    rx_valid_o  : out std_logic;
    rx_data_o   : out std_logic_vector(15 downto 0);
    rx_n_i      : in std_logic;
    rx_p_i      : in std_logic;
    tx_strobe_i : in std_logic;
    tx_kchar_i  : in std_logic_vector(1 downto 0);
    tx_data_i   : in std_logic_vector(15 downto 0);
    tx_n_o      : out std_logic;
    tx_p_o      : out std_logic
);
end gtx_wrapper;

architecture Behavioral of gtx_wrapper is
   
    signal rx_disperr : std_logic_vector(1 downto 0);
    signal rx_notintable : std_logic_vector(1 downto 0);
    signal rx_kchar : std_logic_vector(1 downto 0);
   
    signal tx_data : std_logic_vector(15 downto 0);
    signal tx_kchar : std_logic_vector(1 downto 0);
    
    signal  gtx0_mgtrefclkrx_i : std_logic_vector(1 downto 0);
    signal gtx0_txoutclk : std_logic;
    signal gtx0_txusrclk2 : std_logic;
    
begin

    rx_error_o <= rx_disperr(0) or rx_disperr(1) or rx_notintable(0) or rx_notintable(1);
    rx_valid_o <= rx_kchar(0) or rx_kchar(1);
    
    tx_data <= tx_data_i when tx_strobe_i = '1' else x"00BC";
    tx_kchar <= tx_kchar_i when tx_strobe_i = '1' else "01";
    
    tx_ref_clk <= gtx0_txoutclk;

    gtx0_mgtrefclkrx_i <= ('0' & clk);
    
    txoutclk_bufg0_inst : bufg
    port map(
        I   => gtx0_txoutclk,
        O   => gtx0_txusrclk2
    );    
    
    high_speed_gtx0_inst : entity work.high_speed_gtx
    generic map(
        GTX_SIM_GTXRESET_SPEEDUP    => 1,
        GTX_TX_CLK_SOURCE           => "RXPLL",
        GTX_POWER_SAVE              => "0000110100"
    )
    port map(
        LOOPBACK_IN         => "000",
        RXCHARISK_OUT       => rx_kchar,
        RXDISPERR_OUT       => rx_disperr,
        RXNOTINTABLE_OUT    => rx_notintable,
        RXCOMMADET_OUT      => open,
        RXENMCOMMAALIGN_IN  => '0',
        RXENPCOMMAALIGN_IN  => '0',
        PRBSCNTRESET_IN     => reset,
        RXENPRBSTST_IN      => "000",
        RXPRBSERR_OUT       => open,
        RXDATA_OUT          => rx_data_o,
        RXRECCLK_OUT        => rx_ref_clk,
        RXUSRCLK2_IN        => gtx0_txusrclk2,
        RXN_IN              => rx_n_i,
        RXP_IN              => rx_p_i,
        RXLOSSOFSYNC_OUT    => open,
        GTXRXRESET_IN       => reset,
        MGTREFCLKRX_IN      => gtx0_mgtrefclkrx_i,
        PLLRXRESET_IN       => reset,
        RXPLLLKDET_OUT      => open,
        RXRESETDONE_OUT     => open,
        TXCHARISK_IN        => tx_kchar,
        TXDATA_IN           => tx_data,
        TXOUTCLK_OUT        => gtx0_txoutclk,
        TXUSRCLK2_IN        => gtx0_txusrclk2,
        TXN_OUT             => tx_n_o,
        TXP_OUT             => tx_p_o,
        GTXTXRESET_IN       => reset,
        MGTREFCLKTX_IN      => gtx0_mgtrefclkrx_i,
        PLLTXRESET_IN       => reset,
        TXPLLLKDET_OUT      => open,
        TXRESETDONE_OUT     => open,
        TXENPRBSTST_IN      => "000",
        TXPRBSFORCEERR_IN   => '0'
    );   

end Behavioral;
