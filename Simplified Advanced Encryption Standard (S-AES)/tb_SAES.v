`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : tb_saes
// Project Name : Simplified Advanced Encryption Standard (S-AES)
//
// Description :
//   Testbench for verifying the functionality of the SAES encryption engine.
//   The testbench applies known S-AES plaintext test vectors and
//   compares the resulting ciphertext with the expected values.
//
//     Plaintext   Expected Ciphertext
//     A06E        595A
//     0000        0581
//     6F6B        2590
//
// Student Name : Shreya Sen
// S-ID : 231001002086
//////////////////////////////////////////////////////////////////////////////////


module tb_saes;
    reg        clk;
    reg        rst;
    reg [15:0] sw;
    wire [15:0] led;
    SAES DUT (.clk(clk),.rst(rst),.sw(sw),.led(led));
    
    always #5 clk = ~clk;

    task test;
        input [15:0] ciphertext;

        begin
            repeat(18) @(posedge clk);
            if (led === ciphertext) begin
                $display("-----------------------------------------");
                $display("PASS");
                $display("Plaintext : %h", sw);
                $display("Expected  : %h", ciphertext);
                $display("Actual    : %h", led);
                $display("-----------------------------------------");
            end       
            else begin
                $display("-----------------------------------------");
                $display("FAIL");
                $display("Plaintext : %h", sw);
                $display("Expected  : %h", ciphertext);
                $display("Actual    : %h", led);
                $display("-----------------------------------------");

            end
        end
    endtask


    initial begin
        $dumpfile("SAES_waves.vcd");
        $dumpvars(0, tb_saes);
        clk = 1'b0;
        rst = 1'b1;
        sw  = 16'h0000;
        
        #20;
        rst = 1'b0;
        
        sw = 16'hA06E;
        test(16'h595A);

        sw = 16'h0000;
        test(16'h0581);

        sw = 16'h6F6B;
        test(16'h2590);
        #20;

        $finish;

    end

endmodule
