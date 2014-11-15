library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity i2c_core_vfat2 is
generic(
    FABRIC_CLK_FREQ     : integer := 40000000
);
port(
    fabric_clk_i    : in std_logic;
    reset_i         : in std_logic;
    
    rx_en_i         : in std_logic;
    rx_data_i       : in std_logic_vector(31 downto 0);
    
    tx_en_o         : out std_logic;  
    tx_data_o       : out std_logic_vector(31 downto 0);
    
    sda_i           : in std_logic_vector;
    sda_o           : out std_logic_vector;
    sda_t           : out std_logic_vector;
    scl_o           : out std_logic_vector
);
end i2c_core_vfat2;

architecture Behavioral of i2c_core_vfat2 is

    signal strobe           : std_logic := '0';
    signal valid            : std_logic := '0';
    signal error            : std_logic := '0';
    signal busy             : std_logic := '0';
    signal chip_select      : std_logic_vector(4 downto 0) := (others => '0');
    signal chip_id          : std_logic_vector(2 downto 0) := (others => '0');
    signal register_select  : std_logic_vector(7 downto 0) := (others => '0');
    signal read_write_n     : std_logic := '0';
    signal din              : std_logic_vector(7 downto 0) := (others => '0');
    signal dout             : std_logic_vector(7 downto 0) := (others => '0');
    
    signal selected_iic     : integer range 0 to 1 := 0;

begin

    ----------------------------------
    -- IIC wrapper                  --
    ----------------------------------

    process(fabric_clk_i)
    
        variable state          : integer range 0 to 7 := 0;
        
        variable chip_byte      : std_logic_vector(7 downto 0) := (others => '0');
        variable register_byte  : std_logic_vector(7 downto 0) := (others => '0');
        variable data_byte      : std_logic_vector(7 downto 0) := (others => '0');
        variable crc_byte       : std_logic_vector(7 downto 0) := (others => '0');
    
    begin
    
        if (rising_edge(fabric_clk_i)) then
        
            if (reset_i = '1') then
                
                tx_en_o <= '0';
                
                strobe <= '0';
            
                state := 0;
            
            else
            
                -- Waiting state
                if (state = 0) then
                        
                    tx_en_o <= '0';
                    
                    -- Incoming data
                    if (rx_en_i = '1') then
                    
                        -- Extract the information from the data packet
                        chip_select <= rx_data_i(28 downto 24);
                        register_select <= rx_data_i(23 downto 16);
                        read_write_n <= rx_data_i(29);
                        din <= rx_data_i(15 downto 8);
                        
                        -- Convert the chip select to the chip ID
                        case rx_data_i(26 downto 24) is
                            when "000" => chip_id <= "001";
                            when "001" => chip_id <= "010"; 
                            when others => chip_id <= "000";
                        end case;
                        
                        selected_iic <= 0;
               
                        -- Compute the CRC byte
                        chip_byte := rx_data_i(31 downto 24); 
                        register_byte := rx_data_i(23 downto 16); 
                        data_byte := rx_data_i(15 downto 8); 
                        crc_byte := chip_byte xor register_byte xor data_byte; 
                        
                        -- Check CRC
                        if (crc_byte = rx_data_i(7 downto 0)) then
                            
                            -- If it matches, proceed to IIC module
                            strobe <= '1';
                    
                            state := 1;
                        
                        else
                        
                            -- Otherwise, send back error
                            state := 2;
                        
                        end if;
                        
                    end if;
                    
                -- Waiting for response from IIC
                elsif (state = 1) then
                
                    if ((valid = '1') or (error = '1')) then
                    
                        strobe <= '0';
                   
                        -- Compute the data to send
                        chip_byte := error & valid & read_write_n & chip_select;
                        register_byte := register_select;
                        data_byte := dout;
                        crc_byte := chip_byte xor register_byte xor data_byte;
                        
                        tx_data_o <= chip_byte & register_byte & data_byte & crc_byte;
                        
                        tx_en_o <= '1';
                        
                        state := 0;  
                        
                    end if;
                    
                -- Sending back error
                elsif (state = 2) then
                
                    -- Compute the data to send
                    chip_byte := '1' & '0' & read_write_n & chip_select;
                    register_byte := register_select;
                    data_byte := (others => '0');
                    crc_byte := chip_byte xor register_byte xor data_byte;
                    
                    tx_data_o <= chip_byte & register_byte & data_byte & crc_byte;
                    
                    tx_en_o <= '1';
                    
                    state := 0;
                    
                else
                    
                    tx_en_o <= '0';
                    
                    strobe <= '0';
                
                    state := 0;
                
                end if;
            
            end if;
        
        end if;
    
    end process;
    
    ----------------------------------
    -- IIC core                     --
    ----------------------------------

    i2c_wrapper_inst : entity work.i2c_wrapper_vfat2
    generic map(
        clk_freq            => FABRIC_CLK_FREQ
    )
    port map(
        clk_i               => fabric_clk_i,
        reset_i             => reset_i,
        strobe_i            => strobe,
        valid_o             => valid,
        error_o             => error,
        busy_o              => busy,
        chip_select_i       => chip_id,
        register_select_i   => register_select,
        read_write_n_i      => read_write_n,
        din_i               => din,
        dout_o              => dout,
        selected_iic_i      => selected_iic,
        sda_i               => sda_i,
        sda_o               => sda_o,
        sda_t               => sda_t,
        scl_o               => scl_o
    );

end Behavioral;