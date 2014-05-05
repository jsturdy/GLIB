library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipbus_vfat2_slave is
port(
	clk             : in std_logic;
	reset           : in std_logic;
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    ipb_vfat2_io    : inout vfat2_data_bus;   
    vfat2_ipb_io    : inout vfat2_data_bus
);
end ipbus_vfat2_slave;

architecture rtl of ipbus_vfat2_slave is	
	signal ack: std_logic;
	signal error: std_logic;
    
    signal gtx_error : std_logic := '0';
    signal gtx_ack : std_logic := '0';

	attribute keep: boolean;
	attribute keep of ack : signal is true;
	attribute keep of error : signal is true;
begin	

	process(clk)
	begin
        if (rising_edge(clk)) then        
            if (reset = '1') then
                ipb_vfat2_io.strobe <= '0';
                vfat2_ipb_io.acknowledge <= '0';
                gtx_error <= '0';
                gtx_ack <= '0';
            else
                -- Reset strobe signal
                if (ipb_vfat2_io.strobe = '1' and ipb_vfat2_io.acknowledge = '1') then 
                    ipb_vfat2_io.strobe <= '0';
                end if;
          
                -- IPBus request
                if (ipb_mosi_i.ipb_strobe = '1') then
                    -- GTX is not busy
                    if (ipb_vfat2_io.strobe = '0' and ipb_vfat2_io.acknowledge = '0') then 
                        -- Set data lines
                        ipb_vfat2_io.valid <= '0';
                        ipb_vfat2_io.error <= '0';
                        ipb_vfat2_io.chipSelect <= ipb_mosi_i.ipb_addr(12 downto 8);
                        ipb_vfat2_io.registerSelect <= ipb_mosi_i.ipb_addr(7 downto 0);
                        if (ipb_mosi_i.ipb_write = '1') then
                            ipb_vfat2_io.readWrite_n <= '1';
                            ipb_vfat2_io.data <= ipb_mosi_i.ipb_wdata(7 downto 0);
                        else
                            ipb_vfat2_io.readWrite_n <= '0';
                            ipb_vfat2_io.data <= (others => '0');                
                        end if;
                        -- Strobe
                        ipb_vfat2_io.strobe <= '1';
                        -- Reset error
                        gtx_error <= '0';
                    -- If GTX is busy, set error
                    else
                        ipb_miso_o.ipb_rdata <= "0000010" & ipb_mosi_i.ipb_write & "000" & ipb_mosi_i.ipb_addr(12 downto 8) & ipb_mosi_i.ipb_addr(7 downto 0) & x"10"; -- Code 10 = GTX busy
                        gtx_error <= '1';
                    end if;
                else
                    gtx_error <= '0';
                end if;
                
                -- Reset acknowledgment signal
                if (vfat2_ipb_io.strobe = '0' and vfat2_ipb_io.acknowledge = '1') then
                    vfat2_ipb_io.acknowledge <= '0';
                end if;                
                
                -- Receive data from GTX
                if (vfat2_ipb_io.strobe = '1' and vfat2_ipb_io.acknowledge = '0') then
                    -- Set data bus
                    ipb_miso_o.ipb_rdata <= "00000" & vfat2_ipb_io.error & vfat2_ipb_io.valid & vfat2_ipb_io.readWrite_n & "000" & vfat2_ipb_io.chipSelect & vfat2_ipb_io.registerSelect & vfat2_ipb_io.data;
                    vfat2_ipb_io.acknowledge <= '1';
                    -- Acknowledge IPBus
                    gtx_ack <= '1';
                else
                    gtx_ack <= '0';
                end if;
                
                error <= gtx_error and not error;
                ack <= gtx_ack and not ack;
                
            end if;
        end if;
	end process;
	
    ipb_miso_o.ipb_err <= error;
    ipb_miso_o.ipb_ack <= ack;
    
end rtl;