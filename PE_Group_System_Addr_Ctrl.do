#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\220model.v}
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\altera_mf.v}


vlog -work work PE_Group_System_Addr_Ctrl.v
vlog -work work PE_Group_System_Addr_Ctrl_tb.v

vsim -t ps work.PE_Group_System_Addr_Ctrl_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /PE_Group_System_Addr_Ctrl_tb/clk
add wave -binary /PE_Group_System_Addr_Ctrl_tb/rst

add wave -binary /PE_Group_System_Addr_Ctrl_tb/DataInValid
add wave -binary /PE_Group_System_Addr_Ctrl_tb/DataOutRdy
add wave -binary /PE_Group_System_Addr_Ctrl_tb/DataInRdy
add wave -binary /PE_Group_System_Addr_Ctrl_tb/DataOutValid 

add wave -decimal /PE_Group_System_Addr_Ctrl_tb/WAddr
add wave -decimal /PE_Group_System_Addr_Ctrl_tb/RAddr

add wave -binary /PE_Group_System_Addr_Ctrl_tb/WEn
add wave -binary /PE_Group_System_Addr_Ctrl_tb/REn

add wave -decimal /PE_Group_System_Addr_Ctrl_tb/WAddr_Counter
add wave -decimal /PE_Group_System_Addr_Ctrl_tb/RAddr_Counter

run 900ps
wave zoomrange 0ps 1000ps
