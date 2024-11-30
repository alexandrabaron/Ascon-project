`timescale 1 ns / 10 ps

// Moore FSM
// Import of ascon_pack is not required

module fsm
    (
     //ENTREES
     input logic		clock_i,
     input logic		resetb_i,
     input logic		start_i,
     input logic		data_valid_i,
     input logic [3:0]	        round_i,

     output logic		ena_reg_state_o,
     output logic		cipher_valid_o,
     output logic               tag_o,
     //SORTIE
     output logic		end_o,
     //MUX
     output logic		init_state_o,

     //DOUBLE COUNTER
     output logic		ena_cpt_o,
     output logic		init_a_o,
     output logic		init_b_o,
	 // Everything related to block counter is missing
	
//XOR
     output logic [1:0]	conf_xor_up_o, // prend A1 à 0, P1 à 1, P2 à 2, P3 à 3
     output logic [1:0]	conf_xor_down_o, //prends soit K si =0, 1 si =1 et 0 si =2
     output logic		ena_xor_up_o,
     output logic		ena_xor_down_o
     );

	// States declaration, to be extended
    typedef enum		{idle, set_cpt, initial_state, init, end_init, wait_a1, xor_a1, p_a1, end_init2, wait_p1, xor_p1, p_p1, p_p1_end, wait_p2, xor_p2, p_p2, xor_fin, wait_p3, xor_p3, p_p3, xor_k, fin} fsm_state;

    fsm_state current_state_s, next_state_s;



    // Sequential process to store current state
//mémorise la valeur de l'état courant 
    always_ff @(posedge clock_i, negedge resetb_i) begin
        if (resetb_i == 1'b0) begin
            current_state_s <= idle;
        end
        else begin
            current_state_s <= next_state_s;
        end
    end


    // Combinatorial process for next state
//pour faire uniquement les transitions entre les états
    always_comb begin : OUTPUT_STATE
		
        case(current_state_s)
            idle: begin
                if (start_i == 1'b1)
                    next_state_s = set_cpt;
                else
                    next_state_s = idle;
            end
            set_cpt: begin
                next_state_s = initial_state;
            end
            initial_state: begin
                next_state_s = init;
            end
            init: begin
                if (round_i == 4'hA)
                    next_state_s = end_init;
                else
                    next_state_s = init;
            end
            end_init: begin
                if (data_valid_i == 1'b1)
                    next_state_s = xor_a1;
                else begin
                    next_state_s   = wait_a1;
                end
            end
            xor_a1: begin
                next_state_s = p_a1;
            end
            wait_a1: begin
                if (data_valid_i == 1'b1)
                    next_state_s = xor_a1;
                else begin
                    next_state_s   = wait_a1;
                end 
            end
 	    p_a1: begin
                if (round_i == 4'hA)
                    next_state_s = end_init2;
                else
                    next_state_s = p_a1;
            end
            end_init2: begin
                if (data_valid_i == 1'b1)
                    next_state_s = xor_p1;
                else
                    next_state_s = wait_p1;
            end
            xor_p1: begin
                next_state_s = p_p1;
            end
            wait_p1: begin
                if (data_valid_i == 1'b1)
                    next_state_s = xor_p1;
                else
                    next_state_s = wait_p1;
            end
            p_p1: begin
                if (round_i == 4'hB)
                    next_state_s = p_p1_end;
                else begin
                    next_state_s = p_p1;
                end
            end
	    p_p1_end: begin
		if (data_valid_i == 1'b1)
		    next_state_s = xor_p2;
		else 
		    next_state_s = wait_p2;
	    end
            wait_p2: begin
                if (data_valid_i == 1'b1)
                    next_state_s = xor_p2;
                else 
                    next_state_s   = wait_p2;
                 
            end
            xor_p2: begin
                next_state_s = p_p2;
            end
            p_p2: begin
                if (round_i == 4'hA)
                    next_state_s = xor_fin;
                else
                    next_state_s = p_p2;
            end
            xor_fin: begin
                if (data_valid_i == 1'b1)
                    next_state_s = xor_p3;
                else
                    next_state_s = wait_p3;
            end
            wait_p3: begin
                if (data_valid_i == 1'b1)
                    next_state_s = xor_p3;
                else begin
                    next_state_s   = wait_p3;
                end 
            end
            xor_p3: begin
                next_state_s = p_p3;
            end
 	    p_p3: begin
                if (round_i == 4'hA)
                    next_state_s = xor_k;
                else
                    next_state_s = p_p3;
            end
            xor_k: begin
		next_state_s = fin;
	    end
	    fin: begin
		if(start_i == 1)
			next_state_s = fin;
		else
			next_state_s = idle;
            end 
	    default : 
		    next_state_s = idle;
        endcase // case (current_state_s)

    end // block: OUTPUT_STATE

// -----------------------COMB-----------------------

    // Combinatorial process for outputconf_xor_down_o = 2'b0; values 
//pour les sorties
    always_comb begin : OUTPUT_LOGIC

        // Set default values for the outputs
        cipher_valid_o  = 1'b0;
        end_o           = 1'b0;
        init_state_o    = 1'b1;

        ena_cpt_o       = 1'b0;
        init_a_o        = 1'b0;
        init_b_o        = 1'b0;

        ena_xor_up_o    = 1'b0;
        ena_xor_down_o  = 1'b0;
        conf_xor_up_o = 2'b00;
        conf_xor_down_o = 2'b00;

        ena_reg_state_o = 1'b1; // register is enabled by default
		
        case(current_state_s)
            idle: begin
                ena_reg_state_o = 0;
 		init_state_o    = 1'b0;
            end
            set_cpt: begin
                init_a_o       = 1'b1; // Init counter to 0
                ena_cpt_o      = 1'b1;
      		init_state_o    = 1'b0;
            end
            initial_state: begin
                ena_cpt_o      = 1'b1;
		init_state_o    = 1'b0;
            end
            init: begin //p12
                ena_cpt_o      = 1'b1;
            end
            end_init: begin //XOR down
                ena_xor_down_o  = 1'b1; // conf du xor par défaut
                init_b_o        = 1'b1; // Init counter to 6
                ena_cpt_o       = 1'b1;
            end
            xor_a1: begin
                ena_cpt_o     = 1'b1;
                ena_xor_up_o  = 1'b1; // conf du xor par défaut
            end
            wait_a1: begin
                ena_reg_state_o = 1'b0; // disable register
            end 
	    p_a1: begin
                ena_cpt_o     = 1'b1; // +1 au compteur
	    end
	    end_init2: begin // XOR down avec 1
                ena_xor_down_o  = 1'b1;
		conf_xor_down_o = 2'b1;
                init_b_o        = 1'b1; // Init counter to 6
                ena_cpt_o       = 1'b1;
	    end
	    wait_p1: begin
		ena_reg_state_o = 1'b0; // disable register
	    end
	    xor_p1: begin // XOR up avec P1
                ena_xor_up_o  = 1'b1;
		conf_xor_up_o = 2'b1;

		ena_cpt_o     = 1'b1; // +1 au compteur

	        cipher_valid_o  = 1'b1;
	    end
	    p_p1: begin
                ena_cpt_o     = 1'b1; // +1 au compteur
	    end
	    p_p1_end: begin //état "d'attente" uniquement pour initialiser le compteur init_b
                init_b_o        = 1'b1; // Init counter to 6
                ena_cpt_o       = 1'b1;	
	    end
	    wait_p2: begin
  		ena_reg_state_o = 1'b0; // disable register
	    end
	    xor_p2: begin // XOR up avec P2
                ena_xor_up_o  = 1'b1;
		conf_xor_up_o = 2'b10;

                ena_cpt_o       = 1'b1;	

	        cipher_valid_o  = 1'b1;

	    end
	    p_p2: begin
                ena_cpt_o     = 1'b1; // +1 au compteur
	    end
	    xor_fin: begin // XOR down avec {K, 000...0}
                ena_xor_down_o  = 1'b1;
		conf_xor_down_o = 2'b10;
                init_a_o        = 1'b1; // Init counter to 0
                ena_cpt_o       = 1'b1;

	    end
	    wait_p3: begin
		ena_reg_state_o = 1'b0; // disable register
	    end
	    xor_p3: begin // XOR up avec P3
                ena_xor_up_o  = 1'b1;
		conf_xor_up_o = 2'b11;

                init_a_o        = 1'b1; // Init counter to 0
                ena_cpt_o       = 1'b1;

	        cipher_valid_o  = 1'b1;

	    end
	    p_p3: begin
                ena_cpt_o     = 1'b1; // +1 au compteur
	    end
	    xor_k: begin // XOR down avec K (conf par défaut)
                ena_xor_down_o  = 1'b1;
                ena_cpt_o       = 1'b1;

	    end
	    fin: begin
		init_state_o = 0;
		ena_reg_state_o = 0;
		end_o = 1;
		tag_o = 1;
	    end

        endcase // case (current_state_s)
    end // block: OUTPUT_LOGIC
    
endmodule : fsm

