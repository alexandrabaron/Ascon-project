`timescale 1ns / 1ps

module permutation_xor_tb import ascon_pack::*;(
);
	logic clock_i_s; 
	logic resetb_i_s; 
	logic input_select_i_s; 

	logic ena_cpt_i_s;
    	logic init_a_i_s;
   	logic init_b_i_s;

	logic ena_xor_up_i_s;
	logic ena_xor_down_i_s; 
	logic ena_reg_state_i_s;
	type_state permutation_i_s; 
	logic[63:0] data_xor_up_i_s;
	logic[255:0] data_xor_down_i_s;

	logic ena_cipher_i_s;
	logic ena_tag_i_s;

	type_state permutation_o_s; 
	logic [3:0] round_o_s;
	logic cipher_o_s;
	logic tag_o_s;

	permutation_xor DUT (
		.clock_i(clock_i_s),
		.resetb_i(resetb_i_s),
		.input_select_i(input_select_i_s),

		.ena_cpt_i(ena_cpt_i_s),
		.init_a_i(init_a_i_s),
		.init_b_i(init_b_i_s),

		.ena_xor_up_i(ena_xor_up_i_s),
		.ena_xor_down_i(ena_xor_down_i_s),
		.ena_reg_state_i(ena_reg_state_i_s),
		.permutation_i(permutation_i_s),
		.data_xor_up_i(data_xor_up_i_s),
		.data_xor_down_i(data_xor_down_i_s),

		.ena_cipher_i(ena_cipher_i_s),
		.ena_tag_i(ena_tag_i_s),

		.permutation_o(permutation_o_s),
		.round_o(round_o_s),
		.cipher_o(cipher_o_s),
		.tag_o(tag_o_s)
		);

	/*initial begin
		clock_i_s = 0;
		forever #5 clock_i_s = ~ clock_i_s;
	end*/

	initial begin

		ena_reg_state_i_s = 1'b1;
		ena_cpt_i_s = 1;
		
		permutation_i_s[0]=64'h80400c0600000000;
		permutation_i_s[1]=64'h8a55114d1cb6a9a2;
		permutation_i_s[2]=64'hbe263d4d7aecaaff;
		permutation_i_s[3]=64'h4ed0ec0b98c529b7;
		permutation_i_s[4]=64'hc8cddf37bcd0284a;

		init_a_i_s = 1;
		init_b_i_s = 0;
		clock_i_s = 0;
		
		resetb_i_s = 0;
		input_select_i_s = 0;

		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;

		clock_i_s = 1;

		
		#10
		clock_i_s = 0;

		#10

/// On vient de terminer la 0-ième itération

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //1
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //2
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //3
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //4
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //5
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //6
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //7
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //8
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //9
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //10
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 1; //11
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 0;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;


		
		#10
		clock_i_s = 0;
		#10

		resetb_i_s = 1;
		ena_cpt_i_s = 0; //"12" + XOR DOWN 
//Ceci n'est pas une vraie permutation elle permet simplement de réalisé le XOR.
		init_a_i_s = 0;
		init_b_i_s = 0;
		
		input_select_i_s = 1;
		data_xor_up_i_s = 64'b0;		
		data_xor_down_i_s = {128'h0, 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF};
		ena_xor_down_i_s = 1;
		ena_xor_up_i_s = 0;
		
		clock_i_s = 1;
		ena_reg_state_i_s = 1'b1;
		
/// La 11-ème est terminé ici



//////////////////////////////////////

		

		

	end
endmodule : permutation_xor_tb
