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

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    #20;
    rst_n = 1;

    #10;
    ui_in = 8'h54;   // A=4, B=5, product=20
    #20;

    ui_in = 8'hF0;   // A=0, B=15
    #20;

    $finish;
  end

  tt_um_Son_nion user_project (
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

endmodule
