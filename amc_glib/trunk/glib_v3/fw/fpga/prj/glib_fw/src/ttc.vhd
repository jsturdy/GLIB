library ieee;
use ieee.std_logic_1164.all;

entity ttc is
port(
    ttc_clk_p_i     : in std_logic;
    ttc_clk_n_i     : in std_logic;
    ttc_data_p_i    : in std_logic;
    ttc_data_n_i    : in std_logic;

    gtx_clk_i       : in std_logic;
    ttc_trigger_o   : out std_logic;
    l1_led_o        : out std_logic;
    bc0_led_o       : out std_logic
);
end ttc;

architecture Behavioral of ttc is

    signal bcntres              : std_logic := '0';
    signal evcntres             : std_logic := '0';
    signal sinerrstr            : std_logic := '0';
    signal dberrstr             : std_logic := '0';
    signal brcst                : std_logic_vector(5 downto 0) := (others => '0');
    signal brcststr             : std_logic := '0';
    signal l1accept	            : std_logic := '0';
    signal tcc_clock            : std_logic := '0';
    
begin

    --================================--
    -- TTC/TTT signal handling 	
    -- from ngFEC_logic.vhd (HCAL)
    --================================--

    amc13_inst : entity work.amc13_top
    port map(
        ttc_clk_p  => ttc_clk_p_i,
        ttc_clk_n  => ttc_clk_n_i,
        ttc_data_p => ttc_data_p_i,
        ttc_data_n => ttc_data_n_i,
        ttc_clk    => tcc_clock,
        ttcready   => open,
        l1accept   => l1accept,
        bcntres    => bcntres,
        evcntres   => evcntres, 
        sinerrstr  => sinerrstr,
        dberrstr   => dberrstr,
        brcststr   => brcststr,
        brcst      => brcst
    );    
    
    process(tcc_clock)
        variable i : integer := 0;
    begin
        if (rising_edge(tcc_clock)) then
            if (i < 2_500_000) then
                bc0_led_o <= '0';
            else
                bc0_led_o <= '1';
            end if;
            
            if (i = 5_000_000) then
                i := 0;
            else
                i := i + 1;
            end if;
        end if;
    end process;
    
    process(tcc_clock)
        variable i : integer := 0;
    begin
        if (rising_edge(tcc_clock)) then
            if (i > 0) then
                l1_led_o <= '1';
            else
                l1_led_o <= '0';
            end if;
            
            if (l1accept = '1') then
                i := 400;
            elsif (i > 0) then
                i := i - 1;
            else
                i := 0;
            end if;
        end if;
    end process;
        
    clock_bridge_trigger_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => '0',
        m_clk_i     => tcc_clock,
        m_en_i      => l1accept,
        s_clk_i     => gtx_clk_i,
        s_en_o      => ttc_trigger_o
    );    

end Behavioral;

