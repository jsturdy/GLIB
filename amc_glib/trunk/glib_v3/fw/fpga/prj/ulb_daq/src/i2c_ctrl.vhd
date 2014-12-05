LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY i2c_ctrl_vfat IS
	PORT
	(
		clk				: in  	std_logic;
		reset			: in  	std_logic;
		------------------------------
		enable			: in  	std_logic;
		------------------------------
		clkprescaler	: in  	unsigned(11 downto 0);
		executestrobe	: in  	std_logic;
		ralmode			: in  	std_logic;
		slaveaddress	: in  	std_logic_vector(7 downto 0);
		slaveregister	: in  	std_logic_vector(7 downto 0);
		datatoslave		: in  	std_logic_vector(7 downto 0);
		writetoslave	: in  	std_logic;
		------------------------------
		startclk		: out  	std_logic;
		execstart		: out 	std_logic;
		execstop		: out 	std_logic;
		execwr			: out 	std_logic;
		execgetack		: out 	std_logic;
		execrd			: out 	std_logic;
		execsendack		: out 	std_logic;
		bytetowrite		: out 	std_logic_vector(7 downto 0);
		------------------------------
		completed		: in  	std_logic;
		failed			: in  	std_logic;
		------------------------------
		addr_out		: out   std_logic_vector(7 downto 0);
		reg_out			: out   std_logic_vector(7 downto 0);
		wrdata_out		: out   std_logic_vector(7 downto 0);
		wr_out			: out   std_logic;
		ral_out			: out   std_logic;
		------------------------------
		busy			: out   std_logic;
		done			: out   std_logic;
		error_rdack1	: out   std_logic;
		error_rdack2	: out   std_logic;
		error_rdack3	: out   std_logic;
		error_rdack4	: out   std_logic;
		error			: out   std_logic
	);

END i2c_ctrl_vfat;

ARCHITECTURE behave OF i2c_ctrl_vfat IS



signal enable_reg		: std_logic;

signal executestrobe_reg: std_logic;
signal slaveaddress_reg	: std_logic_vector(7 downto 0);
signal slaveregister_reg: std_logic_vector(7 downto 0);
signal datatoslave_reg	: std_logic_vector(7 downto 0);
signal writetoslave_reg	: std_logic;
signal clkprescaler_reg	: unsigned(11 downto 0);
signal ralmode_reg		: std_logic;

signal exec				: std_logic;
signal addr				: std_logic_vector(7 downto 0);
signal reg				: std_logic_vector(7 downto 0);
signal datain			: std_logic_vector(7 downto 0);
signal wr				: std_logic;
signal ral				: std_logic;

type ctrlfsm_type	is
(idle,
req_startclk,
req_start_1,
req_chipaddr_1,
req_getack_1,
req_regaddr,
req_getack_2,
req_wrdata,
req_getack_3,
req_stop_1,
req_start_2,
req_chipaddr_2,
req_getack_4,
req_rddata,
req_sendack,
req_stop_2
);
signal ctrlfsm		: ctrlfsm_type;
signal ctrlfsmprev	: ctrlfsm_type;

type chopexecfsm_type	is (idle,a,b);
signal chopexecfsm	:chopexecfsm_type;


BEGIN
--========================--
reg_in:process(clk, reset)
--========================--
-- registers the input
-- signals
--========================--
	variable ff: std_logic;

begin
if reset='1' then

	enable_reg			<= '0'; ff:='0';
	executestrobe_reg	<= '0';
	slaveaddress_reg	<= (others=>'0');
	slaveregister_reg	<= (others=>'0');
	datatoslave_reg		<= (others=>'0');
	writetoslave_reg	<= '0';
	clkprescaler_reg	<= (others=>'0');
	ralmode_reg			<= '0';


elsif clk'event and clk='1' then

	enable_reg			<= ff; ff:=enable; -- 1clk delay
	executestrobe_reg	<= executestrobe;
	slaveaddress_reg	<= slaveaddress;
	slaveregister_reg	<= slaveregister;
	datatoslave_reg		<= datatoslave;
	writetoslave_reg	<= writetoslave;
	clkprescaler_reg	<= clkprescaler;
	ralmode_reg			<= ralmode;

end if;
end process;


--========================--
i2creg:process(clk, reset)
--========================--
-- latches the i2ctransaction
-- parameters
--========================--
	variable timer: unsigned(11 downto 0);
begin
if reset='1' then

	exec				<= '0';
	addr				<= (others=>'0');
	reg					<= (others=>'0');
	datain				<= (others=>'0');
	wr					<= '0';
	ral					<= '0';

	chopexecfsm 		<= idle;

