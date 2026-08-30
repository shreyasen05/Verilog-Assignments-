`timescale 1ns / 1ps
module tb_SAES;
    reg clk, rst;
    reg [15:0] plaintext;
    wire [15:0] chipertext;

    SAES DUT(.plaintext(plaintext),.chipertext(chipertext),.clk(clk),.rst(rst));

    always #5 clk = ~clk;

    initial begin
        $monitor($time,"| Plain Text=%h | Chiper text=%h | SBOX=%h | SR=%h | MC=%h |K1=%h| K2=%h| round=%b ",plaintext,chipertext,DUT.sbox_out, DUT.sr_out, DUT.mc_out,DUT.K1,DUT.K2,DUT.round);
        //$monitor($time,"| Plain Text=%h | Chiper text=%h | DataReg=%h |round=%b",plaintext,chipertext,DUT.DataReg,DUT.round);
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        plaintext = 16'hE793;
        #130;
        $finish;
    end
endmodule
