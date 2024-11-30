`timescale 1ns / 1ps
module permutation import ascon_pack::*;
	(
		input logic [3:0] round_i,
		input logic clock_i,
		input logic resetb_i,
		input logic input_select_i,
		input logic ena_reg_state_i,
		input type_state permutation_i,
		output type_state permutation_o
	);
	
	type_state mux_to_const_add_s;	
	type_state const_add_to_sub_s; //signal intermédiaire entre Pc et Ps
	type_state sub_to_diff_s; // signal entre Ps et Pl
	type_state diff_to_reg_s; //signal entre pl et registre
	type_state register_output_s;
	// instanciation MUX : si input_select_i = 1 mux_to_const_add_s = permutation_i
	assign mux_to_const_add_s = (input_select_i) ? register_output_s : permutation_i;
	
	//instanciation ADD
	constant_add constant_add_inst
	(
		.constant_add_i(mux_to_const_add_s),
		.round_i(round_i),
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
		.diffusion_o(diff_to_reg_s)
	);
	//instanciation REGISTRE 
	register_state register_state_inst
	(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.ena_reg_state_i(ena_reg_state_i),
		.register_i(diff_to_reg_s),
		.register_o(register_output_s)
	);
	
	assign permutation_o = register_output_s;

endmodule : permutation
