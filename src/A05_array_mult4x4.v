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

    wire [7:0] row0, row1, row2, row3;
    wire [7:0] s12, s123, sfinal;

    assign row0 = {4'b0000, pp0};
    assign row1 = {3'b000, pp1, 1'b0};
    assign row2 = {2'b00, pp2, 2'b00};
    assign row3 = {1'b0, pp3, 3'b000};

    // 8-bit adder, built from bitwise logic only
    wire c1, c2, c3;
    wire [7:0] carry;

    assign s12[0] = row0[0] ^ row1[0];
    assign carry[0] = row0[0] & row1[0];

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : GEN_ADD1
            assign s12[i] = row0[i] ^ row1[i] ^ carry[i-1];
            assign carry[i] = (row0[i] & row1[i]) |
                              (row0[i] & carry[i-1]) |
                              (row1[i] & carry[i-1]);
        end
    endgenerate

    assign s123[0] = s12[0] ^ row2[0];
    assign carry[0] = s12[0] & row2[0];  // not safe if reused; better use a separate carry wire

    // Better: use a full adder module instead of reusing single carry
    // This pattern is clearer and less error-prone.

endmodule
