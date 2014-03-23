--=================================================================================================--
--==================================== module information =========================================--
--=================================================================================================--
--																																  	--
-- company:  					cern (ph-ese-be)																			--
-- engineer: 					manoel barros marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- create date:		    	10/02/2012     																			--
-- project name:				cdce_phase_monitoring													            --
-- module name:   		 	cdce_phase_monitoring 		 										               --
-- 																																--
-- language:					vhdl'93																						--
--																																	--
-- target devices: 			glib (virtex 6)	   																	--
-- tool versions: 			ise 13.2																						--
--																																	--
-- revision:		 			1.0 																							--
--																																	--
-- additional comments: 																									--
--																																	--
--=================================================================================================--
--=================================================================================================--
-- ieee vhdl standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
-- xilinx devices library:
library unisim;
use unisim.vcomponents.all;
-- user libraries and packages:
use work.cdce_phase_monitoring_package.all;
--=================================================================================================--
--======================================= module body =============================================-- 
--=================================================================================================--
entity cdce_phase_monitoring is
port 
(	
		reset_i					: in  std_logic;
		--- iodelay i/f -----
		clk200mhz_i				: in  std_logic;
		--- cdce i/f --------
		cdce_clkin_i			: in  std_logic;
		cdce_clkout_i_p		: in  std_logic;
		cdce_clkout_i_n		: in  std_logic;
		cdce_sync_done_i		: in  std_logic;
		cdce_sync_busy_i		: in  std_logic;
		cdce_clkout_o			: out std_logic;
		--- ipbus i/f -------
		ipbusclk_i				: in  std_logic;
		exp_signature_i		: in  std_logic_vector(143 downto 0);
		signature_mask_i		: in  std_logic_vector(143 downto 0);
		signature_o				: out std_logic_vector(143 downto 0);
		signature_match_o		: out std_logic;		-- free running
		signature_mismatch_o	: out std_logic;		-- latched, inverted
		signature_valid_o		: out std_logic;
		error_count_o			: out std_logic_vector(11 downto 0)
	);	
end cdce_phase_monitoring;
architecture structural of cdce_phase_monitoring is
	--======================== signal declarations ========================--
			
	-- signals:		
	signal clk240mhz_0									: std_logic;	
	signal clk240mhz_1									: std_logic;	
	signal clk40mhz										: std_logic;	
	signal pll_locked										: std_logic;	
	signal delayctrl_rdy									: std_logic;	
	signal delayedsignal									: std_logic_vector(11 downto 0);
	signal reg0												: std_logic_vector(11 downto 0);	
	signal reg0_buff										: regbufft;
	signal reg1												: std_logic_vector(11 downto 0);	
	signal reg1_buff										: regbufft;
	signal interleaver									: std_logic_vector(143 downto 0);

	signal signature_match_r							: std_logic;
	signal signature_mismatch_r						: std_logic;
	
	signal error_count_r									: std_logic_vector(14 downto 0);
	
	signal exp_signature									: std_logic_vector(143 downto 0);
	signal exp_signature_r								: std_logic_vector(143 downto 0);
	signal exp_signature_masked						: std_logic_vector(143 downto 0);
	signal exp_signature_masked_r						: std_logic_vector(143 downto 0);

	signal signature_mask								: std_logic_vector(143 downto 0);	
	signal signature_mask_r								: std_logic_vector(143 downto 0);
	
	signal acq_signature_r								: std_logic_vector(143 downto 0);
	signal acq_signature_masked						: std_logic_vector(143 downto 0);
