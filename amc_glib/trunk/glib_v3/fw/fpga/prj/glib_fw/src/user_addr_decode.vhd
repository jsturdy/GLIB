library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.user_package.all;

package user_addr_decode is

	function user_wb_addr_sel (signal addr : in std_logic_vector(31 downto 0)) return integer;
	function user_ipb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer;

end user_addr_decode;

package body user_addr_decode is

	function user_ipb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is
		variable sel : integer;
	begin
		if    std_match(addr, "010000000000000000000000--------") then sel := ipb_glib_global_regs;				-- 0x400000XX
		elsif std_match(addr, "010000010000000000000000--------") then sel := ipb_glib_tracking_link0_regs;		-- 0x410000XX
		elsif std_match(addr, "010000010000000000000001--------") then sel := ipb_glib_tracking_link1_regs;		-- 0x410001XX
		elsif std_match(addr, "010000010000000000000010--------") then sel := ipb_glib_tracking_link2_regs;		-- 0x410002XX
		else
			sel := 99;
		end if;
		return sel;
	end user_ipb_addr_sel;

   function user_wb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is
		variable sel : integer;
   begin
		if   std_match(addr, "100000000000000000000000--------") then  	sel := user_wb_regs;
		else
			sel := 99;
		end if;
		return sel;
	end user_wb_addr_sel;

end user_addr_decode;
