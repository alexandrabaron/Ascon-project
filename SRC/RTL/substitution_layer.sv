`timescale 1ns / 1ps
module substitution_layer import ascon_pack::*;
    (
        input type_state sub_layer_i,
        output type_state sub_layer_o
    );
    genvar i;
    generate
        for (i=0; i<64; i++) begin : generate_sbox
            //instantiation
            sbox instance_box (
                .sbox_i({sub_layer_i[0][i],sub_layer_i[1][i],sub_layer_i[2][i], sub_layer_i[3][i],sub_layer_i[4][i]}),
                .sbox_o({sub_layer_o[0][i],sub_layer_o[1][i],sub_layer_o[2][i], sub_layer_o[3][i],sub_layer_o[4][i]})
            );
		end : generate_sbox
	endgenerate
endmodule : substitution_layer

