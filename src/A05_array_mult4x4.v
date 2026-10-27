`default_nettype none

module A05_array_mult4x4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [7:0] p
);

    wire [3:0] pp0, pp1, pp2, pp3;

    assign pp0[0] = a[0] & b[0];
    assign pp0[1] = a[1] & b[0];
    assign pp0[2] = a[2] & b[0];
    assign pp0[3] = a[3] & b[0];

    assign pp1[0] = a[0] & b[1];
    assign pp1[1] = a[1] & b[1];
    assign pp1[2] = a[2] & b[1];
    assign pp1[3] = a[3] & b[1];

    assign pp2[0] = a[0] & b[2];
    assign pp2[1] = a[1] & b[2];
    assign pp2[2] = a[2] & b[2];
    assign pp2[3] = a[3] & b[2];

    assign pp3[0] = a[0] & b[3];
    assign pp3[1] = a[1] & b[3];
    assign pp3[2] = a[2] & b[3];
    assign pp3[3] = a[3] & b[3];

    wire [7:0] row0, row1, row2, row3;
    wire [7:0] sum01, sum12, sum_final;

    assign row0 = {4'b0000, pp0};
    assign row1 = {3'b000, pp1, 1'b0};
    assign row2 = {2'b00, pp2, 2'b00};
    assign row3 = {1'b0, pp3, 3'b000};

    add8 u_add01 (
        .a(row0),
        .b(row1),
        .sum(sum01),
        .carry()
    );

    add8 u_add12 (
        .a(sum01),
        .b(row2),
        .sum(sum12),
        .carry()
    );

    add8 u_add_final (
        .a(sum12),
        .b(row3),
        .sum(sum_final),
        .carry()
    );

    assign p = sum_final;

endmodule

module add8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] sum,
    output wire carry
);

    wire c0, c1, c2, c3, c4, c5, c6;

    assign sum[0] = a[0] ^ b[0];
    assign c0 = a[0] & b[0];

    assign sum[1] = a[1] ^ b[1] ^ c0;
    assign c1 = (a[1] & b[1]) | (a[1] & c0) | (b[1] & c0);

    assign sum[2] = a[2] ^ b[2] ^ c1;
    assign c2 = (a[2] & b[2]) | (a[2] & c1) | (b[2] & c1);

    assign sum[3] = a[3] ^ b[3] ^ c2;
    assign c3 = (a[3] & b[3]) | (a[3] & c2) | (b[3] & c2);

    assign sum[4] = a[4] ^ b[4] ^ c3;
    assign c4 = (a[4] & b[4]) | (a[4] & c3) | (b[4] & c3);

    assign sum[5] = a[5] ^ b[5] ^ c4;
    assign c5 = (a[5] & b[5]) | (a[5] & c4) | (b[5] & c4);

    assign sum[6] = a[6] ^ b[6] ^ c5;
    assign c6 = (a[6] & b[6]) | (a[6] & c5) | (b[6] & c5);

    assign sum[7] = a[7] ^ b[7] ^ c6;
    assign carry = (a[7] & b[7]) | (a[7] & c6) | (b[7] & c6);

endmodule
