library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity i2c_wrapper_vfat2 is
generic(
    clk_freq            : integer := 160000000
);
port(
    clk_i               : in std_logic;
    reset_i             : in std_logic;
    
    strobe_i            : in std_logic;
    valid_o             : out std_logic;
    error_o             : out std_logic;
    busy_o              : out std_logic;
    
    chip_select_i       : in std_logic_vector(2 downto 0);
    register_select_i   : in std_logic_vector(7 downto 0);
    read_write_n_i      : in std_logic;
    din_i               : in std_logic_vector(7 downto 0);
    dout_o              : out std_logic_vector(7 downto 0);  

    selected_iic_i      : in integer;
    sda_i               : in std_logic_vector;
    sda_o               : out std_logic_vector;
    sda_t               : out std_logic_vector;
    scl_o               : out std_logic_vector
);
end i2c_wrapper_vfat2;

architecture Behavioral of i2c_wrapper_vfat2 is

    signal reset        : std_logic := '0';

    signal ctrl_reg     : std_logic_vector(15 downto 0) := (others => '0');
    signal data_reg     : std_logic_vector(31 downto 0) := (others => '0');
    signal status_reg   : std_logic_vector(31 downto 0) := (others => '0');
    
    signal busy         : std_logic := '0';
    signal exec         : std_logic := '0';
    signal done         : std_logic := '0';
    signal enable       : std_logic := '0';
    
    constant divider    : integer range 0 to (2**12 - 1) := clk_freq / 100000; -- 100 kHz
 --   constant divider    : integer range 0 to (2**12 - 1) := clk_freq / 10000; -- 10 kHz

begin

    process(clk_i)
    
        variable chip_select        : std_logic_vector(2 downto 0) := (others => '0');
        variable register_select    : unsigned(7 downto 0) := (others => '0');
        variable data               : std_logic_vector(7 downto 0) := (others => '0');
        variable read_write_n       : std_logic := '0';
    
        variable last_strobe        : std_logic := '0';
        
        variable state              : integer range 0 to 7 := 0;
        
    begin
    
        if (rising_edge(clk_i)) then
        
            if (reset_i = '1') then
            
                error_o <= '0';
                
                valid_o <= '0';
                
                busy_o <= '0';
                
                exec <= '0';
                
                enable <= '0';
                
                last_strobe := '0';
                
                state := 0;
                
            else
            
                enable <= '1';
            
                if (state = 0) then
            
                    if (last_strobe = '0' and strobe_i = '1') then
                    
                        busy_o <= '1';
                    
                        chip_select := chip_select_i;
                        register_select := unsigned(register_select_i);
                        data := din_i;
                        read_write_n := read_write_n_i;
                        
                        -- Normal reg
                        if (register_select < 16) then
                        
                            -- Read
                            if (read_write_n = '1') then
                            
                                data_reg <= "0000000" & '0' & '0' & chip_select & std_logic_vector(register_select(3 downto 0)) & "00000000" & "00000000";
                            
                            -- Write
                            else
                            
                                data_reg <= "0000000" & '1' & '0' & chip_select & std_logic_vector(register_select(3 downto 0)) & "00000000" & data;
                            
                            end if;
                            
                            exec <= '1';
                            
                            state := 1;
                            
                        -- Extended reg
                        else
                        
                            data_reg <= "0000000" & '1' & '0' &  chip_select & "1110" & "00000000" & std_logic_vector(register_select - 16);
                            
                            exec <= '1';
                            
                            state := 2;
                            
                        end if;
                        
                    end if;
                    
                elsif (state = 1) then
                
                    exec <= '0';
                    
                    if (done = '1') then
                    
                        -- Error
                        if (status_reg(27) = '1') then
                            
                            dout_o <= "00000000";
                        
                            valid_o <= '0';
                            
                            error_o <= '1';
                           
                        -- Valid
                        else
                        
                            -- Write
                            if (status_reg(24) = '1') then
                            
                                dout_o <= "00000000";
                            
                            -- Read
                            else
                                
                                dout_o <= status_reg(7 downto 0);
                            
                            end if;
                        
                            valid_o <= '1';
                            
                            error_o <= '0';
                            
                        end if;
                        
                        state := 7;
                        
                    else
                    
                        state := 1;
                        
                    end if;
                    
                elsif (state = 2) then
                
                    exec <= '0';
                    
                    if (done = '1') then
                    
                        if (status_reg(27) = '1') then
                            
                            dout_o <= "00000000";
                            
                            valid_o <= '0';
                            
                            error_o <= '1';
                            
                            state := 7;
                            
                        else        
                            
                            state := 3;
                            
                        end if;
                    
                    else
                    
                        state := 2;
                        
                    end if;   
                    
                elsif (state = 3) then
                
                    if (busy = '0') then
                        
                        -- Read
                        if (read_write_n = '1') then
                        
                            data_reg <= "0000000" & '0' & '0' & chip_select & "1111" & "00000000" & "00000000";
                        
                        -- Write
                        else
                        
                            data_reg <= "0000000" & '1' & '0' & chip_select & "1111" & "00000000" & data;
                        
                        end if;                        
                        
                        exec <= '1';        
                        
                        state := 4;
                    
                    else
                    
                        state := 3;
                            
                    end if;
                    
                elsif (state = 4) then
                
                    exec <= '0';
                    
                    if (done = '1') then
                    
                        -- Error
                        if (status_reg(27) = '1') then
                            
                            dout_o <= "00000000";
                        
                            valid_o <= '0';
                            
                            error_o <= '1';
                           
                        -- Valid
                        else
                        
                            -- Write
                            if (status_reg(24) = '1') then
                            
                                dout_o <= "00000000";
                            
                            -- Read
                            else
                                
                                dout_o <= status_reg(7 downto 0);
                            
                            end if;
                        
                            valid_o <= '1';
                            
                            error_o <= '0';
                            
                        end if;
                        
                        state := 7;
                        
                    end if;
                    
                elsif (state = 7) then
                
                    valid_o <= '0';
                    
                    error_o <= '0';
                    
                    busy_o <= '0';
                    
                    state := 0;
      
                else
                
                    exec <= '0';
                    
                    state := 0;
                    
                end if;
                
                last_strobe := strobe_i;
                
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
        
    i2c_master_inst : entity work.i2c_master_vfat2
    port map(
        clk				=> clk_i,
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