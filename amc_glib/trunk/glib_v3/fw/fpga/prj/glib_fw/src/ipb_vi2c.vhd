library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_vi2c is
port(

	ipb_clk_i   : in std_logic;
	gtx_clk_i   : in std_logic;
	reset_i     : in std_logic;
    
	ipb_mosi_i  : in ipb_wbus;
	ipb_miso_o  : out ipb_rbus;
    
    tx_en_o     : out std_logic;
    tx_data_o   : out std_logic_vector(31 downto 0);
    
    rx_en_i     : in std_logic;
    rx_data_i   : in std_logic_vector(31 downto 0)
    
);
end ipb_vi2c;

architecture rtl of ipb_vi2c is

	signal ipb_ack      : std_logic := '0';
	signal ipb_data     : std_logic_vector(31 downto 0) := (others => '0'); 

    signal tx_en        : std_logic := '0';
    signal tx_data      : std_logic_vector(31 downto 0) := (others => '0');
    
    signal rx_strobe    : std_logic := '0';
    signal rx_ack       : std_logic := '0';
    
begin

    --================================--
    -- Clock bridges
    --================================--
    
    clock_bridge_tx_inst : entity work.clock_bridge
    port map(
        reset_i     => reset_i,
        m_clk_i     => ipb_clk_i,
        m_en_i      => tx_en,
        m_data_i    => tx_data,        
        s_clk_i     => gtx_clk_i,
        s_en_o      => tx_en_o,
        s_data_o    => tx_data_o
    );  

    --================================--
    -- TX
    --================================--

    process(ipb_clk_i)
    
        variable state              : integer range 0 to 3 := 0;
    
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
                
                state := 0;
                
                last_ipb_strobe := '0';
                
            else 
            
                -- Wait state
                if (state = 0) then
                
                    tx_en <= '0';
                
                    -- Register data
                    if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                    
                        if (ipb_mosi_i.ipb_write = '1') then
                    
                            chip_byte := "00" & '0' & ipb_mosi_i.ipb_addr(12 downto 8);

                            data_byte := ipb_mosi_i.ipb_wdata(7 downto 0); 
                            
                        else
                    
                            chip_byte := "00" & '1' & ipb_mosi_i.ipb_addr(12 downto 8);

                            data_byte := (others => '0');
                        
                        end if;
                                                    
                        register_byte := ipb_mosi_i.ipb_addr(7 downto 0);
                        
                        state := 1;
                        
                    end if;
                    
                -- Compute CRC
                elsif (state = 1) then
                    
                    -- CRC
                    crc_byte := def_gtx_vi2c 
                                xor chip_byte 
                                xor register_byte 
                                xor data_byte;
                        
                    state := 2;

                -- Send data
                elsif (state = 2) then
                        
                    tx_data <= chip_byte & register_byte & data_byte & crc_byte;
                    
                    tx_en <= '1';
                    
                    state := 0;

                else
                    
                    tx_en <= '0';
                    
                end if;  
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
            
            end if;
        
        end if;
        
    end process;

    --================================--
    -- RX
    --================================--
    
    process(gtx_clk_i)
    
        variable state              : integer range 0 to 3 := 0;
        
        variable chip_byte      : std_logic_vector(7 downto 0) := (others => '0');
        variable register_byte  : std_logic_vector(7 downto 0) := (others => '0');
        variable data_byte      : std_logic_vector(7 downto 0) := (others => '0');
        variable crc_byte       : std_logic_vector(7 downto 0) := (others => '0');
        variable crc_check      : std_logic_vector(7 downto 0) := (others => '0');
        
    begin
    
        if (rising_edge(gtx_clk_i)) then
        
            if (reset_i = '1') then
            
                rx_strobe <= '0';
                
                state := 0;
                
            else 
            
                -- Wait
                if (state = 0) then
            
                    -- Register data
                    if (rx_en_i = '1') then
                    
                        chip_byte := rx_data_i(31 downto 24);
                               
                        register_byte := rx_data_i(23 downto 16);
                        
                        data_byte := rx_data_i(15 downto 8);
                        
                        crc_byte := rx_data_i(7 downto 0);     
                        
                        crc_check := def_gtx_vi2c 
                                     xor rx_data_i(31 downto 24) 
                                     xor rx_data_i(23 downto 16) 
                                     xor rx_data_i(15 downto 8);
                    
                        state := 1;
                        
                    end if;
                    
                -- Check CRC
                elsif (state = 1) then
                
                    ipb_data <= "00000" & chip_byte(7) & chip_byte(6) & chip_byte(5)    -- Unused - Error - Valid - Read/Write_n
                                & "000" & chip_byte(4 downto 0)                         -- Chip select
                                & register_byte                                         -- Register select
                                & data_byte;                                            -- Data                    
                    
                    if (crc_byte = crc_check) then
                    
                        state := 2;
                        
                    else
                    
                        state := 0;
                        
                    end if;
                    
                -- Return data
                elsif (state = 2) then

                    rx_strobe <= '1';

                    state := 3;
                    
                -- Wait for ack
                elsif (state = 3) then
                
                    if (rx_ack = '1') then
                    
                        rx_strobe <= '0';
                        
                        state := 0;
                        
                    end if;

                else
                
                    rx_strobe <= '0';

                    state := 0;
                    
                end if;
                
            end if;
            
        end if;
        
    end process;
    
    
    process(ipb_clk_i)
    begin

        if (rising_edge(ipb_clk_i)) then

            if (reset_i = '1') then
            
                rx_ack <= '0';

                ipb_ack <= '0';

            else
            
                if (rx_strobe = '1' and rx_ack = '0') then
                
                    ipb_ack <= '1';
                    
                    rx_ack <= '1';
               
                elsif (rx_strobe = '0' and rx_ack = '1') then
            
                    ipb_ack <= '0';
                    
                    rx_ack <= '0';
                    
                else
                
                    ipb_ack <= '0';
                    
                end if;

            end if;

        end if;

    end process;
    
    ipb_miso_o.ipb_err <= '0';
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack;
    ipb_miso_o.ipb_rdata <= ipb_data;
                            
end rtl;