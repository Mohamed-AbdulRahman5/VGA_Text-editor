

##set_property INIT 2'h2 [get_cells {uart/Uart_reciever/FSM_sequential_state_reg[1]_i_2}]
#set_property -dict [list CONFIG.C_MEMORY_INIT_FILE {char.mem}] [get_ips xpm_mem_gen_top_0]

create_clock -period 10.000 -waveform {0.000 5.000} [get_ports clk]
