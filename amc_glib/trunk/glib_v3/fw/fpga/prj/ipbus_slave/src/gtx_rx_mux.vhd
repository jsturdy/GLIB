library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity gtx_rx_mux is
port(
    clk             : in std_logic;
    reset           : in std_logic;
    vfat2_ipb_io    : inout vfat2_data_bus;
    rx_valid_i      : in std_logic;
    rx_data_i       : in std_logic_vector(15 downto 0)
);
end gtx_rx_mux;

architecture Behavioral of gtx_rx_mux is
begin
      
    process(clk) 
        variable state : integer range 0 to 2 := 0;
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                vfat2_ipb_io.strobe <= '0';
                state := 0;
            else
                -- Acknowledge
                if (vfat2_ipb_io.strobe = '1' and vfat2_ipb_io.acknowledge = '1') then
                    vfat2_ipb_io.strobe <= '0';
                end if;       
            
                if (state = 0) then
                    if (rx_valid_i = '1') then
                        -- VFAT2 data packet
                        if (rx_data_i = x"04BC") then
                            state := 1;
                        end if;
                    end if;
                -- VFAT 1
                elsif (state = 1) then
                    vfat2_ipb_io.error <= rx_data_i(15);
                    vfat2_ipb_io.valid <= rx_data_i(14);
                    vfat2_ipb_io.readWrite_n <= rx_data_i(13);
                    vfat2_ipb_io.chipSelect <= rx_data_i(12 downto 8);
                    vfat2_ipb_io.registerSelect <= rx_data_i(7 downto 0);
                    state := 2;
                -- VFAT 2
                elsif (state = 2) then
                    vfat2_ipb_io.data <= rx_data_i(15 downto 8);
                    if (vfat2_ipb_io.strobe = '0' and vfat2_ipb_io.acknowledge = '0') then
                        vfat2_ipb_io.strobe <= '1';
                    end if;       
                    state := 0;   
                else
                    state := 0;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;

