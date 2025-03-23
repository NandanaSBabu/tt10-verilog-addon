import cocotb
from cocotb.regression import TestFactory
from cocotb.regression import TestFactory
from cocotb.result import TestFailure

@cocotb.coroutine
def test_project(dut):
    # Test signals
    ui_in = 3  # x input = 3
    uio_in = 4 # y input = 4

    # Reset the DUT
    dut.rst_n <= 0
    yield cocotb.helpers.Timer(10, units='ns')  # Apply reset for 10ns
    dut.rst_n <= 1
    yield cocotb.helpers.Timer(10, units='ns')  # Wait for 10ns to deassert reset

    # Enable DUT and apply inputs
    dut.ena <= 1
    dut.ui_in <= ui_in
    dut.uio_in <= uio_in
    yield cocotb.helpers.Timer(20, units='ns')  # Wait for 20ns for output to stabilize

    # Check the output (sqrt(3^2 + 4^2) = sqrt(9 + 16) = sqrt(25) = 5)
    expected_output = 5
    if dut.uo_out.value != expected_output:
        raise TestFailure(f"Test failed! Expected {expected_output}, got {dut.uo_out.value}")
    else:
        print(f"Test passed! Output is {dut.uo_out.value}")

# Create TestFactory and run
tf = TestFactory(test_project)
tf.generate_tests()
