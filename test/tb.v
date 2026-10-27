module tb;

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  wire [3:0] a;
  wire [3:0] b;
  wire [7:0] p;

  assign a = ui_in[3:0];
  assign b = ui_in[7:4];
  assign p = uo_out;

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

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    #10;
    rst_n = 1;

    ui_in = 8'h54;   // a=4, b=5 -> p=20
    #20;

    ui_in = 8'hA3;   // a=3, b=10 -> p=30
    #20;

    ui_in = 8'hF0;   // a=0, b=15
    #20;

    $finish;
  end

  always #5 clk = ~clk;

endmodule
