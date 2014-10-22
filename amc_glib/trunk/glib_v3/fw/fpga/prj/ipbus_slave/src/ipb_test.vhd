library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_test is
generic(
    SIZE        : integer := 255
);
port(

    -- Clocks and reset
	ipb_clk_i   : in std_logic;
	reset_i     : in std_logic;
    
    -- IPBus data
	ipb_mosi_i  : in ipb_wbus;
	ipb_miso_o  : out ipb_rbus
    
);
end ipb_test;

architecture rtl of ipb_test is
    
    -- IPBus acknowledgment signals
	signal ipb_ack      : std_logic_vector((SIZE - 1) downto 0) := (others => '0');

begin

    process(ipb_clk_i)
    
        variable last_ipb_strobe    : std_logic := '0';
       
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                ipb_ack <= (others => '0');
                
                last_ipb_strobe := '0';
                
            else 
            
                if (ipb_mosi_i.ipb_strobe = '1') then
                    ipb_ack((SIZE - 1) downto 1) <= ipb_ack((SIZE - 2) downto 0);
                else
                    ipb_ack <= (others => '0');
                end if;
                
                -- Incomming IPBus request
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                
                    ipb_ack(0) <= '1';
                    
                end if;  
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
            
            end if;
        
        end if;
        
    end process;
  
    ipb_miso_o.ipb_err <= '0';
    ipb_miso_o.ipb_ack <= ipb_ack(SIZE - 1);
    ipb_miso_o.ipb_rdata <= x"20141020";
                            
end rtl;