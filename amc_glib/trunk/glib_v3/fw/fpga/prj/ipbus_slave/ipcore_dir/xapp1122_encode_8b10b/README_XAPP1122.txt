
             Application Note: XAPP1122 - Xilinx 8b/10b Encoder
             Version: v1.1
             Release Date: October 31, 2008

================================================================================
  
      File Name:  README_XAPP1122.txt
  
        Project:  8b/10b Encoder Reference Design
  
        Company:  Xilinx, Inc.
  
    DISCLAIMER OF LIABILITY
  
                  This file contains proprietary and confidential information of
                  Xilinx, Inc. ("Xilinx"), that is distributed under a license
                  from Xilinx, and may be used, copied and/or disclosed only
                  pursuant to the terms of a valid license agreement with Xilinx.
  
                  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
                  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
                  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
                  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
                  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
                  does not warrant that functions included in the Materials will
                  meet the requirements of Licensee, or that the operation of the
                  Materials will be uninterrupted or error-free, or that defects
                  in the Materials will be corrected.  Furthermore, Xilinx does
                  not warrant or make any representations regarding use, or the
                  results of the use, of the Materials in terms of correctness,
                  accuracy, reliability or otherwise.
  
                  Xilinx products are not designed or intended to be fail-safe,
                  or for use in any application requiring fail-safe performance,
                  such as life-support or safety devices or systems, Class III
                  medical devices, nuclear facilities, applications related to
                  the deployment of airbags, or any other applications that could
                  lead to death, personal injury or severe property or
                  environmental damage (individually and collectively, "critical
                  applications").  Customer assumes the sole risk and liability
                  of any use of Xilinx products in critical applications,
                  subject only to applicable laws and regulations governing
                  limitations on product liability.
  
                  Copyright 2008 Xilinx, Inc.  All rights reserved.
  
                  This disclaimer and copyright notice must be retained as part
                  of this file at all times.
  
================================================================================

This document contains the following sections: 

1. Introduction
2. New Features
3. Instructions
 3.1. Summary of Tool Support
  3.1.1. Installation of the Design and Tools
 3.2. File List and Hierarchy
  3.2.1. File Information
 3.3. Parameterizing the RTL 
  3.3.1. Automatic Configuration
  3.3.2. Manual Configuration
 3.4. Netlist Generation
  3.4.1. XST Script
 3.5. Implementation Script
 3.6. Generating the MIF file (ModelSim)
 3.7. Importing Design Files into ISE
4. Resolved Issues (originally in the 8b/10b Encoder LogiCORE IP core)
5. Known Issues 
6. Technical Support
7. Release History
 
================================================================================

1. INTRODUCTION

This package contains the source code for the 8b/10b Encoder Reference Design.
The Application Note that accompanies this design is XAPP1122.  This 
application note describes the implementation of an 8b/10b encoder, which encodes
8-bit words into 10-bit DC-balanced symbols.  The Reference Design is based on 
the ISE Core Generator 8b/10b Encoder v5.0 LogiCORE IP netlist core.  Supported 
device families for this reference design are: Virtex-II, Virtex-II Pro, 
Spartan-3, Spartan-3E, Spartan-3A, Spartan-3A DSP, Virtex-4, Virtex-5 and newer 
architectures.

The 8b/10b code is a byte oriented binary transmission code. The 256 possible 
byte values and 12 additional special command characters are encoded into ten bit 
symbols by the 8b/10b encoder. The symbols are typically then serialized for 
transmission across a link's physical media (fiber, copper).  At the receiver, 
they are de-serialized. Following de-serialization, the symbols are decoded back 
into eight bit symbols by the 8b/10b decoder.  

The 8b/10b Encoder is a fully synchronous design.  The bulk of the encoding logic 
can be constructed out of LUTs or a single BRAM.  Optional input ports provide 
additional system control, such as Clock Enable (CE), Force Code (FORCE_CODE),
and a disparity override (FORCE_DISP, DISP_IN).  Optional output ports provide 
visibility into the encoder operation, such as the current running disparity 
(DISP_OUT), New Data (ND) and command error (KERR).

For further information please refer to XAPP1122 at 
http://www.xilinx.com/support/documentation/application_notes/xapp1122.pdf

This README describes the necessary steps for configuring the design parameters, 
and running XST, Ngdbuild, Map, and PAR on the 8b/10b Encoder Reference Design.
Additionally, it describes how to generate a new .mif file for the BRAM 
implementation of the 8b/10b Encoder, if the encoder look-up table is modified 
beyond this reference design.


2. NEW FEATURES  
 
   - Virtex-5 support
   - Spartan-3E support
   - Spartan-3A support
   - Default initialization values have been assigned to the Encoder ports and
     signals.  These values dictate the initial state of the design on power-up.
     The initial values for DOUT, DOUT_B, DISP_OUT, and DISP_OUT_B are assigned 
     by the generics C_FORCE_CODE_VAL, C_FORCE_CODE_VAL_B, C_FORCE_CODE_DISP, and
     C_FORCE_CODE_DISP_B, respectively.  The default for all other ports and
     signals is 0.

 
3. INSTRUCTIONS


3.1. SUMMARY OF TOOL SUPPORT

   - Xilinx ISE 10.1 (including XST 10.1 and xilperl)
   - ModelSim 6.3c    : required for generating a new .mif file (optional)


3.1.1. INSTALLATION OF THE DESIGN AND TOOLS

   - Install Xilinx ISE 10.1
     - The provided Reference Design Perl scripts must be invoked using a Perl 
       program such as xilperl, which is distributed with Xilinx ISE software. 
       In the Windows environment, the scripts are intended to be executed 
       within a Windows command window (DOS shell).

   - Extract the zip file (xapp1122_encode_8b10b.zip) into a directory 


3.2. FILE LIST AND HIERARCHY

Note: Only VHDL source is available in this release.

/xapp1122_encode_8b10b
    |
    +--> README_XAPP1122.txt (this file)
    +--> /src
    |      |
    |      +--> enc.mif
    |      +--> /vhdl 
    |            |
    |            | (in compilation order)
    |            +--> encode_8b10b_pkg.vhd
    |            +--> encode_8b10b_lut_base.vhd
    |            +--> encode_8b10b_lut.vhd
    |            +--> encode_8b10b_bram.vhd
    |            +--> encode_8b10b_rtl.vhd
    |            +--> encode_8b10b_top.vhd
    |
    +--> /implement
    |      |
    |      +--> CustomizeWrapper.pl
    |      +--> encode_8b10b_wrapper.vhd
    |      +--> /wrapper_bak
    |      |     |
    |      |     +--> WrapperTemplate.txt
    |      |     
    |      +--> RunXST.pl
    |      +--> vhdl_xst.scr
    |      +--> vhdl_xst.prj
    |      +--> Implement.pl
    |      +--> /results
    |
    +--> /bram_init
           |
           +--> MakeMIF.pl
           +--> mifgen_enc.vhd
           +--> MakeMIF_mti.do


3.2.1. FILE INFORMATION

  - README_XAPP1122.txt       : describes the Reference Design files and script 
    (this file)                 files, and includes instructions to execute the
                                provided scripts

  - /src directory            : contains the 8b/10b Encoder source files,
                                including the VHDL RTL and enc.mif file 

  - enc.mif                   : text file containing a 1024 x 12-bit table for
                                initializing the encoder BRAM, if applicable

  - /vhdl directory           : contains the 8b/10b Encoder RTL files

  - encode_8b10b_pkg.vhd      : VHDL RTL - package file containing commonly used
                                constants and functions 

  - encode_8b10b_lut_base.vhd : VHDL RTL - implementation containing single
                                LUT-based Encoder

  - encode_8b10b_lut.vhd      : VHDL RTL - LUT implementation of the Encoder

  - encode_8b10b_bram.vhd     : VHDL RTL - BRAM implementation of the Encoder

  - encode_8b10b_rtl.vhd      : VHDL RTL - top-level core file

  - encode_8b10b_top.vhd      : VHDL RTL - core wrapper file.  Translates the 12
                                simplified generics in the top-level core 
                                wrapper file (encode_8b10b_wrapper.vhd) to the
                                full set of 19 generics in the top-level core
                                file (encode_8b10b_rtl.vhd)

  - /implement directory      : contains the 8b/10b Encoder top-level core 
                                wrapper file, scripts, and supplemental 
                                files/directories for implementing the 8b/10b 
                                Encoder

  - CustomizeWrapper.pl       : interactive Perl script used to customize the
                                top-level core wrapper file, 
                                encode_8b10b_wrapper.vhd

  - encode_8b10b_wrapper.vhd  : customizable VHDL top-level core wrapper file 
                                with a simplified set of 12 generics

  - /wrapper_bak directory    : contains a back-up copy of the last generated 
                                top-level core wrapper file, 
                                encode_8b10b_wrapper_bak.vhd

  - WrapperTemplate.txt       : template for the customizable VHDL top-level core  
                                wrapper file, encode_8b10b_wrapper.vhd

  - RunXST.pl                 : Perl script that synthesizes the wrappers and
                                source files using XST
  
  - vhdl_xst.scr              : XST script file.  Contains the XST options
                                for synthesis, including the target part

  - vhdl_xst.prj              : XST project file.  Contains the relative paths
                                to the wrappers and source files to be 
                                synthesized

  - Implement.pl              : Perl script that runs Ngdbuild, Map, and PAR
                                on the synthesized netlist

  - /results directory        : contains all output products of XST, Ngdbuild,
                                Map, and PAR

  - /bram_init directory      : contains all scripts and supplemental files 
                                for regenerating the enc.mif file

  - MakeMIF.pl                : Perl script that generates a new enc.mif file
                                by simulating the VHDL file, mifgen_enc.vhd,
                                and the LUT-based implementation of the 8b/10b
                                Encoder in ModelSim

  - mifgen_enc.vhd            : Creates stimulus to exercise all possible
                                encoder input combinations.  Captures output
                                of LUT-based Encoder to a .mif file

  - MakeMIF_mti.do            : ModelSim .do script for simulating mifgen_enc



3.3. PARAMETERIZING THE RTL 

Before generating a netlist, the user should set the desired parameters in
the top-level core wrapper file: encode_8b10b_wrapper.vhd.  These generics 
may be set automatically using the provided Perl script or manually by editing 
the source files directly.  

Alternatively, the user may skip the parameterization step by using the 
default top-level core wrapper file provided.  The default configuration is of 
a dual-port block RAM-based Encoder with all optional ports enabled.


3.3.1. AUTOMATIC CONFIGURATION

To simplify the process of assigning the generics, a Perl script has been 
provided for the user's convenience.  This Perl script will guide the user 
through a sequence of questions regarding the desired 8b/10b encoder 
configuration.  This configuration will be applied to the wrapper template file 
to generate the top-level core wrapper file. Any unused optional ports will be
selectively removed or tied off.  The previous top-level core wrapper file 
will be backed up to the /implement/wrapper_bak directory for later retrieval, 
if desired, as encode_8b10b_wrapper_bak.vhd.

From within the /implement directory, execute the Perl script 
CustomizeWrapper.pl at the Windows command prompt or Linux command line:

  > xilperl CustomizeWrapper.pl

The output top-level core wrapper file will replace the existing wrapper
within the /implement directory.

Refer to XAPP1122 for detailed descriptions of the available generics.  


3.3.2. MANUAL CONFIGURATION

All optional ports are present in the default top-level core wrapper file.  The 
generics in this file may be modified manually to suit the desired configuration.  

Additionally, the user may manually customize a top-level core wrapper file 
that has been generated by the CustomizeWrapper.pl script.  However, be aware 
that if any optional ports were disabled in this wrapper file, the ports will 
have been stripped from the port list by the script.  

The provided wrapper files and customization script operate on a reduced
set of 12 generics.  With the reduced set of generics, the second encoder of a 
dual-encoder configuration is automatically configured to have the same
optional ports as the first encoder.  However, the force code values for 
each encoder remain separate.  A user may access the full set of 19 generics
and manually configure the two encoders separately by editing the top-level
core file, encode_8b10b_rtl.vhd, and removing the two wrapper files 
(encode_8b10b_wrapper.vhd and encode_8b10b_top.vhd) from the list of source files 
to be implemented.


3.4. NETLIST GENERATION

The 8b/10b Encoder may be synthesized with the Xilinx Synthesis Tool (XST) 
through ISE or the provided command-line script and project files.  


3.4.1. XST SCRIPT 

To generate a netlist via XST synthesis, from within the /implement directory,
execute the RunXST.pl script at the Windows command prompt or Linux command line.

  > xilperl RunXST.pl

The output files are generated in the /implement/results directory.
The output netlist is encode_8b10b.ngc
The XST log file is encode_8b10b.srp
To change the target part, modify the vhdl_xst.scr file.


3.5. IMPLEMENTATION SCRIPT 

The 8b/10b Encoder may be implemented in ISE or by the provided command-line 
script.  To run Ngdbuild, Map, and PAR on the synthesized netlist, from within 
the /implement directory, execute the Implement.pl script at the Windows command 
prompt or Linux command line.

  > xilperl Implement.pl

The output files are generated in the /implement/results directory.


3.6. GENERATING THE MIF FILE (MODELSIM)

The 8b/10b Encoder is implemented as a 1024 x 12-bit look-up table.  The 1024 
entry table accounts for every possible combination of inputs: the disparity
input (1-bit DISP_IN), the command input (1-bit KIN), and the input data byte
(8-bit DIN).  The 12-bit entries contain the command error (1-bit KERR), the
running disparity output (1-bit DISP_OUT), and the encoded symbol output (10-bit 
DOUT).

If the BRAM version of the 8b/10b Encoder is implemented, a .mif file is 
required to initialize the BRAM with the look-up table values.  The .mif file 
included with the reference design is named: 

  enc.mif  

To generate a modified .mif file, and thus alter the default encoding behavior of 
the BRAM implementation, the user must modify the RTL for the LUT version of the 
8b/10b encoder.  The specific file to modify is:

  /src/vhdl/encode_8b10b_lut_base.vhd  

The new .mif file is generated by simulating the LUT version of the encoder 
through all 1024 possible input combinations of DISP_IN, KIN, and DIN.  The 
resulting 10-bit encoded output, running disparity, and command error are 
then captured as the look-up table contents to the .mif file.  To run this 
simulation and generate the .mif, from within the /bram_init directory, execute 
the script MakeMIF.pl at the Windows command prompt or Linux command line.

  > xilperl MakeMIF.pl

The Perl script compiles the mifgen_enc.vhd testbench and the LUT version of the 
encoder core files.  It then runs ModelSim, and writes the results to the enc.mif 
file.  Once the .mif file has been generated in the /bram_init directory, it 
should be manually copied into the /src directory to overwrite the default .mif 
file.  


3.7. IMPORTING DESIGN FILES INTO ISE

   - Start up the Xilinx ISE 10.1 Project Navigator application.

   - From the "File" menu, create a new project ("New Project") or browse to an 
     existing project ("Open Project").  You will be importing the 8b/10b 
     encoder design files into this project.

   - If creating a new project, the New Project Wizard will guide you through
     the process of creating a project.   

     - In the Create New Project pop-up window, specify the Project Name and
       Project Location.  The top-level source type is HDL.  Click "Next".
     - Select the Device Properties.  Click "Next".
     - In the Create New Source window, click "Next".
     - In the Add Existing Sources window, 
       - Click "Add Source".  
       - Browse to the implement directory within the extracted 
         xapp1122_encode_8b10b folder (/xapp1122_encode_8b10b/implement/). 
       - Select the configured top-level core wrapper file, 
         encode_8b10b_wrapper.vhd.  This will be the top-level design file.
       - Click "Open".
       - Click "Add Source".  
       - Browse to the HDL source directory within the extracted 
         xapp1122_encode_8b10b folder (/xapp1122_encode_8b10b/src/vhdl/). 
       - Select all of the VHDL design files.
       - Click "Open".  
       - Click "Next".  
       - Click "Finish".  
     These steps will import the selected encoder files into your project.

   For more information on running ISE 10.1, please refer to the online
   documentation at http://toolbox.xilinx.com/docsan/xilinx10/books/manuals.pdf,
   or to the local documentation included with your Xilinx ISE 10.1 software
   installation:
 
   Windows PC:
   Start Menu -> Programs -> Xilinx ISE Design Suite 10.1 -> ISE -> Documentation


4. RESOLVED ISSUES (ORIGINALLY IN THE 8B/10B ENCODER LOGICORE IP CORE)

    - Core contains incompletely specified RLOCs
      - Version found: v4.0 (LogiCORE IP core)
      - Version fixed: v1.1
      - CR 325690: RLOCs were removed to improve portability between architectures

    - Priority of CE signal over FORCE_CODE when initializing registers is 
      inconsistent.
      - Version found: v5.0 (LogiCORE IP core)
      - Version fixed: v1.1
      - CR 476991
 

5. KNOWN ISSUES 
   
    - None

   The most recent information, including known issues, workarounds, and 
   resolutions for this version is provided in the Answer Record (AR 31287)
   located at:

   http://www.xilinx.com/support/answers/31287.htm


6. TECHNICAL SUPPORT 

   To obtain technical support, create a WebCase at www.xilinx.com/support.
   Questions are routed to a team with expertise using this product.  
     
   Xilinx provides technical support for use of this product when used
   according to the guidelines described in the core documentation, and
   cannot guarantee timing, functionality, or support of this product for
   designs that do not follow specified guidelines.


7. RELEASE HISTORY 

Date        By            Version      Description
================================================================================
10/31/2008  Xilinx, Inc.  1.1          Initial release based on 8b/10b Encoder 
                                       v5.0 LogiCORE IP core
================================================================================


