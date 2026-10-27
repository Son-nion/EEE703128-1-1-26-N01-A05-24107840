<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
This project implements an unsigned 4x4 array multiplier in Verilog. It takes two 4-bit input values, A and B, and produces an 8-bit product equal to A × B.

- `ui[0]` to `ui[3]` are used for input A[0] to A[3]
- `ui[4]` to `ui[7]` are used for input B[0] to B[3]
- `uo[0]` to `uo[7]` provide the output product bits P[0] to P[7]

The design uses an array multiplier structure, where partial products are generated for each combination of bits from A and B, and then summed together to form the final product. Because this is a combinational logic design, the output updates immediately whenever the input values change.

This project is suitable for Tiny Tapeout because it is compact, simple to verify, and demonstrates the use of standard digital arithmetic logic in hardware.

## How to test

To test the multiplier:

1. Apply the first operand A to `ui[0]` to `ui[3]`.
2. Apply the second operand B to `ui[4]` to `ui[7]`.
3. Read the 8-bit product from `uo[0]` to `uo[7]`.

Example:
- A = `1011` (decimal 11)
- B = `0101` (decimal 5)
- Product = `01101111` (decimal 55)

This can be tested using a Verilog simulation or a Tiny Tapeout-compatible test setup. The expected output should match the binary multiplication result for the selected inputs.

## External hardware

No additional external hardware is required for this project.

The circuit is designed to operate using the standard Tiny Tapeout input/output interface only. No PMODs, LEDs, displays, or other peripherals are needed for normal operation.
