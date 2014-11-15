library ieee;
use ieee.std_logic_1164.all;

entity t1_handler is
port(

    gtp_clk_i   : in std_logic;
    vfat2_clk_i : in std_logic;
    reset_i     : in std_logic;
    
    lv1a_i      : in std_logic;
    calpulse_i  : in std_logic;
    resync_i    : in std_logic;
    bc0_i       : in std_logic;
    
    t1_o        : out std_logic
    
);
end t1_handler;

architecture Behavioral of t1_handler is

    signal fast_signals : std_logic_vector(3 downto 0) := (others => '0');
    signal slow_signals : std_logic_vector(3 downto 0) := (others => '0');

begin
    
    fast_signals <= lv1a_i & calpulse_i & resync_i & bc0_i;

    clock_bridge_strobes_inst : entity work.clock_bridge_strobes
    port map(
        reset_i => reset_i,
        m_clk_i => gtp_clk_i,
        m_en_i  => fast_signals,
        s_clk_i => vfat2_clk_i,
        s_en_o  => slow_signals
    );

    t1_encoder_inst : entity work.t1_encoder
    port map(
        vfat2_clk_i => vfat2_clk_i,
        reset_i     => reset_i,
        lv1a_i      => slow_signals(3),
        calpulse_i  => slow_signals(2),
        resync_i    => slow_signals(1),
        bc0_i       => slow_signals(0),  
        t1_o        => t1_o
    );    
    
end Behavioral;

