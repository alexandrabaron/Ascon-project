`timescale 1ns / 1ps

module sbox_tb

    import ascon_pack::*;
(
);
    // Déclaration des signaux
    logic [4:0] sbox_i_s;
    logic [4:0] sbox_o_s;

    // Instanciation du DUT
    sbox DUT (
        .sbox_i(sbox_i_s),
        .sbox_o(sbox_o_s)
    );

    initial begin
        // Initialisation des valeurs de test
        	sbox_i_s = 5'h00;
                #5
		sbox_i_s = 5'h01;
		#5 
		sbox_i_s = 5'h02;
		#5 
		sbox_i_s = 5'h03;
		#5 
		sbox_i_s = 5'h04;
		#5 
		sbox_i_s = 5'h05;
		#5 
		sbox_i_s = 5'h06;
		#5 
		sbox_i_s = 5'h07;
		#5 
		sbox_i_s = 5'h08;
		#5 
		sbox_i_s = 5'h09;
		#5 
		sbox_i_s = 5'h0A;
		#5 
		sbox_i_s = 5'h0B;
		#5 
		sbox_i_s = 5'h0C;
		#5 
		sbox_i_s = 5'h0D;
		#5  
		sbox_i_s = 5'h0E;
		#5  
		sbox_i_s = 5'h0F;
		#5  
		sbox_i_s = 5'h10;
		#5  
		sbox_i_s = 5'h11;
		#5  
		sbox_i_s = 5'h12;
		#5  
		sbox_i_s = 5'h13;
		#5  
		sbox_i_s = 5'h14;
		#5 
		sbox_i_s = 5'h15;
		#5
		sbox_i_s = 5'h16;
		#5 
		sbox_i_s = 5'h17;
		#5 
		sbox_i_s = 5'h18;
		#5 
		sbox_i_s = 5'h19;
		#5 
		sbox_i_s = 5'h1A;
		#5 
		sbox_i_s = 5'h1B;
		#5 
		sbox_i_s = 5'h1C;
		#5
		sbox_i_s = 5'h1D;
		#5 
		sbox_i_s = 5'h1E;
		#5 
		sbox_i_s = 5'h1F;
    end

endmodule : sbox_tb
