//////////////////////////////////////////////////////////////////////////////////
// Module Name : sbox
// Project Name : Simplified Advanced Encryption Standard (S-AES)
//
// Description :
//   This module performs the S-AES Nibble substitution
//   A fixed 16×4-bit ROM that maps each 4-bit input nibble to a corresponding 
//   4-bit output. Four parallel lookups are used to process the 16-bit state 
//   in one operation.
//
// Student Name : Shreya Sen
// S-ID : 231001002086
//////////////////////////////////////////////////////////////////////////////////


module sbox (
    input clk,
    input [15:0] in,
    output [15:0] out
);    
    wire [3:0] addr0, addr1, addr2, addr3;
    wire [3:0] dout0, dout1, dout2, dout3;

    assign addr3 = in[15:12];
    assign addr2 = in[11:8];
    assign addr1 = in[7:4];
    assign addr0 = in[3:0];
    
    blk_mem_gen_0 SB_ROM3 (
  .clka(clk),    // input wire clka
  .addra(addr3),  // input wire [3 : 0] addra
  .douta(dout3)  // output wire [3 : 0] douta
); 
    blk_mem_gen_0 SB_ROM2 (
  .clka(clk),    // input wire clka
  .addra(addr2),  // input wire [3 : 0] addra
  .douta(dout2)  // output wire [3 : 0] douta
); 
    blk_mem_gen_0 SB_ROM1 (
  .clka(clk),    // input wire clka
  .addra(addr1),  // input wire [3 : 0] addra
  .douta(dout1)  // output wire [3 : 0] douta
);  
    blk_mem_gen_0 SB_ROM0 (
  .clka(clk),    // input wire clka
  .addra(addr0),  // input wire [3 : 0] addra
  .douta(dout0)  // output wire [3 : 0] douta
);

    assign out = {dout3, dout2, dout1, dout0};
endmodule
