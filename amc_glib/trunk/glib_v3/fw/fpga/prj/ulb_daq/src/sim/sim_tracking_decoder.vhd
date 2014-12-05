library ieee;
use ieee.std_logic_1164.all;
 
library work; 
 
entity sim_tracking_decoder is
end sim_tracking_decoder;
 
architecture behavior of sim_tracking_decoder is 

    --inputs
    signal vfat2_clk_i          : std_logic := '0';
    signal reset_i              : std_logic := '0';
    signal en_i                 : std_logic := '0';
    signal data_i               : std_logic := '0';

    --outputs
    signal en_o                 : std_logic;
    signal data_o               : std_logic_vector(191 downto 0);

    constant vfat2_clk_period   : time := 25 ns;
 
begin
 
    uut : entity work.tracking_decoder 
    port map(
        vfat2_clk_i => vfat2_clk_i,
        reset_i     => reset_i,
        en_i        => en_i,
        data_i      => data_i,
        en_o        => en_o,
        data_o      => data_o
    );

    -- clock process definitions
    vfat2_clk_process :process
    begin
        vfat2_clk_i <= '0';
        wait for vfat2_clk_period / 2;
        vfat2_clk_i <= '1';
        wait for vfat2_clk_period / 2;
    end process;
 
    -- stimulus process
    stim_proc: process
    begin		
        reset_i <= '1';
        wait for 100 ns;
        reset_i <= '0';        

        wait for vfat2_clk_period * 10;
        
        en_i <= '1';
        data_i <= '1';
        wait for vfat2_clk_period * 1;
        data_i <= '0';
        wait for vfat2_clk_period * 1;
        data_i <= '1';
        wait for vfat2_clk_period * 1;
        data_i <= '0';
        wait for vfat2_clk_period * 1;
        data_i <= '1';
        wait for vfat2_clk_period * 188;
        en_i <= '0';

        wait;
    end process;

end;