--	signal acq_signature_masked_r						: std_logic_vector(143 downto 0);

	signal inv_signature_mask							: std_logic_vector(143 downto 0);
	signal inv_signature_mask_r						: std_logic_vector(143 downto 0);

	signal superposed_signature						: std_logic_vector(143 downto 0);
	signal superposed_signature_r						: std_logic_vector(143 downto 0);
	
	signal monitoring_busy								: std_logic;
	
	signal cdce_clkout_i									: std_logic;
	
	signal signature_valid_r							: std_logic;		

	signal cdce_sync_busy_clk40mhz					: std_logic;
	signal cdce_sync_done_clk40mhz					: std_logic;
	signal cdce_sync_done_clk240mhz_0				: std_logic;
	signal cdce_sync_done_clk240mhz_1				: std_logic;
	signal cdce_sync_done_clk240mhz_0_r				: std_logic;
	signal cdce_sync_done_clk240mhz_1_r				: std_logic;
	
	signal final_signature_r							: std_logic_vector(143 downto 0);
	signal signatures_ready								: std_logic;
	

	
	signal fsm												: std_logic_vector(1 downto 0);
	attribute keep 		 								: boolean;

	attribute keep of fsm 									: signal is true;
	attribute keep of cdce_sync_done_clk240mhz_0_r 	: signal is true;
	attribute keep of cdce_sync_done_clk240mhz_1_r 	: signal is true;
	
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== architecture body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--============================ user logic =============================--	



	--=============================--
		cdce_clkout_ibufgds: ibufgds
	--=============================--
		generic map (capacitance => "dont_care", diff_term => true, ibuf_delay_value => "0", iostandard => "lvds_25")	
		port map 	(i => cdce_clkout_i_p, ib => cdce_clkout_i_n, o => cdce_clkout_i);	
	--=============================--

	CDCE_CLKOUT_O <= cdce_clkout_i;



	--====================================--
	fastclk_0_process: process(clk240mhz_0)
	--====================================--
		variable sel	: std_logic_vector(2 downto 0);
	begin
		if rising_edge(clk240mhz_0) then				
			
			case sel is
				when "000" => reg0_buff(0)	<= reg0;						
				when "001" => reg0_buff(1)	<= reg0;						
				when "010" => reg0_buff(2)	<= reg0;						
				when "011" => reg0_buff(3)	<= reg0;						
				when "100" => reg0_buff(4)	<= reg0;						
				when "101" => reg0_buff(5)	<= reg0;						
				when others =>
			end case;	
			reg0	<= delayedsignal;		
			
			if cdce_sync_done_clk240mhz_0_r = '1' then	
				if sel = "101" then sel := "000"; 		else sel:= sel+1;			end if;				
			else
				--sel		 := "000";
				sel		 := "001";
			end if;	
			cdce_sync_done_clk240mhz_0_r <= cdce_sync_done_clk240mhz_0;	
			
		end if;
	end process;
	--====================================--


--           +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+	
-- clk240_0  | |  | |  | |  | |  | |  | |  | |  | |  | |  | |  | |  | |		
--         --+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +	

--             +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+	
-- clk240_180  | |  | |  | |  | |  | |  | |  | |  | |  | |  | |  | |  | |		
--         ----+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +--+ +	

--           +--------------+              +--------------+              
-- clk40_0   |              |              |              |              
--       ----+              +--------------+              +--------------

--                                         +-----------------------------
-- sync_done                               |                             
--       ----------------------------------+                             



	--====================================--
	fastclk_1_process: process(clk240mhz_1)
	--====================================--
		variable sel 	 	: std_logic_vector( 2 downto 0);
		variable reg_r		: std_logic_vector(11 downto 0);
		variable sync_r 	: std_logic;
	begin
		if rising_edge(clk240mhz_1) then				
			
			case sel is
				when "000" => reg1_buff(0)	<= reg1;						
				when "001" => reg1_buff(1)	<= reg1;						
				when "010" => reg1_buff(2)	<= reg1;						
				when "011" => reg1_buff(3)	<= reg1;						
				when "100" => reg1_buff(4)	<= reg1;						
				when "101" => reg1_buff(5)	<= reg1;						
				when others =>
			end case;	
			reg1	<= delayedsignal;		
			
			--if cdce_sync_done_clk240mhz_1 = '1' and sync_r ='1' then 
			--if cdce_sync_done_clk240mhz_1 = '1' then 
			
			--if sync_r = '1' then
			if cdce_sync_done_clk240mhz_1_r = '1' then
			-- the falling edge sees the sync done earlier than the rising edge
			-- therefore it has to wait one clock cycle for assembling correctly the signature
				if sel = "101" then sel := "000"; 		else sel:= sel+1;			end if;				
			else
				--sel		 := "000";
				sel		 := "001";
			end if;
			cdce_sync_done_clk240mhz_1_r <= cdce_sync_done_clk240mhz_0_r;
