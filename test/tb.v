`default_nettype none
`timescale 1ns/1ps

module tb;

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Khai báo tách 2 số 4-bit để dễ kéo vào GTKWave theo dõi
  wire [3:0] a = ui_in[3:0];
  wire [3:0] b = ui_in[7:4];

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

  // Tạo xung clock chu kỳ 10ns (5ns mức cao, 5ns mức thấp)
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'h00;
    uio_in = 8'h00;

    // Bật reset trong 12ns (thả reset trễ hơn posedge clock đầu tiên)
    #12;
    rst_n = 1;

    // Cập nhật giá trị input tại cạnh xuống (negedge) để tránh xung đột với cạnh lên
    @(negedge clk); ui_in = 8'hFF; // a = 15, b = 15 => Expected = 225 (8'hE1)
    @(negedge clk); ui_in = 8'hF1; // a = 1,  b = 15 => Expected = 15  (8'h0F)
    @(negedge clk); ui_in = 8'h88; // a = 8,  b = 8  => Expected = 64  (8'h40)
    @(negedge clk); ui_in = 8'h97; // a = 7,  b = 9  => Expected = 63  (8'h3F)
    @(negedge clk); ui_in = 8'h1F; // a = 15, b = 1  => Expected = 15  (8'h0F)
    @(negedge clk); ui_in = 8'hFE; // a = 14, b = 15 => Expected = 210 (8'hD2)
    @(negedge clk); ui_in = 8'h28; // a = 8,  b = 2  => Expected = 16  (8'h10)
    @(negedge clk); ui_in = 8'hA5; // a = 5,  b = 10 => Expected = 50  (8'h32)
    @(negedge clk); ui_in = 8'h53; // a = 3,  b = 5  => Expected = 15  (8'h0F)
    @(negedge clk); ui_in = 8'hDF; // a = 15, b = 13 => Expected = 195 (8'hC3)
    @(negedge clk); ui_in = 8'hFB; // a = 11, b = 15 => Expected = 165 (8'hA5)

    #20;
    $finish;
  end

endmodule
