module tb_CLA;
    parameter N=16;
    reg [N-1:0] a,b;
    reg cin;
    wire [N-1:0] sum;
    wire cout;
    wire [3:0] p_out, g_out;

    CLA_16 DUT (.carry(cout), .sum(sum), .p_out(p_out), .g_out(g_out), .a(a), .b(b), .cin(cin));
    
    initial 
        begin
            $dumpfile("CLA.vcd");
            $dumpvars(0,tb_CLA);
            $monitor($time," input1=%d, input2=%d | Sum=%d, Carry=%b, P=%b, G=%b",a,b,sum,cout,p_out, g_out);
            a=16'd115; b=16'd202; cin=0;
            #10
            a=16'd12; b=16'd3; cin=1;
            #10 $finish;
        end
endmodule

/* iverilog -o CLA_out CLA.v tb_CLA.v
vvp CLA_out
gtkwave CLA.vcd