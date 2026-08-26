`timescale 1ns / 1ps
module tb_UpDownCounter;
     reg clk, reset, direction;
     wire  [3:0] count;
     wire mode_led;
    
    counter DUT (.clk(clk),.reset(reset),.direction(direction),.count(count),.mode_led(mode_led));
    
    always #5 clk = ~clk;
    
    initial begin
        $monitor($time,"| Reset=%b | Direction=%b | Count=%b | LED=%b",reset, direction, count, mode_led);
        clk = 0;
        reset = 1;
        direction = 1;
        #20 reset = 0;
        #100;
        direction = 0;
        #300;
        $finish;
    end
endmodule
