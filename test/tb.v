`default_nettype none
`timescale 1ns/1ps

module tb;

  reg [3:0] a;
  reg [3:0] b;
  wire [7:0] p;

  integer i, j;

  // Instantiate the multiplier
  A05_array_mult4x4 dut (
    .a(a),
    .b(b),
    .p(p)
  );

  initial begin
    $dumpfile("a05_waves.vcd");
    $dumpvars(0, tb);

    a = 0;
    b = 0;

    // Walk through all 4x4 combinations
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        a = i;
        b = j;
        #10;
      end
    end

    #20;
    $finish;
  end

endmodule
