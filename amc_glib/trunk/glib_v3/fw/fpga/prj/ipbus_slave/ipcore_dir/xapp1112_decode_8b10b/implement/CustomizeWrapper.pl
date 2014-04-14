#!xilperl

##-----------------------------------------------------------------------------
##
##  File Name   : CustomizeWrapper.pl
##
##  Version     : 1.1
##
##  Last Update : 2008-10-31
##
##  Project     : 8b/10b Decoder Reference Design
##
##  Description : Perl script to configure the 8b/10b decoder parameters
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
use File::Copy;
use Cwd;

$cwd = cwd;

## Move the previous top-level core wrapper file to the /wrapper_bak directory
$filename = "./decode_8b10b_wrapper.vhd"; # wrapper file to be generated
$bakfilename = "./wrapper_bak/decode_8b10b_wrapper_bak.vhd"; # back up wrapper
copy($filename, $bakfilename) or
    die("Error:  $filename file cannot be backed up to $bakfilename\n");

## Copy the wrapper template file to the destination wrapper file
## Create a temporary file from the wrapper and user input
## (At the end, overwrite the wrapper file with the temporary file generated)
$template = "./wrapper_bak/WrapperTemplate.txt"; # template file
copy($template, $filename) or
    die("Error:  $template file cannot be copied to $filename\n");
$mode = 0644;
chmod $mode, $filename;
open(FILE, '<', "$filename") or
    die("Error:  Cannot open file $filename\n");
open(FILETMP, '>', "$filename.tmp") or
    die("Error:  Cannot open temp file $filename.tmp\n");

## Query user to configure the Decoder generics
print "\n\n***************************************************************\n";
print "8B/10B Decoder Reference Design Customizer v1.1 \n";
print "***************************************************************\n";

print "\n***************************************************************\n";
print "Please input the following parameters for the 8b/10b decoder: \n";
print "***************************************************************\n\n";

$txt = "Enter the decoder type to implement\n0 = LUT-based, 1 = BRAM-based: ";
$decode_type = query1($txt);
$has_bports = query1("0 = single decoder, 1 = dual decoder: ");

print "\nPlease select the optional ports to be implemented. \n";
if ($has_bports)
{   print "Note: for a dual decoder, the optional ports selected will be enabled \n";
    print "for both decoders.\n";}

print "\nPlease select from the following optional input ports: \n";
$has_ce = query2("Clock enable (CE) (y/n): ");
$has_sinit = query2("Synchronous Reset (SINIT) (y/n): ");
$has_disp_in = query2("Running Disparity In (DISP_IN) (y/n): ");

print "\nPlease select from the following optional output ports: \n";
$has_code_err = query2("Code Error (CODE_ERR) (y/n): ");
$has_disp_err = query2("Disparity Error (DISP_ERR) (y/n): ");
if ($has_ce eq "y") {$has_nd = query2("New Data (ND) (y/n): ");}
else {$has_nd = "n";}
$has_run_disp = query2("Running Disparity Out (RUN_DISP) (y/n): ");
$has_sym_disp = query2("Symbol Disparity Out (SYM_DISP) (y/n): ");

print "\n";
print "0 = D.0.0 (pos)\n";  #DOUT: 000_00000  KOUT: 0  RD: 1
print "1 = D.0.0 (neg)\n";  #DOUT: 000_00000  KOUT: 0  RD: 0
print "2 = D.10.2 (pos)\n"; #DOUT: 010_01010  KOUT: 0  RD: 1
print "3 = D.10.2 (neg)\n"; #DOUT: 010_01010  KOUT: 0  RD: 0
print "4 = D.21.5 (pos)\n"; #DOUT: 101_10101  KOUT: 0  RD: 1
print "5 = D.21.5 (neg)\n"; #DOUT: 101_10101  KOUT: 0  RD: 0
$sinit_val_a = query3("Please select the initialization value of decoder 1: ");

if ($has_bports eq "1") {
    print "\n";
    print "0 = D.0.0 (pos)\n";  #DOUT: 000_00000  KOUT: 0  RD: 1
    print "1 = D.0.0 (neg)\n";  #DOUT: 000_00000  KOUT: 0  RD: 0
    print "2 = D.10.2 (pos)\n"; #DOUT: 010_01010  KOUT: 0  RD: 1
    print "3 = D.10.2 (neg)\n"; #DOUT: 010_01010  KOUT: 0  RD: 0
    print "4 = D.21.5 (pos)\n"; #DOUT: 101_10101  KOUT: 0  RD: 1
    print "5 = D.21.5 (neg)\n"; #DOUT: 101_10101  KOUT: 0  RD: 0
    $sinit_val_b = query3("Please select the initialization value of decoder 2: ");
}
else {$sinit_val_b = 1;}