--			sync_r := cdce_sync_done_clk240mhz_1_r;
--						 cdce_sync_done_clk240mhz_1_r <= cdce_sync_done_clk240mhz_1;	
		end if;
	end process;
	--====================================--


	--====================================--
	slowclk_sync_process: process(reset_i, clk40mhz)		
	--====================================--
	begin
		if reset_i = '1' then 	
			interleaver										<= (others => '0');			
		elsif rising_edge(clk40mhz) then
			-- signature interleaving:				
			interleaver( 11 downto   0)				<= reg0_buff(0);	
			interleaver( 23 downto  12)				<= reg1_buff(0);	
			interleaver( 35 downto  24)				<= reg0_buff(1);
			interleaver( 47 downto  36)				<= reg1_buff(1);
			interleaver( 59 downto  48)				<= reg0_buff(2);
			interleaver( 71 downto  60)				<= reg1_buff(2);
			interleaver( 83 downto  72)				<= reg0_buff(3);
			interleaver( 95 downto  84)				<= reg1_buff(3);
			interleaver(107 downto  96)				<= reg0_buff(4);
			interleaver(119 downto 108)				<= reg1_buff(4);
			interleaver(131 downto 120)				<= reg0_buff(5);	
			interleaver(143 downto 132)				<= reg1_buff(5);

		end if;	
	end process;	
	--====================================--
		
	
	
	--====================================--	
	slowclk_process: process(reset_i, clk40mhz)					
	--====================================--	
		variable timer			: integer;
		variable count			: integer range 0 to 255;
		constant usec			: integer:= 40; -- cycles of 25ns
	begin
		if reset_i = '1' then 			
			fsm	<= "00";
		elsif rising_edge(clk40mhz) then	
			
			error_count_r	<= conv_std_logic_vector(count, 15);
			
			case fsm is
				
				--======--
				when "00" => --idle
				--======--
				
					signature_valid_r			<= '0';
					signature_mismatch_r		<= '0';
					monitoring_busy			<= '0';
					if cdce_sync_done_clk40mhz = '1' then
						fsm						<= "01";
						timer						:= 1000*usec; --initdelay;
					end if;
				
				--======--
				when "01" =>				
				--======--
					
					if timer = 0 then
						fsm						<= "10";
						timer						:= 5*usec; -- 200 iterations @ 40MHz
						count						:= 0;
					else
						timer						:=timer-1;
						if timer=3 then monitoring_busy	<= '1'; end if;
					end if;
				
				--======--
				when "10" =>			
				--======--
				
					if timer = 0 then
						monitoring_busy		<= '0';
						signature_valid_r		<= '1';
						if cdce_sync_done_clk40mhz = '0' and cdce_sync_busy_clk40mhz='1' then fsm<= "00"; end if;-- ongoing cdce sync
					
					else		
						if final_signature_r = exp_signature_masked_r then
								signature_match_r			<= '1';
						else					
								signature_mismatch_r		<= '1';
								signature_match_r			<= '0';
								count						:= count+1;							
						end if;
						timer := timer - 1;
					end if;

				--======--
				when others =>			
				--======--
									
			end case;	
		end if;	
	end process;		
	--====================================--
	
	

	--====================================--
	rnm: for i in 0 to 143 generate
	--====================================--
		
		reg_n_mask: process(reset_i, clk40mhz)		
			variable busy_r		: std_logic;
			variable busy_rr		: std_logic;
			variable busy_rrr		: std_logic;
		begin
			if reset_i ='1' then
					--
					exp_signature_masked_r(i)	<= '0';
--					acq_signature_masked_r(i)	<= '0';
					superposed_signature_r(i)	<= '0';
					final_signature_r		 (i)	<= '0';		
					--					
					busy_r							:= '0';
					busy_rr							:= '0';
					busy_rrr							:= '0';
					signatures_ready				<= '0';
					--					
			elsif rising_edge(clk40mhz) then	
				--
				if cdce_sync_done_clk40mhz = '0' and cdce_sync_busy_clk40mhz='1' then -- ongoing cdce sync
					--
					exp_signature_masked_r(i)	<= '0';
--					acq_signature_masked_r(i)	<= '0';
					superposed_signature_r(i)	<= '0';
					final_signature_r(i)			<= '0';
					--
				else

					if busy_r = '1' and monitoring_busy = '1' then
						--
						exp_signature_masked_r(i)	<= exp_signature_r(i) and (not signature_mask_r(i));
