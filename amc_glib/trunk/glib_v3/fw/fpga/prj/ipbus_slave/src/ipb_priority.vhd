library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_priority is
port(

    -- Clocks and reset
	ipb_clk_i       : in std_logic;
	gtx_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    -- Data to the GTX
    priorities_o    : out std_logic_vector(6 downto 0)
    
);
end ipb_priority;

architecture rtl of ipb_priority is

    -- IPBus acknowledgment signals
	signal ipb_ack          : std_logic := '0';
    
    -- T1 signals
    signal priority_signals : std_logic_vector(6 downto 0) := (others => '0');
    
begin

    ----------------------------------
    -- Clock bridges                --
    ----------------------------------
    
    clock_bridge_lv1a_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => priority_signals(0),    
        s_clk_i     => gtx_clk_i,
        s_en_o      => priorities_o(0)
    ); 
    
    clock_bridge_calpulse_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => priority_signals(1),      
        s_clk_i     => gtx_clk_i,
        s_en_o      => priorities_o(1)
    ); 
    
    clock_bridge_resync_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => priority_signals(2),
        s_clk_i     => gtx_clk_i,
        s_en_o      => priorities_o(2)
    ); 
    
    clock_bridge_bc0_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => priority_signals(3),    
        s_clk_i     => gtx_clk_i,
        s_en_o      => priorities_o(3)
    ); 
    
    clock_bridge_oh_res_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => priority_signals(4),    
        s_clk_i     => gtx_clk_i,
        s_en_o      => priorities_o(4)
    ); 
    
    clock_bridge_v_hres_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => priority_signals(5),    
        s_clk_i     => gtx_clk_i,
        s_en_o      => priorities_o(5)
    ); 
    
    clock_bridge_v_bres_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => priority_signals(6),    
        s_clk_i     => gtx_clk_i,
        s_en_o      => priorities_o(6)
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
                
                priority_signals <= (others => '0');
                
                last_ipb_strobe := '0';
                
            else 
                
                -- Incoming data from IPBus controller
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                   
                    if (ipb_mosi_i.ipb_addr(2 downto 0) = "000") then
                        priority_signals <= (0 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "001") then
                        priority_signals <= (1 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "010") then
                        priority_signals <= (2 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "011") then
                        priority_signals <= (3 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "100") then
                        priority_signals <= (4 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "101") then
                        priority_signals <= (5 => '1', others => '0');
                    elsif (ipb_mosi_i.ipb_addr(2 downto 0) = "110") then
                        priority_signals <= (6 => '1', others => '0');
                    else
                        priority_signals <= (others => '0');
                    end if;
                    
                    ipb_ack <= '1';

                else
                    
                    -- Reset strobes
                    priority_signals <= (others => '0');
                    
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