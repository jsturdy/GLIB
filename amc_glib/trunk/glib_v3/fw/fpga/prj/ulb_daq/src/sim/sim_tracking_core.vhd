library ieee;
use ieee.std_logic_1164.all;
 
library work; 
 
entity sim_tracking_core is
end sim_tracking_core;
 
architecture behavior of sim_tracking_core is 

   --inputs
   signal vfat2_clk_i           : std_logic := '0';
   signal gtp_clk_i             : std_logic := '0';
   signal reset_i               : std_logic := '0';
   signal vfat2_dvalid_i        : std_logic_vector(1 downto 0) := (others => '0');
   signal vfat2_data_0_i        : std_logic := '0';
   signal vfat2_data_1_i        : std_logic := '0';
   signal vfat2_data_2_i        : std_logic := '0';
   signal vfat2_data_3_i        : std_logic := '0';
   signal vfat2_data_4_i        : std_logic := '0';
   signal vfat2_data_5_i        : std_logic := '0';
   signal vfat2_data_6_i        : std_logic := '0';
   signal vfat2_data_7_i        : std_logic := '0';
   signal tx_done_i             : std_logic := '0';

 	--outputs
   signal tx_ready_o            : std_logic := '0';
   signal tx_data_o             : std_logic_vector(191 downto 0):= (others => '0');
    
   constant vfat2_clk_period    : time := 25 ns;
   constant gtp_clk_period      : time := 6.25 ns;
 
begin

    uut : entity work.tracking_core
    port map(
        gtp_clk_i       => gtp_clk_i,
        vfat2_clk_i     => vfat2_clk_i,
        reset_i         => reset_i,
        tx_ready_o      => tx_ready_o,
        tx_done_i       => '1',
        tx_data_o       => tx_data_o,
        vfat2_dvalid_i  => vfat2_dvalid_i,
        vfat2_data_0_i  => vfat2_data_0_i,
        vfat2_data_1_i  => vfat2_data_1_i,
        vfat2_data_2_i  => vfat2_data_2_i,
        vfat2_data_3_i  => vfat2_data_3_i,
        vfat2_data_4_i  => vfat2_data_4_i,
        vfat2_data_5_i  => vfat2_data_5_i,
        vfat2_data_6_i  => vfat2_data_6_i,
        vfat2_data_7_i  => vfat2_data_7_i
    );

    -- clock process definitions
    vfat2_clk_process :process
    begin
        vfat2_clk_i <= '0';
        wait for vfat2_clk_period / 2;
        vfat2_clk_i <= '1';
        wait for vfat2_clk_period / 2;
    end process;

    -- clock process definitions
    gtp_clk_process :process
    begin
        gtp_clk_i <= '0';
        wait for gtp_clk_period / 2;
        gtp_clk_i <= '1';
        wait for gtp_clk_period / 2;
    end process;
 
    -- stimulus process
    stim_proc: process
    begin		
        reset_i <= '1';
        wait for 100 ns;
        reset_i <= '0';        

        wait for vfat2_clk_period * 10;
        
        vfat2_dvalid_i <= "11";
        vfat2_data_0_i <= '1';
        wait for vfat2_clk_period * 1;
        vfat2_data_0_i <= '0';
        wait for vfat2_clk_period * 1;
        vfat2_data_0_i <= '1';
        wait for vfat2_clk_period * 1;
        vfat2_data_0_i <= '0';
        wait for vfat2_clk_period * 1;
        vfat2_data_0_i <= '1';
        wait for vfat2_clk_period * 188;
        vfat2_dvalid_i <= "00";

        wait;
    end process;

end;
