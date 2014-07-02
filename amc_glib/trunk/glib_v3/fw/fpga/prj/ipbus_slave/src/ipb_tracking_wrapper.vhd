library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_tracking_wrapper is
port(

    -- Clocks and reset
	ipb_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    -- Data from the GTX
    gtx_clk_i       : in std_logic;
    rx_en_i         : in std_logic;
    rx_data_i       : in std_logic_vector(191 downto 0)
    
);
end ipb_tracking_wrapper;

architecture rtl of ipb_tracking_wrapper is
   
   signal rd_en     : std_logic;
   signal data      : std_logic_vector(191 downto 0);
   signal valid     : std_logic;
   signal underflow : std_logic;
   
begin	

    tracking_data_fifo_inst : entity work.tracking_data_fifo
    port map(
        rst         => reset_i,
        wr_clk      => gtx_clk_i,
        rd_clk      => ipb_clk_i,
        din         => rx_data_i,
        wr_en       => rx_en_i,
        rd_en       => rd_en,
        dout        => data,
        full        => open,
        empty       => open,
        valid       => valid,
        underflow   => underflow
    );

    ipb_tracking_inst : entity work.ipb_tracking
    port map(
        ipb_clk_i   => ipb_clk_i,
        reset_i     => reset_i,
        ipb_mosi_i  => ipb_mosi_i,
        ipb_miso_o  => ipb_miso_o,
        rd_en_o     => rd_en,
        data_i      => data,
        valid_i     => valid,
        underflow_i => underflow
    );    
                            
end rtl;