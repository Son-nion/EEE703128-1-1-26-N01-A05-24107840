# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1

    test_vectors = [
        (0, 0, 0),
        (1, 1, 1),
        (4, 5, 20),
        (9, 9, 81),
        (15, 15, 225),
    ]

    for a, b, expected in test_vectors:
        dut.ui_in.value = (b << 4) | a
        await ClockCycles(dut.clk, 1)
        actual = int(dut.uo_out.value)
        assert actual == expected, f"a={a}, b={b}, got={actual}, expected={expected}"

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
