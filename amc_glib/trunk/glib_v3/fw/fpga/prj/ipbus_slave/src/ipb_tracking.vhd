library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_tracking is
port(

    -- Clocks and reset
	ipb_clk_i       : in std_logic;
	reset_i         : in std_logic;
    
    -- IPBus data
	ipb_mosi_i      : in ipb_wbus;
	ipb_miso_o      : out ipb_rbus;
    
    -- Data from the GTX
    rd_en_o         : out std_logic;
    data_i          : in std_logic_vector(191 downto 0);
    valid_i         : in std_logic;
    underflow_i     : in std_logic   
    
);
end ipb_tracking;

architecture rtl of ipb_tracking is

    -- IPBus signals
	signal ipb_ack      : std_logic := '0';
	signal ipb_error    : std_logic := '0';
	signal ipb_data     : std_logic_vector(31 downto 0) := (others => '0');
   
begin	

    process(ipb_clk_i)
    
        -- Strobe
        variable last_ipb_strobe    : std_logic := '0';
        
        -- Data select
        variable data_select        : integer range 0 to 15 := 0;
        
        -- FIFO variables
        variable fifo_data          : std_logic_vector(191 downto 0);
        variable valid              : std_logic := '0';
        variable underflow          : std_logic := '0';
        
        -- Waiting for data
        variable awaiting_data      : boolean := false;
        
    begin
    
        if (rising_edge(ipb_clk_i)) then
        
            -- Reset
            if (reset_i = '1') then
                
                rd_en_o <= '0';
                
                ipb_ack <= '0';
                ipb_error <= '0';
                
                last_ipb_strobe := '0';
                
                data_select := 0;
                
                valid := '0';
                underflow := '0';
                
                awaiting_data := false;
                
            else 
            
                -------------------------
                -- PC -> IPBus -> FIFO --
                -------------------------
                
                -- Strobe awaiting
                if (last_ipb_strobe = '0' and ipb_mosi_i.ipb_strobe = '1') then
                
                    data_select := to_integer(unsigned(ipb_mosi_i.ipb_addr(3 downto 0)));
      
                    if (data_select = 0) then
      
                        -- Strobe
                        rd_en_o <= '1';
                        
                        -- Reset local FIFO parameters
                        valid := '0';
                        underflow := '0';                        
                        
                    else
                        
                        -- Reset strobe
                        rd_en_o <= '0';
                        
                    end if;

                    awaiting_data := true;

                else
                    
                    -- Reset strobe
                    rd_en_o <= '0';
                    
                end if; 
                
                -------------------
                -- FIFO -> IPBus --
                -------------------    

                if (valid_i = '1') then
                
                    fifo_data := data_i;
                    valid := '1';
                    underflow := '0';
                
                elsif (underflow_i = '1') then
                
                    fifo_data := (others => '0');
                    valid := '0';
                    underflow := '1';
                
                end if;
                
                
                -----------------
                -- IPBus -> PC --
                -----------------  
                
                if (awaiting_data = true) then
                
                    if (valid = '1' or underflow = '1') then
                    
                        ipb_data <= fifo_data((191 - data_select * 16) downto (191 - data_select * 16 - 15));
                        
                        ipb_ack <= valid;
                        ipb_error <= underflow;
                        
                        awaiting_data := false;
                    
                    end if;
                
                end if;
                
                last_ipb_strobe := ipb_mosi_i.ipb_strobe;
                
            end if;
            
        end if;
        
    end process;
    
    ipb_miso_o.ipb_err <= ipb_mosi_i.ipb_strobe and ipb_error;
    ipb_miso_o.ipb_ack <= ipb_mosi_i.ipb_strobe and ipb_ack;    
    ipb_miso_o.ipb_rdata <= ipb_data;
                            
end rtl;