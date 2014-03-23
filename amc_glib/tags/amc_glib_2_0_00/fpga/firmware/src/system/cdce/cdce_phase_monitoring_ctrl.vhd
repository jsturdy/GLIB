library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library unisim;
use unisim.vcomponents.all;
use work.cdce_phase_monitoring_package.all;
entity cdce_phase_monitoring_ctrl is
port 
(	
	reset_i						: in  std_logic;
	clk_i							: in  std_logic;
	sync_cmd_i					: in  std_logic;
	monitoring_status_dv_i	: in  std_logic;
	monitoring_status_i		: in  std_logic;
	forbid_retry_i				: in  std_logic;
	retries_o					: out std_logic_vector(3 downto 0);
	resync_o						: out std_logic
);	
end cdce_phase_monitoring_ctrl;

architecture arch_ipb_clk of cdce_phase_monitoring_ctrl is

constant max_retries 		: std_logic_vector(3 downto 0):="1010";
signal 	retries 				: std_logic_vector(3 downto 0);
signal 	state					: std_logic_vector(2 downto 0);
signal 	resync_r				: std_logic;


attribute keep					: boolean;
attribute keep of state		: signal is true;


	
begin

	
	--==================--
	resync_o <= resync_r;
	--==================--
	
	
	
	
process(reset_i,clk_i)
	variable dv					: std_logic;
	variable fail				: std_logic;
	variable timer				: integer range 0 to 65535;
	constant two_usec			: integer range 0 to 255  := 125;
	constant aftersyncdelay	: integer range 0 to 65535:= 500*two_usec; -- max = 1.5msec
	constant resync_uptime	: integer range 0 to 65535:= 500*two_usec; -- max = 1.5msec	
	constant resync_downtime: integer range 0 to 65535:= 500*two_usec; -- max = 1.5msec
	variable	rising			: std_logic;
	variable	falling			: std_logic;
	variable sync_cmd_prev	: std_logic;

begin

if reset_i = '1' then

	state				<= "100";
	retries 			<= "0000";
	resync_r 		<= '1';
	
	fail				:= '0';
	dv					:= '0';
	rising			:= '0';
	falling			:= '0';
	sync_cmd_prev	:= '0';
	
elsif rising_edge(clk_i) then


	if falling = '1' then
		resync_r		<= '1';
		retries		<= "0000";
		state			<= "000";
		timer			:= aftersyncdelay;
	else

		case state is

			--======--
			when "000" => 	-- init delay for timer cycles
			--======--
			
				resync_r	<= '1';		
				if timer=0 then
					state		<= "001";
				else
					timer:=timer-1;
				end if;	

			--======--
			when "001" => 	-- check	if monitoring is done
			--======--
				
				resync_r 		<= '1';
				if dv='1' then
					if fail='1' then
						if retries/=max_retries and forbid_retry_i='0' then
							state		<= "010";
							timer		:= resync_downtime;
							retries 	<= retries+1;
						else
							state		<= "101"; 	-- go to idle (failure)
						end if;
					else
						state			<= "110";	-- go to idle (success)
					end if;
				end if;			

				
			--======--
			when "010" =>	-- deassert	for resync_downtime cycles
			--======--

				resync_r	<= '0';
				if timer=0 then
					state		<= "011";
					timer		:= resync_uptime;
				else
					timer:=timer-1;
				end if;	
			
			--======--
			when "011" =>	-- assert   for resync_uptime cycles	
			--======--
			
				resync_r	<= '1';
				if timer=0 then
					state		<= "000";
					timer		:= aftersyncdelay;
				else
					timer:=timer-1;
				end if;		
				
			--======--
			when "100" =>	-- idle state, initial
			--======--
				resync_r	<= '1';		
			
			--======--
			when "101" =>	-- idle state, failure
			--======--
				resync_r	<= '1';		

			--======--
			when "110" =>	-- idle state, success
			--======--
				resync_r	<= '1';		

			
			when others =>
		end case;		
	end if;
	
	fail			:= monitoring_status_i;
	dv				:= monitoring_status_dv_i;


	if sync_cmd_prev='0' and sync_cmd_i='1' then rising :='1'; else rising :='0'; end if;
	if sync_cmd_prev='1' and sync_cmd_i='0' then falling:='1'; else falling:='0'; end if;
	sync_cmd_prev:= sync_cmd_i;



end if;
end process; 

retries_o <= retries;


end arch_ipb_clk;
