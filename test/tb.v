`default_nettype none
`timescale 1ns/1ps

module tb;

  // Tín hiệu giao diện chuẩn của Tiny Tapeout
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Tách bus ui_in thành 2 số a và b 4-bit để dễ kiểm tra
  wire [3:0] a = ui_in[3:0];
  wire [3:0] b = ui_in[7:4];
  
  // Giá trị kết quả kỳ vọng
  wire [7:0] expected_out = a * b;

  // Biến đếm lỗi và biến vòng lặp
  integer i;
  integer errors = 0;

  // Gọi Module thiết kế (DUT)
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

  // Tạo xung clock giả định (giữ đúng chuẩn Tiny Tapeout)
  always #5 clk = ~clk;

  initial begin
    // Ghi dữ liệu ra tệp VCD để quan sát trên GTKWave
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    // Khởi tạo trạng thái ban đầu
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'h00;
    uio_in = 8'h00;

    #10;
    rst_n = 1;

    $display("==================================================");
    $display("   BAT DAU KIEM TRA AUTOMATIC TESTBENCH (4x4)     ");
    $display("==================================================");

    // Quét toàn bộ 256 trường hợp ngõ vào (16 x 16)
    for (i = 0; i < 256; i = i + 1) begin
      ui_in = i[7:0];
      
      // Chờ 1ns để mạch tổ hợp lan truyền tín hiệu
      #1; 

      // So sánh kết quả thực tế (uo_out) với lý thuyết (expected_out)
      if (uo_out !== expected_out) begin
        $display("[LÔI] Thoi gian: %0t ns | a = %2d | b = %2d | uo_out = %3d (8'h%2h) | Ky vong = %3d (8'h%2h)",
                 $time, a, b, uo_out, uo_out, expected_out, expected_out);
        errors = errors + 1;
      end
    end

    // In báo cáo tổng kết
    $display("==================================================");
    if (errors == 0) begin
      $display(">>> TEST PASSED: Tat ca 256 truong hop deu DUNG! <<<");
    end else begin
      $display(">>> TEST FAILED: Phat hien %0d truong hop SAI! <<<", errors);
    end
    $display("==================================================");

    #10;
    $finish;
  end

endmodule
