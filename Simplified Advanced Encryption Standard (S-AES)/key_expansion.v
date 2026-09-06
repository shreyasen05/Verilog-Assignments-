//////////////////////////////////////////////////////////////////////////////////
// Module Name : key_expansion
// Project Name : Simplified Advanced Encryption Standard (S-AES)
//
// Description :
//   Generates the three 16-bit round keys(K0,K1,K2) required by the S-AES 
//   from a 16-bit master key(2D65)
//   K0 = 2D65
//   K1 = B5D0 <- Round key for first round
//   K2 = 1BCB <- Round key for second round
//
// Student Name : Shreya Sen
// S-ID : 231001002086
//////////////////////////////////////////////////////////////////////////////////


module key_expansion (
    input clk,rst,start,
    input [15:0] MASTER_KEY,
    output reg [15:0] K0, K1, K2,
    output reg done
);
    //MASTER_KEY = 16'h2D65;

    reg [7:0] w0,w1,w2,w3;
    
    reg [15:0] sbox_in;
    wire [15:0] sbox_out;
    sbox SBOX (.clk(clk),.in(sbox_in),.out(sbox_out));
    
    localparam [7:0] Rcon1 = 8'h80;
    localparam [7:0] Rcon2 = 8'h30;
    
    reg [2:0] state;
    localparam IDLE = 3'b000;
    localparam K0_cal = 3'b110;
    localparam sbox_K1 = 3'b001;
    localparam K1_cal = 3'b010;
    localparam sbox_K2 = 3'b011;
    localparam K2_cal = 3'b100;
    localparam finish = 3'b101;
    
    
    always @(*) begin
        sbox_in = 16'h0000;
        if (state == sbox_K1) begin
            sbox_in = {w1[3:0],w1[7:4],8'h00};
        end
        else if (state == sbox_K2) begin
            sbox_in = {w3[3:0],w3[7:4],8'h00};
        end
    end
    
    always @ (posedge clk) begin
        if (rst)begin
            state <= IDLE;
            K0 <= 16'h0000; K1 <= 16'h0000; K2 <= 16'h0000;
            w0 <= 8'h00; w1 <= 8'h00; w2 <= 8'h00; w3 <= 8'h00;
            done <= 1'b0;
        end
        else begin
          case (state)
            IDLE : begin
                done <= 1'b0;
                if (start) state <= K0_cal;
            end
            K0_cal : begin
                K0 <= MASTER_KEY;
                w0 <= MASTER_KEY[15:8];
                w1 <= MASTER_KEY[7:0];
                state <= sbox_K1;
            end
            sbox_K1 : begin
                //sbox_in <= {w1[3:0],w1[7:4],8'h00};
                state <= K1_cal;
            end
            K1_cal : begin
                w2 <= w0 ^ Rcon1 ^ sbox_out[15:8]; 
                w3 <= w0 ^ Rcon1 ^ sbox_out[15:8] ^ w1;
                K1 <= {(w0 ^ Rcon1 ^ sbox_out[15:8]), (w0 ^ Rcon1 ^ sbox_out[15:8] ^ w1)};
                state <= sbox_K2;
            end
            sbox_K2 : begin
                //sbox_in <= {w3[3:0],w3[7:4],8'h00};
                state <= K2_cal;
            end
            K2_cal : begin
                //w4 <= w2 ^ Rcon2 ^ sbox_out[15:8];
                //w5 <= w2 ^ Rcon2 ^ sbox_out[15:8] ^ w3;
                K2 <= {(w2 ^ Rcon2 ^ sbox_out[15:8]),(w2 ^ Rcon2 ^ sbox_out[15:8] ^ w3)};
                state <= finish;
            end
            finish : begin
                done <= 1'b1;
                state <= IDLE;
            end
            default : state <= IDLE;
        endcase
    end
    end
endmodule
