`timescale 1ns/1ps

module tb;

    reg  [3:0] a;
    reg  [3:0] b;
    wire [7:0] p;

    integer errors;
    integer i, j;

    A05_array_mult4x4 dut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        errors = 0;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i[3:0];
                b = j[3:0];

                #1;

                if (p !== (i * j)) begin
                    $display("FAIL: a=%0d b=%0d got=%0d expected=%0d", i, j, p, i * j);
                    errors = errors + 1;
                end
            end
        end

        if (errors == 0) begin
            $display("PASS: exhaustive 4x4 multiplier test passed (256 cases)");
        end else begin
            $display("FAIL: %0d mismatches detected", errors);
        end

        $finish;
    end

endmodule
