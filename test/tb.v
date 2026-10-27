`default_nettype none
`timescale 1ns / 1ps

module tb ();

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  integer a;
  integer b;
  integer expected;
  integer i, j;

  // Tiny Tapeout wrapper
  tt_um_Son_nion user_project (
      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path
      .ena    (ena),      // enable
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // reset
  );

  // Clock generator
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'h00;
    uio_in = 8'h00;

    #20;
    rst_n = 1;

    // Test all combinations of A and B (0..15)
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        a = i;
        b = j;

        // ui_in format: [b3:b0][a3:a0]
        ui_in = {b[3:0], a[3:0]};

        #10;

        expected = a * b;

        if (uo_out !== expected[7:0]) begin
          $display("Mismatch: a=%0d b=%0d got=%0d expected=%0d", a, b, uo_out, expected);
          $fatal(1);
        end
      end
    end

    $display("All test vectors passed.");
    #20;
    $finish;
  end

endmodule
