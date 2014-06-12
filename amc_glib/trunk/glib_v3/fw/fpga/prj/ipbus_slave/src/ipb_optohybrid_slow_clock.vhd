library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_optohybrid_slow_clock is
port(

    -- Clocks and reset
	ipb_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    -- Data to the GTX
    tx_en_o         : out std_logic;
    tx_failed_i     : in std_logic;
    tx_data_o       : out std_logic_vector(31 downto 0);
    
    -- Data from the GTX
    rx_en_i         : in std_logic;
    rx_data_i       : in std_logic_vector(31 downto 0)
    
);
end ipb_optohybrid_slow_clock;

architecture rtl of ipb_optohybrid_slow_clock is

    -- IPBus error signals
	signal ipb_error_tx : std_logic := '0';
	signal ipb_error_rx : std_logic := '0';
    
    -- IPBus acknowledgment signals
	signal ipb_ack      : std_logic := '0';
    
    -- IPBus return data
	signal ipb_data     : std_logic_vector(31 downto 0) := (others => '0');  

begin	

    process(ipb_clk_i)
    
        -- Strobe
        variable last_ipb_strobe    : std_logic := '0';
        variable last_gtx_strobe    : std_logic := '0';
        
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                -- IPBus signals
                ipb_error_tx <= '0';
                ipb_error_rx <= '0';
                ipb_ack <= '0';
                
                last_ipb_strobe := '0';
                last_gtx_strobe := '0';
                
            else
            
                ------------------
                -- IPBus -> GTX --
                ------------------   
                
                -- Strobe awaiting
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then

                    -- Set TX
                    tx_data_o <= x"0000" & "1101010011000111";
      
                    -- Strobe
                    tx_en_o <= '1';

                else
                    
                    tx_en_o <= '0';
                    
                end if;   
                
                -- Error while sending
                
                if (tx_failed_i = '1') then
                
                    -- Raise the error flag
                    ipb_error_tx <= '1';

                else
                
                    ipb_error_tx <= '0';
                
                end if;
                
                ------------------
                -- GTX -> IPBus --
                ------------------  

                -- A response from the GTX is present
                if (last_gtx_strobe = '0' and rx_en_i = '1') then
            
                    -- Set data bus
                    ipb_data <= x"12345678";
                                
                    -- Reset IPBus error
                    ipb_error_rx <= '0';

                    -- Set IPBus acknowledgment
                    ipb_ack <= '1';
                    
                else
                
                    -- Set IPBus error
                    ipb_error_rx <= '0';

                    -- Reset IPBus acknowledgment
                    ipb_ack <= '0';                        
                
                end if;
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
                last_gtx_strobe := rx_en_i;
                
            end if;
            
        end if;
        
    end process;
    
    ipb_miso_o.ipb_err <= ipb_mosi_i.ipb_strobe and (ipb_error_tx or ipb_error_rx);
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack;    
    ipb_miso_o.ipb_rdata <= ipb_data;
                            
end rtl;