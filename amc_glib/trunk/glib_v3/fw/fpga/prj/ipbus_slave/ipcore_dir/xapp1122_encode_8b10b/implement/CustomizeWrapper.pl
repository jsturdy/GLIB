#!xilperl

##-----------------------------------------------------------------------------
##
##  File Name   : CustomizeWrapper.pl
##
##  Version     : 1.1
##
##  Last Update : 2008-10-31
##
##  Project     : 8b/10b Encoder Reference Design
##
##  Description : Perl script to configure the 8b/10b encoder parameters
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
$filename = "./encode_8b10b_wrapper.vhd"; # wrapper file to be generated
$bakfilename = "./wrapper_bak/encode_8b10b_wrapper_bak.vhd"; # back up wrapper
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

## Query user to configure the Encoder generics
print "\n\n***************************************************************\n";
print "8B/10B Encoder Reference Design Customizer v1.1 \n";
print "***************************************************************\n";

print "\n***************************************************************\n";
print "Please input the following parameters for the 8b/10b encoder: \n";
print "***************************************************************\n\n";

$txt = "Enter the encoder type to implement\n0 = LUT-based, 1 = BRAM-based: ";
$encode_type = query1($txt);
$has_bports = query1("0 = single encoder, 1 = dual encoder: ");

print "\nPlease select the optional ports to be implemented. \n";
if ($has_bports)
{   print "Note: for a dual encoder, the optional ports selected will be enabled \n";
    print "for both encoders.\n";}

print "\nPlease select from the following optional input ports: \n";
$has_ce = query2("Clock enable (CE) (y/n): ");
$has_force_code = query2("Force Code (FORCE_CODE) (y/n): ");
$has_disp_in = query2("Running Disparity In (DISP_IN and FORCE_DISP) (y/n): ");

print "\nPlease select from the following optional output ports: \n";
$has_disp_out = query2("Running Disparity Out (DISP_OUT) (y/n): ");
if ($has_ce eq "y") {$has_nd = query2("New Data (ND) (y/n): ");}
else {$has_nd = "n";}
$has_kerr = query2("Command Error (KERR) (y/n): ");


if (get_optpin($has_force_code)) {
    print "\n";
    print "0 = D.10.2 (pos)\n";  # 1010101010 1
    print "1 = D.10.2 (neg)\n";  # 1010101010 0
    print "2 = D.21.5 (pos)\n";  # 0101010101 1
    print "3 = D.21.5 (neg)\n";  # 0101010101 0
    print "4 = K.28.5 (neg)\n";  # 0101111100 0
    $force_code_val_a = query3("Please select the Force Code Value (C_FORCE_CODE_VAL) for encoder 1 (0-4): ");
    if ($force_code_val_a eq '0' || $force_code_val_a eq '2') {
        $force_code_disp_a = 1;
    }
    else {$force_code_disp_a = 0;}

    if ($has_bports eq "1") {
        print "\n";
        print "0 = D.10.2 (pos)\n";  # 1010101010 1
        print "1 = D.10.2 (neg)\n";  # 1010101010 0
        print "2 = D.21.5 (pos)\n";  # 0101010101 1
        print "3 = D.21.5 (neg)\n";  # 0101010101 0
        print "4 = K.28.5 (neg)\n";  # 0101111100 0
        $force_code_val_b = query3("Please select the Force Code Value (C_FORCE_CODE_VAL_B) for encoder 2 (0-4): ");
        if ($force_code_val_b eq '0' || $force_code_val_b eq '2') {
            $force_code_disp_b = 1;
        }
        else {$force_code_disp_b = 0;}
    }
    else {
        $force_code_val_b = 1;
        $force_code_disp_b = 0;
    }
}
else {
    $force_code_disp_a = 0;
    $force_code_disp_b = 0;
    $force_code_val_a = 1;
    $force_code_val_b = 1;
}
print ("\n\n\nVHDL parameters were generated as follows: \n");
print ("===============================================\n");
print ("C_ENCODE_TYPE       : INTEGER := $encode_type;\n");
print ("C_FORCE_CODE_DISP   : INTEGER := $force_code_disp_a;\n");
print ("C_FORCE_CODE_DISP_B : INTEGER := $force_code_disp_b;\n");
print ("C_FORCE_CODE_VAL    : STRING  := ",get_init_val($force_code_val_a),";\n");
print ("C_FORCE_CODE_VAL_B  : STRING  := ",get_init_val($force_code_val_b),";\n");
print ("C_HAS_BPORTS        : INTEGER := $has_bports;\n");
print ("C_HAS_CE            : INTEGER := ", get_optpin($has_ce),";\n");
print ("C_HAS_DISP_OUT      : INTEGER := ", get_optpin($has_disp_out),";\n");
print ("C_HAS_DISP_IN       : INTEGER := ", get_optpin($has_disp_in),";\n");
print ("C_HAS_FORCE_CODE    : INTEGER := ", get_optpin($has_force_code),";\n");
print ("C_HAS_KERR          : INTEGER := ", get_optpin($has_kerr),";\n");
print ("C_HAS_ND            : INTEGER := ", get_optpin($has_nd),";\n");
print ("===============================================\n");

