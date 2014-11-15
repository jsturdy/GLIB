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
	fabric_clk_i    : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    -- Data to the GTX
    tx_en_o         : out std_logic;
    tx_data_o       : out std_logic_vector(31 downto 0);
    
    -- Data from the GTX
    rx_en_i         : in std_logic;
    rx_data_i       : in std_logic_vector(31 downto 0)
    
);
end ipb_vfat2;

architecture rtl of ipb_vfat2 is

    -- IPBus error signals
	signal ipb_error    : std_logic := '0';
    
    -- IPBus acknowledgment signals
	signal ipb_ack      : std_logic := '0';
    
    -- IPBus return data
	signal ipb_data     : std_logic_vector(31 downto 0) := (others => '0'); 

    -- FIFO signals
    signal tx_en        : std_logic := '0';
    signal tx_data      : std_logic_vector(31 downto 0) := (others => '0');
    
    signal rx_en        : std_logic := '0';
    signal rx_data      : std_logic_vector(31 downto 0) := (others => '0');
    
begin

    ----------------------------------
    -- Clock bridges                --
    ----------------------------------
    
    clock_bridge_tx_inst : entity work.clock_bridge
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => tx_en,
        m_data_i    => tx_data,        
        s_clk_i     => fabric_clk_i,
        s_en_o      => tx_en_o,
        s_data_o    => tx_data_o
    );    

    clock_bridge_rx_inst : entity work.clock_bridge
    port map(
        reset_i     => reset_i,
        m_clk_i     => fabric_clk_i,
        m_en_i      => rx_en_i,
        m_data_i    => rx_data_i,        
        s_clk_i     => ipb_clk_i,
        s_en_o      => rx_en,
        s_data_o    => rx_data
    );   

    ----------------------------------
    -- IPBus -> GTX                 --
    ----------------------------------

    process(ipb_clk_i)
    
        variable chip_byte          : std_logic_vector(7 downto 0) := (others => '0');
        variable register_byte      : std_logic_vector(7 downto 0) := (others => '0');
        variable data_byte          : std_logic_vector(7 downto 0) := (others => '0');
        variable crc_byte           : std_logic_vector(7 downto 0) := (others => '0');

        variable last_ipb_strobe    : std_logic := '0';
        
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                tx_en <= '0';
                
                last_ipb_strobe := '0';
                
            else 
                
                -- Incoming data from IPBus controller
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                   
                    -- Write operation
                    if (ipb_mosi_i.ipb_write = '1') then

                        -- Unused - Read/Write - Chip select
                        chip_byte := "00" & '0' & ipb_mosi_i.ipb_addr(12 downto 8);
                        
                        -- Data
                        data_byte := ipb_mosi_i.ipb_wdata(7 downto 0); 
                    
                    -- Read operation
                    else

                        -- Unused - Read/Write - Chip select
                        chip_byte := "00" & '1' & ipb_mosi_i.ipb_addr(12 downto 8);
                        
                        -- Data
                        data_byte := "00000000";

                    end if;
                   
                    -- Register select                        
                    register_byte := ipb_mosi_i.ipb_addr(7 downto 0);
                    
                    -- CRC
                    crc_byte := chip_byte xor register_byte xor data_byte;
                    
                    -- Set TX data
                    tx_data <= chip_byte & register_byte & data_byte & crc_byte;
                    
                    -- Set TX strobe
                    tx_en <= '1';

                else
                    
                    -- Reset TX strobe
                    tx_en <= '0';
                    
                end if;  
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
            
            end if;
        
        end if;
        
    end process;
    
    ----------------------------------
    -- GTX -> IPBus                 --
    ---------------------------------- 

    process(ipb_clk_i)
        
        variable chip_byte      : std_logic_vector(7 downto 0) := (others => '0');
        variable register_byte  : std_logic_vector(7 downto 0) := (others => '0');
        variable data_byte      : std_logic_vector(7 downto 0) := (others => '0');
        variable crc_byte       : std_logic_vector(7 downto 0) := (others => '0');
        
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                ipb_error <= '0';
                
                ipb_ack <= '0';
                
            else 
            
                -- Response from OptoHybrid
                if (rx_en = '1') then
                    
                    -- Unused - Read/Write - Chip select
                    chip_byte := rx_data(31 downto 24);
                    
                    -- Register select                        
                    register_byte := rx_data(23 downto 16);
                    
                    -- Data
                    data_byte := rx_data(15 downto 8);
                    
                    -- CRC
                    crc_byte := chip_byte xor register_byte xor data_byte;       
                    
                    -- Check CRC
                    --if (crc_byte = rx_data(7 downto 0)) then
                    
                        -- Set data bus
                        ipb_data <= "00000" & chip_byte(7) & chip_byte(6) & chip_byte(5)    -- Unused - Error - Valid - Read/Write_n
                                    & "000" & chip_byte(4 downto 0)                         -- Chip select
                                    & register_byte                                         -- Register select
                                    & data_byte;                                            -- Data
                                    
                        -- Reset IPBus error
                        ipb_error <= '0';

                        -- Set IPBus acknowledgment
                        ipb_ack <= '1';
                        
                    --else
                    
                        -- Set IPBus error
                    --    ipb_error <= '1';

                        -- Reset IPBus acknowledgment
                    --    ipb_ack <= '0';
                                    
                    --end if;    
                        
                else
                    
                    ipb_ack <= '0';
                
                    ipb_error <= '0';
                
                end if;
                
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