print ("\n\n\nVHDL parameters were generated as follows: \n");
print ("===============================================\n");
print ("C_DECODE_TYPE  : integer := $decode_type;\n");
print ("C_HAS_BPORTS   : integer := $has_bports;\n");
print ("C_HAS_CE       : integer := ", get_optpin($has_ce),";\n");
print ("C_HAS_SINIT    : integer := ", get_optpin($has_sinit),";\n");
print ("C_HAS_DISP_IN  : integer := ", get_optpin($has_disp_in),";\n");
print ("C_HAS_CODE_ERR : integer := ", get_optpin($has_code_err),";\n");
print ("C_HAS_DISP_ERR : integer := ", get_optpin($has_disp_err),";\n");
print ("C_HAS_ND       : integer := ", get_optpin($has_nd),";\n");
print ("C_HAS_RUN_DISP : integer := ", get_optpin($has_run_disp),";\n");
print ("C_HAS_SYM_DISP : integer := ", get_optpin($has_sym_disp),";\n");
print ("C_SINIT_VAL    : string  := ",get_init_val($sinit_val_a),";\n");
print ("C_SINIT_VAL_B  : string  := ",get_init_val($sinit_val_b),";\n\n");
print ("===============================================\n");

## set variable that define which ports are needed
$onlybasica = ((not $has_bports) and
               (not get_optpin($has_ce)) and
               (not get_optpin($has_nd)) and
               (not get_optpin($has_code_err)) and
               (not get_optpin($has_disp_err)) and
               (not get_optpin($has_disp_in)) and
               (not get_optpin($has_run_disp)) and
               (not get_optpin($has_sinit)) and
               (not get_optpin($has_sym_disp)));

$onlybasicb = ($has_bports and
               (not get_optpin($has_ce)) and
               (not get_optpin($has_nd)) and
               (not get_optpin($has_code_err)) and
               (not get_optpin($has_disp_err)) and
               (not get_optpin($has_disp_in)) and
               (not get_optpin($has_run_disp)) and
               (not get_optpin($has_sinit)) and
               (not get_optpin($has_sym_disp)));

$celast = ((get_optpin($has_ce)) and
           (not get_optpin($has_nd)) and
           (not get_optpin($has_code_err)) and
           (not get_optpin($has_disp_err)) and
           (not get_optpin($has_disp_in)) and
           (not get_optpin($has_run_disp)) and
           (not get_optpin($has_sinit)) and
           (not get_optpin($has_sym_disp)));

$sinitlast = ((get_optpin($has_sinit)) and
              (not get_optpin($has_disp_in)) and
              (not get_optpin($has_code_err)) and
              (not get_optpin($has_disp_err)) and
              (not get_optpin($has_nd)) and
              (not get_optpin($has_run_disp)) and
              (not get_optpin($has_sym_disp)));

$dispinlast = ((get_optpin($has_disp_in)) and
               (not get_optpin($has_code_err)) and
               (not get_optpin($has_disp_err)) and
               (not get_optpin($has_nd)) and
               (not get_optpin($has_run_disp)) and
               (not get_optpin($has_sym_disp)));

$codeerrlast = ((get_optpin($has_code_err)) and
                (not get_optpin($has_disp_err)) and
                (not get_optpin($has_nd)) and
                (not get_optpin($has_run_disp)) and
                (not get_optpin($has_sym_disp)));

$disperrlast = ((get_optpin($has_disp_err)) and
                (not get_optpin($has_nd)) and
                (not get_optpin($has_run_disp)) and
                (not get_optpin($has_sym_disp)));

$ndlast = ((get_optpin($has_nd)) and
           (not get_optpin($has_run_disp)) and
           (not get_optpin($has_sym_disp)));

$rundisplast = ((get_optpin($has_run_disp)) and
                (not get_optpin($has_sym_disp)));

$symdisplast = (get_optpin($has_sym_disp));

