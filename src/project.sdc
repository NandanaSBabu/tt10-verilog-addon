# Define the clock with a period of 10 ns (100 MHz)
create_clock -name clk -period 10 [get_ports clk]

# Set input delay relative to the clock (assuming 2 ns external delay)
set_input_delay 2 -clock clk [get_ports ui_in]
set_input_delay 2 -clock clk [get_ports uio_in]

# Set output delay relative to the clock (assuming 2 ns external delay)
set_output_delay 2 -clock clk [get_ports uo_out]
set_output_delay 2 -clock clk [get_ports uio_out]
