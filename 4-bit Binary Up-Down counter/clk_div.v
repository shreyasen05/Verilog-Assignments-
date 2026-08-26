module clk_div (clk,reset,d_clk);
    input clk, reset;
    output reg d_clk;
    reg [24:0] d_count;
    localparam integer th = 25000000 - 1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            d_count <= 25'd0;
            d_clk <= 1'b0;
        end
        else if (d_count == th) begin
            d_count <= 25'd0;
            d_clk <= ~d_clk;
        end
        else begin
            d_count <= d_count + 25'd1;
        end
    end
endmodule
