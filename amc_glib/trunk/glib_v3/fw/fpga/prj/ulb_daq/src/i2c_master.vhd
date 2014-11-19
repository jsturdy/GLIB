LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY i2c_master IS
PORT
(
	clk				: in  	std_logic;
	reset			: in  	std_logic;
	--- i2c registers ------------
	ctrlreg			: in  	std_logic_vector(15 downto 0);
	datareg			: in  	std_logic_vector(31 downto 0);
	statusreg		: out 	std_logic_vector(31 downto 0);
	--- ctrlsignals --------------
	busy			: out	std_logic;
	exec_str		: in  	std_logic;		
	done_str		: out	std_logic;
	------------------------------
    selected_iic    : in    integer;
	scl				: out 	std_logic_vector;
	sda_i			: in std_logic_vector;
	sda_o			: out std_logic_vector;
	sda_t			: out std_logic_vector
); 			
END i2c_master;


--===========================================
-- NOTE: the response is latched when ctrl_done=1
--===========================================



ARCHITECTURE hierarchy OF i2c_master IS


--- i2c ctrl register --------
signal ignoreack	:std_logic;
signal enable		:std_logic;
signal clkprescaler	:unsigned(11 downto 0);
--- i2c data register --------
signal ralmode		:std_logic;
signal writetoslave	:std_logic;	
signal slaveaddress	:std_logic_vector(7 downto 0);
signal slaveregister:std_logic_vector(7 downto 0);
signal datatoslave	:std_logic_vector(7 downto 0);
--- i2c status register ------
signal status		:std_logic_vector(31 downto 0);	

signal datafromslave:std_logic_vector(7 downto 0);	
signal error_rdack1	:std_logic;		
signal error_rdack2	:std_logic;		
signal error_rdack3	:std_logic;		
signal error_rdack4	:std_logic;		
signal error		:std_logic;
signal addr_out		:std_logic_vector(7 downto 0);
signal reg_out		:std_logic_vector(7 downto 0);
signal wrdata_out	:std_logic_vector(7 downto 0);
signal wr_out		:std_logic;
signal ral_out		:std_logic;
------------------------------
signal done_dld		:std_logic;
signal busy_dld		:std_logic;

signal ctrl_done	:std_logic;
signal ctrl_busy	:std_logic;
signal startclk		:std_logic;
signal execstart	:std_logic;
signal execstop		:std_logic;
signal execwr		:std_logic;
signal execgetack	:std_logic;
signal execrd		:std_logic;
signal execsendack	:std_logic;
signal bytetowrite	:std_logic_vector(7 downto 0);
signal completed	:std_logic;
signal failed		:std_logic;
signal noack		:std_logic;


BEGIN


--===========================================
-- i2c ctrl register
--===========================================
-- [15] 	= ignore_failures
-- [12] 	= enable
-- [9:0] 	= prescaler
--===========================================
enable 			<= 		ctrlreg(12);
clkprescaler	<= 		unsigned(ctrlreg(11 downto 0));
--===========================================
process(clk)
--===========================================
begin
if clk'event and clk='1' then
	ignoreack <= ctrlreg(15);
end if;
end process;
--===========================================
-- i2c data register
--===========================================
-- [25] 	= rl (ralmode)	   
-- [24] 	= wr (write)	   
-- [23] 	= not used		   
-- [22:16] 	= ad (addr)		   
-- [15] 	= not used		   
-- [14: 8] 	= rg (reg)		   
-- [ 7: 0] 	= dw (datatowrite)
--===========================================
ralmode		<=datareg(25);
writetoslave	<= datareg(24);
slaveaddress	<= '0'& datareg(22 downto 16);
slaveregister	<= '0'& datareg(14 downto 8 );
datatoslave	<= datareg( 7 downto 0 );
--===========================================
-- i2c status register
--===========================================
-- [31] 	= e4 (error_rdack4)
-- [30] 	= e3 (error_rdack3)
-- [29] 	= e2 (error_rdack2)
-- [28] 	= e1 (error_rdack1)
-- [27]		= er (error)	   	   
-- [26]		= dn (ctrl_done)	   	   
-- [25] 	= rl (ralmode)	   
-- [24] 	= wr (write)	   
-- [23:16] 	= ad (addr)		   
-- [15: 8] 	= rg (reg)	
-- [7: 0] 	= dt (datatowrite or dataread) 		   
--===========================================
process(clk, reset)
begin
if reset='1' then
	status	 <=(others =>'0');
	done_dld <= '0';
	busy_dld <= '0';

elsif clk'event and clk='1' then
	done_dld <= ctrl_done;
	busy_dld <= ctrl_busy;
	if ctrl_done='1' then
		status(31) <= error_rdack4;
		status(30) <= error_rdack3;
		status(29) <= error_rdack2;
		status(28) <= error_rdack1;
		status(27) <= error;
		status(26) <= ctrl_done;
		status(25) <= ral_out;
		status(24) <= wr_out;
		
		status(23 downto 16)	<= addr_out;
		status(15 downto  8)	<= reg_out;
		status(7 downto 0)	<= datafromslave;
		if wr_out='1' then 
		status(7 downto 0)	<= wrdata_out;
		end if;
	end if;
end if;
end process;
statusreg 	<= status;
done_str  	<= done_dld;
busy		<= busy_dld;	
--===========================================



--===========================================
u1: entity work.i2c_data
--===========================================
port map
(
	clk				=> clk,
	reset			=> reset,
	enable			=> enable,
	------------------------------
	clkprescaler	=> clkprescaler,
	startclk_ext	=> startclk,
	execstart_ext	=> execstart,
	execstop_ext	=> execstop,
	execwr_ext		=> execwr,
	execgetack_ext	=> execgetack,
	execrd_ext		=> execrd,
	execsendack_ext	=> execsendack,
	bytetowrite_ext	=> bytetowrite,
	completed		=> completed,
	failed			=> noack,
	byteread		=> datafromslave,
	------------------------------
    selected_iic    => selected_iic,
	scl				=> scl,
	sda_i			=> sda_i,
	sda_o			=> sda_o,
	sda_t			=> sda_t
); 			

--===========================================
u2: entity work.i2c_ctrl_vfat
--===========================================
port map
(
	clk				=> clk,
	reset			=> reset,
	enable			=> enable,
	------------------------------
	executestrobe	=> exec_str,
	ralmode			=> ralmode,
	slaveaddress	=> slaveaddress,
	slaveregister	=> slaveregister,
	datatoslave		=> datatoslave,
	writetoslave	=> writetoslave,
	------------------------------
	clkprescaler	=> clkprescaler,
	startclk		=> startclk,
	execstart		=> execstart,
	execstop		=> execstop,
	execwr			=> execwr,
	execgetack		=> execgetack,
	execrd			=> execrd,
	execsendack		=> execsendack,
	bytetowrite		=> bytetowrite,
	completed		=> completed,
	failed			=> failed,
	------------------------------
	addr_out		=> addr_out,
	reg_out			=> reg_out,
	wrdata_out		=> wrdata_out,
	wr_out			=> wr_out,		
	ral_out			=> ral_out,		
	------------------------------
	done			=> ctrl_done,
	busy			=> ctrl_busy,
	error_rdack1	=> error_rdack1,
	error_rdack2	=> error_rdack2,
	error_rdack3	=> error_rdack3,
	error_rdack4	=> error_rdack4,	
	error			=> error
); 	failed <= '0' when ignoreack='1' else noack;		

END hierarchy;