module accumulator (d_in,ac_out,reset,clk,op);
    input d_in,reset,clk;
    output reg [3:0] ac_out;     
    input [2:0] op;
    reg [3:0] out;
    
    localparam AND = 3'b000,
               ADD = 3'b001,
               LDA = 3'b010,
               COM = 3'b011,
               SR = 3'b100,
               SL = 3'b101,
               MUL = 3'b110,
               DIV = 3'b111;

    always @(*) begin
        case (op)
            AND : out = ac_out & d_in;
            ADD : out = ac_out + d_in;
            LDA : out = d_in; 
            COM : out = ~ac_out;
            SR : out = ac_out >> 1'b1;
            SL : out = ac_out << 1'b1;
            MUL : out = ac_out * d_in;
            DIV : out = ac_out / d_in;
            default: out = ac_out;
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            ac_out <= 4'b0000;
        end
        else begin
            ac_out <= out;
        end
    end
endmodule