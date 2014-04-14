#!xilperl

##-----------------------------------------------------------------------------
##
##  File Name   : Implement.pl
##
##  Version     : 1.1
##
##  Last Update : 2008-10-31
##
##  Project     : 8b/10b Decoder Reference Design
##
##  Description : Perl script to implement the 8b/10b Decoder
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

print "\nImplementing the 8b/10b Decoder Reference Design\n";

print "\n===============================================\n";
print "Running Ngdbuild...\n";
system ("ngdbuild -p 5vlx30-ff324-1 -sd ./results -dd ./results -nt on decode_8b10b ./results/decode_8b10b.ngd");

print "\n===============================================\n";
print "Running Map...\n";
system ("map -w -o ./results/decode_8b10b_map.ncd ./results/decode_8b10b.ngd");

print "\n===============================================\n";
print "Running PAR...\n";
system ("par -w ./results/decode_8b10b_map.ncd ./results/decode_8b10b_routed.ncd");

# move implementation output products to /results directory
rename "decode_8b10b_wrapper_map.xrpt", "results/decode_8b10b_wrapper_map.xrpt";
rename "decode_8b10b_wrapper_par.xrpt", "results/decode_8b10b_wrapper_par.xrpt";
rename "xilinx_device_details.xml", "results/xilinx_device_details.xml";
rename "xlnx_auto_0.ise", "results/xlnx_auto_0.ise";
rename "xlnx_auto_0_xdb", "results/xlnx_auto_0_xdb";
