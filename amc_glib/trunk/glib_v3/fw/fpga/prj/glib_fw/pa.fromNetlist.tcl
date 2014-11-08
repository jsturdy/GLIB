
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name glib_fw -dir "Z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/planAhead_run_1" -part xc6vlx130tff1156-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "Z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/glib_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {Z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw} {../../src/system/cdce/cdce_phase_mon_v2/dpram} {../../src/system/ethernet/ipcore_dir/basex} {../../src/system/ethernet/ipcore_dir/sgmii} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/ezdma2_ctrl_dpram} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/ipbus_ctrl_dpram} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_rd_fifo} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_wr_fifo} {../../src/system/cdce/cdce_phase_mon_v2/pll} {../../src/system/pll} }
add_files [list {../../src/system/cdce/cdce_phase_mon_v2/dpram/ttclk_distributed_dpram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../src/system/ethernet/ipcore_dir/basex/v6_emac_v2_3_basex.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "Z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/system.ucf" [current_fileset -constrset]
add_files [list {Z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/system.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {Z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/system_clk.ucf}] -fileset [get_property constrset [current_run]]
link_design
