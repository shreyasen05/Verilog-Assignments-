module CLA (sum, carry, a, b, cin); //4 bit Carry look Ahead Adder
    parameter n = 4;
    input [n-1:0] a, b;
    input cin;
    output [n-1:0] sum;
    output carry;

    wire [n:0] c;
    wire [n-1:0] g,p;
    wire g_out,p_out;

    assign carry = c[n-1];
    assign c[0] = cin;
    assign g = a & b;  
    assign p = a ^ b;

    genvar i;
    generate
        for(i=0; i<n; i=i+1)
        begin : CLA_loop
            assign c[i+1] = g[i] + (p[i] & c[i]) ;
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    assign p_out = p[0] & p[1] & p[2] & p[3];
    assign g_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module CLA_16 (sum, carry, p_out, g_out, a, b, cin);
    parameter n = 16;
    input [n-1:0] a, b;
    input cin;
    output [n-1:0] sum;
    output carry;
    output [3:0] p_out, g_out;

    wire [3:0] c;

    CLA CLA1 (.sum(sum[3:0]), .carry(c[0]), .a(a[3:0]), .b(b[3:0]), .cin(cin));
    CLA CLA2 (.sum(sum[7:4]), .carry(c[1]), .a(a[7:4]), .b(b[7:4]), .cin(c[0]));
    CLA CLA3 (.sum(sum[11:8]), .carry(c[2]), .a(a[11:8]), .b(b[11:8]), .cin(c[1]));
    CLA CLA4 (.sum(sum[15:12]), .carry(c[3]), .a(a[15:12]), .b(b[15:12]), .cin(c[2]));

    assign carry = c[3];
    
    assign p_out[0] = CLA1.p_out;
    assign p_out[1] = CLA2.p_out;
    assign p_out[2] = CLA3.p_out;
    assign p_out[3] = CLA4.p_out;

    assign g_out[0] = CLA1.g_out;
    assign g_out[1] = CLA2.g_out;
    assign g_out[2] = CLA3.g_out;
    assign g_out[3] = CLA4.g_out;
endmodule