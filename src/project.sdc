# Create a clock named 'clk' with a period of 20ns (50 MHz)
create_clock -name clk -period 20 [get_ports clk]

# Define input and output delays (adjust based on your needs)
set_input_delay 1 [all_inputs]
set_output_delay 1 [all_outputs]

# Set constraints for the reset signal (active-low)
set_false_path -from [get_ports rst_n]
