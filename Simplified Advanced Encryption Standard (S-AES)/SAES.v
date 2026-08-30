module SAES (plaintext,chipertext,clk,rst);
    input clk, rst;
    input [15:0] plaintext;
    output reg [15:0] chipertext;

    wire [15:0] K0, K1, K2;
    
    localparam MASTER_KEY = 16'h2D65;
    key_expansion KEYS (.clk(clk),.MASTER_KEY(MASTER_KEY), .K0(K0), .K1(K1), .K2(K2));

    reg [15:0] DataReg;
    wire [15:0] sbox_out, sr_out, mc_out;


    reg [2:0] state;
    reg round;

    localparam IDLE =  3'b000;
    localparam start = 3'b001;//plaintext xor k0
    localparam NibbleSub = 3'b010;
    localparam NibbleSubWait = 3'b111;
    localparam ShiftRows = 3'b011;
    localparam MixColumns = 3'b100;
    localparam AddRoundKey = 3'b101;
    localparam done = 3'b110;

    sbox SB5(.clk(clk),.in(DataReg),.out(sbox_out));

    shift_rows SR (.in(DataReg), .out(sr_out));

    mix_columns MC(.in(DataReg), .out(mc_out));

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            DataReg <= 16'h0000;
            chipertext <= 16'h0000;
            round <= 1'b0;
        end
        else begin
            case (state)
                IDLE : state <= start;
                start : begin
                    DataReg <= plaintext ^ K0;
                    state <= NibbleSub;
                end 
                 NibbleSub : begin
                    state <= NibbleSubWait;//clk synchronization
                 end
                NibbleSubWait : begin
                    DataReg <= sbox_out;
                    state <= ShiftRows;
                end
                ShiftRows : begin
                    DataReg <= sr_out;
                    case (round)
                        1'b0 : begin
                            state <= MixColumns;
                        end
                        1'b1 : begin
                            state <= AddRoundKey;
                        end
                    endcase
                end
                MixColumns : begin
                    DataReg <= mc_out;
                    state <= AddRoundKey;
                end
                AddRoundKey : begin
                    case (round)
                        1'b0 : begin
                            DataReg <= DataReg ^ K1;
                            state <= NibbleSub;
                            round <= round + 1;
                        end
                        1'b1 : begin
                            DataReg <= DataReg ^ K2;
                            state <= done;
                        end
                    endcase
                end
                done : begin
                    chipertext <= DataReg;
                end
                default: state <= IDLE;
            endcase
        end
        
    end
endmodule
