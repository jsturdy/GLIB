library ieee;
use ieee.std_logic_1164.all;

entity t1_handler is
port(

    fabric_clk_i    : in std_logic;
    vfat2_clk_i     : in std_logic;
    reset_i         : in std_logic;
    
    lv1a_i          : in std_logic;
    calpulse_i      : in std_logic;
    resync_i        : in std_logic;
    bc0_i           : in std_logic;
    
    t1_o            : out std_logic
    
);
end t1_handler;

architecture Behavioral of t1_handler is

    signal lv1a     : std_logic := '0';
    signal calpulse : std_logic := '0';
    signal resync   : std_logic := '0';
    signal bc0      : std_logic := '0';

begin

    lv1a_inst : entity work.clock_bridge_strobes port map(reset_i => reset_i, m_clk_i => fabric_clk_i, m_en_i => lv1a_i, s_clk_i => vfat2_clk_i, s_en_o => lv1a);
    calpulse_inst : entity work.clock_bridge_strobes port map(reset_i => reset_i, m_clk_i => fabric_clk_i, m_en_i => calpulse_i, s_clk_i => vfat2_clk_i, s_en_o => calpulse);
    resync_inst : entity work.clock_bridge_strobes port map(reset_i => reset_i, m_clk_i => fabric_clk_i, m_en_i => resync_i, s_clk_i => vfat2_clk_i, s_en_o => resync);
    bc0_inst : entity work.clock_bridge_strobes port map(reset_i => reset_i, m_clk_i => fabric_clk_i, m_en_i => bc0_i, s_clk_i => vfat2_clk_i, s_en_o => bc0);

    t1_encoder_inst : entity work.t1_encoder
    port map(
        vfat2_clk_i => vfat2_clk_i,
        reset_i     => reset_i,
        lv1a_i      => lv1a,
        calpulse_i  => calpulse,
        resync_i    => resync,
        bc0_i       => bc0,  
        t1_o        => t1_o
    );    
    
end Behavioral;

