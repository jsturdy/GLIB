library ieee;
use ieee.std_logic_1164.all;
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
		--              addr, "00------------------------------" is reserved (system ipbus fabric)
		if    std_match(addr, "010000000000000100000-----------") then sel := ipbus_vfat2_0;
		elsif std_match(addr, "010000000000000100001-----------") then sel := ipbus_vfat2_1;
		elsif std_match(addr, "01000000000000010001------------") then sel := ipbus_vfat2_2;
		elsif std_match(addr, "0100000000000010000000000000----") then sel := ipbus_tracking_0;
		elsif std_match(addr, "0100000000000010000000000001----") then sel := ipbus_tracking_1;
		elsif std_match(addr, "0100000000000010000000000010----") then sel := ipbus_tracking_2;
		elsif std_match(addr, "01000000000000110000000000000---") then sel := ipbus_fast_signals;
		elsif std_match(addr, "01000000000001000000000000000000") then sel := ipbus_test;
		elsif std_match(addr, "010000000000010100000000--------") then sel := ipbus_oh_registers_1;
		elsif std_match(addr, "010000000000010100000000--------") then sel := ipbus_oh_registers_0;
		elsif std_match(addr, "010000000000010100000000--------") then sel := ipbus_oh_registers_2;
--		 elsif std_match(addr, "01000000000000000000000100000000") then sel := user_ipb_timer; -- xx
		--              addr, "1-------------------------------" is reserved (wishbone fabric)
		else	
			sel := 99;
		end if;
		return sel;
	end user_ipb_addr_sel;

   function user_wb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is
		variable sel : integer;
   begin
		--              addr, "00------------------------------" is reserved (system ipbus fabric)
		--              addr, "01------------------------------" is reserved (user ipbus fabric)
		if    std_match(addr, "100000000000000000000000--------") then  	sel := user_wb_regs;
--		elsif std_match(addr, "10000000000000000000000100000000") then		sel := user_wb_timer; -- xx
		else	
			sel := 99;
		end if;
		return sel;
	end user_wb_addr_sel; 

end user_addr_decode;