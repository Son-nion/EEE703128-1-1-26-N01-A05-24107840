`default_nettype none

module A05_array_mult4x4 (
    input  [3:0] a,    
    input  [3:0] b,    
    output [7:0] p    
);

    // 1. Sinh các Tích một phần (Partial Products)
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

    // 2. Hàng cộng thứ 1 (Row 1 Adder)
    wire [3:0] x1, y1, s1;
    wire [4:0] k1;

    assign x1    = {1'b0, pp0[3:1]};
    assign y1    = pp1;
    assign k1[0] = 1'b0;            

    genvar k1_idx;
    generate
        for (k1_idx = 0; k1_idx < 4; k1_idx = k1_idx + 1) begin : GEN_ROW1
            assign s1[k1_idx]     = x1[k1_idx] ^ y1[k1_idx] ^ k1[k1_idx];
            assign k1[k1_idx+1] = (x1[k1_idx] & y1[k1_idx])
                                | (x1[k1_idx] & k1[k1_idx])
                                | (y1[k1_idx] & k1[k1_idx]);
        end
    endgenerate

    // 3. Hàng cộng thứ 2 (Row 2 Adder)
    wire [3:0] x2, y2, s2;
    wire [4:0] k2;

    assign x2    = {k1[4], s1[3:1]};
    assign y2    = pp2;
    assign k2[0] = 1'b0;

    genvar k2_idx;
    generate
        for (k2_idx = 0; k2_idx < 4; k2_idx = k2_idx + 1) begin : GEN_ROW2
            assign s2[k2_idx]     = x2[k2_idx] ^ y2[k2_idx] ^ k2[k2_idx];
            assign k2[k2_idx+1] = (x2[k2_idx] & y2[k2_idx])
                                | (x2[k2_idx] & k2[k2_idx])
                                | (y2[k2_idx] & k2[k2_idx]);
        end
    endgenerate

    // 4. Hàng cộng thứ 3 (Row 3 Adder)
    wire [3:0] x3, y3, s3;
    wire [4:0] k3;

    assign x3    = {k2[4], s2[3:1]};
    assign y3    = pp3;
    assign k3[0] = 1'b0;

    genvar k3_idx;
    generate
        for (k3_idx = 0; k3_idx < 4; k3_idx = k3_idx + 1) begin : GEN_ROW3
            assign s3[k3_idx]     = x3[k3_idx] ^ y3[k3_idx] ^ k3[k3_idx];
            assign k3[k3_idx+1] = (x3[k3_idx] & y3[k3_idx])
                                | (x3[k3_idx] & k3[k3_idx])
                                | (y3[k3_idx] & k3[k3_idx]);
        end
    endgenerate

    // 5. Gán kết quả Ngõ ra p (Product)
    assign p[0]   = pp0[0];
    assign p[1]   = s1[0];
    assign p[2]   = s2[0];
    assign p[3]   = s3[0];
    assign p[7:4] = {k3[4], s3[3:1]};

endmodule
