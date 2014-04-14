library ieee;
use ieee.std_logic_1164.all;

use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipbus_transmitter_slave is
port(
	clk					: in std_logic;
	reset				: in std_logic;
	ipb_mosi_i			: in ipb_wbus;
	ipb_miso_o			: out ipb_rbus;
	------------------
    ipb_gbt_i           : in optohybrid_bus;
    ipb_gbt_o           : out optohybrid_bus
);
end ipbus_transmitter_slave;

architecture rtl of ipbus_transmitter_slave is	
	signal ack: std_logic;

	attribute keep: boolean;
	attribute keep of ack: signal is true;
begin	

	process(reset, clk)
	begin
        if (reset = '1') then
            ack <= '0';
        elsif (rising_edge(clk)) then		
            -- To GBT
            if (ipb_mosi_i.ipb_strobe = '1') then 
                ipb_gbt_o.strobe <= '1';
                ipb_gbt_o.chip <= ipb_mosi_i.ipb_addr(12 downto 8);
                ipb_gbt_o.reg <= ipb_mosi_i.ipb_addr(7 downto 0);
                if (ipb_mosi_i.ipb_write = '1') then
                    ipb_gbt_o.write_read_n <= '1';
                    ipb_gbt_o.data <= ipb_mosi_i.ipb_wdata(7 downto 0);
                else
                    ipb_gbt_o.write_read_n <= '0';
                    ipb_gbt_o.data <= (others => '0');                
                end if;
            else
                ipb_gbt_o.strobe <= '0';
            end if;
            
            -- From GBT
            if (ipb_gbt_i.strobe = '1') then
                ipb_miso_o.ipb_rdata <= "000000000000000000000000" & ipb_gbt_i.data;
            end if;
            
            ack <= ipb_gbt_i.strobe and not ack;
        end if;
	end process;
	
    ipb_miso_o.ipb_ack <= ack;
    ipb_miso_o.ipb_err <= '0';
end rtl;