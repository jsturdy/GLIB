library ieee;
use ieee.std_logic_1164.all;

--! xilinx packages
library unisim;
use unisim.vcomponents.all;

entity gtx_clocking is
port(
    gtx_clk_p   : in std_logic;
    gtx_clk_n   : in std_logic;
    gtx_clk     : out std_logic
);
end gtx_clocking;

architecture Behavioral of gtx_clocking is
begin

    gtx_clk_inst : ibufds_gtxe1
    port map(
        O       => gtx_clk,
        ODIV2   => open,
        CEB     => '0',
        I       => gtx_clk_p,
        IB      => gtx_clk_n
    );    

end Behavioral;

