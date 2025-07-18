transcript on
if ![file isdirectory DE10_NANO_SoC_GHRD_iputf_libs] {
	file mkdir DE10_NANO_SoC_GHRD_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/pll_40mhz_sim/pll_40mhz.vo"

vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/fir_generic.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/clip_shaper.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/noise_distribution.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/noise_collisions.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/pzc_ped_track.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/shaper_fenics.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/select_rand.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/random_number_generator.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/rand_LFSR.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/iir_ordem2.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/iir_ordem1.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/hits_positions.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/Hits_Bunch_train.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/FPGA_Simulator_v1_PZC.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/energy_distribution.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/energy_collisions.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/bunch_train_mask.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/ip/edge_detect {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/ip/edge_detect/altera_edge_detector.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/ip/debounce {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/ip/debounce/debounce.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/ip/altsource_probe {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/ip/altsource_probe/hps_reset.v}
vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10 {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/de10_nano_soc_ghrd.v}

vlog -vlog01compat -work work +incdir+C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos {C:/Users/luacacio/Documents/FPGA_Doutorado/HPS_FPGA_Sim_DE10_Git/HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/FPGA_Simulator_v1_PZC_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  FPGA_Simulator_v1_PZC_tb

add wave *
view structure
view signals
run 10 us