## set variable that define which ports are needed
$onlybasica = ((not $has_bports) and
               (not get_optpin($has_ce)) and
               (not get_optpin($has_force_code)) and
               (not get_optpin($has_disp_in)) and
               (not get_optpin($has_disp_out)) and
               (not get_optpin($has_nd)) and
               (not get_optpin($has_kerr)));

$onlybasicb = ($has_bports and
               (not get_optpin($has_ce)) and
               (not get_optpin($has_force_code)) and
               (not get_optpin($has_disp_in)) and
               (not get_optpin($has_disp_out)) and
               (not get_optpin($has_nd)) and
               (not get_optpin($has_kerr)));

$celast = ((get_optpin($has_ce)) and
           (not get_optpin($has_force_code)) and
           (not get_optpin($has_disp_in)) and
           (not get_optpin($has_disp_out)) and
           (not get_optpin($has_nd)) and
           (not get_optpin($has_kerr)));

$force_codelast = ((get_optpin($has_force_code)) and
                   (not get_optpin($has_disp_in)) and
                   (not get_optpin($has_disp_out)) and
                   (not get_optpin($has_nd)) and
                   (not get_optpin($has_kerr)));

$dispinlast = ((get_optpin($has_disp_in)) and
               (not get_optpin($has_disp_out)) and
               (not get_optpin($has_nd)) and
               (not get_optpin($has_kerr)));

$dispoutlast = ((get_optpin($has_disp_out)) and
                (not get_optpin($has_nd)) and
                (not get_optpin($has_kerr)));

$ndlast = ((get_optpin($has_nd)) and
           (not get_optpin($has_kerr)));

