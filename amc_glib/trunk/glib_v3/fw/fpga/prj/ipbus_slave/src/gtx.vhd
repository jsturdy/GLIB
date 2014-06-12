library ieee;
use ieee.std_logic_1164.all;

--! xilinx packages
library unisim;
use unisim.vcomponents.all;

library work;

entity gtx_wrapper is
port(
    gtx_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    rx_error_o      : out std_logic;
    rx_kchar_o      : out std_logic_vector(1 downto 0);
    rx_data_o       : out std_logic_vector(15 downto 0);
    rx_n_i          : in std_logic;
    rx_p_i          : in std_logic;
    
    tx_kchar_i      : in std_logic_vector(1 downto 0);
    tx_data_i       : in std_logic_vector(15 downto 0);
    tx_n_o          : out std_logic;
    tx_p_o          : out std_logic
);
end gtx_wrapper;

architecture Behavioral of gtx_wrapper is
   
    signal rx_disperr       : std_logic_vector(1 downto 0) := (others => '0'); 
    signal rx_notintable    : std_logic_vector(1 downto 0) := (others => '0');
    
    signal gtx0_mgtrefclkrx : std_logic_vector(1 downto 0) := (others => '0'); 
    
begin

    rx_error_o <= rx_disperr(0) or rx_disperr(1) or rx_notintable(0) or rx_notintable(1);

    gtx0_mgtrefclkrx <= '0' & gtx_clk_i;

    high_speed_gtx0_inst : entity work.high_speed_gtx
    generic map(
        GTX_SIM_GTXRESET_SPEEDUP    => 1,
        GTX_TX_CLK_SOURCE           => "RXPLL",
        GTX_POWER_SAVE              => "0000110100"
    )
    port map(
        RXCHARISK_OUT       => rx_kchar_o,
        RXDISPERR_OUT       => rx_disperr,
        RXNOTINTABLE_OUT    => rx_notintable,
        RXBYTEISALIGNED_OUT => open,
        RXCOMMADET_OUT      => open,
        RXENMCOMMAALIGN_IN  => '1',
        RXENPCOMMAALIGN_IN  => '1',
        RXDATA_OUT          => rx_data_o,
        RXRECCLK_OUT        => open,
        RXUSRCLK2_IN        => gtx_clk_i,
        RXN_IN              => rx_n_i,
        RXP_IN              => rx_p_i,
        RXLOSSOFSYNC_OUT    => open,
        GTXRXRESET_IN       => reset_i,
        MGTREFCLKRX_IN      => gtx0_mgtrefclkrx,
        PLLRXRESET_IN       => reset_i,
        RXPLLLKDET_OUT      => open,
        RXRESETDONE_OUT     => open,
        TXCHARISK_IN        => tx_kchar_i,
        TXDATA_IN           => tx_data_i,
        TXOUTCLK_OUT        => open,
        TXUSRCLK2_IN        => gtx_clk_i,
        TXN_OUT             => tx_n_o,
        TXP_OUT             => tx_p_o,
        GTXTXRESET_IN       => reset_i,
        MGTREFCLKTX_IN      => gtx0_mgtrefclkrx,
        PLLTXRESET_IN       => reset_i,
        TXPLLLKDET_OUT      => open,
        TXRESETDONE_OUT     => open
    );   
    
end Behavioral;
