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
    tx_en_i         : in std_logic;
    tx_ack_o        : out std_logic;
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
    signal wr_en        : std_logic := '0';
    signal data_in      : std_logic_vector(31 downto 0) := (others => '0');
    
    signal rd_en        : std_logic := '0';
    signal rd_valid     : std_logic := '0';
    signal data_out     : std_logic_vector(31 downto 0) := (others => '0');
    

begin

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
                
                wr_en <= '0';
                
                last_ipb_strobe := '0';
                
            else 
                
                -- Strobe awaiting
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                   
                    if (ipb_mosi_i.ipb_write = '1') then

                        -- Unused - Read/Write - Chip select
                        chip_byte := "00" & '0' & ipb_mosi_i.ipb_addr(12 downto 8);
                        
                        -- Data
                        data_byte := ipb_mosi_i.ipb_wdata(7 downto 0); 
                        
                    else

                        -- Unused - Read/Write - Chip select
                        chip_byte := "00" & '1' & ipb_mosi_i.ipb_addr(12 downto 8);
                        
                        -- Data
                        data_byte := "00000000";

                    end if;
                   
                    -- Register select                        
                    register_byte := ipb_mosi_i.ipb_addr(7 downto 0);
                    
                    -- CRC
                    crc_byte := def_gtx_vfat2_request xor chip_byte xor register_byte xor data_byte;
                    
                    -- Set TX
                    data_in <= chip_byte & register_byte & data_byte & crc_byte;
                    
                    -- Strobe
                    wr_en <= '1';

                else
                    
                    wr_en <= '0';
                    
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
        
        variable state          : integer range 0 to 1 := 0;
        
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
            
                rd_en <= '0';
            
                ipb_error <= '0';
                
                ipb_ack <= '0';
                
                state := 0;
                
            else 

                if (state = 0) then
                
                    rd_en <= '1';
                    
                    ipb_ack <= '0';
                    
                    ipb_error <= '0';
                    
                    state := 1;
                    
                elsif (state = 1) then
                
                    rd_en <= '0';
                    
                    if (rd_valid = '1') then
                    
                        -- Unused - Read/Write - Chip select
                        chip_byte := data_out(31 downto 24);
                        
                        -- Register select                        
                        register_byte := data_out(23 downto 16);
                        
                        -- Data
                        data_byte := data_out(15 downto 8);
                        
                        -- CRC
                        crc_byte := def_gtx_vfat2_request xor chip_byte xor register_byte xor data_byte;       
                        
                        -- Check CRC
                        if (crc_byte = data_out(7 downto 0)) then
                        
                            -- Set data bus
                            ipb_data <= "00000" & data_out(31) & data_out(30) & data_out(29) -- Unused - Error - Valid - Read/Write_n
                                        & "000" & data_out(28 downto 24)                       -- Chip select
                                        & data_out(23 downto 16)                               -- Register select
                                        & data_out(15 downto 8);                               -- Data
                                        
                            -- Reset IPBus error
                            ipb_error <= '0';

                            -- Set IPBus acknowledgment
                            ipb_ack <= '1';
                            
                        else
                        
                            -- Set IPBus error
                            ipb_error <= '1';

                            -- Reset IPBus acknowledgment
                            ipb_ack <= '0';
                                        
                        end if;                        
                    
                    else
                        
                        ipb_error <= '0';

                        ipb_ack <= '0';
                    
                    end if;
                    
                    state := 0;
                
                else
                
                    rd_en <= '0';
                
                    ipb_error <= '0';
                    
                    ipb_ack <= '0';
                    
                    state := 0;
                
                end if;
                
            end if;
            
        end if;
        
    end process;	
    
    ----------------------------------
    -- Buffers                      --
    ----------------------------------

    tx_buffer : entity work.buffer_fifo
    port map(
        rst     => reset_i,
        wr_clk  => ipb_clk_i,
        rd_clk  => fabric_clk_i,
        din     => data_in,
        wr_en   => wr_en,
        rd_en   => tx_en_i,
        dout    => tx_data_o,
        full    => open,
        empty   => open,
        valid   => tx_ack_o
    );
    
    rx_buffer : entity work.buffer_fifo
    port map(
        rst     => reset_i,
        wr_clk  => fabric_clk_i,
        rd_clk  => ipb_clk_i,
        din     => rx_data_i,
        wr_en   => rx_en_i,
        rd_en   => rd_en,
        dout    => data_out,
        full    => open,
        empty   => open,
        valid   => rd_valid
    );
    
    ----------------------------------
    -- IPBus signals                --
    ----------------------------------
    
    ipb_miso_o.ipb_err <= ipb_mosi_i.ipb_strobe and ipb_error;
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack;
    ipb_miso_o.ipb_rdata <= ipb_data;
                            
end rtl;