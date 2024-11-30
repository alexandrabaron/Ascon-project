`timescale 1ns / 1ps

module diffusion_layer_tb import ascon_pack::*;(
        //vide
    	);
	type_state diffusion_i_s;
	type_state diffusion_o_s;
	
	diffusion_layer DUT (
		.diffusion_i(diffusion_i_s),
		.diffusion_o(diffusion_o_s)
	);
	initial begin
		diffusion_i_s[0] = 64'h0;
		diffusion_i_s[1] = 64'h0;
		diffusion_i_s[2] = 64'h0;
		diffusion_i_s[3] = 64'h0;
		diffusion_i_s[4] = 64'h0;
		
		#50
		
		diffusion_i_s[0] = 64'h78e2_cc41_faab_aa1a;
		diffusion_i_s[1] = 64'hbc7a_2e77_5aab_abf7;
		diffusion_i_s[2] = 64'h4b81_c0cb_bdb5_fc1a;
		diffusion_i_s[3] = 64'hb22e_133e_424f_0250;
		diffusion_i_s[4] = 64'h044d_3370_2433_805d;    
		
	end
endmodule : diffusion_layer_tb
