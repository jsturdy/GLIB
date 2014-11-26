library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity link_trigger is
port(

    -- Clocks and reset

    gtp_clk_i       : in std_logic;
    vfat2_clk_i     : in std_logic;
    reset_i         : in std_logic;

    -- GTP signals

    rx_error_i      : in std_logic;
    rx_kchar_i      : in std_logic_vector(1 downto 0);
    rx_data_i       : in std_logic_vector(15 downto 0);

    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0);
    
    -- BX counter
    bx_counter_i    : in std_logic_vector(31 downto 0);

    -- VFAT2 data lines

    vfat2_data_0_i  : in std_logic_vector(7 downto 0);
    vfat2_data_1_i  : in std_logic_vector(7 downto 0);
    vfat2_data_2_i  : in std_logic_vector(7 downto 0);
    vfat2_data_3_i  : in std_logic_vector(7 downto 0);
    vfat2_data_4_i  : in std_logic_vector(7 downto 0);
    vfat2_data_5_i  : in std_logic_vector(7 downto 0);
    vfat2_data_6_i  : in std_logic_vector(7 downto 0);
    vfat2_data_7_i  : in std_logic_vector(7 downto 0);
    vfat2_data_8_i  : in std_logic_vector(7 downto 0);
    vfat2_data_9_i  : in std_logic_vector(7 downto 0);
    vfat2_data_10_i : in std_logic_vector(7 downto 0);
    vfat2_data_11_i : in std_logic_vector(7 downto 0);
    vfat2_data_12_i : in std_logic_vector(7 downto 0);
    vfat2_data_13_i : in std_logic_vector(7 downto 0);
    vfat2_data_14_i : in std_logic_vector(7 downto 0);
    vfat2_data_15_i : in std_logic_vector(7 downto 0);
    vfat2_data_16_i : in std_logic_vector(7 downto 0);
    vfat2_data_17_i : in std_logic_vector(7 downto 0);
    vfat2_data_18_i : in std_logic_vector(7 downto 0);
    vfat2_data_19_i : in std_logic_vector(7 downto 0);
    vfat2_data_20_i : in std_logic_vector(7 downto 0);
    vfat2_data_21_i : in std_logic_vector(7 downto 0);
    vfat2_data_22_i : in std_logic_vector(7 downto 0);
    vfat2_data_23_i : in std_logic_vector(7 downto 0)

);
end link_trigger;

architecture Behavioral of link_trigger is

    signal orbits   : std_logic_vector(5 downto 0) := (others => '0');

begin
    
    --================================--
    -- Buffer data
    --================================--

    process(vfat2_clk_i) 
    begin
 
        if (rising_edge(vfat2_clk_i)) then

            orbits(0) <= vfat2_data_8_i(0) or vfat2_data_8_i(1) or vfat2_data_8_i(2) or vfat2_data_8_i(3) or vfat2_data_8_i(4) or vfat2_data_8_i(5) or vfat2_data_8_i(6) or vfat2_data_8_i(7);
            orbits(1) <= vfat2_data_9_i(0) or vfat2_data_9_i(1) or vfat2_data_9_i(2) or vfat2_data_9_i(3) or vfat2_data_9_i(4) or vfat2_data_9_i(5) or vfat2_data_9_i(6) or vfat2_data_9_i(7);
            orbits(2) <= vfat2_data_10_i(0) or vfat2_data_10_i(1) or vfat2_data_10_i(2) or vfat2_data_10_i(3) or vfat2_data_10_i(4) or vfat2_data_10_i(5) or vfat2_data_10_i(6) or vfat2_data_10_i(7);
            orbits(3) <= vfat2_data_11_i(0) or vfat2_data_11_i(1) or vfat2_data_11_i(2) or vfat2_data_11_i(3) or vfat2_data_11_i(4) or vfat2_data_11_i(5) or vfat2_data_11_i(6) or vfat2_data_11_i(7);
            orbits(4) <= vfat2_data_12_i(0) or vfat2_data_12_i(1) or vfat2_data_12_i(2) or vfat2_data_12_i(3) or vfat2_data_12_i(4) or vfat2_data_12_i(5) or vfat2_data_12_i(6) or vfat2_data_12_i(7);
            orbits(5) <= vfat2_data_13_i(0) or vfat2_data_13_i(1) or vfat2_data_13_i(2) or vfat2_data_13_i(3) or vfat2_data_13_i(4) or vfat2_data_13_i(5) or vfat2_data_13_i(6) or vfat2_data_13_i(7);
            
        end if;
        
    end process;
    
    --================================--
    -- Send data
    --================================--
    

    process(gtp_clk_i)
        
        variable state          : integer range 0 to 3;
        
        variable data           : std_logic_vector(47 downto 0) := (others => '0');
    
    begin
    
        if (rising_edge(gtp_clk_i)) then
        
            if (reset_i = '1') then
            
                tx_data_o <= def_gtp_trigger & x"BC";
                
                tx_kchar_o <= "00";
                
                state := 0;
                
            else
            
                if (state = 0) then
                    
                    tx_kchar_o <= "01";
                    
                    tx_data_o <= def_gtp_trigger & x"BC";
                    
                    data := bx_counter_i & "0000000000" & orbits;
                    
                    state := 1;
                    
                elsif (state = 1) then
                
                    tx_kchar_o <= "00";
                    
                    tx_data_o <= data(47 downto 32);
                    
                    state := 2;
                    
                elsif (state = 2) then
                
                    tx_kchar_o <= "00";
                    
                    tx_data_o <= data(31 downto 16);
                    
                    state := 3;
                    
                elsif (state = 3) then
                
                    tx_kchar_o <= "00";
                    
                    tx_data_o <= data(15 downto 0);
                    
                    state := 0;
                    
                else
                            
                    tx_data_o <= def_gtp_trigger & x"BC";
                    
                    tx_kchar_o <= "00";
                    
                    state := 0;
                
                end if;
            
            end if;
        
        end if;
    
    end process;

end Behavioral;
