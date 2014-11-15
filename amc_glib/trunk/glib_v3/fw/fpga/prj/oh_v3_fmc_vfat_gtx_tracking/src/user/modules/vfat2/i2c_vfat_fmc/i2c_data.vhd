LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY i2c_data IS
generic(M: integer :=1;
		    N: integer :=12);
	PORT
	(
		clk				: in  	std_logic;
		reset			: in  	std_logic;
		enable			: in  	std_logic;
		------------------------------
		clkprescaler	: in  	unsigned(11 downto 0);
		startclk_ext	: in  	std_logic;
		execstart_ext	: in  	std_logic;
		execstop_ext	: in  	std_logic;
		execwr_ext		: in  	std_logic;
		execgetack_ext	: in  	std_logic;
		execrd_ext		: in  	std_logic;
		execsendack_ext	: in  	std_logic;
		bytetowrite_ext	: in  	std_logic_vector(7 downto 0);
		byteread		: out 	std_logic_vector(7 downto 0);
		------------------------------
		completed		: out  	std_logic;
		failed			: out  	std_logic;
		------------------------------
        selected_iic    : in    integer;
		scl				: out 	std_logic_vector;
		sda_i           : in std_logic_vector;
		sda_o			: out std_logic_vector;
		sda_t			: out std_logic_vector
	); 			

END i2c_data;

ARCHITECTURE behave OF i2c_data IS

signal exec			: std_logic;
signal addr			: std_logic_vector(7 downto 0);
signal datain		: std_logic_vector(7 downto 0);
signal wr			: std_logic;
signal prescaler	: unsigned(11 downto 0);

signal en			: std_logic;
signal startclk		: std_logic;
signal execstart	: std_logic;
signal execstop 	: std_logic;
signal execwr		: std_logic;
signal execgetack	: std_logic;
signal execrd		: std_logic;
signal execsendack	: std_logic;
signal bytetowrite	: std_logic_vector(7 downto 0);

signal wrbit		: std_logic;
signal rdbit		: std_logic;
	
type datafsm_type	is 
(idle, 
startcondition_1, startcondition_2,
stopcondition_1 , stopcondition_2,
writebyte,
getack,
readbyte,
sendack
);
signal datafsm	: datafsm_type;

BEGIN
--========================--
reg_in:process(clk, reset)
--========================--
begin
if reset='1' then
	
	en			<= '0';
	prescaler	<= (others=>'0');

--	startclk	<= '0';
--	execstart	<= '0';
--	execstop	<= '0';
--	execwr		<= '0';
--	execgetack	<= '0';
--	execrd		<= '0';
--	execsendack	<= '0';
--	bytetowrite	<= (others=>'0');
	
elsif clk'event and clk='1' then
	
	en			<= enable;
	prescaler	<= clkprescaler;

--	startclk	<= startclk_ext;
--	execstart	<= execstart_ext;
--	execstop	<= execstop_ext;
--	execwr		<= execwr_ext;
--	execgetack	<= execgetack_ext;
--	execrd		<= execrd_ext;
--	execsendack	<= execsendack_ext;
--	bytetowrite	<= bytetowrite_ext;

end if;		
end process;

	startclk	<= startclk_ext;
	execstart	<= execstart_ext;
	execstop	<= execstop_ext;
	execwr		<= execwr_ext;
	execgetack	<= execgetack_ext;
	execrd		<= execrd_ext;
	execsendack	<= execsendack_ext;
	bytetowrite	<= bytetowrite_ext;

--========================--
main:process(clk, reset)
--========================--
begin
if reset='1' then
elsif clk'event and clk='1' then
end if;
end process;

--========================--
i2cscl:process(clk, reset)
--========================--
	variable timer : unsigned(11 downto 0);
	variable level : std_logic := '1';
	variable clkhasstarted : std_logic;
begin
if reset='1' then
	SCL <= (others => 'Z');
	level 	:= '1';
	clkhasstarted := '0';
	
elsif clk'event and clk='1' then
	if en = '1' then
		if clkhasstarted = '1' then
			if timer = 1 then
				level := not level;
				timer := '0' & prescaler(11 downto 1);
			else
				timer := timer - 1;
			end if;
		elsif startclk='1' then		
			level 	:= '0';
			timer	:= '0' & prescaler(11 downto 1);
			clkhasstarted :='1';
		end if;
        
        if (level = '1') then
            SCL <= (others => 'Z');
        else
            SCL <= (others => '0');
        end if;
	else
		SCL <= (others => 'Z');
		level := '0';
		clkhasstarted := '0';
		timer := '0' & prescaler(11 downto 1);
	end if;
