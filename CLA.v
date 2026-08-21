module CLA (sum, carry, a, b, cin); //4 bit Carry look Ahead Adder
    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output carry;

    wire [3:0] p,g;
    wire [4:0] c;
    wire g_out,p_out;

    assign c[0] = cin;
    assign carry = c[4];

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : CLA_loop
            assign g[i] = a[i] & b[i];      // G0 = A0.B0, G1 = A1.B1, G2 = A2.B2, G3 = A3.B3
            assign p[i] = (a[i] ^ b[i]);     //P0 = (A0 xor B0), P1 = (A1 xor B1), P2 = (A2 xor B2), P3 = (A3 xor B3)
            assign sum[i] = p[i] ^ c[i];    //S0 = (P0 xor C_in), S1 = (P1 xor C1), S2 = (P2 xor C2), S3 = (P3 xor C3)
        end
    endgenerate

    assign c[1] = g[0] | (p[0] & c[0]);    //C1 = G0 + P0.C_in
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);    //C2 = G1 + P1.C1 
    assign c[3] = g[2] | (p[2] & g[1]) | (p[1] & p[2] & g[0]) | (p[2] & p[1] & p[0] & c[0]);    //C3 = G2 + P2.C2
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[1] & p[2] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);    //C4 = G3 + P3.C3

    assign p_out = p[0] & p[1] & p[2] & p[3];
    assign g_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module RCA_16 (sum, carry, a, b, cin);
    input [15:0] a, b;
    input cin;
    output [15:0] sum;
    output carry;

    wire [3:0] c;
    assign carry = c[3];

    CLA CLA1 (.sum(sum[3:0]), .carry(c[0]), .a(a[3:0]), .b(b[3:0]), .cin(cin));
    CLA CLA2 (.sum(sum[7:4]), .carry(c[1]), .a(a[7:4]), .b(b[7:4]), .cin(c[0]));
    CLA CLA3 (.sum(sum[11:8]), .carry(c[2]), .a(a[11:8]), .b(b[11:8]), .cin(c[1]));
    CLA CLA4 (.sum(sum[15:12]), .carry(c[3]), .a(a[15:12]), .b(b[15:12]), .cin(c[2]));
endmodule

module CLA_16 (sum, carry, a, b, cin);
    input [15:0] a, b;
    input cin;
    output [15:0] sum;
    output carry;

    wire [3:0] c;
    assign carry = c[3];

    wire [3:0] p_out, g_out;

    assign p_out[0] = CLA1.p_out;
    assign p_out[1] = CLA2.p_out;
    assign p_out[2] = CLA3.p_out;
    assign p_out[3] = CLA4.p_out;

    assign g_out[0] = CLA1.g_out;
    assign g_out[1] = CLA2.g_out;
    assign g_out[2] = CLA3.g_out;
    assign g_out[3] = CLA4.g_out;

    assign c[0] = g_out[0] | (p_out[0] & cin);    //C4 = G0 + P0.C0
    assign c[1] = g_out[1] | (p_out[1] & g_out[0]) | (p_out[1] & p_out[0] & cin);    //C8 = G1 + P1.C1 
    assign c[2] = g_out[2] | (p_out[2] & g_out[1]) | (p_out[1] & p_out[2] & g_out[0]) | (p_out[2] & p_out[1] & p_out[0] & cin);    //C12 = G2 + P2.C2
    assign c[3] = g_out[3] | (p_out[3] & g_out[2]) | (p_out[3] & p_out[2] & g_out[1]) | (p_out[3] & p_out[1] & p_out[2] & g_out[0]) | (p_out[3] & p_out[2] & p_out[1] & p_out[0] & cin);    //C16 = G3 + P3.C3
    
    CLA CLA1 (.sum(sum[3:0]), .carry(), .a(a[3:0]), .b(b[3:0]), .cin(cin));
    CLA CLA2 (.sum(sum[7:4]), .carry(), .a(a[7:4]), .b(b[7:4]), .cin(c[0]));
    CLA CLA3 (.sum(sum[11:8]), .carry(), .a(a[11:8]), .b(b[11:8]), .cin(c[1]));
    CLA CLA4 (.sum(sum[15:12]), .carry(), .a(a[15:12]), .b(b[15:12]), .cin(c[2]));
endmodule
