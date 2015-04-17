
REM
REM   ____  ____
REM  /   /\/   /
REM /___/  \  /    Vendor: Xilinx
REM \   \   \/     Version : 1.12
REM  \   \         Application : Virtex-6 FPGA GTX Transceiver Wizard
REM  /   /         Filename : implement_synplify_bat.ejava
REM /___/   /\     
REM \   \  /  \
REM  \___\/\___\
REM
REM
REM implement_synplify.bat script
REM Generated by Xilinx Virtex-6 FPGA GTX Transceiver Wizard
REM
REM (c) Copyright 2009-2011 Xilinx, Inc. All rights reserved.
REM 
REM This file contains confidential and proprietary information
REM of Xilinx, Inc. and is protected under U.S. and 
REM international copyright and other intellectual property
REM laws.
REM 
REM DISCLAIMER
REM This disclaimer is not a license and does not grant any
REM rights to the materials distributed herewith. Except as
REM otherwise provided in a valid license issued to you by
REM Xilinx, and to the maximum extent permitted by applicable
REM law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
REM WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
REM AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
REM BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
REM INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
REM (2) Xilinx shall not be liable (whether in contract or tort,
REM including negligence, or under any other theory of
REM liability) for any loss or damage of any kind or nature
REM related to, arising under or in connection with these
REM materials, including for any direct, or any indirect,
REM special, incidental, or consequential loss or damage
REM (including loss of data, profits, goodwill, or any type of
REM loss or damage suffered as a result of any action brought
REM by a third party) even if such damage or loss was
REM reasonably foreseeable or Xilinx had been advised of the
REM possibility of the same.
REM
REM CRITICAL APPLICATIONS
REM Xilinx products are not designed or intended to be fail-
REM safe, or for use in any application requiring fail-safe
REM performance, such as life-support or safety devices or
REM systems, Class III medical devices, nuclear facilities,
REM applications related to the deployment of airbags, or any
REM other applications that could lead to death, personal
REM injury, or severe property or environmental damage
REM (individually and collectively, "Critical
REM Applications"). Customer assumes the sole risk and
REM liability of any use of Xilinx products in Critical
REM Applications, subject only to applicable laws and
REM regulations governing limitations on product liability.
REM
REM THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
REM PART OF THIS FILE AT ALL TIMES.

REM Set XST as default synthesizer

REM Read command line arguments

REM Change CWD to results

REM Clean results directory
REM Create results directory
REM Change current directory to results
ECHO WARNING: Removing existing results directory
RMDIR /S /Q results
MKDIR results
COPY synplify.prj   .\results\
COPY *.ngc          .\results\

REM Run Synthesis

ECHO "### Running Synplify Pro - "
synplify_pro -batch synplify.prj

COPY gtx_top.edf .\results
cd .\results

REM Run ngdbuild

ngdbuild -uc ..\..\example_design\gtx_top.ucf -p xc6vlx130t-ff1156-1 gtx_top.edf gtx_top.ngd

REM end run ngdbuild section

REM Run map

ECHO 'Running NGD'
map -p xc6vlx130t-ff1156-1 -o mapped.ncd gtx_top.ngd

REM Run par

ECHO 'Running par'
par mapped.ncd routed.ncd 

REM Report par results

ECHO 'Running design through bitgen'
bitgen -w routed.ncd

REM Trace Report

ECHO 'Running trce'
trce -e 10 routed.ncd mapped.pcf -o routed

REM Run netgen

ECHO 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -sim -dir . -tm gtx_top -w routed.ncd routed.vhd

REM Change directory to implement

CD ..

