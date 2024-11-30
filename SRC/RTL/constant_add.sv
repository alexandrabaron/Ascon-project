`timescale 1ns / 1ps
module constant_add
    import ascon_pack::*;
    (
        input type_state constant_add_i,
        input logic [3:0] round_i, //compteur de ronde
        output type_state constant_add_o
    );
    // x0,x1 ne sont pas affectés, (on a décrit un fil en matériel)
    assign constant_add_o[0] = constant_add_i[0];
    assign constant_add_o[1] = constant_add_i[1];

    //on veut ajouter 8 bits
    assign constant_add_o[2][63:8] = constant_add_i[2][63:8];
    assign constant_add_o[2][7:0] = constant_add_i[2][7:0] ^ round_constant[round_i];

    //x3,x4 ne sont pas affectés, (on a décrit un fil en matériel)
    assign constant_add_o[3] = constant_add_i[3];
    assign constant_add_o[4] = constant_add_i[4];

endmodule : constant_add

