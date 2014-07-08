library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_vfat2 is
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
end ipb_vfat2;

architecture rtl of ipb_vfat2 is

    -- IPBus error signals
	signal ipb_error_tx : std_logic := '0';
	signal ipb_error_rx : std_logic := '0';
    
    -- IPBus acknowledgment signals
	signal ipb_ack      : std_logic_vector(127 downto 0) := (others => '0');
    
    -- IPBus return data
	signal ipb_data     : std_logic_vector(31 downto 0) := (others => '0');  

begin	

    process(ipb_clk_i)
    
        -- TX data
        variable tx_rd_chip_select  : std_logic_vector(7 downto 0) := (others => '0');
        variable tx_register_select : std_logic_vector(7 downto 0) := (others => '0'); 
        variable tx_data            : std_logic_vector(7 downto 0) := (others => '0'); 
        variable tx_crc             : std_logic_vector(7 downto 0) := (others => '0'); 
        
        -- RX data
        variable rx_rd_chip_select  : std_logic_vector(7 downto 0) := (others => '0'); 
        variable rx_register_select : std_logic_vector(7 downto 0) := (others => '0'); 
        variable rx_data            : std_logic_vector(7 downto 0) := (others => '0'); 
        variable rx_crc             : std_logic_vector(7 downto 0) := (others => '0'); 

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
                ipb_ack <= (others => '0');
                
                last_ipb_strobe := '0';
                last_gtx_strobe := '0';
                
            else
            
                -- Shift the acknowledgments
                ipb_ack(127 downto 1) <= ipb_ack(126 downto 0);
                
                ------------------
                -- IPBus -> GTX --
                ------------------   
                
                -- Strobe awaiting
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then

                    if (ipb_mosi_i.ipb_write = '1') then

                        -- Unused - Read/Write - Chip select
                        tx_rd_chip_select := "00" & '0' & ipb_mosi_i.ipb_addr(12 downto 8);
                        
                        -- Data
                        tx_data := ipb_mosi_i.ipb_wdata(7 downto 0); 
                        
                    else

                        -- Unused - Read/Write - Chip select
                        tx_rd_chip_select := "00" & '1' & ipb_mosi_i.ipb_addr(12 downto 8);
                        
                        -- Data
                        tx_data := "00000000";

                    end if;
                   
                    -- Register select                        
                    tx_register_select := ipb_mosi_i.ipb_addr(7 downto 0);
                    
                    -- CRC
                    tx_crc := ("0001" & def_gtx_vfat2_request) xor tx_rd_chip_select xor tx_register_select xor tx_data;
                    
                    -- Set TX
                    tx_data_o <= tx_rd_chip_select & tx_register_select & tx_data & tx_crc;
                    
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
            
                    -- Unused - Read/Write - Chip select
                    rx_rd_chip_select := rx_data_i(31 downto 24);
                    -- Register select                        
                    rx_register_select := rx_data_i(23 downto 16);
                    -- Data
                    rx_data := rx_data_i(15 downto 8);
                    -- CRC
                    rx_crc := ("0000" & def_gtx_vfat2_request) xor rx_rd_chip_select xor rx_register_select xor rx_data;       
                    
                    -- Check CRC
                    if (rx_crc = rx_data_i(7 downto 0)) then
                    
                        -- Set data bus
                        ipb_data <= "00000" & rx_data_i(31) & rx_data_i(30) & rx_data_i(29) -- Unused - Error - Valid - Read/Write_n
                                    & "000" & rx_data_i(28 downto 24)                       -- Chip select
                                    & rx_data_i(23 downto 16)                               -- Register select
                                    & rx_data_i(15 downto 8);                               -- Data
                                    
                        -- Reset IPBus error
                        ipb_error_rx <= '0';

                        -- Set IPBus acknowledgment
                        ipb_ack(0) <= '1';
                        
                    else
                    
                        -- Set IPBus error
                        ipb_error_rx <= '1';

                        -- Reset IPBus acknowledgment
                        ipb_ack(0) <= '0';
                                    
                    end if;
                    
                else
                
                    -- Set IPBus error
                    ipb_error_rx <= '0';

                    -- Reset IPBus acknowledgment
                    ipb_ack(0) <= '0';                        
                
                end if;
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
                last_gtx_strobe := rx_en_i;
                
            end if;
            
        end if;
        
    end process;
    
    ipb_miso_o.ipb_err <= ipb_mosi_i.ipb_strobe and (ipb_error_tx or ipb_error_rx);
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack(127);    
    ipb_miso_o.ipb_rdata <= ipb_data;
                            
end rtl;