module tb_RCA;
    parameter N=9;
    reg [N-1:0] a,b;
    reg cin;
    wire signed [N-1:0] sum;
    wire cout;

    RCA DUT (.carry(cout), .sum(sum), .in1(a), .in2(b), .mode(cin));
    
    initial 
        begin
            $dumpfile("nbit_RCA.vcd");
            $dumpvars(0,tb_RCA);
            $monitor($time," input1=%d, input2=%d | Result=%d, Carry=%b",a,b,sum,cout);
            a=9'd150; b=9'd25; cin=0;
            #10
            a=9'd20; b=9'd30; cin=1;
            #10
            a=9'd80; b=9'd30; cin=1;
            #10 $finish;
        end
endmodule

/* iverilog -o RCA_out RCA.v tb_nbit_RCA.v
vvp RCA_out
gtkwave nbit_RCA.vcd