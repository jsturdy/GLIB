library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_tracking is
port(

	ipb_clk_i       : in std_logic;
	gtx_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    rx_en_i         : in std_logic;
    rx_data_i       : in std_logic_vector(223 downto 0);
    
    fifo_reset_i    : in std_logic;
    fifo_count_o    : out std_logic_vector(11 downto 0)
    
);
end ipb_tracking;

architecture rtl of ipb_tracking is

    signal ipb_ack      : std_logic := '0';
	signal ipb_data     : std_logic_vector(31 downto 0) := (others => '0'); 

    signal rd_en        : std_logic := '0';
    signal rd_data      : std_logic_vector(223 downto 0) := (others => '0');
    signal rd_valid     : std_logic := '0';
    signal rd_underflow : std_logic := '0';
    
begin
    
    tracking_data_fifo_inst : entity work.tracking_data_fifo
    port map(
        rst             => (fifo_reset_i or reset_i),
        wr_clk          => gtx_clk_i,
        wr_en           => rx_en_i,
        din             => rx_data_i,
        rd_clk          => ipb_clk_i,
        rd_en           => rd_en,
        valid           => rd_valid,
        underflow       => rd_underflow,
        dout            => rd_data,
        rd_data_count   => fifo_count_o,
        full            => open,
        empty           => open
    ); 
   
    process(ipb_clk_i)
        
        variable state              : integer range 0 to 3 := 0;
        
        variable data               : std_logic_vector(223 downto 0) := (others => '0');
    
        variable last_ipb_strobe    : std_logic := '0';
       
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            if (reset_i = '1') then
                
                ipb_ack <= '0';
                
                rd_en <= '0';
                
                state := 0;
                
                last_ipb_strobe := '0';
                
            else 
            
                if (state = 0) then
                
                    ipb_ack <= '0';
                
                    if (ipb_mosi_i.ipb_strobe = '1' and last_ipb_strobe = '0') then
                
                        if (ipb_mosi_i.ipb_addr(3 downto 0) = "0000") then
                            
                            rd_en <= '1';
                            
                            state := 1;
                        
                        elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0001") then
                        
                            ipb_data <= data(31 downto 0);
                            
                            state := 2;
                            
                        elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0010") then
                        
                            ipb_data <= data(63 downto 32);
                            
                            state := 2;
                            
                        elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0011") then
                        
                            ipb_data <= data(95 downto 64);
                            
                            state := 2;
                            
                        elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0100") then
                        
                            ipb_data <= data(127 downto 96);
                            
                            state := 2;
                            
                        elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0101") then
                        
                            ipb_data <= data(159 downto 128);
                            
                            state := 2;
                            
                        elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0110") then
                        
                            ipb_data <= data(191 downto 160);
                            
                            state := 2;
                            
                        elsif (ipb_mosi_i.ipb_addr(3 downto 0) = "0111") then
                        
                            ipb_data <= data(223 downto 192);
                            
                            state := 2;
                        
                        end if;
                
                    end if;
                    
                elsif (state = 1) then
                
                    rd_en <= '0';
                    
                    if (rd_valid = '1') then
                    
                        ipb_data <= (0 => '1', others => '0');
                    
                        data := rd_data;
                        
                        state := 2;
                        
                    elsif (rd_underflow = '1') then
                    
                        ipb_data <= (others => '0');
                    
                        data := (others => '1');
                        
                        state := 2;
                        
                    end if;
                    
                elsif (state = 2) then
                
                    ipb_ack <= '1';
                    
                    state := 0;
                    
                else
                    
                    ipb_ack <= '0';
                    
                    rd_en <= '0';
                    
                    state := 0;
                
                end if;
            
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
            
            end if;
        
        end if;
        
    end process;
    
    ipb_miso_o.ipb_err <= '0';
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack;
    ipb_miso_o.ipb_rdata <= ipb_data;
                            
end rtl;