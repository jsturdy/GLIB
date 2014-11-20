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
    
		if    std_match(addr, "010000000000000100000-----------") then sel := ipb_vi2c_0;   -- 0x4001XXYY     0 <= XX <= 7
		elsif std_match(addr, "010000000000000100001-----------") then sel := ipb_vi2c_1;   -- 0x4001XXYY     8 <= XX <= 15
		elsif std_match(addr, "01000000000000010001------------") then sel := ipb_vi2c_2;   -- 0x4001XXYY     16 <= XX <= 23
        
		elsif std_match(addr, "0100000000000010000000000000----") then sel := ipb_track_0;  -- 0x4002000X  
		elsif std_match(addr, "0100000000000010000000010000----") then sel := ipb_track_1;  -- 0x4002010X
		elsif std_match(addr, "0100000000000010000000100000----") then sel := ipb_track_2;  -- 0x4002020X
        
		elsif std_match(addr, "0100000000000011000000000-------") then sel := ipb_regs_0;   -- 0x400300XX  
		elsif std_match(addr, "0100000000000011000000010-------") then sel := ipb_regs_1;   -- 0x400301XX
		elsif std_match(addr, "0100000000000011000000100-------") then sel := ipb_regs_2;   -- 0x400302XX
        
		elsif std_match(addr, "010000000000010000000000--------") then sel := ipb_info_0;   -- 0x400400XX  
		elsif std_match(addr, "010000000000010000000001--------") then sel := ipb_info_1;   -- 0x400401XX
		elsif std_match(addr, "010000000000010000000010--------") then sel := ipb_info_2;   -- 0x400402XX
        
		elsif std_match(addr, "01000000000001010000000000000000") then sel := ipb_trigger;   -- 0x4005000
        
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
