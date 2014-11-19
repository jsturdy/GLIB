library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.user_package.all;

entity clock_control is
port(

    fpga_clk_i          : in std_logic;
    vfat2_clk_fpga_i    : in std_logic;
    vfat2_clk_ext_i     : in std_logic;
    cdce_clk_rec_i      : in std_logic;
    
    fpga_pll_locked_i   : in std_logic;
    rec_pll_locked_i    : in std_logic;
    cdce_pll_locked_i   : in std_logic;
    
    vfat2_clk_o         : out std_logic;
    cdce_clk_o          : out std_logic;
   
    vfat2_src_select_i  : in std_logic;
    vfat2_fallback_i    : in std_logic;
    vfat2_reset_src_o   : out std_logic;
    
    cdce_src_select_i   : in std_logic_vector(1 downto 0);
    cdce_fallback_i     : in std_logic;
    cdce_reset_src_o    : out std_logic

);
end clock_control;

architecture Behavioral of clock_control is
begin 
    
    vfat2_clk_o <= vfat2_clk_fpga_i when vfat2_src_select_i = '0' else vfat2_clk_ext_i;
    
    cdce_clk_o <= vfat2_clk_fpga_i when cdce_src_select_i = "00" else 
                  vfat2_clk_ext_i when cdce_src_select_i = "01" else 
                  cdce_clk_rec_i when cdce_src_select_i = "10" else
                  vfat2_clk_fpga_i;

end Behavioral;

