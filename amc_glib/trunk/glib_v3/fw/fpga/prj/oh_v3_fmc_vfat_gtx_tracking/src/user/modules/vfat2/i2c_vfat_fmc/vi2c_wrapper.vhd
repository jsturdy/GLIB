library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity vi2c_wrapper is
generic(
    clk_freq            : integer := 160_000_000
);
port(

    fabric_clk_i        : in std_logic;
    reset_i             : in std_logic;
    
    en_i                : in std_logic;
    
    chip_select_i       : in std_logic_vector(2 downto 0);
    register_select_i   : in std_logic_vector(7 downto 0);
    read_write_n_i      : in std_logic;
    data_i              : in std_logic_vector(7 downto 0);
    
    en_o                : out std_logic;
    status_o            : out std_logic;
    data_o              : out std_logic_vector(7 downto 0);  

    selected_iic_i      : in integer;
    sda_i               : in std_logic_vector;
    sda_o               : out std_logic_vector;
    sda_t               : out std_logic_vector;
    scl_o               : out std_logic_vector
    
);
end vi2c_wrapper;

architecture Behavioral of vi2c_wrapper is

    signal ctrl_reg     : std_logic_vector(15 downto 0) := (others => '0');
    signal data_reg     : std_logic_vector(31 downto 0) := (others => '0');
    signal status_reg   : std_logic_vector(31 downto 0) := (others => '0');
    
    signal busy         : std_logic := '0';
    signal exec         : std_logic := '0';
    signal done         : std_logic := '0';
    signal enable       : std_logic := '0';
    
    constant divider    : integer range 0 to (2**12 - 1) := clk_freq / 100_000;

begin

    process(fabric_clk_i)
    
        variable chip_select        : std_logic_vector(2 downto 0) := (others => '0');
        variable register_select    : std_logic_vector(7 downto 0) := (others => '0');
        variable read_write_n       : std_logic := '0';
        variable data               : std_logic_vector(7 downto 0) := (others => '0');
        
        variable state              : integer range 0 to 7 := 0;
        
    begin
    
        if (rising_edge(fabric_clk_i)) then
        
            if (reset_i = '1') then
            
                en_o <= '0';
                
                exec <= '0';
                
                enable <= '0';
                
                state := 0;
                
            else
            
                enable <= '1';
            
                -- Wait for a request
                if (state = 0) then

                    en_o <= '0';

                    -- Buffer the request
                    if (en_i = '1') then

                        chip_select := chip_select_i;
                        register_select := register_select_i;
                        read_write_n := read_write_n_i;
                        data := data_i;

                        state := 1;

                    end if;
                
                -- Format the data register
                elsif (state = 1) then
                        
                    -- Normal reg
                    if (register_select(7 downto 4) = "0000") then -- equivalent to register_select < 16
                    
                        data_reg(31 downto 25) <= (others => '0');
                        data_reg(24) <= not read_write_n;
                        data_reg(23 downto 16) <= '0' & chip_select & register_select(3 downto 0);
                        data_reg(15 downto 8) <= (others => '0');
                        data_reg(7 downto 0) <= data;
                        
                        state := 2;
                        
                    -- Extended reg
                    else
                    
                        data_reg(31 downto 25) <= (others => '0');
                        data_reg(24) <= '1';
                        data_reg(23 downto 16) <= '0' & chip_select & "1110";
                        data_reg(15 downto 8) <= (others => '0');
                        data_reg(7 downto 0) <= std_logic_vector(unsigned(register_select) - 16);
                        
                        state := 4;
                        
                    end if;
                
                -- Execute the operation for the normal registers
                elsif (state = 2) then
                
                    exec <= '1';
                    
                    state := 3;
                    
                -- Wait for the data for the normal registers (and end the transation after that)
                elsif (state = 3) then
                
                    exec <= '0';
                    
                    if (done = '1') then
                    
                        data_o <= status_reg(7 downto 0);
                    
                        status_o <= not status_reg(27);
                        
                        state := 7;
                        
                    end if;
                    
                -- Execute the operation for the extended registers (second operation after that)
                elsif (state = 4) then
                
                    exec <= '1';
                    
                    state := 5;
                
                -- Wait for the data for the extended registers
                elsif (state = 5) then
                
                    exec <= '0';
                    
                    if (done = '1') then
                    
                        data_o <= status_reg(7 downto 0);
                    
                        status_o <= not status_reg(27);
                        
                        if (status_reg(27) = '1') then
                            
                            state := 7;
                            
                        else       

                            state := 6;
                        
                        end if;
                        
                    end if;
                    
                -- Send second IIC operation
                elsif (state = 6) then
                
                    if (busy = '0') then
                    
                        data_reg(31 downto 25) <= (others => '0');
                        data_reg(24) <= not read_write_n;
                        data_reg(23 downto 16) <= '0' & chip_select & "1111";
                        data_reg(15 downto 8) <= (others => '0');
                        data_reg(7 downto 0) <= data;
                        
                        state := 2;
                        
                    end if;
                    
                -- Send enable signal
                elsif (state = 7) then
                
                    en_o <= '1';
                    
                    state := 0;
      
                else
                
                    en_o <= '0';
                
                    exec <= '0';
                    
                    state := 0;
                    
                end if;
                
            end if;
            
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
    -- [15:8] 	= rg (reg)	
    -- [7:0] 	= dt (datatowrite or dataread) 		   
    --===========================================    
    
    --===========================================
    -- i2c ctrl register
    --===========================================
    -- [15] 	= ignore_failures
    -- [12] 	= enable
    -- [11:0] 	= prescaler
    --===========================================
    
    ctrl_reg <= "000" & enable & std_logic_vector(to_unsigned(divider, 12));
        
    i2c_master_inst : entity work.i2c_master
    port map(
        clk				=> fabric_clk_i,
        reset			=> reset_i,
        ctrlreg			=> ctrl_reg,
        datareg			=> data_reg,
        statusreg		=> status_reg,
        busy			=> busy,
        exec_str		=> exec,	
        done_str		=> done,
        selected_iic    => selected_iic_i,
        sda_i		    => sda_i,
        sda_o           => sda_o,
        sda_t           => sda_t,
        scl				=> scl_o
    ); 		

end Behavioral;