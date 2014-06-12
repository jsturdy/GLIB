library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_vfat2 is
port(

    -- Clocks and reset
	ipb_clk_i   : in std_logic;
	gtx_clk_i   : in std_logic;
	reset_i     : in std_logic;
    
    -- IPBus data
	ipb_mosi_i  : in ipb_wbus;
	ipb_miso_o  : out ipb_rbus;
    
    -- Data to the GTX
    tx_en_o     : out std_logic;
    tx_data_o   : out std_logic_vector(31 downto 0);
    
    -- Data from the GTX
    rx_en_i     : in std_logic;
    rx_data_i   : in std_logic_vector(31 downto 0)
    
);
end ipb_vfat2;

architecture rtl of ipb_vfat2 is

    signal tx_en        : std_logic;
    signal tx_data      : std_logic_vector(31 downto 0);
    signal tx_failed    : std_logic;
    signal rx_en        : std_logic;
    signal rx_data      : std_logic_vector(31 downto 0);

begin	

    ipb_vfat2_slow_clock_inst : entity work.ipb_vfat2_slow_clock
    port map(
        ipb_clk_i   => ipb_clk_i,
        reset_i     => reset_i,
        ipb_mosi_i  => ipb_mosi_i,
        ipb_miso_o  => ipb_miso_o,
        tx_en_o     => tx_en,
        tx_failed_i => tx_failed,
        tx_data_o   => tx_data,
        rx_en_i     => rx_en,
        rx_data_i   => rx_data
    );  

    xclock_tx : entity work.xclock
    port map(
        reset_i     => reset_i,
        clk_a_i     => ipb_clk_i,
        clk_b_i     => gtx_clk_i,
        en_a_i      => tx_en,
        en_b_o      => tx_en_o,
        failed_o    => tx_failed,
        data_a_i    => tx_data,
        data_b_o    => tx_data_o
    );  

    xclock_rx : entity work.xclock
    port map(
        reset_i     => reset_i,
        clk_a_i     => gtx_clk_i,
        clk_b_i     => ipb_clk_i,
        en_a_i      => rx_en_i,
        en_b_o      => rx_en,
        failed_o    => open,
        data_a_i    => rx_data_i,
        data_b_o    => rx_data
    );        
                                
end rtl;