--						acq_signature_masked_r(i)	<= acq_signature_r(i) and (not signature_mask_r(i));
						--	
					end if;

					if busy_rr = '1' and monitoring_busy = '1' then
						if (acq_signature_r(i)='1' and exp_signature_r(i)='0') or (acq_signature_r(i)='0' and exp_signature_r(i)='1') then
							--	
							superposed_signature_r(i)	<= '1'; 	-- 1 -> bit mismatch at least once
							--	
						end if;
						--																									
					end if;

					if busy_rrr = '1' and monitoring_busy = '1' then
						if superposed_signature_r(i)='0' and exp_signature_masked_r(i)='1' then
							final_signature_r(i)	<= '1'; 	-- expected: 1 & always matched
						else
							final_signature_r(i)	<= '0';
						end if;
						--																									
					end if;

					
					
					--				
				end if;
				--
				busy_rrr:= busy_rr;
				busy_rr := busy_r;
				busy_r  := monitoring_busy;
				--
			end if;	
		end process;	
	end generate;
	--====================================--


	--====================================--
	reg: process(reset_i, clk40mhz)		
	--====================================--
	begin
		if reset_i = '1' then
		
				exp_signature_r 			<= (others => '0')		;
				signature_mask_r 			<= (others => '0')		;
		
		elsif rising_edge(clk40mhz) then	
		
			exp_signature_r 				<= exp_signature			;
			signature_mask_r 				<= signature_mask			;
			acq_signature_r				<= interleaver				;

		end if;	
	end process;	
	--====================================--



	--===================== component instantiations ======================--
	dpm: entity work.dual_port_memory
		port map (
			clk 												=> clk40mhz,
			we 												=> '1',
			a 													=> "0000",
			d(143 downto   0)								=> final_signature_r, --superposed_signature_r, --acq_signature_r,
			d(155 downto 144)								=> error_count_r(11 downto 0),
			d(156)											=> '0',
			d(157)											=> signature_valid_r,
			d(158)											=> signature_mismatch_r,
			d(159)											=> signature_match_r,
			--------------------
			qdpo_clk 										=> ipbusclk_i,
			dpra 												=> "0000",			
			qdpo(143 downto   0)							=> signature_o,
			qdpo(155 downto 144)							=> error_count_o,
			qdpo(156)										=> open,
			qdpo(157)										=> signature_valid_o,
			qdpo(158)										=> signature_mismatch_o,
			qdpo(159)										=> signature_match_o
		);	


	dpm2: entity work.dual_port_memory
		port map (
			clk 												=> ipbusclk_i,
			we 												=> '1',
			a 													=> "0000",
			d(143 downto   0)								=> exp_signature_i,
			d(159 downto 144)								=> (others => '0'),
			--------------------
			qdpo_clk 										=> clk40mhz,
			dpra 												=> "0000",			
			qdpo(143 downto   0)							=> exp_signature,
			qdpo(144)										=> open, 
			qdpo(159 downto 145)							=> open
		);	
		
	dpm3: entity work.dual_port_memory
		port map (
			clk 												=> ipbusclk_i,
			we 												=> '1',
			a 													=> "0000",
			d(143 downto   0)								=> signature_mask_i,
			d(159 downto 144)								=> (others => '0'),
			--------------------
			qdpo_clk 										=> clk40mhz,
			dpra 												=> "0000",			
			qdpo(143 downto   0)							=> signature_mask,
			qdpo(159 downto 144)							=> open
		);	


	cdce_sync_done_clk240mhz_0 <= cdce_sync_done_i;
	cdce_sync_done_clk240mhz_1 <= cdce_sync_done_i;
	cdce_sync_done_clk40mhz		<= cdce_sync_done_i;
	cdce_sync_busy_clk40mhz		<= cdce_sync_busy_i;
	

