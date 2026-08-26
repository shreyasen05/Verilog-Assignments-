module D_ff (clk, rst, D, Q);
    input clk, rst, D;
    output reg Q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 1'b0;
        end
        else begin
            Q <= D;
        end
    end
endmodule
