module mux (in1, in2, sel, out);
    input in1, in2, sel;
    output reg out;

    always @(*) begin
        case (sel)
            1'b0 : out = in1;
            1'b1 : out = in2;
            default: out = in1;
        endcase
    end
endmodule