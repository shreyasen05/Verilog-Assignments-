//////////////////////////////////////////////////////////////////////////////////
// Module Name : SAES
// Project Name : Simplified Advanced Encryption Standard (S-AES)
//
// Description :
//   Top-level module implementing the S-AES encryption.
//   It accepts a 16-bit plaintext through the FPGA switches and
//   displays the resulting 16-bit ciphertext on the LEDs.
//
// Student Name : Shreya Sen
// S-ID : 231001002086
//////////////////////////////////////////////////////////////////////////////////


module SAES (
    input clk,
    input rst,
    input [15:0] sw,
    output reg [15:0] led
);
    reg [15:0] sw_latched;
    
    wire [15:0] K0, K1, K2;
    reg start;//key_expansion start signal
    wire done;//key_expansion done output signal
    localparam MASTER_KEY = 16'h2D65;
    key_expansion KEYS (.clk(clk),.rst(rst),.start(start),.MASTER_KEY(MASTER_KEY), .K0(K0), .K1(K1), .K2(K2),.done(done));

    reg [15:0] DataReg;
    reg [15:0] sbox_in; 
    wire [15:0] sbox_out, sr_out, mc_out, ark1, ark2;


    reg [2:0] state;

    localparam IDLE =  3'b000;
    localparam KEY_EXP = 3'b001;
    localparam SUB_R1 = 3'b010;
    localparam R1 = 3'b111;
    localparam SUB_R2 = 3'b011;
    localparam R2 = 3'b100;
    localparam CIPHER = 3'b101;
    localparam finish = 3'b110;

    sbox SB5(.clk(clk),.in(sbox_in),.out(sbox_out));

    shift_rows SR (.in(sbox_out), .out(sr_out));

    mix_columns MC(.in(sr_out), .out(mc_out));
    
    add_round_key ARK1(.state(mc_out),.round_key(K1),.out(ark1));//round 1
    add_round_key ARK2(.state(sr_out),.round_key(K2),.out(ark2));//round 2

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            sw_latched <= 16'h0000;
            sbox_in <= 16'h0000;
            DataReg <= 16'h0000;
            led <= 16'h0000;
            start <= 1'b0;
        end
        else begin
            case (state)
                IDLE : begin
                    start <= 1'b0;
                    if (sw_latched != sw) begin
                        sw_latched <= sw;
                        state <= KEY_EXP;
                    end
                end
                KEY_EXP : begin
                    start <= 1'b1;
                    state <= SUB_R1;
                end
                SUB_R1 : begin
                    if (done) begin 
                        sbox_in <= sw_latched ^ K0;
                        state <= R1;
                    end
                end
                R1 : begin
                    state <= SUB_R2;
                end
                SUB_R2 : begin
                    sbox_in <= ark1;
                    state <= R2;
                end
                R2 : begin
                    state <= CIPHER;
                end
                CIPHER : begin
                    DataReg <= ark2;
                    state <= finish;
                end
                finish : begin
                    led <= DataReg;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
        
    end
endmodule
