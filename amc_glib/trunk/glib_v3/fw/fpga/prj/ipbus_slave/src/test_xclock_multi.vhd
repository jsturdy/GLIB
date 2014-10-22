library ieee;
use ieee.std_logic_1164.all;

library work;
 
entity test_xclock_strobes is
end test_xclock_strobes;
 
architecture behavior of test_xclock_strobes is 

    signal reset_i          : std_logic := '0';
    signal m_clk_i          : std_logic := '0';
    signal m_en_i           : std_logic_vector(5 downto 0) := (others => '0');
    signal s_clk_i          : std_logic := '0';
    signal s_en_o           : std_logic_vector(5 downto 0) := (others => '0');

    constant m_clk_period   : time := 10 ns;
    constant s_clk_period   : time := 14 ns;
 
begin
 
    -- Instantiate the Unit Under Test (UUT)
    uut : entity work.clock_bridge_strobes 
    port map(
        reset_i     => reset_i,
        m_clk_i     => m_clk_i,
        m_en_i      => m_en_i,
        s_clk_i     => s_clk_i,
        s_en_o      => s_en_o
    );

    -- Clock process definitions
    m_clk_process :process
    begin
        m_clk_i <= '0';
        wait for m_clk_period / 2;
        m_clk_i <= '1';
        wait for m_clk_period / 2;
    end process;
    
    s_clk_process :process
    begin
        s_clk_i <= '0';
        wait for s_clk_period / 2;
        s_clk_i <= '1';
        wait for s_clk_period / 2;
    end process;
 

    -- Stimulus process
    stim_proc: process
    begin	
        
        reset_i <= '1';
        
        wait for 100 ns;
        
        reset_i <= '0';	

        wait for m_clk_period * 10;
        
        
        wait for m_clk_period;
        m_en_i(0) <= '1';
        wait for m_clk_period;
        m_en_i(0) <= '0';
        
        wait for m_clk_period * 2;
        m_en_i(3) <= '1';
        m_en_i(5) <= '1';
        wait for m_clk_period;
        m_en_i(3) <= '0';
        m_en_i(5) <= '0';
        
        wait for m_clk_period * 4;
        m_en_i(2) <= '1';
        wait for m_clk_period;
        m_en_i(2) <= '0';
        
    wait;
    end process;

end;
