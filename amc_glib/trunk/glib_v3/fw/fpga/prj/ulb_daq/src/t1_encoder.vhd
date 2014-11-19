library ieee;
use ieee.std_logic_1164.all;

entity t1_encoder is
port(

    vfat2_clk_i : in std_logic;
    reset_i     : in std_logic;
    
    lv1a_i      : in std_logic;
    calpulse_i  : in std_logic;
    resync_i    : in std_logic;
    bc0_i       : in std_logic;
    
    t1_o        : out std_logic
    
);
end t1_encoder;

architecture Behavioral of t1_encoder is
begin

    process(vfat2_clk_i)
    
        variable data       : std_logic_vector(2 downto 0) := (others => '0'); -- MSB sent first
        variable data_cnt   : integer range 0 to 3 := 0;
        
        variable state      : integer range 0 to 1 := 0; 
        
    begin    
    
        if (rising_edge(vfat2_clk_i)) then
        
            if (reset_i = '1') then
            
                t1_o <= '0';
                
                state := 0;    
                
            else
            
                if (state = 0) then
                    
                    t1_o <= '0'; 
                
                    if (lv1a_i = '1') then    
                    
                        data := "100";
                        
                        data_cnt := 2;
                        
                        state := 1;
                        
                    elsif (calpulse_i = '1') then 
                    
                        data := "111";
                        
                        data_cnt := 2;
                        
                        state := 1;
                        
                    elsif (resync_i = '1') then  
                    
                        data := "110";
                        
                        data_cnt := 2;
                        
                        state := 1;
                        
                    elsif (bc0_i = '1') then 
                    
                        data := "101";
                        
                        data_cnt := 2;
                        
                        state := 1;
                        
                    end if;    
                    
                elsif (state = 1) then
                
                    t1_o <= data(data_cnt);  
                    
                    if (data_cnt = 0) then
                    
                        state := 0;
                    
                    else
                    
                        data_cnt := data_cnt - 1;
                    
                    end if;
                    
                -- Out of FSM
                else 
                
                    t1_o <= '0';
                    
                    state := 0;   
                    
                end if;
                
            end if;
            
        end if;
        
    end process;
    
end Behavioral;