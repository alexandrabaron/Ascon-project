`timescale 1ns / 1ps
module substitution_layer_tb import ascon_pack::*;
(
);
	type_state sub_layer_i_s;
        type_state sub_layer_o_s;
        
        
substitution_layer DUT(
	.sub_layer_i(sub_layer_i_s),
	.sub_layer_o(sub_layer_o_s)
	

);

	initial begin
		sub_layer_i_s[0] = 64'h0;
		sub_layer_i_s[1] = 64'h0;
		sub_layer_i_s[2] = 64'h0;
		sub_layer_i_s[3] = 64'h0;
		sub_layer_i_s[4] = 64'h0;
		
		#10;
		
		sub_layer_i_s[0] = 64'h8040_0c06_0000_0000; 
		sub_layer_i_s[1] = 64'h8a55_114d_1cb6_a9a2; 
		sub_layer_i_s[2] = 64'hbe26_3d4d_7aec_aa0f;
		sub_layer_i_s[3] = 64'h4ed0_ec0b_98c5_29b7;  
		sub_layer_i_s[4] = 64'hc8cd_df37_bcd0_284a;
	end
endmodule : substitution_layer_tb
