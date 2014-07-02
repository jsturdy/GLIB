library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_optohybrid_start_wrapper is
port(

    -- Clocks and reset
	ipb_clk_i   : in std_logic;
	gtx_clk_i   : in std_logic;
	reset_i     : in std_logic;
    
    -- IPBus data
	ipb_mosi_i  : in ipb_wbus;
	ipb_miso_o  : out ipb_rbus;
    
    -- Data to the GTX
    tx_en_o     : out std_logic
    
);
end ipb_optohybrid_start_wrapper;

architecture rtl of ipb_optohybrid_start_wrapper is

    signal tx_en        : std_logic;
    signal tx_data      : std_logic_vector(31 downto 0);
    signal tx_failed    : std_logic;
    signal rx_en        : std_logic;
    signal rx_data      : std_logic_vector(31 downto 0);

begin	

    ipb_optohybrid_start_inst : entity work.ipb_optohybrid_start
    port map(
        ipb_clk_i   => ipb_clk_i,
        reset_i     => reset_i,
        ipb_mosi_i  => ipb_mosi_i,
        ipb_miso_o  => ipb_miso_o,
        tx_en_o     => tx_en
    );  

    xclock_tx : entity work.xclock_en
    port map(
        reset_i     => reset_i,
        clk_a_i     => ipb_clk_i,
        clk_b_i     => gtx_clk_i,
        en_a_i      => tx_en,
        en_b_o      => tx_en_o,
        failed_o    => open
    );      
                                
end rtl;