# Set clock constraints
create_clock -name clk -period 10 [get_ports clk]

# Input delays
set_input_delay -clock clk 0.2 [get_ports {ui_in uio_in ena rst_n}]

# Output delays
set_output_delay -clock clk 0.2 [get_ports {uo_out uio_out uio_oe}]
