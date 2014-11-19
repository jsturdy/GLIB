library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.user_package.all;

entity registers_core is
port(

    fabric_clk_i    : in std_logic;
    reset_i         : in std_logic;
    
    rx_en_i         : in std_logic;
    rx_data_i       : in std_logic_vector(47 downto 0);
    
    tx_ready_o      : out std_logic;
    tx_done_i       : in std_logic;
    tx_data_o       : out std_logic_vector(47 downto 0);

    wbus_o          : out array32(127 downto 0);
    wbus_t          : out std_logic_vector(127 downto 0);
    rbus_i          : in array32(127 downto 0)

);
end registers_core;

architecture rtl of registers_core is
begin

    process(fabric_clk_i)
    
        variable state          : integer range 0 to 7 := 0;
        
        variable data_byte      : std_logic_vector(31 downto 0) := (others => '0');
        variable register_byte  : std_logic_vector(7 downto 0) := (others => '0');
        variable crc_byte       : std_logic_vector(7 downto 0) := (others => '0');
        variable crc_check      : std_logic_vector(7 downto 0) := (others => '0');
        
    begin

        if (rising_edge(fabric_clk_i)) then

            if (reset_i = '1') then
            
                tx_ready_o <= '0';

                wbus_t <= (others => '0');
                
                state := 0;
            
            else
                
                -- Wait
                if (state = 0) then

                    if (rx_en_i = '1') then
                    
                        -- Register the data
                        data_byte := rx_data_i(47 downto 16);
                        register_byte := rx_data_i(15 downto 8);
                        crc_byte := rx_data_i(7 downto 0);
                        crc_check := def_gtp_regs 
                                     xor rx_data_i(47 downto 40) 
                                     xor rx_data_i(39 downto 32) 
                                     xor rx_data_i(31 downto 24) 
                                     xor rx_data_i(23 downto 16) 
                                     xor rx_data_i(15 downto 8);
                    
                        state := 1;
                    
                    end if;
                    
                -- Prepare the request and check CRC
                elsif (state = 1) then    
                
                    if (register_byte(7) = '1') then
                    
                        data_byte := rbus_i(to_integer(unsigned(register_byte(6 downto 0))));
                        
                    else
                    
                        wbus_o(to_integer(unsigned(register_byte(6 downto 0)))) <= data_byte;
                        
                    end if;
                    
                    if (crc_check = crc_byte) then
                        
                        state := 2;
                        
                    else 
                    
                        state := 0;
                        
                    end if;
                
                -- Execute the request (if write)
                elsif (state = 2) then
                
                    if (register_byte(7) = '0') then
                    
                        wbus_t(to_integer(unsigned(register_byte(6 downto 0)))) <= '1';
                    
                    end if;
                    
                    state := 3;
                
                -- Reset the strobes and compute the CRC
                elsif (state = 3) then
                
                    wbus_t(to_integer(unsigned(register_byte(6 downto 0)))) <= '0';
                
                    crc_byte := def_gtp_regs 
                                xor data_byte(31 downto 24) 
                                xor data_byte(23 downto 16) 
                                xor data_byte(15 downto 8) 
                                xor data_byte(7 downto 0) 
                                xor register_byte;
                    
                    state := 4;
                    
                -- Sending back ready signal
                elsif (state = 4) then
                    
                    tx_data_o <= data_byte & register_byte & crc_byte;
                    
                    tx_ready_o <= '1';
                    
                    state := 5;
                    
                -- Wait for done
                elsif (state = 5) then
                
                    if (tx_done_i = '1') then
                    
                        tx_ready_o <= '0';
                        
                        state := 0;
                        
                    end if;
                    
                else
            
                    tx_ready_o <= '0';

                    wbus_t <= (others => '0');
                    
                    state := 0;
          
                end if;
            
            end if;

        end if;

    end process;

end rtl;
