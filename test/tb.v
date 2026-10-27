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

    rst_n = 1;
    ui_in = 8'hFF;
    ui_in = 8'hF1;
    ui_in = 8'h88;
    ui_in = 8'h97;
    ui_in = 8'h1F;
    ui_in = 8'hFE;
    ui_in = 8'h28;
    ui_in = 8'hA5;
    ui_in = 8'h53;
    ui_in = 8'hDF;
    ui_in = 8'hFB;
    $finish;
  end

  always #5 clk = ~clk;

endmodule
