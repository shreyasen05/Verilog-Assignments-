`timescale 1ns / 1ps
module tb_LFSR;
    reg clk,rst,sel;
    reg [3:0] seed;
    wire [3:0] state;

    LFSR DUT (.clk(clk),.rst(rst),.sel(sel),.seed(seed),.state(state));

    always #5 clk = ~clk;

    initial begin
        $monitor($time,"state=%b",state);
        clk = 0; rst = 1;
        seed = 4'b1111;
        sel = 1'b0;
        #10;
        rst = 0;
        #100 sel = 1'b1;
        #1500;
        $finish;
    end
endmodule
