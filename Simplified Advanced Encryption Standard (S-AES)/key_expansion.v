module key_expansion (clk,MASTER_KEY, K0, K1, K2);
    input clk;
    input [15:0] MASTER_KEY;
    output [15:0] K0, K1, K2;

    //MASTER_KEY = 16'h2D65;

    assign K0 = MASTER_KEY;

    wire [7:0] w0,w1,w2,w3,w4,w5,Rcon1,Rcon2;
    wire [3:0] w_c, w_d, w_g, w_h;
    
    blk_mem_gen_1 RCON1 (.clka(clk),.addra(1'b0),.douta(Rcon1));
    blk_mem_gen_1 RCON2 (.clka(clk),.addra(1'b1),.douta(Rcon2));
    
    assign w0 = MASTER_KEY[15:8];
    assign w1 = MASTER_KEY[7:0];
    //K1
    blk_mem_gen_0 SB1 (.clka(clk),.addra(w1[3:0]),.douta(w_c));
    blk_mem_gen_0 SB2 (.clka(clk),.addra(w1[7:4]),.douta(w_d));
    assign w2 = w0 ^ Rcon1 ^ {w_c,w_d};  // gw1 = Rcon1 ^ {w_c,w_d}; 
    assign w3 = w2 ^ w1;
    assign K1 = {w2,w3};
    //K2
    blk_mem_gen_0 SB3 (.clka(clk),.addra(w3[7:4]),.douta(w_g));
    blk_mem_gen_0 SB4 (.clka(clk),.addra(w3[3:0]),.douta(w_h));
    assign w4 = w2 ^ Rcon2 ^ {w_h,w_g};  //gw3 = Rcon2 ^ {w_h,w_g};
    assign w5 = w4 ^ w3;
    assign K2 = {w4,w5};
endmodule