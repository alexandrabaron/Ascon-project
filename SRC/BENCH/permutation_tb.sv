`timescale 1ns / 1ps

module permutation_tb import ascon_pack::*;(
);

	logic [3:0] round_i_s;
	logic clock_i_s;
	logic resetb_i_s;
	logic input_select_i_s;
	logic ena_reg_state_i_s;
	type_state permutation_i_s;
	type_state permutation_o_s;

	permutation DUT (
		.round_i(round_i_s),
		.clock_i(clock_i_s),
		.resetb_i(resetb_i_s),
		.input_select_i(input_select_i_s),
		.ena_reg_state_i(ena_reg_state_i_s),
		.permutation_i(permutation_i_s),
		.permutation_o(permutation_o_s)
		);


	initial begin
		clock_i_s = 0;
		forever #5 clock_i_s = ~ clock_i_s;
	end


	initial begin

		resetb_i_s = 0;
		input_select_i_s = 0;
		round_i_s = 0;
		ena_reg_state_i_s = 1'b1;

		permutation_i_s[0]=64'h80400c0600000000;
		permutation_i_s[1]=64'h8a55114d1cb6a9a2;
		permutation_i_s[2]=64'hbe263d4d7aecaaff;
		permutation_i_s[3]=64'h4ed0ec0b98c529b7;
		permutation_i_s[4]=64'hc8cddf37bcd0284a;

		#10
		resetb_i_s = 1;
		/*#10
		input_select_i_s = 1;
		round_i_s=1;
		#10
		round_i_s=2;*/
		
		
	end
endmodule : permutation_tb
