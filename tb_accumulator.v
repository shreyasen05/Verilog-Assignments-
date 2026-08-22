`timescale 1ns/1ps

module tb_accumulator;
    reg d_in, reset, clk;
    reg [2:0] op;
    wire [3:0] ac_out;

    accumulator AC (.d_in(d_in), .ac_out(ac_out), .reset(reset), .clk(clk), .op(op));

    always #5 clk = ~clk;

    localparam AND = 3'b000,
               ADD = 3'b001,
               LDA = 3'b010,
               COM = 3'b011,
               SR  = 3'b100,
               SL  = 3'b101,
               MUL = 3'b110,
               DIV = 3'b111;

    initial begin
        $dumpfile("accumulator.vcd");
        $dumpvars(0, tb_accumulator);

        clk = 0;
        reset = 1;
        d_in = 0;
        op = ADD;

        #2 $display("Reset: ac_out = %b", ac_out);

        #3 reset = 0;
        d_in = 1;
        op = LDA;
        #10 $display("LDA: ac_out = %b", ac_out);

        d_in = 1;
        op = ADD;
        #10 $display("ADD: ac_out = %b", ac_out);

        d_in = 1;
        op = AND;
        #10 $display("AND: ac_out = %b", ac_out);

        op = COM;
        #10 $display("COM: ac_out = %b", ac_out);

        op = SR;
        #10 $display("SR : ac_out = %b", ac_out);

        op = SL;
        #10 $display("SL : ac_out = %b", ac_out);

        d_in = 0;
        op = MUL;
        #10 $display("MUL: ac_out = %b", ac_out);

        d_in = 1;
        op = DIV;
        #10 $display("DIV: ac_out = %b", ac_out);

        #10 $finish;
    end
endmodule

/*iverilog -o accumulator_out accumulator.v tb_accumulator.v
vvp accumulator_out
gtkwave accumulator.vcd