module f1_fsm (
    input   logic       rst,
    input   logic       clk,
    input   logic       trigger,
    input   logic       en,
    output  logic       cmd_seq,
    output  logic       cmd_delay,
    output  logic [7:0] data_out
);

    typedef enum {IDLE, S1, S2, S3, S4, S5, S6, S7, S8} light_state;
    light_state current_state, next_state;

    always_ff @(posedge clk, posedge trigger)
        if (rst)
            current_state <= IDLE;
        else if(trigger && current_state == IDLE)
            current_state <= next_state;
        else if (current_state != IDLE && en)
            current_state <= next_state;
    
    always_comb
        case (current_state)
            IDLE:   begin
                        next_state = S1;
                        data_out = 8'b0;
                        cmd_delay = 0;
                        cmd_seq = 1;
                    end
            S1:     begin
                        next_state = S2;
                        data_out = 8'b1;
                    end
            S2:     begin
                        next_state = S3;
                        data_out = 8'b11;
                    end
            S3:     begin
                        next_state = S4;
                        data_out = 8'b111;
                    end
            S4:     begin
                        next_state = S5;
                        data_out = 8'b1111;
                    end
            S5:     begin
                        next_state = S6;
                        data_out = 8'b11111;
                    end
            S6:     begin
                        next_state = S7;
                        data_out = 8'b111111;
                    end
            S7:     begin
                        next_state = S8;
                        data_out = 8'b1111111;
                        cmd_delay = 1;
                    end
            S8:     begin
                        next_state = IDLE;
                        data_out = 8'b11111111;
                        cmd_seq = 0;
                        cmd_delay = 0;
                    end   
            default: next_state = IDLE;
        endcase
    
    
endmodule
