--
-- This module stores the received tracking data in a FIFO and lets IPBus read it 
--
--
-- Ways to improve: must be connected to the RX module
--
-- Modifications needed for V2: not needed in V2, or maybe to spy on the data. Data must go through AMC13
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_tracking_tmp is
port(

    -- Clocks and reset
	ipb_clk_i       : in std_logic;
	gtx_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus
    
);
end ipb_tracking_tmp;

architecture rtl of ipb_tracking_tmp is

    -- IPBus error signals
	signal ipb_error    : std_logic := '0';
    
    -- IPBus acknowledgment signals
	signal ipb_ack      : std_logic := '0';
    
    -- IPBus return data
	signal ipb_data     : std_logic_vector(31 downto 0) := (others => '0'); 
    
    
    
begin

    ----------------------------------
    -- IPBus                        --
    ----------------------------------
   
    process(ipb_clk_i)
    
        variable last_ipb_strobe    : std_logic := '0';
        
        variable bc                 : unsigned(11 downto 0) := (others => '0');
        variable ec                 : unsigned(7 downto 0) := (others => '0');
        variable chipId             : unsigned(11 downto 0) := (others => '0');
        variable data               : unsigned(127 downto 0) := (127 => '1', others => '0');
       
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                ipb_ack <= '0';
                
                last_ipb_strobe := '0';
                
                bc := (others => '0');
                
                ec := (others => '0');
                
                chipID := (others => '0');
                
            else 
            
                -- Incomming IPBus request
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                
                    if (ipb_mosi_i.ipb_addr(3 downto 0) = "0000") then
                    
                        bc := bc + 10;
                        ec := ec + 1;
                        chipId := chipId + 2;
                        data := data ror 1;
                        
                        ipb_data <= (others => '0');
                        
                    elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0001") then
                    
                        ipb_data <= "1010" & std_logic_vector(bc) & "1100" & std_logic_vector(ec) & "1111";
                        
                    elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0010") then
                    
                        ipb_data <= "1110" & std_logic_vector(chipId) & std_logic_vector(data(127 downto 112));
                        
                    elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0011") then
                    
                        ipb_data <= std_logic_vector(data(111 downto 80));
                        
                    elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0100") then
                    
                        ipb_data <= std_logic_vector(data(79 downto 48));
                        
                    elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0101") then
                    
                        ipb_data <= std_logic_vector(data(47 downto 16));
                        
                    elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0110") then
                    
                        ipb_data <= std_logic_vector(data(15 downto 0)) & x"AAAA";
                        
                    
                    end if;
                   
                    ipb_ack <= '1';
                    
                else
                
                    ipb_ack <= '0';
                    
                end if;
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
            
            end if;
        
        end if;
        
    end process;
    
    ----------------------------------
    -- IPBus signals                --
    ----------------------------------
    
    ipb_miso_o.ipb_err <= ipb_mosi_i.ipb_strobe and ipb_error;
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack;
    ipb_miso_o.ipb_rdata <= ipb_data;
                            
end rtl;