#!xilperl

##-----------------------------------------------------------------------------
##
##  File Name   : MakeMIF.pl
##
##  Version     : 1.1
##
##  Last Update : 2008-10-31
##
##  Project     : 8b/10b Encoder Reference Design
##
##  Description : Perl script to generate the .mif file required for
##                implementing the blockRAM-based 8b/10b encoder
##
##  Company     : Xilinx, Inc.
##
##  DISCLAIMER OF LIABILITY
##
##                This file contains proprietary and confidential information of
##                Xilinx, Inc. ("Xilinx"), that is distributed under a license
##                from Xilinx, and may be used, copied and/or disclosed only
##                pursuant to the terms of a valid license agreement with Xilinx.
##
##                XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
##                ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
##                EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
##                LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
##                MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
##                does not warrant that functions included in the Materials will
##                meet the requirements of Licensee, or that the operation of the
##                Materials will be uninterrupted or error-free, or that defects
##                in the Materials will be corrected.  Furthermore, Xilinx does
##                not warrant or make any representations regarding use, or the
##                results of the use, of the Materials in terms of correctness,
##                accuracy, reliability or otherwise.
##
##                Xilinx products are not designed or intended to be fail-safe,
##                or for use in any application requiring fail-safe performance,
##                such as life-support or safety devices or systems, Class III
##                medical devices, nuclear facilities, applications related to
##                the deployment of airbags, or any other applications that could
##                lead to death, personal injury or severe property or
##                environmental damage (individually and collectively, "critical
##                applications").  Customer assumes the sole risk and liability
##                of any use of Xilinx products in critical applications,
##                subject only to applicable laws and regulations governing
##                limitations on product liability.
##
##                Copyright 2008 Xilinx, Inc.  All rights reserved.
##
##                This disclaimer and copyright notice must be retained as part
##                of this file at all times.
##
##-----------------------------------------------------------------------------
##
##  History
##
##  Date        Version   Description
##
##  10/31/2008  1.1       Initial release
##
##-----------------------------------------------------------------------------

use File::Path;

print "\nCleaning up any previously compiled encoder files...\n";
rmtree('encode_8b10b', 1, 1);

print "\n==============================================";
print "\nCompiling 8b/10b encoder LUT-version files....\n";
print "==============================================\n";
system ("vlib encode_8b10b");
system ("vcom -93 -work encode_8b10b ./../src/vhdl/encode_8b10b_pkg.vhd");
system ("vcom -93 -work encode_8b10b ./../src/vhdl/encode_8b10b_lut_base.vhd");
system ("vcom -93 -work encode_8b10b ./mifgen_enc.vhd");

print "\n====================================================";
print "\nRunning Modelsim and generating new MIF file....";
print "\n====================================================\n";
system ("vsim -c -do MakeMIF_mti.do");
print "\n\nMIF file generation complete\n";
