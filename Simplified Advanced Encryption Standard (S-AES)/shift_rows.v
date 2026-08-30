module shift_rows (in, out);
    input [15:0]  in;
    output [15:0]  out;

    assign out = {in[15:12], in[11:8], in[3:0], in[7:4]};
endmodule