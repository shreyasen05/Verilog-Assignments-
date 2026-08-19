module HA (sum,carry,a,b);    //Half Adder
    input a, b;
    output sum, carry;

    assign sum = a ^ b;
    assign carry = a & b;
endmodule

module FA (sum,carry,a,b,cin);    //Full Adder using 2 Half Adders, 1 OR gate
    input a, b, cin;
    output sum, carry;
    wire s1, c1, c2;

    HA HA1 (.sum(s1), .carry(c1), .a(a), .b(b));
    HA HA2 (.sum(sum), .carry(c2), .a(s1), .b(cin));

    assign carry = c1|c2;
endmodule

module RCA (sum,carry,in1,in2,mode);    //n bit Ripple Carry Adder using n Full Adders
    parameter n=9;

    input [n-1:0] in1, in2;
    input mode;   //when mode=0, addition; if mode=1, subtraction
    output signed [n-1:0] sum;
    output carry;

    wire [n:0] cout;
    wire [n-1:0] in2c;

    assign cout[0] = mode;
    assign carry = cout[n];
    
    assign in2c = in2 ^ {n{mode}};

    genvar i;
    generate
        for (i=0; i<n; i=i+1) begin : adder_loop
            FA FA1 (.sum(sum[i]), .carry(cout[i+1]), .a(in1[i]), .b(in2c[i]), .cin(cout[i]));
        end
    endgenerate
endmodule
