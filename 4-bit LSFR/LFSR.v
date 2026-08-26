//////////////////////////////////////////////////////////////////////////////////
// The flip-flops can be initialized with a seed by using four multiplexers
// When the select line of the multiplexer sel is made 0, 
//the bits of the seed vector are passed to the D inputs of the flip-flops.
// For each of the three flip-flops on the right, when sel = 1, 
//the output of the DFF to its left is applied to the input. 
//For the left-most DFF, the bit to be shifted in when the sel = 1, is computed by 
//XORing the outputs of the two DFFs on the right.
//////////////////////////////////////////////////////////////////////////////////

module LFSR (clk,rst,sel,seed,state);
    input clk,rst,sel;
    input [3:0] seed;
    output [3:0] state;

    wire w1, w2, w3, w4, w5, w1int, w2int, w3int, w4int, slow_clk;

    assign w1 = w5 ^ w4;

    clk_div CLKDiv(.clk(clk),.rst(rst),.d_clk(slow_clk));

    mux MUX3(.in1(seed[3]), .in2(w1), .sel(sel), .out(w1int));
    mux MUX2(.in1(seed[2]), .in2(w2), .sel(sel), .out(w2int));
    mux MUX1(.in1(seed[1]), .in2(w3), .sel(sel), .out(w3int));
    mux MUX0(.in1(seed[0]), .in2(w4), .sel(sel), .out(w4int));

    D_ff DFF3(.clk(slow_clk), .rst(rst), .D(w1int), .Q(w2));
    D_ff DFF2(.clk(slow_clk), .rst(rst), .D(w2int), .Q(w3));
    D_ff DFF1(.clk(slow_clk), .rst(rst), .D(w3int), .Q(w4));
    D_ff DFF0(.clk(slow_clk), .rst(rst), .D(w4int), .Q(w5));

    assign state[3:0] = {w2, w3, w4, w5};
endmodule
