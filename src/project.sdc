create_clock -name clk -period 20 {clk}  ;# 50MHz clock
set_input_delay -clock clk 2 [all_inputs]
set_output_delay -clock clk 2 [all_outputs]
set_driving_cell -lib_cell INV [all_inputs]
set_load 0.1 [all_outputs]
set_max_fanout 5 [all_outputs]
