--
-- This entity receives signals from IPBus to create a fast signal pulse (LV1A, CalPulse, BC0, resets, ...)
-- and outputs strobes at 160 MHz for the GTX TX modules.
--
-- This is not the ideal way to send those commands (they should come from the AMC13), but it is a good thing 
-- to be able to send them anyway using IPBus.
--
--
-- Ways to improve: -
--
-- Modifications needed for V2: none
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_fast_signals is
port(

    -- Clocks and reset
	ipb_clk_i       : in std_logic;
	gtx_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    -- Fast signals to the GTX
    fast_signals_o  : out std_logic_vector(6 downto 0)
    
);
end ipb_fast_signals;

architecture rtl of ipb_fast_signals is

    -- IPBus acknowledgment signals
	signal ipb_ack          : std_logic := '0';
    
    -- T1 signals
    signal fast_signals : std_logic_vector(6 downto 0) := (others => '0');
    
begin

    ----------------------------------
    -- Clock bridges                --
    ----------------------------------
    
    clock_bridge_strobes_inst : entity work.clock_bridge_strobes
    port map(
        reset_i => reset_i,
        m_clk_i => ipb_clk_i,
        m_en_i  => fast_signals,
        s_clk_i => gtx_clk_i,
        s_en_o  => fast_signals_o
    );

    ----------------------------------
    -- IPBus -> GTX                 --
    ----------------------------------

    process(ipb_clk_i)

        variable last_ipb_strobe    : std_logic := '0';
        
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                fast_signals <= (others => '0');
                
                last_ipb_strobe := '0';
                
            else 
                
                -- Incoming data from IPBus controller
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                   
                    if (ipb_mosi_i.ipb_addr(2 downto 0) = "000") then
                        fast_signals <= (0 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "001") then
                        fast_signals <= (1 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "010") then
                        fast_signals <= (2 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "011") then
                        fast_signals <= (3 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "100") then
                        fast_signals <= (4 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "101") then
                        fast_signals <= (5 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "110") then
                        fast_signals <= (6 => '1', others => '0');
                    else
                        fast_signals <= (others => '0');
                    end if;
                    
                    ipb_ack <= '1';

                else
                    
                    -- Reset strobes
                    fast_signals <= (others => '0');
                    
                    ipb_ack <= '0';
                        
                end if;  
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
            
            end if;
        
        end if;
        
    end process;
    
    ----------------------------------
    -- IPBus signals                --
    ----------------------------------
    
    ipb_miso_o.ipb_err <= '0';
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack;
    ipb_miso_o.ipb_rdata <= (others => '0');
                            
end rtl;