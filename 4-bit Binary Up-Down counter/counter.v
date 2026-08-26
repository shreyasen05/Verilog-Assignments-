module counter (clk,reset,direction,count,mode_led);
    input clk, reset, direction;
    output reg [3:0] count;
    output mode_led;

    wire slow_clk;
    wire [3:0] n_count;

    assign mode_led = direction;

    clk_div SC (.clk(clk),.reset(reset),.d_clk(slow_clk));
    add_sub AS(.p_count(count), .n_count(n_count), .direction(direction));

    always @(posedge slow_clk) begin
        if (reset) begin
            count <= 4'b0000;
        end
        else begin
            count <= n_count;
        end
    end
endmodule