elsif clk'event and clk='1' then

	case chopexecfsm is

		--=========--
		when idle =>
		--=========--
			exec <= '0';
			if executestrobe_reg='1' then
				chopexecfsm		<=  a ;
				timer			:= clkprescaler_reg;
				---------------------------------
				exec 			<= '1';
				addr			<= slaveaddress_reg;
				reg				<= slaveregister_reg;
				datain			<= datatoslave_reg;
				wr				<= writetoslave_reg;
				ral				<= ralmode_reg;
			end if;

		--=========--
		when a =>
		--=========--
			if timer=0 then
				exec 			<= '0';
				chopexecfsm		<=  b ;
			else
				exec 			<= '1';
				timer			:=timer-1;
			end if;

		--=========--
		when b =>
		--=========--
			exec <= '0';
			if executestrobe_reg='0' then
				chopexecfsm		<= idle;
			end if;
	end case;
end if;
end process;


--========================--
main:process(clk, reset)
--========================--

variable timer			: unsigned(11 downto 0);
variable stdWR, stdRD  	: std_logic;
variable ralWR, ralRD	: std_logic;
variable cnt			: integer range 0 to 7;
variable startclkfsm	: std_logic;
variable interrupted	: std_logic;
variable clkhasstarted	: std_logic;
begin
if reset='1' then

	ctrlfsm		<= idle; ctrlfsmprev <= idle;
	startclk	<= '0';
	execstart	<= '0';
	execstop	<= '0';
	execwr		<= '0';
	execgetack	<= '0';
	execrd		<= '0';
	execsendack	<= '0';

	busy 		<= '0';
	done		<= '0';
	error		<= '0'; 	interrupted := '0';
	-------------------
	error_rdack1<= '0';
	error_rdack2<= '0';
	error_rdack3<= '0';
	error_rdack4<= '0';
	-------------------

	clkhasstarted:='0';

	stdWR 		:= '0';
	stdRD 		:= '0';
	ralWR 		:= '0';
	ralWR 		:= '0';

