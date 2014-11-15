----------------------------------------------------------------------------------------------------------
--
-- Filename: 		gtx_rx_mux.vhd
-- Author: 		Erik Verhagen
-- Created: 		06 Nov 2014
-- For: 		IIHE Brussels
--
-- Description: 	RX MUX
--
-- History: 
--			[06-11-2014] File created
--
----------------------------------------------------------------------------------------------------------

--
-- This entity dispatches the incoming data to the different modules.
--
--
-- Ways to improve: must add tracking handling -> data sizes of 16 entries
--
-- Modifications needed for V2: -
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity gtx_rx_mux is
port(

    gtx_clk_i       : in std_logic;
    reset_i         : in std_logic;
    
    vfat2_en_o      : out std_logic;
    vfat2_data_o    : out std_logic_vector(31 downto 0);
    
    regs_en_o       : out std_logic;
    regs_data_o     : out std_logic_vector(31 downto 0);
  
    rx_kchar_i      : in std_logic_vector(1 downto 0);
    rx_data_i       : in std_logic_vector(15 downto 0)
    
);
end gtx_rx_mux;

architecture Behavioral of gtx_rx_mux is
begin
      
    process(gtx_clk_i) 
    
        -- State machine
        variable state          : integer range 0 to 7 := 0;
    
        -- Incomming data
        variable data           : std_logic_vector(31 downto 0) := (others => '0');
        
        -- Output slave
        variable selected_core  : integer range 0 to 3 := 0;
    
    begin
    
        if (rising_edge(gtx_clk_i)) then
            -- Reset
            if (reset_i = '1') then
                vfat2_en_o <= '0';
                regs_en_o <= '0';
                selected_core := 0;
                state := 0;
            else
                -- Wait for header data package
                if (state = 0) then
                    -- Detect header data package
                    if (rx_kchar_i = "01") then
                        -- VFAT2 data packet
                        if (rx_data_i = def_gtx_vfat2 & x"BC") then
                            -- Set selected the core
                            selected_core := 1;
                            -- Go to "receive data" state
                            state := 1;
                        --OH Regs data packet
                        elsif (rx_data_i = def_gtx_oh_regs & x"BC") then
                            -- Set selected the core
                            selected_core := 2;
                            -- Go to "receive data" state
                            state := 1;
                        end if;  
                    end if;
                    
                    vfat2_en_o <= '0';
                    regs_en_o <= '0';
                   
                -- Get the first data packet
                elsif (state = 1) then
                    if (rx_kchar_i = "00") then
                        -- Save the data
                        data(31 downto 16) := rx_data_i;
                        state := 2;
                    else 
                        state := 0;
                    end if;
                    
                -- Get the second data packet
                elsif (state = 2) then
                    if (rx_kchar_i = "00") then
                        -- Save the data
                        data(15 downto 0) := rx_data_i;
                        -- Acknowledge the selected core
                        if (selected_core = 1) then
                            -- Set the ipbus data
                            vfat2_data_o <= data;
                            -- Strobe
                            vfat2_en_o <= '1';
                        
                        elsif (selected_core = 2) then
                            -- Set the ipbus data
                            regs_data_o <= data;
                            -- Strobe
                            regs_en_o <= '1';
                        end if;
                    end if;
                    state := 0;
                -- Out of FSM
                else
                    vfat2_en_o <= '0';
                    regs_en_o <= '0';
                    selected_core := 0;
                    state := 0;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;


