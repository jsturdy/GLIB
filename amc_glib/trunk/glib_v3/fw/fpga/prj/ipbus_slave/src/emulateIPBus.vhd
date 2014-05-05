library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity emulateIPBus is
port(
    clk             : in std_logic;
    ipb_vfat2_io    : inout vfat2_data_bus;
    vfat2_ipb_io    : inout vfat2_data_bus
);
end emulateIPBus;

architecture Behavioral of emulateIPBus is
begin

    process(clk)
        variable state : integer range 0 to 2047 := 0;
    begin
        if (rising_edge(clk)) then
            if (vfat2_ipb_io.strobe = '1' and vfat2_ipb_io.acknowledge = '0') then
                vfat2_ipb_io.acknowledge <= '1';
            end if;
            
            if (vfat2_ipb_io.strobe = '0' and vfat2_ipb_io.acknowledge = '1') then
                vfat2_ipb_io.acknowledge <= '0';
            end if;
        
        
            if (ipb_vfat2_io.acknowledge = '1') then
                ipb_vfat2_io.strobe <= '0';
            end if;
        
            if (state = 2047) then
                ipb_vfat2_io.valid <= '0';
                ipb_vfat2_io.error <= '0';
                ipb_vfat2_io.readWrite_n <= '1';
                ipb_vfat2_io.chipSelect <= "01010";
                ipb_vfat2_io.registerSelect <= x"AA";
                ipb_vfat2_io.data <= x"CC";
                ipb_vfat2_io.strobe <= '1';
                state := 0;
            else
                state := state + 1;
            end if;
        end if;
    end process;

end Behavioral;