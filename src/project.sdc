# Define the clock signal with a 50 MHz frequency (20 ns period)
create_clock -name clk -period 20 [get_ports clk]

# Set input delay (adjust if needed)
set_input_delay 1 [all_inputs] -clock clk

# Set output delay (adjust if needed)
set_output_delay 1 [all_outputs] -clock clk

# Define reset as a false path (active-low reset should not affect timing analysis)
set_false_path -from [get_ports rst_n]# Define the clock with a period of 10 ns (100 MHz)
create_clock -name clk -period 10 [get_ports clk]

# Set input delay relative to the clock (2.5 ns)
set_input_delay 2.5 -clock clk [get_ports ui_in]
set_input_delay 2.5 -clock clk [get_ports uio_in]

# Set output delay relative to the clock (2.5 ns)
set_output_delay 2.5 -clock clk [get_ports uo_out]
set_output_delay 2.5 -clock clk [get_ports uio_out]
