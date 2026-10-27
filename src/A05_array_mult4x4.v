module A05_array_mult4x4 (
    input  [3:0] a,
    input  [7:4] b,
    output [7:0] p
);

    // Straightforward 4x4 combinational multiplier.
    // This avoids the incorrect carry/shift wiring in the previous adder-tree version.
    assign p = a * b;

endmodule
