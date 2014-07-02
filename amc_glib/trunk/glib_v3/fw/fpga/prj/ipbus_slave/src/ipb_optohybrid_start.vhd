library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_optohybrid_start is
port(

    -- Clocks and reset
	ipb_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    -- Data to the GTX
    tx_en_o         : out std_logic
    
);
end ipb_optohybrid_start;

architecture rtl of ipb_optohybrid_start is

    -- IPBus acknowledgment signals
	signal ipb_ack  : std_logic := '0';
   
begin	

    process(ipb_clk_i)
    
        -- Strobe
        variable last_ipb_strobe    : std_logic := '0';
        
        -- Restart counter
        variable counter            : integer range 0 to 31 := 0;
        
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                ipb_ack <= '0';
                
                last_ipb_strobe := '0';
                
                counter := 0;
                
            else 

                -- Waited for OptoHybrid to reset
                if (counter = 31) then
                
                    -- Set IPBus acknowledgment
                    ipb_ack <= '1';
                    
                    counter := 0;
                    
                -- Waiting for OptoHybrid to reset
                elsif (counter > 0) then
                    
                    -- Reset IPBus acknowledgment
                    ipb_ack <= '0';
                    
                    counter := counter + 1;
                
                -- Nothing
                else
                    
                    -- Reset IPBus acknowledgment
                    ipb_ack <= '0';
                    
                    counter := 0;
                    
                end if;
            
                ------------------
                -- IPBus -> GTX --
                ------------------   
                
                -- Strobe awaiting
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
      
                    -- Strobe
                    tx_en_o <= '1';
                    
                    counter := 1;

                else
                    
                    -- Reset strobe
                    tx_en_o <= '0';
                    
                end if; 
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
                
            end if;
            
        end if;
        
    end process;
    
    ipb_miso_o.ipb_err <= '0';
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack;    
    ipb_miso_o.ipb_rdata <= x"12345678";
                            
end rtl;