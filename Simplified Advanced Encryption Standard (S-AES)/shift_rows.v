//////////////////////////////////////////////////////////////////////////////////
// Module Name : shift_rows
// Project Name : Simplified Advanced Encryption Standard (S-AES)
//
// Description :
//   This module is used to rearranges the four nibbles of the 
//   16-bit state according to the S-AES ShiftRows operation.
//   Initial Position : N00 N01 N10 N11 
//   Final Position : N00 N01 N11 N10
//
// Student Name : Shreya Sen
// S-ID : 231001002086
//////////////////////////////////////////////////////////////////////////////////


module shift_rows (
    input [15:0]  in,
    output [15:0]  out
);
    assign out = {in[15:12], in[11:8], in[3:0], in[7:4]};
endmodule
