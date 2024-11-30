`timescale 1 ns / 10 ps
module ascon_top import ascon_pack::*;
	(		
		input logic clock_i, //horloge
		input logic resetb_i, //signal d'initialisation		
		//flot de contrôle : entrées machine d'état 	
		input logic start_i, //pour commencer le chiffrement
		input logic data_valid_i, //vérifie la présence d'une donnée valide sur data_i
		//flot de données : entrées permutation & XOR
		input logic[63:0] data_i, //entrée
		input logic[127:0] key_i, //clé
		input logic[127:0] nonce_i, //entrée pour le nombre arbitraire

		//flot de contrôle : soties machine d'état
		output logic cipher_valid_o, //vérifie la validité de la sortie cipher_o
		output logic end_o, //fin du chiffrement du message 

		//flot de données : sorties permutation & XOR
		output logic[63:0] cipher_o, 
		output logic[127:0] tag_o
	);

	//Pour initialisation
	logic [320:0] entree;
	assign entree = {64'h80400C0600000000,key_i,nonce_i};

	//pour le compteur de rondes
	logic [3:0] round_s;
	logic ena_cpt_s;
	logic init_a_s;
	logic init_b_s;

	//pour les XOR
	logic [1:0] conf_xor_up_s;
	logic [1:0] conf_xor_down_s;
	logic ena_xor_up_s;
	logic ena_xor_down_s;
	logic[63:0] data_xor_up_s;
	logic[255:0] data_xor_down_s;

	type_state permutation_o_s;

	//pour les registres
	logic input_select_s;
	logic ena_reg_state_s;
	logic ena_cipher_s;
	logic ena_tag_s;
	

	//Pour les XOR 
	always_comb begin : CONF_XOR_UP
		data_xor_up_s = 64'h0;
		case(conf_xor_up_s)
			2'b00 : data_xor_up_s = {48'h4120746F2042, 16'b1000000000000000}; //A1
			2'b01 : data_xor_up_s = {64'h5244562061752054}; //P1
			2'b10 : data_xor_up_s = {64'h6927626172206365}; //P2
			2'b11 : data_xor_up_s = {64'h20736F6972203F, 8'b10000000}; //P3
		endcase
	end // block: CONF_XOR_UP

	always_comb begin : CONF_XOR_DOWN
		data_xor_down_s = 64'h0;
		case(conf_xor_down_s)
			2'b00 : data_xor_down_s = {128'b0, key_i}; //{0...0,K} INIT
			2'b01 : data_xor_down_s = 256'b1; //{0...0,1} DONNEE ASSOC
			2'b10 : data_xor_down_s = {key_i, 128'b0}; //{K,0...0} FINAL
		endcase
	end // block: CONF_XOR_DOWN
	

	//instance de permutation	
	permutation_xor perm(

		.clock_i(clock_i),
		.resetb_i(resetb_i),  
		.input_select_i(input_select_s), 

		.ena_cpt_i(ena_cpt_s),
		.init_a_i(init_a_s),
		.init_b_i(init_b_s),

		.ena_xor_up_i(ena_xor_up_s),
		.ena_xor_down_i(ena_xor_down_s),
		.ena_reg_state_i(ena_reg_state_s),
		.permutation_i(entree), 
		.data_xor_up_i(data_xor_up_s),
		.data_xor_down_i(data_xor_down_s),

		.ena_cipher_i(ena_cipher_s),
		.ena_tag_i(ena_tag_s),

		.permutation_o(permutation_o_s),
		.round_o(round_s),
		.cipher_o(cipher_o),
		.tag_o(tag_o)
	);

/*	//instance de compteur 2 init
	counter_double_init cdi(
		.clock_i(clock_i),
	 	.resetb_i(resetb_i),
	 	.ena_i(ena_cpt_s),
	 	.init_a_i(init_a_s),
	 	.init_b_i(init_b_s),
	 	.count_o(round_s)
	);
*/

	//instance de fsm
	fsm fsm(
	
		.clock_i(clock_i),
     		.resetb_i(resetb_i),
     		.start_i(start_i),
     		.data_valid_i(data_valid_i),
     		.round_i(round_s),

     		.ena_reg_state_o(ena_reg_state_s),
     		.cipher_valid_o(ena_cipher_s),
		.tag_o(ena_tag_s),

     		.end_o(end_o),

     		.init_state_o(input_select_s),

     		.ena_cpt_o(ena_cpt_s),
     		.init_a_o(init_a_s),
     		.init_b_o(init_b_s),

		.conf_xor_up_o(conf_xor_up_s), 
		.conf_xor_down_o(conf_xor_down_s), 
		.ena_xor_up_o(ena_xor_up_s),
     		.ena_xor_down_o(ena_xor_down_s)

	);
endmodule : ascon_top
