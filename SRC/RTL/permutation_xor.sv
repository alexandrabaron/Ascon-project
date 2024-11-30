`timescale 1ns / 1ps
module permutation_xor import ascon_pack::*;
	(
		input logic clock_i, //horloge 
		input logic resetb_i, //reinitialisation asynchrone 
		input logic input_select_i, //selecteur pour premier MUX (0 pour sortie, 1 pour permutation)
		input logic ena_cpt_i, // Signal d'activation du compteur
    		input logic init_a_i, // Signal d'initialisation du compteur à 0
   		input logic init_b_i, // Signal d'initialisation du compteur à 6

		//Pour les MUX des XOR
		input logic ena_xor_up_i, // Signal d'activation du XOR amont
		input logic ena_xor_down_i, // Signal d'activation du XOR aval 
		input logic ena_reg_state_i,
		input type_state permutation_i, 
		input logic[63:0] data_xor_up_i, // Données pour le XOR amont
		input logic[255:0] data_xor_down_i,  // Données pour le XOR aval

		input logic ena_cipher_i, 
		input logic ena_tag_i, 

		output type_state permutation_o,
		output logic [3:0] round_o,
		output logic cipher_o, 
		output logic tag_o 
	);
		
	type_state mux_to_xor_up_s;
	type_state xor_up_to_const_add_s;

	type_state xor_up_to_cipher_s; 
  	

	type_state const_add_to_sub_s; //signal intermédiaire entre Pc et Ps
	type_state sub_to_diff_s; // signal entre Ps et Pl
	type_state diff_to_xor_down_s;

	type_state xor_down_to_tag_s; 
	/* Le tag est disponible après finalisation (p12) et XOR final => pas toujours disponible */	
	type_state tag_s; 

	type_state xor_down_to_reg_s; //signal entre pl et registre
	type_state register_output_s;	


	logic [3:0] round_i_s;

	// RAPPEL: <target_net> = <boolean_cond>?<true_assignment>:<false_assignment>;

	// instanciation MUX
	assign mux_to_xor_up_s = (input_select_i) ? register_output_s : permutation_i;
	// si mux entrée = 1 -> register_output_s sinon permutation_i

	//instanciation Xor_Up
	xor_up xor_up_inst
	(
		.data_xor_up_i(data_xor_up_i),
		.ena_xor_up_i(ena_xor_up_i),
		.state_i(mux_to_xor_up_s),
		.state_o(xor_up_to_const_add_s),
		.cipher_o(xor_up_to_cipher_s)
	);
	//instanciation ADD
	constant_add constant_add_inst
	(
		.constant_add_i(xor_up_to_const_add_s),
		.round_i(round_i_s),
		.constant_add_o(const_add_to_sub_s)
	);

	//instanciation SUBSTITUTION
	substitution_layer substitution_layer_inst
	(
		.sub_layer_i(const_add_to_sub_s),
		.sub_layer_o(sub_to_diff_s)
	);

	//instanciation DIFFUSION
	diffusion_layer diffusion_layer_inst
	(
		.diffusion_i(sub_to_diff_s),
		.diffusion_o(diff_to_xor_down_s)
	);

	//instanciation Xor_Down
	xor_down xor_down_inst
	(
		.data_xor_down_i(data_xor_down_i),
		.ena_xor_down_i(ena_xor_down_i),
		.state_i(diff_to_xor_down_s),
		.state_o(xor_down_to_reg_s),
		.tag_o(xor_down_to_tag_s)
	);
	
	//instanciation REGISTRE 
	register_state register_state_inst
	(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.register_i(xor_down_to_reg_s),
		.register_o(register_output_s),
		.ena_reg_state_i(ena_reg_state_i)
	);

	//instanciation REGISTRE cipher 
	register_state register_state_cipher_inst
	(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.register_i(xor_up_to_cipher_s),
		.register_o(cipher_o),
		.ena_reg_state_i(ena_cipher_i)
	);

	//instanciation REGISTRE tag 
	register_state register_state_tag_inst
	(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.register_i(xor_down_to_tag_s),
		.register_o(tag_s),
		.ena_reg_state_i(ena_tag_i)
	);

	//instanciation COUNTER DOUBLE INIT

	counter_double_init counter_double_init_inst
	(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.ena_i(ena_cpt_i),
		.init_a_i(init_a_i),
		.init_b_i(init_b_i),
		.count_o(round_i_s)
	);
	assign permutation_o = register_output_s;
	assign round_o = round_i_s;
	assign tag_o = tag_s ^ permutation_i[0:1];

		
endmodule : permutation_xor