$kerrlast = (get_optpin($has_kerr));

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
    elsif (($line1 =~ /ENCODE_TYPE/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_ENCODE_TYPE       => $encode_type, \n";
    }
    elsif (($line1 =~ /C_HAS_BPORTS/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_BPORTS        => $has_bports, \n";
    }
    elsif (($line1 =~ /C_HAS_CE/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_CE            => ", get_optpin($has_ce),",\n";
    }
    elsif (($line1 =~ /C_HAS_KERR/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_KERR          => ", get_optpin($has_kerr),",\n";
    }
    elsif (($line1 =~ /C_HAS_DISP_IN/ and ($line1 =~ /=>/)))
    {
        print FILETMP "   C_HAS_DISP_IN       => ", get_optpin($has_disp_in),",\n";
    }
    elsif (($line1 =~ /C_HAS_ND/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_ND            => ", get_optpin($has_nd),"\n";
    }
    elsif (($line1 =~ /C_HAS_DISP_OUT/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_DISP_OUT      => ", get_optpin($has_disp_out),",\n";
    }
    elsif (($line1 =~ /C_HAS_FORCE_CODE/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_HAS_FORCE_CODE    => ", get_optpin($has_force_code),",\n";
    }
    elsif (($line1 =~ /C_FORCE_CODE_DISP_B/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_FORCE_CODE_DISP_B => $force_code_disp_b, \n";
    }
    elsif (($line1 =~ /C_FORCE_CODE_DISP/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_FORCE_CODE_DISP   => $force_code_disp_a, \n";
    }
    elsif (($line1 =~ /C_FORCE_CODE_VAL_B/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_FORCE_CODE_VAL_B  => \"", get_init_val($force_code_val_b),"\",\n";
    }
    elsif (($line1 =~ /C_FORCE_CODE_VAL/) and ($line1 =~ /=>/))
    {
        print FILETMP "   C_FORCE_CODE_VAL    => \"", get_init_val($force_code_val_a),"\",\n";
    }
    ## Set ports for top level entity
    # mandatory a port in entity
    elsif (($line1 =~ /DOUT/) and not($line1 =~ /DOUT_B/)  and ($line1 =~ /STD/))
    {
        print FILETMP "    DOUT         : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)       ";
        if (not $onlybasica) {print FILETMP ";\n";}

    }
    # mandatory b port in entity
    elsif ((($line1 =~ /CLK_B/) or ($line1 =~ /DIN_B/) or ($line1 =~ /DOUT_B/) or ($line1 =~ /KIN_B/)) and ($line1 =~ /STD/))
    {
        if (($has_bports) and not($line1 =~ /DOUT_B/))
        {   print FILETMP $line; }
        elsif ($has_bports)
        {
            print FILETMP "    DOUT_B       : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)       ";
            if ($onlybasicb) {print FILETMP "\n";} else {print FILETMP ";\n";}
        }
    }
    #FORCE_CODE port in entity
    elsif (($line1 =~ /FORCE_CODE/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_force_code)) {
            if (not($line1 =~ /FORCE_CODE_B/)) {
                print FILETMP "    FORCE_CODE   : IN  STD_LOGIC                    := '0'";
                if ($force_codelast and not($has_bports))
                {print FILETMP "\n"} else {print FILETMP ";\n"}
            } elsif ($has_bports) {
                print FILETMP "    FORCE_CODE_B : IN  STD_LOGIC                    := '0'";
                if ($force_codelast) {print FILETMP "\n"} else {print FILETMP ";\n"}
            }
        }
    }
    #FORCE_DISP port in entity
    elsif (($line1 =~ /FORCE_DISP/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_disp_in)) {
            if (not($line1 =~ /FORCE_DISP_B/)) {
                print FILETMP "    FORCE_DISP   : IN  STD_LOGIC                    := '0';\n";
            }
            elsif ($has_bports) {
                print FILETMP "    FORCE_DISP_B : IN  STD_LOGIC                    := '0';\n";
            }
        }
    }
    # CE port in entity
    elsif (($line1 =~ /CE/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_ce))
        {  if (not($line1 =~ /CE_B/))
           {   print FILETMP "    CE           : IN  STD_LOGIC                    := '0'";
               if ($celast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports) {
               print FILETMP "    CE_B         : IN  STD_LOGIC                    := '0'";
               if ($celast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #DISP_IN port in entity
    elsif (($line1 =~ /DISP_IN/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_disp_in))
        {  if (not($line1 =~ /DISP_IN_B/))
           {   print FILETMP "    DISP_IN      : IN  STD_LOGIC                    := '0'";
               if ($dispinlast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports)  {
               print FILETMP "    DISP_IN_B    : IN  STD_LOGIC                    := '0'";
               if ($dispinlast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #KERR port in entity
    elsif (($line1 =~ /KERR/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_kerr))
        {  if (not($line1 =~ /KERR_B/))
           {   print FILETMP "    KERR         : OUT STD_LOGIC                    := '0'";
               if ($kerrlast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports)  {
               print FILETMP "    KERR_B       : OUT STD_LOGIC                    := '0'";
               if ($kerrlast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #ND port in entity
    elsif (($line1 =~ /ND/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_nd))
        {  if (not($line1 =~ /ND_B/))
           {   print FILETMP "    ND           : OUT STD_LOGIC                    := '0'";
               if ($ndlast and not($has_bports))
               {print FILETMP "\n"} else {print FILETMP ";\n"}
           } elsif ($has_bports)  {
               print FILETMP "    ND_B         : OUT STD_LOGIC                    := '0'";
               if ($ndlast) {print FILETMP "\n"} else {print FILETMP ";\n"}
           }
        }
    }
    #DISP_OUT port in entity
    elsif (($line1 =~ /DISP_OUT/) and ($line1 =~ /STD/))
    {
        if (get_optpin($has_disp_out))
        {  if (not($line1 =~ /DISP_OUT_B/))
           {   print FILETMP "    DISP_OUT     : OUT STD_LOGIC                    ";
               if ($dispoutlast and not($has_bports))
               {print FILETMP "     \n"} else {print FILETMP "      ;\n"}
           } elsif ($has_bports)  {
               print FILETMP "    DISP_OUT_B   : OUT STD_LOGIC                    ";
               if ($dispoutlast) {print FILETMP "      \n"} else {print FILETMP "      ;\n"}
           }
        }
    }
    ## Port assignments for Encode_8b10b module
    # mandatory b port
    elsif ((($line1 =~ /CLK_B/) or ($line1 =~ /DIN_B/) or ($line1 =~ /DOUT_B/) or ($line1 =~ /KIN_B/)) and ($line1 =~ /=>/))
    {
        if ($has_bports)
        {   print FILETMP $line; }
        else
        {
            if ($line1 =~ /CLK_B/)     { print FILETMP "    CLK_B         =>  LOW,\n";}
            elsif ($line1 =~ /DIN_B/)  { print FILETMP "    DIN_B         =>  LOWSLV,\n";}
            elsif ($line1 =~ /DOUT_B/) { print FILETMP "    DOUT_B        =>  open,\n";}
            elsif ($line1 =~ /KIN_B/)  { print FILETMP "    KIN_B         =>  LOW,\n";}
        }
    }
    # FORCE_CODE port
    elsif (($line1 =~ /FORCE_CODE/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_force_code))
        {   if (not($line1 =~ /FORCE_CODE_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    FORCE_CODE_B  =>  LOW, \n";}
        }
        else
        {
            if ($line1 =~ /FORCE_CODE_B/) { print FILETMP "    FORCE_CODE_B  =>  LOW, \n";}
            else                     { print FILETMP "    FORCE_CODE    =>  LOW, \n";}

        }
    }
    # FORCE_DISP port
    elsif (($line1 =~ /FORCE_DISP/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_disp_in))
        {   if (not($line1 =~ /FORCE_DISP_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    FORCE_DISP_B  =>  LOW, \n";}
        }
        else
        {
            if ($line1 =~ /FORCE_DISP_B/) { print FILETMP "    FORCE_DISP_B  =>  LOW, \n";}
            else                     { print FILETMP "    FORCE_DISP    =>  LOW, \n";}

        }
    }
    # CE port
    elsif (($line1 =~ /CE/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_ce))
        {   if (not($line1 =~ /CE_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    CE_B          =>  HIGH,\n";}
        }
        else
        {
            if ($line1 =~ /CE_B/) { print FILETMP "    CE_B          =>  HIGH,\n";}
            else                  { print FILETMP "    CE            =>  HIGH,\n";}

        }
    }
    # DISP_IN port
    elsif (($line1 =~ /DISP_IN/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_disp_in))
        {   if (not($line1 =~ /DISP_IN_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    DISP_IN_B     =>  LOW, \n";}
        }
        else
        {
            if ($line1 =~ /DISP_IN_B/) { print FILETMP "    DISP_IN_B     =>  LOW, \n";}
            else                       { print FILETMP "    DISP_IN       =>  LOW, \n";}

        }
    }
    # KERR port
    elsif (($line1 =~ /KERR/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_kerr))
        {   if (not($line1 =~ /KERR_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    KERR_B        =>  open \n";}
        }
        else
        {
            if ($line1 =~ /KERR_B/) { print FILETMP "    KERR_B        =>  open \n";}
            else                        { print FILETMP "    KERR          =>  open, \n";}

        }
    }
    # ND port
    elsif (($line1 =~ /ND/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_nd))
        {   if (not($line1 =~ /ND_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    ND_B          =>  open,\n";}
        }
        else
        {
            if ($line1 =~ /ND_B/) { print FILETMP "    ND_B          =>  open, \n";}
            else                        { print FILETMP "    ND            =>  open, \n";}

        }
    }
    #DISP_OUT port
    elsif (($line1 =~ /DISP_OUT/) and ($line1 =~ /=>/))
    {
        if (get_optpin($has_disp_out))
        {   if (not($line1 =~ /DISP_OUT_B/) or ($has_bports))
            { print FILETMP $line; }
            else
            { print FILETMP "    DISP_OUT_B    =>  open,\n";}
        }
        else
        {
            if ($line1 =~ /DISP_OUT_B/) { print FILETMP "    DISP_OUT_B    =>  open, \n";}
            else                        { print FILETMP "    DISP_OUT      =>  open, \n";}

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
    if ($val == 0)    {return "1010101010"}
    elsif ($val == 1) {return "1010101010"}
    elsif ($val == 2) {return "0101010101"}
    elsif ($val == 3) {return "0101010101"}
    elsif ($val == 4) {return "0101111100"}
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
# Check if the user response is 0, 1, 2, 3, or 4
#-----------------------------------------------------
sub is_valid3 {
    my $rsp = shift();
    if ($rsp eq '0' || $rsp eq '1' || $rsp eq '2' ||
        $rsp eq '3' || $rsp eq '4') {return 1;}
    else {return 0;}
}
