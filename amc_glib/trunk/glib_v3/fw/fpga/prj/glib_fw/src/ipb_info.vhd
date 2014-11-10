library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

entity ipb_info is
port(

	ipb_clk_i   : in std_logic;
	reset_i     : in std_logic;

	ipb_mosi_i  : in ipb_wbus;
	ipb_miso_o  : out ipb_rbus;

    wbus_o      : out array32(255 downto 0);
    wbus_t      : out std_logic_vector(255 downto 0);
    rbus_i      : in array32(255 downto 0)

);
end ipb_info;

architecture rtl of ipb_info is

    signal register_select  : integer range 0 to 255 := 0;
    signal register_write   : std_logic := '0';
    signal ipb_ack          : std_logic := '0';

begin

    -- Get the IPBus parameters
    register_select <= to_integer(unsigned(ipb_mosi_i.ipb_addr(7 downto 0)));
    register_write <= ipb_mosi_i.ipb_strobe and ipb_mosi_i.ipb_write;

    -- Prepare the data to be written
    wbus_o(register_select) <= ipb_mosi_i.ipb_wdata;

    -- Write process
    process(ipb_clk_i)
    begin

        if (rising_edge(ipb_clk_i)) then

            if (reset_i = '1') then

                wbus_t <= (others => '0');

            elsif (register_write = '1') then

                wbus_t(register_select) <= '1';

            else

                wbus_t <= (others => '0');

            end if;

            ipb_ack <= ipb_mosi_i.ipb_strobe and not ipb_ack;

        end if;

    end process;

    ipb_miso_o.ipb_err <= '0';
    ipb_miso_o.ipb_ack <= ipb_ack;
    ipb_miso_o.ipb_rdata <= rbus_i(register_select);

end rtl;
