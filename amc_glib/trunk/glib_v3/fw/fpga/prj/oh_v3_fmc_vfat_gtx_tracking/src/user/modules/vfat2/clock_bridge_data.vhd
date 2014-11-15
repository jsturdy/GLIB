--
-- This entity takes care of crossing clock-domains for one strobe and a data bus
--

library ieee;
use ieee.std_logic_1164.all;

entity clock_bridge_data is
port(
    reset_i     : in std_logic;
    
    m_clk_i     : in std_logic;
    m_en_i      : in std_logic;
    m_data_i    : in std_logic_vector;
    
    s_clk_i     : in std_logic;
    s_en_o      : out std_logic;
    s_data_o    : out std_logic_vector
);
end clock_bridge_data;

architecture behavioral of clock_bridge_data is

    -- Status registers
    signal in_status    : std_logic := '0';
    signal out_status   : std_logic := '0';
    
begin

    -- Input clock
    process(m_clk_i)
    begin
        -- Work only at the rising edge
        if (rising_edge(m_clk_i)) then
            -- Reset signal
            if (reset_i = '1') then
                in_status <= '0';
            else
                -- Detect an input strobe
                if (m_en_i = '1') then
                    -- Check if the module is busy
                    if (in_status = out_status) then
                        -- If not, change the status
                        in_status <= not in_status;
                        -- Set the data
                        s_data_o <= m_data_i;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- Output clock
    process(s_clk_i)
    begin
        -- Work only at the rising edge
        if (rising_edge(s_clk_i)) then
            -- Reset signal
            if (reset_i = '1') then
                s_en_o <= '0';
                out_status <= '0';
            else   
                -- Check if a strobe is waiting
                if (in_status /= out_status) then
                    -- If so, set an output strobe
                    s_en_o <= '1';
                    -- Change the status
                    out_status <= not out_status;
                -- Otherwhise
                else
                    -- reset the strobe
                    s_en_o <= '0';
                end if;
            end if;
        end if;
    end process;    

end behavioral;