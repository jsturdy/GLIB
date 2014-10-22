library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity link_tracking is
port(
    gtx_clk_i       : in std_logic;
    ipb_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    rx_error_i      : in std_logic;
    rx_kchar_i      : in std_logic_vector(1 downto 0);
    rx_data_i       : in std_logic_vector(15 downto 0);
    
    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0);
   
	ipb_vfat2_i     : in ipb_wbus;
	ipb_vfat2_o     : out ipb_rbus;
    
	ipb_tracking_i  : in ipb_wbus;
	ipb_tracking_o  : out ipb_rbus;
    
    priorities_i    : in std_logic_vector(6 downto 0)
);
end link_tracking;

architecture Behavioral of link_tracking is
         
    -- VFAT2 signals
    
    signal vfat2_tx_en      : std_logic := '0';
    signal vfat2_tx_ack     : std_logic := '0';
    signal vfat2_tx_data    : std_logic_vector(31 downto 0) := (others => '0');
    signal vfat2_rx_en      : std_logic := '0';
    signal vfat2_rx_data    : std_logic_vector(31 downto 0) := (others => '0');
    
    -- Tracking signals
    
    signal tracking_rx_en   : std_logic := '0';
    signal tracking_rx_data : std_logic_vector(15 downto 0) := (others => '0');
    
begin

    gtx_rx_mux_inst : entity work.gtx_rx_mux
    port map(
        gtx_clk_i       => gtx_clk_i,
        reset_i         => reset_i,
        vfat2_en_o      => vfat2_rx_en,
        vfat2_data_o    => vfat2_rx_data,
        rx_kchar_i      => rx_kchar_i,
        rx_data_i       => rx_data_i
    );   
    
    gtx_tx_mux_inst : entity work.gtx_tx_mux
    port map(
        gtx_clk_i       => gtx_clk_i,
        reset_i         => reset_i,
        vfat2_en_i      => vfat2_tx_en,
        vfat2_data_i    => vfat2_tx_data,
        tx_kchar_o      => tx_kchar_o,
        tx_data_o       => tx_data_o,
        priorities_i    => priorities_i
    );  
    
    ipb_vfat2_inst : entity work.ipb_vfat2
    port map(
        ipb_clk_i       => ipb_clk_i,
        gtx_clk_i       => gtx_clk_i,    
        reset_i         => reset_i,
        ipb_mosi_i      => ipb_vfat2_i,
        ipb_miso_o      => ipb_vfat2_o,
        tx_en_o         => vfat2_tx_en,
        tx_data_o       => vfat2_tx_data,
        rx_en_i         => vfat2_rx_en,
        rx_data_i       => vfat2_rx_data
    );
    
    ipb_tracking_inst : entity work.ipb_tracking
    port map(
        ipb_clk_i   => ipb_clk_i,
        gtx_clk_i   => gtx_clk_i,
        reset_i     => reset_i,
        ipb_mosi_i  => ipb_tracking_i,
        ipb_miso_o  => ipb_tracking_o,
        rx_en_i     => tracking_rx_en,
        rx_data_i   => tracking_rx_data
    );

end Behavioral;

