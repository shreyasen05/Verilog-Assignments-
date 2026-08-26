module add_sub (p_count,n_count,direction);
    input [3:0] p_count;
    input direction;
    output [3:0] n_count;

    wire [3:0] b, carry;

    assign b = 4'b0001 ^ {4{~direction}};

    FA FA1(.sum(n_count[0]),.carry(carry[0]),.a(p_count[0]),.b(b[0]),.cin(~direction));
    FA FA2(.sum(n_count[1]),.carry(carry[1]),.a(p_count[1]),.b(b[1]),.cin(carry[0]));
    FA FA3(.sum(n_count[2]),.carry(carry[2]),.a(p_count[2]),.b(b[2]),.cin(carry[1]));
    FA FA4(.sum(n_count[3]),.carry(carry[3]),.a(p_count[3]),.b(b[3]),.cin(carry[2]));
endmodule
