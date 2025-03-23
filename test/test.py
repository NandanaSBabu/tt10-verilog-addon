import cocotb
from cocotb.regression import TestFactory
from cocotb.result import TestFailure

@cocotb.coroutine
def test_project(dut):
    # Test signals (values for x and y)
    ui_in = 3  # x input = 3
    uio_in = 4 # y input = 4

    # Reset the DUT
    dut.rst_n.value = 0
    yield cocotb.Timer(10, units='ns')  # Apply reset for 10ns
    dut.rst_n.value = 1
    yield cocotb.Timer(10, units='ns')  # Wait for 10ns to deassert reset

    # Enable DUT and apply inputs
    dut.ena.value = 1
    dut.ui_in.value = ui_in
    dut.uio_in.value = uio_in
    yield cocotb.Timer(20, units='ns')  # Wait for 20ns for output to stabilize

    # Check the output: sqrt(x^2 + y^2)
    expected_output = 5  # sqrt(3^2 + 4^2) = sqrt(9 + 16) = sqrt(25) = 5
    print(f"Output value: {dut.uo_out.value}")  # Debug: Print the output value for inspection
    if dut.uo_out.value != expected_output:
        raise TestFailure(f"Test failed! Expected {expected_output}, got {dut.uo_out.value}")
    else:
        print(f"Test passed! Output is {dut.uo_out.value}")

    # Additional test cases for validation
    ui_in = 7
    uio_in = 24
    dut.ui_in.value = ui_in
    dut.uio_in.value = uio_in
    yield cocotb.Timer(20, units='ns')  # Wait for 20ns for output to stabilize
    expected_output = 25  # sqrt(7^2 + 24^2) = sqrt(49 + 576) = sqrt(625) = 25
    print(f"Output value: {dut.uo_out.value}")
    if dut.uo_out.value != expected_output:
        raise TestFailure(f"Test failed! Expected {expected_output}, got {dut.uo_out.value}")
    else:
        print(f"Test passed! Output is {dut.uo_out.value}")

    # Further tests (x = 10, y = 15)
    ui_in = 10
    uio_in = 15
    dut.ui_in.value = ui_in
    dut.uio_in.value = uio_in
    yield cocotb.Timer(20, units='ns')  # Wait for 20ns
    expected_output = 18  # sqrt(10^2 + 15^2) = sqrt(100 + 225) = sqrt(325) = 18
    print(f"Output value: {dut.uo_out.value}")
    if dut.uo_out.value != expected_output:
        raise TestFailure(f"Test failed! Expected {expected_output}, got {dut.uo_out.value}")
    else:
        print(f"Test passed! Output is {dut.uo_out.value}")

    # End simulation
    yield cocotb.Timer(100, units='ns')
    print("Simulation completed.")

# Create TestFactory and generate tests
tf = TestFactory(test_project)
tf.generate_tests()
