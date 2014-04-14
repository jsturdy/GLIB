-------------------------------------------------------------------------------
--
--  Module      : mifgen_enc.vhd
--
--  Version     : 1.1
--
--  Last Update : 2008-10-31
--
--  Project     : 8b/10b Encoder Reference Design
--
--  Description : 8b/10b Encoder MIF file generator
--
--  Company     : Xilinx, Inc.
--
--  DISCLAIMER OF LIABILITY
--
--                This file contains proprietary and confidential information of
--                Xilinx, Inc. ("Xilinx"), that is distributed under a license
--                from Xilinx, and may be used, copied and/or disclosed only
--                pursuant to the terms of a valid license agreement with Xilinx.
--
--                XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
--                ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
--                EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
--                LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
--                MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
--                does not warrant that functions included in the Materials will
--                meet the requirements of Licensee, or that the operation of the
--                Materials will be uninterrupted or error-free, or that defects
--                in the Materials will be corrected.  Furthermore, Xilinx does
--                not warrant or make any representations regarding use, or the
--                results of the use, of the Materials in terms of correctness,
--                accuracy, reliability or otherwise.
--
--                Xilinx products are not designed or intended to be fail-safe,
--                or for use in any application requiring fail-safe performance,
--                such as life-support or safety devices or systems, Class III
--                medical devices, nuclear facilities, applications related to
--                the deployment of airbags, or any other applications that could
--                lead to death, personal injury or severe property or
--                environmental damage (individually and collectively, "critical
--                applications").  Customer assumes the sole risk and liability
--                of any use of Xilinx products in critical applications,
--                subject only to applicable laws and regulations governing
--                limitations on product liability.
--
--                Copyright 2008 Xilinx, Inc.  All rights reserved.
--
--                This disclaimer and copyright notice must be retained as part
--                of this file at all times.
--
-------------------------------------------------------------------------------
--
--  History
--
--  Date        Version   Description
--
--  10/31/2008  1.1       Initial release
--
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

USE STD.textio.ALL;

LIBRARY encode_8b10b;

-------------------------------------------------------------------------------
-- Entity Declaration
-------------------------------------------------------------------------------
ENTITY mifgen_enc IS

END mifgen_enc;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
ARCHITECTURE xilinx OF mifgen_enc IS

-------------------------------------------------------------------------------
-- Constant Declarations
-------------------------------------------------------------------------------
--debug_output=true : enc.mif will have headings and can be imported into Excel
--debug_output=false: enc.mif will be formatted to initialize a BRAM
  CONSTANT debug_output    : BOOLEAN := FALSE;

  CONSTANT clk_period      : TIME    := 10 ns;
  CONSTANT half_clk_period : TIME    := clk_period/2;

-------------------------------------------------------------------------------
-- Signals Declarations
-------------------------------------------------------------------------------
--Encoder Inputs
  SIGNAL in_force_code   : STD_LOGIC := '0';
  SIGNAL in_force_disp   : STD_LOGIC := '1';
  SIGNAL in_ce           : STD_LOGIC := '1';

--encin is used to combine these three signals so that all combinations can be
--iterated through
  SIGNAL encin           : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000";

  ALIAS in_dispin        : STD_LOGIC IS encin(8);
  ALIAS in_kin           : STD_LOGIC IS encin(9);
  ALIAS in_din           : STD_LOGIC_VECTOR(7 DOWNTO 0) IS encin(7 DOWNTO 0);


--Encoder Outputs
  SIGNAL out_dispout     : STD_LOGIC;
  SIGNAL out_dout        : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL out_kerr        : STD_LOGIC;
  SIGNAL out_nd          : STD_LOGIC;

--Internal Signals
  SIGNAL stimulating     : BOOLEAN   := TRUE;  --whether clock is running
  SIGNAL clk             : STD_LOGIC := '0';

--Delayed encoder inputs (delayed one clock cycle to synchronize with outputs)
  SIGNAL dlay_force_code : STD_LOGIC;
  SIGNAL dlay_force_disp : STD_LOGIC;
  SIGNAL dlay_ce         : STD_LOGIC;
  SIGNAL dlay_dispin     : STD_LOGIC;
  SIGNAL dlay_kin        : STD_LOGIC;
  SIGNAL dlay_din        : STD_LOGIC_VECTOR(7 DOWNTO 0);

-------------------------------------------------------------------------------
-- BEGIN ARCHITECTURE
-------------------------------------------------------------------------------
BEGIN

----------------------------------------------------
--Object Instantiation
----------------------------------------------------
  encmodel : ENTITY encode_8b10b.encode_8b10b_lut_base
    GENERIC MAP (
      C_HAS_DISP_IN     => 1,
      C_HAS_FORCE_CODE  => 1,
      C_FORCE_CODE_VAL  => "0011001100",
      C_FORCE_CODE_DISP => 1,
      C_HAS_ND          => 1,
      C_HAS_KERR        => 1
      )
    PORT MAP (
      DIN               => in_din,
      KIN               => in_kin,
      FORCE_DISP        => in_force_disp,
      FORCE_CODE        => in_force_code,
      DISP_IN           => in_dispin,
      CE                => in_ce,
      CLK               => clk,
      DOUT              => out_dout,
      KERR              => out_kerr,
      DISP_OUT          => out_dispout,
      ND                => out_nd
      );

----------------------------------------------------
--Define Processes
----------------------------------------------------

--Clock stimulation
stimulate_clk : PROCESS
BEGIN
  clk <= '0';
  WHILE stimulating LOOP
    WAIT FOR half_clk_period;
    clk <= NOT clk;
  END LOOP;

  --pulse the clock a few more times before exiting, to insure that all
  -- delayed signals get through.
  WAIT FOR half_clk_period;
  clk <= NOT clk;
  WAIT FOR half_clk_period;
  clk <= NOT clk;

  --since the clock stimulation process always runs, we need to suspend it
  WAIT;
END PROCESS stimulate_clk;


generate_mif_enc : PROCESS (clk)
  --for generating mif files
  VARIABLE encM       : LINE;
  FILE     encmiffile : TEXT OPEN WRITE_MODE IS "enc.mif";
  VARIABLE encout     : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
  VARIABLE firstpass  : BOOLEAN := TRUE;

BEGIN
  IF (clk'event AND clk='1') THEN
    --for debug output only
    dlay_force_code <= in_force_code;
    dlay_force_disp <= in_force_disp;
    dlay_ce         <= in_ce;
    dlay_kin        <= in_kin;
    dlay_din        <= in_din;
    dlay_dispin     <= in_dispin;

    --check to see if we've reached the end yet
    IF (encin = "1111111111") THEN
      stimulating <= FALSE;  --stop stimulating clock
    END IF;

    encin <= encin + 1;
    encout := out_kerr & out_dispout & out_dout;

    IF (out_nd='1') THEN
      --for debug output only
      IF (debug_output) THEN

        IF firstpass THEN
          write(encM, STRING'("DISPIN F_CODE F_DISP CE KIN DIN(bin) DIN(int) "));
          write(encM, STRING'("KERR DISPOUT DOUT(bin)  "));
          writeline(encmiffile, encM);
          firstpass := FALSE;
        END IF;
        write(encM, STRING'("     "));
        write(encM, BIT'(To_bit(dlay_dispin)));
        write(encM, STRING'("      "));
        write(encM, BIT'(To_bit(dlay_force_code)));
        write(encM, STRING'("      "));
        write(encM, BIT'(To_bit(dlay_force_disp)));
        write(encM, STRING'("  "));
        write(encM, BIT'(To_bit(dlay_ce)));
        write(encM, STRING'("   "));
        write(encM, BIT'(To_bit(dlay_kin)));
        write(encM, ' ');
        write(encM, BIT_VECTOR'(To_bitvector(dlay_din)));
        write(encM, ' ');
        write(encM, conv_integer(dlay_din), justified=>RIGHT, field=>8);
        write(encM, STRING'("    "));
        write(encM, BIT'(To_bit(out_kerr)));
        write(encM, STRING'("       "));
        write(encM, BIT'(To_bit(out_dispout)));
        write(encM, ' ');
        write(encM, BIT_VECTOR'(To_bitvector(out_dout)));
        writeline(encmiffile, encM);
      ELSE
        --write the value on the output bus of the encoder to a file
        --Encoder output bus contents
        write(encM, BIT_VECTOR'(To_bitvector(encout)));
        writeline(encmiffile, encM);
      END IF;
    END IF; --do nothing if no new data(ND)
  END IF;
END PROCESS generate_mif_enc;

END xilinx;

