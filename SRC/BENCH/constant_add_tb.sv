`timescale 1ns / 1ps
module constant_add_tb import ascon_pack::*;(
        //vide
    	);
	type_state constant_add_i_s,constant_add_o_s;
	logic [3:0] round_s;

	constant_add DUT (
		.constant_add_i(constant_add_i_s),
		.constant_add_o(constant_add_o_s),
		.round_i(round_s)
	);
	initial begin
		constant_add_i_s[0] = 64'h0000000000000000;
		constant_add_i_s[1] = 64'h0000000000000000;
		constant_add_i_s[2] = 64'h0000000000000000;
		constant_add_i_s[3] = 64'h0000000000000000;
		constant_add_i_s[4] = 64'h0000000000000000;
		round_s = 4'h0;
		#5
		round_s = 4'h1;
		#5
		round_s = 4'h2;
		#5
		round_s = 4'h3;
		#5
		round_s = 4'h4;
		#5

		round_s = 4'h5;
		#5
		round_s = 4'h6;
		#5
		round_s = 4'h7;
		#5
		round_s = 4'h8;
		#5
		round_s = 4'h9;
		#5
		round_s = 4'ha;
		#5
		round_s = 4'hb;


	end

endmodule : constant_add_tb
