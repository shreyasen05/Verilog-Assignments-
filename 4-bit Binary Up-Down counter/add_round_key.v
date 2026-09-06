//////////////////////////////////////////////////////////////////////////////////
// Module Name : add_round_key
// Project Name : Simplified Advanced Encryption Standard (S-AES)
//
// Description :
//   This operation mixes the secret key with the data state
//  Output state = Input state ⊕ Corresponding Round key
//
// Student Name : Shreya Sen
// S-ID : 231001002086
//////////////////////////////////////////////////////////////////////////////////


module add_round_key (
    input  [15:0] state,
    input  [15:0] round_key,
    output [15:0] out
);
    assign out = state ^ round_key;
endmodule
