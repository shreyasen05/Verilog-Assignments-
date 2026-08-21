module tb_CLA;
    parameter N=16;
    reg [N-1:0] a,b;
    reg cin;
    wire [N-1:0] sum_RCA, sum_CLA;
    wire cout_RCA, cout_CLA;

    CLA_16 DUT (.carry(cout_CLA), .sum(sum_CLA), .a(a), .b(b), .cin(cin));
    RCA_16 M (.carry(cout_RCA), .sum(sum_RCA), .a(a), .b(b), .cin(cin));
    initial 
        begin
            $dumpfile("CLA.vcd");
            $dumpvars(0,tb_CLA);
            $monitor($time," input1=%d, input2=%d | Sum_CLA=%d, Carry_CLA=%b| Sum_RCA=%d, Carry_RCA=%b",a,b, sum_CLA,cout_CLA,sum_RCA,cout_RCA);
            a=16'd115; b=16'd202; cin=0;
            #10
            a=16'd12; b=16'd3; cin=1;
            #10 $finish;
        end
endmodule
