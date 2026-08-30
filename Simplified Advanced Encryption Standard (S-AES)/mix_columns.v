module mix_columns (in,out);
    input [15:0]  in;
    output [15:0]  out;

    function [3:0] mul;
        input [3:0] a;
        begin
            case (a)
                4'h0 : mul = 4'h0;
                4'h1 : mul = 4'h4;
                4'h2 : mul = 4'h8;
                4'h3 : mul = 4'hC;
                4'h4 : mul = 4'h3;
                4'h5 : mul = 4'h7;
                4'h6 : mul = 4'hB;
                4'h7 : mul = 4'hF;
                4'h8 : mul = 4'h6;
                4'h9 : mul = 4'h2;
                4'hA : mul = 4'hE;
                4'hB : mul = 4'hA;
                4'hC : mul = 4'h5;
                4'hD : mul = 4'h1;
                4'hE : mul = 4'h9;
                4'hF : mul = 4'hD;
                default: mul = 4'h0;
            endcase
        end
    endfunction;
    
    assign out[15:12] = in[15:12] ^ mul(in[7:4]);
    assign out[11:8] = in[11:8] ^ mul(in[3:0]);
    assign out[7:4] = in[7:4] ^ mul(in[15:12]);
    assign out[3:0] = in[3:0] ^ mul(in[11:8]);
endmodule