--	dpm4: entity work.dual_port_memory
--		port map (
--			clk 												=> cdce_clkin_i,
--			we 												=> '1',
--			a 													=> "0000",
--			d(0)												=> cdce_sync_done_i,
--			d(159 downto 1)								=> (others => '0'),
--			--------------------
--			qdpo_clk 										=> clk240mhz_0,
--			dpra 												=> "0000",			
--			qdpo(0)											=> cdce_sync_done_clk240mhz_0,
--			qdpo(159 downto 1)							=> open
--		);	
--
--	dpm5: entity work.dual_port_memory
--		port map (
--			clk 												=> cdce_clkin_i,
--			we 												=> '1',
--			a 													=> "0000",
--			d(0)												=> cdce_sync_done_i,
--			d(159 downto 1)								=> (others => '0'),
--			--------------------
--			qdpo_clk 										=> clk240mhz_1,
--			dpra 												=> "0000",			
--			qdpo(0)											=> cdce_sync_done_clk240mhz_1,
--			qdpo(159 downto 1)							=> open
--		);	
--
--	dpm6: entity work.dual_port_memory
--		port map (
--			clk 												=> cdce_clkin_i,
--			we 												=> '1',
--			a 													=> "0000",
--			d(0)												=> cdce_sync_done_i,
--			d(1)												=> cdce_sync_busy_i,
--			d(159 downto 2)								=> (others => '0'),
--			--------------------
--			qdpo_clk 										=> clk40mhz,
--			dpra 												=> "0000",			
--			qdpo(0)											=> cdce_sync_done_clk40mhz,
--			qdpo(1)											=> cdce_sync_busy_clk40mhz,
--			qdpo(159 downto 2)							=> open
--		);	


	------------------------------------------------------------------------------
	-- "output    output      phase     duty      pk-to-pk        phase"
	-- "clock    freq (mhz) (degrees) cycle (%) jitter (ps)  error (ps)"
	------------------------------------------------------------------------------
	-- "output    output      phase     duty      pk-to-pk        phase"
	-- "clock    freq (mhz) (degrees) cycle (%) jitter (ps)  error (ps)"
	------------------------------------------------------------------------------
	-- clk_out1___240.000_____-9.000______50.0______125.580____166.174
	-- clk_out2___240.000____189.000______50.0______125.580____166.174
	-- clk_out3____40.000_____-1.500______50.0______169.737____166.174
	--
	------------------------------------------------------------------------------
	-- "input clock   freq (mhz)    input jitter (ui)"
	------------------------------------------------------------------------------
	-- __primary______________40____________0.001
	--
	pll: entity work.cdce_phase_monitoring_pll
		port map (
			-- clock in ports:
			clk_in1 											=> cdce_clkin_i,
			-- clock out ports:
			clk_out1 										=> clk240mhz_0,
			clk_out2 										=> clk240mhz_1,
			clk_out3											=> clk40mhz,
			-- status and control signals:
			reset  											=> '0',
			locked 											=> pll_locked
		);

		--clk40mhz <= cdce_clkin_i;

	delayctrl: idelayctrl		
		port map (		
			rdy 												=> delayctrl_rdy,			
			refclk 											=> clk200mhz_i, 		
			rst 												=> reset_i 					
		);		

	delay_13_parallel: for i in 11 downto 0 generate
		io_delay: iodelaye1
			generic map (
				cinvctrl_sel 								=> false,      			-- enable dynamic clock inversion (true/false)
				delay_src 									=> "clkin",       		-- delay input ("i", "clkin", "datain", "io", "o")
				high_performance_mode 					=> true, 					-- reduced jitter (true), reduced power (false)
				idelay_type 								=> "fixed",					-- "default", "fixed", "variable", or "var_loadable" 
				idelay_value 								=> dly_tap_values(i),   -- input delay tap setting (0-31)
				odelay_type 								=> "fixed",					-- "fixed", "variable", or "var_loadable" 
				odelay_value 								=> 0,							-- output delay tap setting (0-31)
				refclk_frequency 							=> 200.0,      			-- idelayctrl clock input frequency in mhz
				signal_pattern 							=> "clock")     			-- "data" or "clock" input signal			
			port map (						
				cntvalueout 								=> open,						-- 5-bit output: counter value output
				dataout 										=> delayedsignal(i),		-- 1-bit output: delayed data output
				c 												=> '0',						-- 1-bit input: clock input
				ce 											=> '0',           		-- 1-bit input: active high enable increment/decrement input
				cinvctrl 									=> '0',       				-- 1-bit input: dynamic clock inversion input
				clkin 										=> cdce_clkout_i,		-- 1-bit input: clock delay input
				cntvaluein 									=> (others => '0'),		-- 5-bit input: counter value input
				datain 										=> '0',           		-- 1-bit input: internal delay data input
				idatain	 									=> '0',         			-- 1-bit input: data input from the i/o
				inc 											=> '0',  		         -- 1-bit input: increment / decrement tap delay input
				odatain 										=> '0',         			-- 1-bit input: output delay data input
				rst 											=> '0',             		-- 1-bit input: active-high reset tap-delay input
				t 												=> '1'                  -- 1-bit input: 3-state input (ug361 page 105)
			);			
	end generate;
	
	--=====================================================================--
end structural;
--=================================================================================================--
--=================================================================================================--