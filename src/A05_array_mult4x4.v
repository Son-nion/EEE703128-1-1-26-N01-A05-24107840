`default_nettype none

module A05_array_mult4x4 (
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] p
);

    wire [3:0] pp0, pp1, pp2, pp3;
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : GEN_PP
            assign pp0[j] = a[j] & b[0];
            assign pp1[j] = a[j] & b[1];
            assign pp2[j] = a[j] & b[2];
            assign pp3[j] = a[j] & b[3];
        end
    endgenerate

    // Each row must be aligned to its bit weight
    wire [7:0] row0, row1, row2, row3;
    assign row0 = {4'b0000, pp0};       // pp0 at bits [3:0]
    assign row1 = {3'b000, pp1, 1'b0};  // pp1 << 1
    assign row2 = {2'b00, pp2, 2'b00};  // pp2 << 2
    assign row3 = {1'b0, pp3, 3'b000};  // pp3 << 3

    // 8-bit ripple adder
    wire [7:0] acc1, acc2, acc3;
    wire c1, c2, c3;

    add8 u1 (
        .a(row0),
        .b(row1),
        .sum(acc1),
        .carry(c1)
    );

    add8 u2 (
        .a(acc1),
        .b(row2),
        .sum(acc2),
        .carry(c2)
    );

    add8 u3 (
        .a(acc2),
        .b(row3),
        .sum(p),
        .carry(c3)
    );

endmodule

module add8 (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] sum,
    output       carry
);

    wire [7:0] carry_int;

    assign sum[0] = a[0] ^ b[0];
    assign carry_int[0] = a[0] & b[0];

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : GEN_ADD
            assign sum[i] = a[i] ^ b[i] ^ carry_int[i-1];
            assign carry_int[i] = (a[i] & b[i])
                               | (a[i] & carry_int[i-1])
                               | (b[i] & carry_int[i-1]);
        end
    endgenerate

    assign carry = carry_int[7];

endmodule
