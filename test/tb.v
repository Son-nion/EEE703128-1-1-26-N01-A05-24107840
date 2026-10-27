`default_nettype none

module tb;

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

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

  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'h00;
    uio_in = 8'h00;

    #10;
    rst_n = 1;

    // Test vector: {a, b} = {ui_in[3:0], ui_in[7:4]}
    // expected output = a * b

    ui_in = 8'hFF; #10;
    ui_in = 8'hF1; #10;
    ui_in = 8'h88; #10;
    ui_in = 8'h97; #10;
    ui_in = 8'h1F; #10;
    ui_in = 8'hFE; #10;
    ui_in = 8'h28; #10;
    ui_in = 8'hA5; #10;
    ui_in = 8'h53; #10;
    ui_in = 8'hDF; #10;
    ui_in = 8'hFB; #10;


    $finish;
  end

endmodule
