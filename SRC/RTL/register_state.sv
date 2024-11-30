`timescale  1ns/1ps

module register_state import ascon_pack::*;
	(
	 input logic	clock_i,
	 input logic	resetb_i,
	 input logic    ena_reg_state_i,
	 input		type_state register_i,
	 output		type_state register_o
	 );

	 type_state state_s;
	// Register
	always @ (posedge clock_i, negedge resetb_i) begin //information de sensibilité (posedge)
		if (resetb_i == 1'b0) begin 
			state_s <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0}; //actif a l'état bas 
		end
		
		else if (ena_reg_state_i == 1'b1) begin
			state_s <= register_i; //on recopie ce qu'il y a en entree en sortie
		end
		else begin
			//register_o <= register_o; pas le droit d'écrire ça : on peut pas lire et écrire en même temps. Par contre, on peut le faire sur une variable intermédiaire.
			//on recopie ce qu'il y a en entree en sortie
			state_s <= state_s;// state_s reçoit state_s = je mémorise
		end
	end
	assign register_o = state_s;

endmodule : register_state

//cela permet d'actualiser notre permutation => permet de figer la variable.