elsif clk'event and clk='1' then

	execstart	<= '0';
	execstop	<= '0';
	execwr		<= '0';
	execgetack	<= '0';
	execrd		<= '0';
	execsendack	<= '0';

	if enable_reg='1' then
		--=================--
		-- error handling
		--=================--
		if failed='1' then
			interrupted := '1';
			-------------------
			--intividual report
			-------------------
			if ctrlfsmprev=req_getack_1 then
				error_rdack1<= '1';
				error_rdack2<= '0';
				error_rdack3<= '0';
				error_rdack4<= '0';
			elsif ctrlfsmprev=req_getack_2 then
				error_rdack1<= '0';
				error_rdack2<= '1';
				error_rdack3<= '0';
				error_rdack4<= '0';
			elsif ctrlfsmprev=req_getack_3 then
				error_rdack1<= '0';
				error_rdack2<= '0';
				error_rdack3<= '1';
				error_rdack4<= '0';
			elsif ctrlfsmprev=req_getack_4 then
				error_rdack1<= '0';
				error_rdack2<= '0';
				error_rdack3<= '0';
				error_rdack4<= '1';
			end if;
			ctrlfsm <= req_stop_2;
		end if;

		if timer=1 then

			--=================--
			-- main routine
			--=================--
			timer := clkprescaler_reg;

			case ctrlfsm is
				--=============--
				when idle =>
				--=============--
					interrupted 	:= '0';
					done			<= '0';
					busy			<= '0';
					if exec='1' then
						-------------------
						-- init report
						-------------------
						busy		<= '1';
						error		<= '0';
						error_rdack1<= '0';
						error_rdack2<= '0';
						error_rdack3<= '0';
						error_rdack4<= '0';
						-------------------
						-- set mode
						-------------------
						if    ral='0' and wr='1' then
							stdWR := '1';
							stdRD := '0';
							ralWR := '0';
							ralRD := '0';
						elsif ral='0' and wr='0' then
							stdWR := '0';
							stdRD := '1';
							ralWR := '0';
							ralRD := '0';
						elsif ral='1' and wr='1' then
							stdWR := '0';
							stdRD := '0';
							ralWR := '1';
							ralRD := '0';
						elsif ral='1' and wr='0' then
							stdWR := '0';
							stdRD := '0';
							ralWR := '0';
							ralRD := '1';
						end if;
						-------------------
						-- startclk once
						-------------------
						if clkhasstarted='0' then
							ctrlfsm <= req_startclk; 	ctrlfsmprev <= idle;
							clkhasstarted:='1';
						else
							ctrlfsm <= req_start_1;	 	ctrlfsmprev <= idle;
						end if;
						-------------------
					end if;

				--=============--
				when req_startclk =>
				--=============--
					startclk	<= '1';
					ctrlfsm		<= req_start_1; 		ctrlfsmprev <= req_startclk;


				--=============--
				when req_start_1 =>
				--=============--
					startclk	<= '0';
					execstart 	<= '1';
					ctrlfsm		<= req_chipaddr_1; 		ctrlfsmprev <= req_start_1;
					cnt			:= 7;

				--=============--
				when req_chipaddr_1 =>
				--=============--
					bytetowrite <= addr(6 downto 0) & stdRD; -- RW=1 when stdRD else RW=0
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_getack_1; 	ctrlfsmprev <= req_chipaddr_1;
					else
						if cnt=7 then execwr<= '1'; end if;
						cnt:=cnt-1;
					end if;

				--=============--
				when req_getack_1 =>
				--=============--
					execgetack 	<= '1';
					if    ralWR='1' then
						ctrlfsm		<= req_regaddr; 	ctrlfsmprev <= req_getack_1;
					elsif ralRD='1' then
						ctrlfsm		<= req_regaddr; 	ctrlfsmprev <= req_getack_1;
					elsif stdWR='1' then
						ctrlfsm		<= req_wrdata;  	ctrlfsmprev <= req_getack_1;
					elsif stdRD='1' then
						ctrlfsm		<= req_rddata;  	ctrlfsmprev <= req_getack_1;
					end if;

				--=============--
				when req_regaddr =>
				--=============--
					bytetowrite <= reg(6 downto 0) & ralRD;
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_getack_2;	ctrlfsmprev <= req_regaddr;
					else
						if cnt=7 then execwr<= '1'; end if;
						cnt:=cnt-1;
					end if;

				--=============--
				when req_getack_2 =>
				--=============--
					execgetack 	<= '1';
					if    ralWR='1' then
						ctrlfsm		<= req_wrdata;		ctrlfsmprev <= req_getack_2;
					elsif ralRD='1' then
						ctrlfsm		<= req_stop_1;		ctrlfsmprev <= req_getack_2;
					end if;

				--=============--
				when req_wrdata =>
				--=============--
					bytetowrite <= datain;
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_getack_3;	ctrlfsmprev <= req_wrdata;
					else
						if cnt=7 then execwr<= '1'; end if;
						cnt:=cnt-1;
					end if;

				--=============--
				when req_getack_3 =>
				--=============--
					execgetack 	<= '1';
					ctrlfsm		<= req_stop_2;			ctrlfsmprev <= req_getack_3;

				--=============--
				when req_stop_1 =>
				--=============--
					execstop 	<= '1';
					ctrlfsm		<= req_start_2;			ctrlfsmprev <= req_stop_1;

				--=============--
				when req_start_2 =>
				--=============--
					execstart 	<= '1';
					ctrlfsm		<= req_chipaddr_2;		ctrlfsmprev <= req_start_2;

				--=============--
				when req_chipaddr_2 =>
				--=============--
					bytetowrite <= addr(6 downto 0) & '1';
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_getack_4;	ctrlfsmprev <= req_chipaddr_2;
					else
						if cnt=7 then execwr<= '1'; end if;
						cnt:=cnt-1;
					end if;

				--=============--
				when req_getack_4 =>
				--=============--
					execgetack 	<= '1';
					ctrlfsm		<= req_rddata;			ctrlfsmprev <= req_getack_4;

				--=============--
				when req_rddata =>
				--=============--
					if cnt=0 then
						ctrlfsm		<= req_sendack;		ctrlfsmprev <= req_rddata;
					else
						if cnt=7 then execrd<= '1'; end if;
						cnt:=cnt-1;
					end if;

				--=============--
				when req_sendack =>
				--=============--
					execsendack	<= '1';
					ctrlfsm		<= req_stop_2;			ctrlfsmprev <= req_sendack;


				--=============--
				when req_stop_2 =>
				--=============--
					execstop 	<= '1';
					ctrlfsm		<= idle;				ctrlfsmprev <= req_stop_2;
					if interrupted='0' then
						done<= '1';error<='0';
					else
						done<= '1';error<='1';
					end if;
			end case;


-- state		| stdWR	| stdRD	| ralWR | ralRD
----------------+-------+-------+-------+-------
-- start_1		|	X	|	X	|	X	|	X
-- chipaddr_1	|	X	|	X	|	X	|	X
-- getack_1		|	X	|	X	|	X	|	X
----------------+-------+-------+-------+-------
-- regaddr_1	|	 	|    	|	X	|	X
-- getack_2		|    	|    	|	X	|	X
----------------+-------+-------+-------+-------
-- wrdata		|	X	|    	|	X	|
-- getack_3		|	X	|    	|	X	|
----------------+-------+-------+-------+-------
-- stop1		|    	|    	|    	|	X
-- start_2		|	 	|    	|    	|	X
-- chipaddr_2	|	 	|    	|    	|	X
-- getack_4		|    	|    	|    	|	X
----------------+-------+-------+-------+-------
-- rddata		|	 	|	X	|    	|	X
-- sendack		|    	|	X	|    	|	X
-- stop2		|	X	|	X	|	X	|	X



		else
			timer 	 := timer-1;
		end if;
	else
		timer 		 := clkprescaler_reg;
		clkhasstarted:='0';
	end if;

end if;
end process;

addr_out	<= addr;
reg_out		<= reg;
wrdata_out	<= datain;
wr_out		<= wr;
ral_out		<= ral;


END behave;