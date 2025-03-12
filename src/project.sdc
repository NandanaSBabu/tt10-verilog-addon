# Define the clock
create_clock -name clk -period 20 [get_ports clk]

# Define input and output constraints
set_input_delay  1.0 -clock clk [get_ports {ui_in uio_in uio_extra ena rst_n}]
set_output_delay 1.0 -clock clk [get_ports {uio_out uo_out uo_extra_out}]

# Set driving strength for inputs
set_drive 1 [get_ports {ui_in uio_in uio_extra ena rst_n}]

# Set load capacitance for outputs
set_load 1 [get_ports {uio_out uo_out uo_extra_out}]

# Define reset behavior
set_false_path -from [get_ports rst_n]
