library ieee;
use ieee.std_logic_1164.all;
 
library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipbus_test is
end ipbus_test;
 
architecture behavior of ipbus_test is   

    signal ipb_clk              : std_logic;
    signal gtx_clk              : std_logic;
    signal reset                : std_logic;
    
    -- IPBus VFAT2 signals
    signal ipb_vfat2_tx_en      : std_logic := '0';
    signal ipb_vfat2_tx_data    : std_logic_vector(31 downto 0);
    signal ipb_vfat2_rx_en      : std_logic := '0';
    signal ipb_vfat2_rx_data    : std_logic_vector(31 downto 0);   
 
	signal ipb_mosi             : ipb_wbus;
	signal ipb_miso             : ipb_rbus; 
 
    constant ipb_clk_period : time := 10 ns;
    constant gtx_clk_period : time := 3 ns;
 
begin
 
    -- stimulus process
    stim_proc: process
    begin		
        reset <= '1';
        ipb_mosi.ipb_addr <= x"AABBCCDD";
        ipb_mosi.ipb_write <= '0';
        ipb_mosi.ipb_wdata <= x"11223344";
        ipb_mosi.ipb_strobe <= '0';
        wait for 100 ns;	
        reset <= '0';
        wait for 20 ns;
        
        ipb_mosi.ipb_strobe <= '1';
        wait until ipb_miso.ipb_err = '1' or ipb_miso.ipb_ack = '1';
        wait for ipb_clk_period;
        ipb_mosi.ipb_strobe <= '0';
       
        wait;
    end process;
    
    ipb_vfat2_inst : entity work.ipb_vfat2
    port map(
        ipb_clk_i   => ipb_clk,
        gtx_clk_i   => gtx_clk,
        reset_i     => reset,
        ipb_mosi_i  => ipb_mosi,
        ipb_miso_o  => ipb_miso,
        tx_en_o     => ipb_vfat2_tx_en,
        tx_data_o   => ipb_vfat2_tx_data,
        rx_en_i     => ipb_vfat2_rx_en,
        rx_data_i   => ipb_vfat2_rx_data  
    );    
    
    ipb_vfat2_rx_en <= ipb_vfat2_tx_en;
    ipb_vfat2_rx_data <= ipb_vfat2_tx_data;
    

    -- clock process definitions
    ipb_clk_process :process
    begin
        ipb_clk <= '0';
        wait for ipb_clk_period / 2;
        ipb_clk <= '1';
        wait for ipb_clk_period / 2;
    end process;
 
    gtx_clk_process :process
    begin
        gtx_clk <= '0';
        wait for gtx_clk_period / 2;
        gtx_clk <= '1';
        wait for gtx_clk_period / 2;
    end process; 

end;
