# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
  # 1. Khởi tạo xung clock (10 us chu kỳ)
  clock = Clock(dut.clk, 10, unit="us")
  cocotb.start_soon(clock.start())

  # 2. Khởi tạo giá trị ban đầu và Reset
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 2)
  dut.rst_n.value = 1
  await ClockCycles(dut.clk, 1)

  dut._log.info("=== BẮT ĐẦU TEST TOÀN BỘ 256 TRƯỜNG HỢP MẠCH NHÂN 4x4 ===")

  # 3. Quét toàn bộ 256 trường hợp ngõ vào (a: 0->15, b: 0->15)
  errors = 0
  for a in range(16):
    for b in range(16):
      # Gán ui_in = {b, a} (b ở 4 bit cao, a ở 4 bit thấp)
      ui_in_val = (b << 4) | a
      dut.ui_in.value = ui_in_val

      # Chờ 1 chu kỳ clock để mô phỏng tính toán
      await ClockCycles(dut.clk, 1)

      # Đọc kết quả ngõ ra
      actual = dut.uo_out.value.to_unsigned()
      expected = a * b

      if actual != expected:
        dut._log.error(
            f"LỖI tại a={a} (4'h{a:X}), b={b} (4'h{b:X}) | ui_in=0x{ui_in_val:02X}"
            f" | uo_out=0x{actual:02X} ({actual}) | Kỳ"
            f" vọng=0x{expected:02X} ({expected})"
        )
        errors += 1
      assert actual == expected, (
          f"Lỗi mạch nhân: a={a}, b={b}, Nhận được={actual}, Kỳ vọng={expected}"
      )

  dut._log.info(
      f"=== TEST HOÀN THÀNH: Đã vượt qua 256/256 trường hợp (Tổng số lỗi:"
      f" {errors}) ==="
  )
