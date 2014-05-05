library ieee;
use ieee.std_logic_1164.all;

--! xilinx packages
library unisim;
use unisim.vcomponents.all;

entity gtxClocking is
port(
    gtxClk_p    : in std_logic;
    gtxClk_n    : in std_logic;
    gtxClk      : out std_logic
);
end gtxClocking;

architecture Behavioral of gtxClocking is
begin

    gtx_clk_inst : ibufds_gtxe1
    port map(
        O       => gtxClk,
        ODIV2   => open,
        CEB     => '0',
        I       => gtxClk_p,
        IB      => gtxClk_n
    );    

end Behavioral;

