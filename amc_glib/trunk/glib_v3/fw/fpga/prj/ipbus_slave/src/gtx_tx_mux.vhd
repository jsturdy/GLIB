library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity gtx_tx_mux is
port(
    clk             : in std_logic;
    reset           : in std_logic;
    ipb_vfat2_io    : inout vfat2_data_bus;
    tx_strobe_o     : out std_logic;
    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0)
);
end gtx_tx_mux;

architecture Behavioral of gtx_tx_mux is
begin
   
    process(clk) 
        variable state : integer range 0 to 2 := 0;
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                tx_strobe_o <= '0';
                tx_kchar_o <= "01";
                tx_data_o <= x"00BC";
                ipb_vfat2_io.acknowledge <= '0';
                state := 0;
            else
                -- Acknowledgment
                if (ipb_vfat2_io.strobe = '0' and ipb_vfat2_io.acknowledge = '1') then
                    ipb_vfat2_io.acknowledge <= '0';
                end if;
            
                if (state = 0) then     
                    -- VFAT2 IPBus Output data
                    if (ipb_vfat2_io.strobe = '1' and ipb_vfat2_io.acknowledge = '0') then
                        -- GTX data
                        tx_data_o <= x"04BC"; -- 04 = VFAT2 Package type, BC is for comma detection
                        tx_kchar_o <= "01";
                        tx_strobe_o <= '1';
                        -- Acknowledgment
                        ipb_vfat2_io.acknowledge <= '1';
                        -- State
                        state := 1;
                    -- No data to send
                    else 
                        tx_strobe_o <= '0';
                        tx_kchar_o <= "01";
                        tx_data_o <= x"00BC";
                        state := 0;
                    end if;
                -- IPBus package 1
                elsif (state = 1) then
                    tx_data_o <= "00" & ipb_vfat2_io.readWrite_n & ipb_vfat2_io.chipSelect & ipb_vfat2_io.registerSelect;
                    tx_kchar_o <= "00";
                    tx_strobe_o <= '1';
                    state := 2;    
                -- IPBus package 2
                elsif (state = 2) then
                    tx_data_o <= ipb_vfat2_io.data & x"00"; -- x"00" = CRC
                    tx_kchar_o <= "00";
                    tx_strobe_o <= '1';
                    state := 0;
                else
                    tx_strobe_o <= '0';
                    tx_kchar_o <= "01";
                    tx_data_o <= x"00BC";
                    state := 0;
                end if; 
            end if;
        end if;
    end process;

end Behavioral;