## Write the selected configuration to the wrapper temporary file
while (my $line = <FILE>)
{
    my $line1 = $line;
    $line1 =~ s/^\s+//;

    if ($line1 =~ /^\-\-/)
    {
        print FILETMP $line; #skip comment
    }
    ## Set instantiation generic
    elsif (($line1 =~ /DECODE_TYPE/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_DECODE_TYPE     => $decode_type, \n";
    }
    elsif (($line1 =~ /C_HAS_BPORTS/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_BPORTS      => $has_bports, \n";
    }
    elsif (($line1 =~ /C_HAS_CE/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_CE          => ", get_optpin($has_ce),",\n";
    }
    elsif (($line1 =~ /C_HAS_CODE_ERR/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_CODE_ERR    => ", get_optpin($has_code_err),",\n";
    }
    elsif (($line1 =~ /C_HAS_DISP_ERR/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_DISP_ERR    => ", get_optpin($has_disp_err),",\n";
    }
    elsif (($line1 =~ /C_HAS_DISP_IN/ and ($line1 =~ /=>/)))
    {
        print FILETMP "   C_HAS_DISP_IN     => ", get_optpin($has_disp_in),",\n";
    }
    elsif (($line1 =~ /C_HAS_ND/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_ND          => ", get_optpin($has_nd),",\n";
    }
    elsif (($line1 =~ /C_HAS_RUN_DISP/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_RUN_DISP    => ", get_optpin($has_run_disp),",\n";
    }
    elsif (($line1 =~ /C_HAS_SINIT/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_SINIT       => ", get_optpin($has_sinit),",\n";
    }
    elsif (($line1 =~ /C_HAS_SYM_DISP/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_SYM_DISP    => ", get_optpin($has_sym_disp),",\n";
    }
    elsif (($line1 =~ /C_SINIT_VAL_B/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_SINIT_VAL_B     => \"", get_init_val($sinit_val_b),"\"\n";
    }
    elsif (($line1 =~ /C_SINIT_VAL/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_SINIT_VAL       => \"", get_init_val($sinit_val_a),"\",\n";
    }
    ## Set ports for top level entity
    # mandatory a port in entity
    elsif (($line1 =~ /KOUT/) and not($line1 =~ /KOUT_B/)  and ($line1 =~ /STD/))
    {
        print FILETMP "    KOUT       : OUT STD_LOGIC                    ";
        if (not $onlybasica) {print FILETMP ";\n";}

    }
    # mandatory b port in entity
    elsif ((($line1 =~ /CLK_B/) or ($line1 =~ /DIN_B/) or ($line1 =~ /DOUT_B/) or ($line1 =~ /KOUT_B/)) and ($line1 =~ /STD/))
    {
        if (($has_bports) and not($line1 =~ /KOUT_B/))
        {   print FILETMP $line; }
        elsif ($has_bports)
        {
            print FILETMP "    KOUT_B     : OUT STD_LOGIC                    ";
            if ($onlybasicb) {print FILETMP "\n";} else {print FILETMP ";\n";}
        }
    }
    # CE port in entity
    elsif (($line1 =~ /CE/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_ce))
        {  if (not($line1 =~ /CE_B/))
           {   print FILETMP "    CE         : IN  STD_LOGIC                    := '0'";
               if ($celast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports) {
               print FILETMP "    CE_B       : IN  STD_LOGIC                    := '0'";
               if ($celast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #SINIT port in entity
    elsif (($line1 =~ /SINIT/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_sinit))
        {  if (not($line1 =~ /SINIT_B/))
           {   print FILETMP "    SINIT      : IN  STD_LOGIC                    := '0'";
               if ($sinitlast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports) {
               print FILETMP "    SINIT_B    : IN  STD_LOGIC                    := '0'";
               if ($sinitlast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #DISP_IN port in entity
    elsif (($line1 =~ /DISP_IN/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_disp_in))
        {  if (not($line1 =~ /DISP_IN_B/))
           {   print FILETMP "    DISP_IN    : IN  STD_LOGIC                    := '0'";
               if ($dispinlast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports)  {
               print FILETMP "    DISP_IN_B  : IN  STD_LOGIC                    := '0'";
               if ($dispinlast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #CODE_ERR port in entity
    elsif (($line1 =~ /CODE_ERR/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_code_err))
        {  if (not($line1 =~ /CODE_ERR_B/))
           {   print FILETMP "    CODE_ERR   : OUT STD_LOGIC                    := '0'";
               if ($codeerrlast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports)  {
               print FILETMP "    CODE_ERR_B : OUT STD_LOGIC                    := '0'";
               if ($codeerrlast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #DISP_ERR port in entity
    elsif (($line1 =~ /DISP_ERR/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_disp_err))
        {  if (not($line1 =~ /DISP_ERR_B/))
           {   print FILETMP "    DISP_ERR   : OUT STD_LOGIC                    := '0'";
               if ($disperrlast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports)  {
               print FILETMP "    DISP_ERR_B : OUT STD_LOGIC                    := '0'";
               if ($disperrlast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #ND port in entity
    elsif (($line1 =~ /ND/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_nd))
        {  if (not($line1 =~ /ND_B/))
           {   print FILETMP "    ND         : OUT STD_LOGIC                    := '0'";
               if ($ndlast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports)  {
               print FILETMP "    ND_B       : OUT STD_LOGIC                    := '0'";
               if ($ndlast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #RUN_DISP port in entity
    elsif (($line1 =~ /RUN_DISP/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_run_disp))
        {  if (not($line1 =~ /RUN_DISP_B/))
           {   print FILETMP "    RUN_DISP   : OUT STD_LOGIC                    ";
               if ($rundisplast and not($has_bports))
               {print FILETMP ":= '0'\n"} else {print FILETMP ":= '0';\n"}
           } elsif ($has_bports)  {
               print FILETMP "    RUN_DISP_B : OUT STD_LOGIC                    ";
               if ($rundisplast) {print FILETMP ":= '0'\n"} else {print FILETMP ":= '0';\n"}
           }
        }
    }
    #SYM_DISP port in entity
    elsif (($line1 =~ /SYM_DISP/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_sym_disp))
        {  if (not($line1 =~ /SYM_DISP_B/))
           {   print FILETMP "    SYM_DISP   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ";
               if ($symdisplast and not($has_bports))
               {print FILETMP ":= \"00\"\n"} else {print FILETMP ":= \"00\";\n"}
           } elsif ($has_bports)  {
               print FILETMP "    SYM_DISP_B : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ";
               if ($symdisplast) {print FILETMP ":= \"00\"\n"} else {print FILETMP ":= \"00\";\n"}
           }
        }
    }
    ## Port assignments for Decode_8b10b module
    # mandatory b port
    elsif ((($line1 =~ /CLK_B/) or ($line1 =~ /DIN_B/) or ($line1 =~ /DOUT_B/) or ($line1 =~ /KOUT_B/)) and ($line1 =~ /=>/))
    {
        if ($has_bports)
        {   print FILETMP $line; }
        else
        {
            if ($line1 =~ /CLK_B/)     { print FILETMP "    CLK_B      =>  LOW,\n";}
            elsif ($line1 =~ /DIN_B/)  { print FILETMP "    DIN_B      =>  LOWSLV,\n";}
            elsif ($line1 =~ /DOUT_B/) { print FILETMP "    DOUT_B     =>  open,\n";}
            elsif ($line1 =~ /KOUT_B/) { print FILETMP "    KOUT_B     =>  open,\n";}
        }
    }
    # CE port
    elsif (($line1 =~ /CE/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_ce))
        {   if (not($line1 =~ /CE_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    CE_B       =>  HIGH,\n";}
        }
        else
        {
            if ($line1 =~ /CE_B/) { print FILETMP "    CE_B       =>  HIGH,\n";}
            else                  { print FILETMP "    CE         =>  HIGH,\n";}

        }
    }
    # SINIT port
    elsif (($line1 =~ /SINIT/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_sinit))
        {   if (not($line1 =~ /SINIT_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    SINIT_B    =>  LOW, \n";}
        }
        else
        {
            if ($line1 =~ /SINIT_B/) { print FILETMP "    SINIT_B    =>  LOW, \n";}
            else                     { print FILETMP "    SINIT      =>  LOW, \n";}

        }
    }
    # DISP_IN port
    elsif (($line1 =~ /DISP_IN/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_disp_in))
        {   if (not($line1 =~ /DISP_IN_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    DISP_IN_B  =>  LOW, \n";}
        }
        else
        {
            if ($line1 =~ /DISP_IN_B/) { print FILETMP "    DISP_IN_B  =>  LOW, \n";}
            else                       { print FILETMP "    DISP_IN    =>  LOW, \n";}

        }
    }
    # CODE_ERR port
    elsif (($line1 =~ /CODE_ERR/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_code_err))
        {   if (not($line1 =~ /CODE_ERR_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    CODE_ERR_B =>  open, \n";}
        }
        else
        {
            if ($line1 =~ /CODE_ERR_B/) { print FILETMP "    CODE_ERR_B =>  open, \n";}
            else                        { print FILETMP "    CODE_ERR   =>  open, \n";}

        }
    }
    # DISP_ERR port
    elsif (($line1 =~ /DISP_ERR/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_disp_err))
        {   if (not($line1 =~ /DISP_ERR_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    DISP_ERR_B =>  open,\n";}
        }
        else
        {
            if ($line1 =~ /DISP_ERR_B/) { print FILETMP "    DISP_ERR_B =>  open, \n";}
            else                        { print FILETMP "    DISP_ERR   =>  open, \n";}

        }
    }
    # ND port
    elsif (($line1 =~ /ND/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_nd))
        {   if (not($line1 =~ /ND_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    ND_B       =>  open,\n";}
        }
        else
        {
            if ($line1 =~ /ND_B/) { print FILETMP "    ND_B       =>  open, \n";}
            else                        { print FILETMP "    ND         =>  open, \n";}

        }
    }
    #RUN_DISP port
    elsif (($line1 =~ /RUN_DISP/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_run_disp))
        {   if (not($line1 =~ /RUN_DISP_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    RUN_DISP_B =>  open,\n";}
        }
        else
        {
            if ($line1 =~ /RUN_DISP_B/) { print FILETMP "    RUN_DISP_B =>  open, \n";}
            else                        { print FILETMP "    RUN_DISP   =>  open, \n";}

        }
    }
    #SYM_DISP port
    elsif (($line1 =~ /SYM_DISP/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_sym_disp))
        {   if (not($line1 =~ /SYM_DISP_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    SYM_DISP_B =>  open \n";}
        }
        else
        {
            if ($line1 =~ /SYM_DISP_B/) { print FILETMP "    SYM_DISP_B =>  open  \n";}
            else                        { print FILETMP "    SYM_DISP   =>  open,  \n";}

        }
    }
    else
    {
        print FILETMP $line;
    }
}

close FILE;
close FILETMP;

# Over-write the wrapper file with the configured (temporary) wrapper file
rename "$filename.tmp", $filename or
    die("Error:  Cannot overwrite $filename\n");

#####################################################
#####################################################
#####################################################
####
####     General Subroutines
####
#####################################################
#####################################################
#####################################################

#-----------------------------------------------------
# Convert user response from y/n to 1/0
#-----------------------------------------------------
sub get_optpin {
    my $sel = shift();
    if ($sel eq 'y' || $sel eq 'Y') {return '1';}
    else {return '0';}
}

#-----------------------------------------------------
# Convert init val to 10 char string of 0s and 1s
#-----------------------------------------------------
sub get_init_val {
    my $val = shift() + 0;
    if ($val == 0)    {return "0000000001";}
    elsif ($val == 1) {return "0000000000";}
    elsif ($val == 2) {return "0100101001";}
    elsif ($val == 3) {return "0100101000";}
    elsif ($val == 4) {return "1011010101";}
    elsif ($val == 5) {return "1011010100";}
    return "0000000000";
}

#-----------------------------------------------------
# Query user for input; re-query if invalid
#-----------------------------------------------------
sub query1 {
    my $txt = shift();
    do {
        print $txt;
        $_ = <STDIN>;
        chomp($_);
        if (is_valid1($_) == 0) {print "  *** Invalid input $_ ***\n";}
    }
    while (is_valid1($_) == 0);
    return $_;
}
#-----------------------------------------------------
# Query user for input; re-query if invalid
#-----------------------------------------------------
sub query2 {
    my $txt = shift();
    do {
        print $txt;
        $_ = <STDIN>;
        chomp($_);
        if (is_valid2($_) == 0) {print "  *** Invalid input $_ ***\n";}
    }
    while (is_valid2($_) == 0);
    return $_;
}
#-----------------------------------------------------
# Query user for input; re-query if invalid
#-----------------------------------------------------
sub query3 {
    my $txt = shift();
    do {
        print $txt;
        $_ = <STDIN>;
        chomp($_);
        if (is_valid3($_) == 0) {print "  *** Invalid input $_ ***\n";}
    }
    while (is_valid3($_) == 0);
    return $_;
}

#-----------------------------------------------------
# Check if the user response is 0 or 1
#-----------------------------------------------------
sub is_valid1 {
    my $rsp = shift();
    if ($rsp eq '0' || $rsp eq '1') {return 1;}
    else {return 0;}
}

#-----------------------------------------------------
# Check if the user response is y, Y, n, or N
#-----------------------------------------------------
sub is_valid2 {
    my $rsp = shift();
    if ($rsp eq 'y' || $rsp eq 'Y' ||
        $rsp eq 'n' || $rsp eq 'N') {return 1;}
    else {return 0;}
}

#-----------------------------------------------------
# Check if the user response is 0, 1, 2, 3, 4, or 5
#-----------------------------------------------------
sub is_valid3 {
    my $rsp = shift();
    if ($rsp eq '0' || $rsp eq '1' || $rsp eq '2' ||
        $rsp eq '3' || $rsp eq '4' || $rsp eq '5') {return 1;}
    else {return 0;}
}
