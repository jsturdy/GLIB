library ieee;
use ieee.std_logic_1164.all;

library work; 
 
entity xclock_test is
end xclock_test;
 
architecture behavior of xclock_test is 
 
    --inputs
    signal clk_a : std_logic := '0';
    signal clk_b : std_logic := '0';
    signal reset : std_logic := '0';
    signal en_a : std_logic := '0';
    signal data_a : std_logic_vector(31 downto 0) := (others => '0');

    --outputs
    signal en_b : std_logic;
    signal failed : std_logic;
    signal data_b : std_logic_vector(31 downto 0);

    -- clock period definitions
    constant clk_a_period : time := 3 ns;
    constant clk_b_period : time := 10 ns;
 
begin

    -- stimulus process
    stim_proc: process
    begin		
        reset <= '1';
        wait for 100 ns;
        reset <= '0';

        wait for clk_a_period * 20;
        
        en_a <= '1';
        data_a <= x"AAAAAAAA";
        wait for clk_a_period;
        data_a <= x"BBBBBBBB";
        wait for clk_a_period;
        data_a <= x"CCCCCCCC";
        wait for clk_a_period;
        data_a <= x"DDDDDDDD";
        wait for clk_a_period;
        data_a <= x"EEEEEEEE";
        wait for clk_a_period;
        data_a <= x"FFFFFFFF";
        wait for clk_a_period;
        
        en_a <= '0';

        wait;
    end process;
   
    -- instantiate the unit under test (uut)
    uut: entity work.xclock 
    port map (
        reset_i => reset,
        clk_a_i => clk_a,
        clk_b_i => clk_b,
        en_a_i => en_a,
        en_b_o => en_b,
        failed_o => failed,
        data_a_i => data_a,
        data_b_o => data_b
    );

    -- clock process definitions
    clk_a_process :process
    begin
        clk_a <= '0';
        wait for clk_a_period / 2;
        clk_a <= '1';
        wait for clk_a_period / 2;
    end process;
    
    clk_b_process :process
    begin
        clk_b <= '0';
        wait for clk_b_period / 2;
        clk_b <= '1';
        wait for clk_b_period / 2;
    end process;

end;
