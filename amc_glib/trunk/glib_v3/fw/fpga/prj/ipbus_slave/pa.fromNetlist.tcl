
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name ipbus_slave -dir "C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/ipbus_slave/planAhead_run_4" -part xc6vlx130tff1156-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/ipbus_slave/glib_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/ipbus_slave} {ipcore_dir} {../../src/system/cdce/cdce_phase_mon_v2/dpram} {../../src/system/ethernet/ipcore_dir/basex} {../../src/system/ethernet/ipcore_dir/sgmii} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/ezdma2_ctrl_dpram} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/ipbus_ctrl_dpram} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_rd_fifo} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_wr_fifo} {../../src/system/cdce/cdce_phase_mon_v2/pll} {../../src/system/pll} }
add_files [list {ipcore_dir/buffer_fifo.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/chipscope_icon.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/chipscope_ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/chipscope_vio.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/tracking_data_fifo.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../src/system/cdce/cdce_phase_mon_v2/dpram/ttclk_distributed_dpram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../src/system/ethernet/ipcore_dir/basex/v6_emac_v2_3_basex.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/ipbus_slave/src/planahead.ucf" [current_fileset -constrset]
add_files [list {C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/src/system/sys/system.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/src/system/sys/system_clk.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/ipbus_slave/src/gtx.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/ipbus_slave/src/planahead.ucf}] -fileset [get_property constrset [current_run]]
link_design
