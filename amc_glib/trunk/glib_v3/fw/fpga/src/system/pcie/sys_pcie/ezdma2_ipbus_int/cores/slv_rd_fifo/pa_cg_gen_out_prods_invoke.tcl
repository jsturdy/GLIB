# Tcl script generated by PlanAhead

set reloadAllCoreGenRepositories false

set tclUtilsPath "c:/Xilinx/14.7/ISE_DS/PlanAhead/scripts/pa_cg_utils.tcl"

set repoPaths ""

set cgIndexMapPath "Z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/PlanAhead/PlanAhead.srcs/sources_1/ip/cg_nt_index_map.xml"

set cgProjectPath "z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_rd_fifo/coregen.cgc"

set ipFile "z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_rd_fifo/slv_rd_fifo.xco"

set ipName "slv_rd_fifo"

set hdlType "VHDL"

set cgPartSpec "xc6vlx130t-1ff1156"

set chains "GENERATE_CURRENT_CHAIN"

set params ""

set bomFilePath "z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_rd_fifo/pa_cg_bom.xml"

# generate the IP
set result [source "c:/Xilinx/14.7/ISE_DS/PlanAhead/scripts/pa_cg_gen_out_prods.tcl"]

exit $result