end if;
end process;

--========================--
i2csda:process(clk, reset)
--========================--
	variable timer : unsigned(11 downto 0);
	variable byte  : std_logic_vector(7 downto 0);
	variable cnt   : integer range 0 to 15;
	variable ack   : std_logic;	
	variable samplingtime : unsigned(11 downto 0);	
begin
if reset='1' then

	wrbit		<='1';  -- read
	datafsm 	<= idle;
	
elsif clk'event and clk='1' then

	--=========--
	case datafsm is
	--=========--

		--=========--
		when idle =>
		--=========--
			completed 	<= '0';
			failed 		<= '0';
			ack	  		:= '1';
			if execstart='1' then
				datafsm <= startcondition_1;
				timer := '0' & prescaler(11 downto 1);
			elsif execstop='1' then
				datafsm <= stopcondition_1;
				timer := '0' & prescaler(11 downto 1);
			elsif execwr='1' then
				datafsm <= writebyte;
				timer := "00" & prescaler(11 downto 2); --x"01";
				byte  := bytetowrite;
				cnt	  := 8;		
			elsif execgetack='1' then
				datafsm <= getack;
				timer := prescaler;
				samplingtime:= prescaler - prescaler(11 downto 2);
			elsif execrd='1' then
				datafsm <= readbyte;
				timer := prescaler;
				samplingtime:= prescaler - prescaler(11 downto 2);
				byte  := (others=>'0');
				cnt	  := 7;		
			elsif execsendack='1' then
				datafsm <= sendack;
				timer := prescaler;
			else
				datafsm <= idle;
			end if;	
		
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@-
		--@@@@ START CONDITION
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		--=========--
		when startcondition_1 =>
		--=========--
			wrbit	<='1';
			if timer=1 then
				datafsm <= startcondition_2;
				timer := "00" & prescaler(11 downto 2);
			else
				timer:=timer-1;
			end if;
		
		--=========--
		when startcondition_2 =>
		--=========--
			if timer=1 then
				wrbit	<='0';
				datafsm <= idle;
			else
				timer:=timer-1;
			end if;

		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@-
		--@@@@ STOP CONDITION
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		
		--=========--
		when stopcondition_1 =>
		--=========--
			wrbit	<='0';
			if timer=1 then
				datafsm <= stopcondition_2;
				timer := "00" & prescaler(11 downto 2);
			else
				timer:=timer-1;
			end if;
		
		--=========--
		when stopcondition_2 =>
		--=========--
			if timer=1 then
				wrbit	<='1';
				datafsm <= idle;
			else
				timer:=timer-1;
			end if;	

		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@-
		--@@@@ WRITE BYTE
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		--=========--
		when writebyte =>
		--=========--
			if timer = (("00" & prescaler(11 downto 2)) + 2) and cnt=0 then
				datafsm <= idle;
			elsif timer=1 then
				timer := prescaler;
				wrbit <= byte(7); byte:=byte(6 downto 0) & '0';
				cnt:=cnt-1;
			else
				timer:=timer-1;
			end if;	

		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@-
		--@@@@ GET ACK
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		--=========--
		when getack =>
		--=========--

			completed <= '0'; 
			failed <= '0';
			wrbit	<='1'; -- read
			if timer=2 then
				datafsm <= idle;
			else
				if timer=samplingtime then 
					ack:=rdbit; 
					if ack='0' then 
						completed <= '1'; failed <= '0';
					else
						completed <= '0'; failed <= '1';
					end if;
				end if;
				timer:=timer-1;
			end if;	

		--=========--
		when readbyte =>
		--=========--
			wrbit	<='1'; -- read
			if timer=2 and cnt=0 then
				datafsm <= idle;
				byteread <= byte;
			elsif timer=1 then
				timer := prescaler;
				cnt:=cnt-1;
			else
				if timer=samplingtime then byte:=byte(6 downto 0) & rdbit; end if;
				timer:=timer-1;
			end if;	

		--=========--
		when sendack =>
		--=========--
			wrbit <= '0'; 
			if timer=2 then
				datafsm <= idle;
			else
				timer:=timer-1;
			end if;	

	end case;

end if;
end process;

rdbit <= sda_i(selected_iic) when wrbit = '1' else 'Z';
sda_o(selected_iic) <= '0' when wrbit = '0' else 'Z';
sda_t(selected_iic) <= '0' when wrbit = '0' else '1';

END behave;