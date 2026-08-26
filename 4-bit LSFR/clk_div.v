module clk_div (clk,rst,d_clk);
    input clk, rst;
    output reg d_clk;

    reg [25:0] d_count;
    localparam th = 50000000 - 1; //for simulation  th = 5 - 1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            d_count <= 26'd0;
            d_clk <= 1'b0;
        end
        else if (d_count == th)begin
            d_count <= 26'd0;
            d_clk <= ~d_clk;
        end
        else begin
            d_count <= d_count +26'd1;
        end
    end
endmodule