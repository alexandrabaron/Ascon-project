
`timescale  1ns/1ps

module xor_down import ascon_pack::*;
	(
	 input logic [255:0] data_xor_down_i,
	 input logic		 ena_xor_down_i,
	 input type_state 	 state_i,
	 output type_state 	 state_o,
	 output logic [127:0] tag_o
	 );

	type_state 	 state_s;

    // Downstream XOR
	assign state_s = state_i;
	assign state_o[0] = state_i[0];
	assign state_o[1] = (ena_xor_down_i) ? state_i[1] ^ data_xor_down_i[255:192] : state_i[1];
	assign state_o[2] = (ena_xor_down_i) ? state_i[2] ^ data_xor_down_i[191:128] : state_i[2];
	assign state_o[3] = (ena_xor_down_i) ? state_i[3] ^ data_xor_down_i[127: 64] : state_i[3];
	assign state_o[4] = (ena_xor_down_i) ? state_i[4] ^ data_xor_down_i[ 63:  0] : state_i[4];

	assign tag_o = state_s[0:1];

endmodule : xor_down
