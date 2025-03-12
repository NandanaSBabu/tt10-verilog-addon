# Define the clock signal with a 50 MHz frequency (20 ns period)
create_clock -name clk -period 20 [get_ports clk]

# Set input delay (adjust if needed)
set_input_delay 1 [all_inputs] -clock clk

# Set output delay (adjust if needed)
set_output_delay 1 [all_outputs] -clock clk

# Define reset as a false path (active-low reset should not affect timing analysis)
set_false_path -from [get_ports rst_n]
