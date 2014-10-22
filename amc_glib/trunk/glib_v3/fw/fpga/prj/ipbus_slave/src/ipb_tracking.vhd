library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_tracking is
port(

    -- Clocks and reset
	ipb_clk_i       : in std_logic;
	gtx_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    -- Data from the GTX
    rx_en_i         : in std_logic;
    rx_data_i       : in std_logic_vector(15 downto 0)
    
);
end ipb_tracking;

architecture rtl of ipb_tracking is

    -- IPBus error signals
	signal ipb_error    : std_logic := '0';
    
    -- IPBus acknowledgment signals
	signal ipb_ack      : std_logic := '0';
    
    -- IPBus return data
	signal ipb_data     : std_logic_vector(31 downto 0) := (others => '0'); 

    -- FIFO signals
    signal rd_en        : std_logic := '0';
    signal rd_data      : std_logic_vector(31 downto 0) := (others => '0');
    signal empty        : std_logic := '1';
    signal rd_valid     : std_logic := '0';
    
begin

    ----------------------------------
    -- Buffer                       --
    ----------------------------------
    
    tracking_buffer_inst : entity work.buffer_fifo
    port map(
        rst     => reset_i,
        wr_clk  => gtx_clk_i,
        rd_clk  => ipb_clk_i,
        din     => rx_data_i,
        wr_en   => rx_en_i,
        rd_en   => rd_en,
        dout    => rd_data,
        full    => open,
        empty   => empty,
        valid   => rd_valid
    ); 

    ----------------------------------
    -- IPBus                        --
    ----------------------------------
   
    process(ipb_clk_i)
    
        variable last_ipb_strobe    : std_logic := '0';
       
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                ipb_ack <= '0';
                
                last_ipb_strobe := '0';
                
            else 
            
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                
                    if (empty = '1') then
                        
                        ipb_error <= '1';
                        
                        rd_en <= '0';
                        
                    else
                    
                        ipb_error <= '0';
                        
                        rd_en <= '1';
                        
                    end if; 
                    
                else
                
                    rd_en <= '0';
                    
                end if;
                
                -- Incomming IPBus request
                if (rd_valid = '1') then
                
                    ipb_data <= rd_data;
                
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