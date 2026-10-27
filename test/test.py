import cocotb
from cocotb.result import TestFailure

@cocotb.test()
async def test_mult_4x4_exhaustive(dut):
    errors = 0

    for a in range(16):
        for b in range(16):
            dut.a.value = a
            dut.b.value = b

            await cocotb.triggers.ClockCycles(dut.clk, 1) if hasattr(dut, "clk") else None

            # This branch is for combinational logic without a clock
            if hasattr(dut, "clk"):
                # if there is a clock, use one cycle delay
                await cocotb.triggers.ClockCycles(dut.clk, 1)
            else:
                await cocotb.triggers.Timer(1, "ns")

            actual = int(dut.p.value)
            expected = a * b

            if actual != expected:
                errors += 1
                raise TestFailure(
                    f"FAIL: a={a}, b={b}, got={actual}, expected={expected}"
                )

    if errors == 0:
        dut._log.info("PASS: exhaustive 4x4 multiplier test passed (256 cases)")
