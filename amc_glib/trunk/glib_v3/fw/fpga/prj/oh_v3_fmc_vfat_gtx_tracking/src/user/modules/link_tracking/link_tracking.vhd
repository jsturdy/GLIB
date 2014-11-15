----------------------------------------------------------------------------------------------------------
--
-- Filename: 		link_tracking.vhd
-- Author: 		Erik Verhagen
-- Created: 		06 Nov 2014
-- For: 		IIHE Brussels
--
-- Description: 	GTX to VFAT2 wrapper
--
-- History: 
--			[06-11-2014] File created
--
----------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.user_package.all;

entity link_tracking is
generic(
    FABRIC_CLK_FREQ : integer := 40000000
);

port(
    -- Clocks and reset
    fabric_clk_i    : in std_logic;
    gtx_clk_i       : in std_logic;
    vfat2_clk_i     : in std_logic;
    reset_i         : in std_logic;

    -- GTP signals
    rx_error_i      : in std_logic;
    rx_kchar_i      : in std_logic_vector(1 downto 0);
    rx_data_i       : in std_logic_vector(15 downto 0);

    tx_kchar_o      : out std_logic_vector(1 downto 0);
    tx_data_o       : out std_logic_vector(15 downto 0);

    -- IIC signals
    sda_i           : in std_logic_vector(1 downto 0); -- 2 IIC sectors
    sda_o           : out std_logic_vector(1 downto 0);
    sda_t           : out std_logic_vector(1 downto 0);
    scl_o           : out std_logic_vector(1 downto 0);
    
    -- VFAT2 data lines
    vfat2_dvalid_i  : in std_logic_vector(1 downto 0); -- 2 data valid sectors
    vfat2_data_0_i  : in std_logic);
end link_tracking;

architecture Structural of link_tracking is

    -- VFAT2 IIC signals
    signal vfat2_rx_en      : std_logic := '0';
    signal vfat2_rx_data    : std_logic_vector(31 downto 0) := (others => '0');

    signal vfat2_tx_ready   : std_logic := '0';
    signal vfat2_tx_en      : std_logic := '0';
    signal vfat2_tx_valid   : std_logic := '0';
    signal vfat2_tx_data    : std_logic_vector(31 downto 0) := (others => '0');
    
    -- VFAT2 Tracking signals
    signal track_tx_ready   : std_logic := '0';
    signal track_tx_en      : std_logic := '0';
    signal track_tx_valid   : std_logic := '0';
    signal track_tx_data    : std_logic_vector(191 downto 0) := (others => '0');

    signal zeros            : std_logic_vector(31 downto 0) := (others => '0');
begin

    ----------------------------------
    -- GTX                          --
    ----------------------------------    

    gtx_rx_mux_inst : entity work.gtx_rx_mux
    port map(
        gtx_clk_i       => gtx_clk_i,
        reset_i         => reset_i,
        
        vfat2_en_o      => vfat2_rx_en,
        vfat2_data_o    => vfat2_rx_data,
        
--        regs_en_o       => regs_rx_en,
--        regs_data_o     => regs_rx_data,
        
        rx_kchar_i      => rx_kchar_i,
        rx_data_i       => rx_data_i
    );

    gtx_tx_mux_inst : entity work.gtx_tx_mux
    port map(
        gtx_clk_i       => gtx_clk_i,
        reset_i         => reset_i, 

        vfat2_en_i      => vfat2_tx_en,
        vfat2_data_i    => vfat2_tx_data,
    
        regs_en_i       => '0',
        regs_data_i     => zeros,
   
        fast_signals_i  => zeros(6 downto 0),
    
        tx_kchar_o      => tx_kchar_o,
        tx_data_o       => tx_data_o
    );


    ----------------------------------
    -- I2C Core                     --
    ----------------------------------
    
--    i2c_core_inst : entity work.i2c_core_vfat2
--    generic map(
--        FABRIC_CLK_FREQ => FABRIC_CLK_FREQ
--    )
--    port map(
--        fabric_clk_i    => fabric_clk_i,
--        reset_i         => reset_i,
--        rx_en_i         => vfat2_rx_en,
--        rx_data_i       => vfat2_rx_data,
--        tx_en_o         => vfat2_tx_en,  
--        tx_data_o       => vfat2_tx_data,
--        sda_i           => sda_i,
--        sda_o           => sda_o,
--        sda_t           => sda_t,
--        scl_o           => scl_o
--    );  

    i2c_core_inst : entity work.vi2c_core
    port map(
        fabric_clk_i    => fabric_clk_i,
        reset_i         => reset_i,
		  
        rx_en_i         => vfat2_rx_en,
        rx_data_i       => vfat2_rx_data,
		  
		  tx_ready_o      => vfat2_tx_en,
		  tx_en_i         => '1',
		  tx_data_o       => vfat2_tx_data,
        
        sda_i           => sda_i,
        sda_o           => sda_o,
        sda_t           => sda_t,
        scl_o           => scl_o
    );  
	 
	 
--    i2c_core_inst : entity work.i2c_core
--    generic map(
--        FABRIC_CLK_FREQ => FABRIC_CLK_FREQ
--    )
--
--    port map(
--        gtx_clk_i       => gtx_clk_i,
--        fabric_clk_i    => fabric_clk_i,
--        reset_i         => reset_i,
--        rx_en_i         => vfat2_rx_en,
--        rx_data_i       => vfat2_rx_data,
--        tx_ready_o      => vfat2_tx_ready,
--        tx_en_i         => vfat2_tx_en,  
--        tx_valid_o      => vfat2_tx_valid,  
--        tx_data_o       => vfat2_tx_data,
--        sda_i           => sda_i(1 downto 0),
--        sda_o           => sda_o(1 downto 0),
--        sda_t           => sda_t(1 downto 0),
--        scl_o           => scl_o(1 downto 0)
--    );   

end architecture;
