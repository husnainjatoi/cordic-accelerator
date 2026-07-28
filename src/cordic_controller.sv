`timescale 1ns / 1ps

module cordic_controller(
    input logic clk, rst, start,
    output logic load_init, en_calc,
    output logic [3:0] iter_count,
    output logic done
    );
    
    typedef enum logic [1:0] {IDLE, CALC, DONE_ST} state_t;
    state_t current_state, next_state;
    logic [3:0] next_iter_count;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            current_state <= IDLE;
            iter_count <= 4'd0;
        end
        else begin
            current_state <= next_state;
            iter_count <= next_iter_count;
        end
    end
    
    always_comb begin
        next_state = current_state;
        next_iter_count = iter_count;
        load_init = 1'b0;
        done = 1'b0;
        en_calc = 1'b0;
        
        case(current_state)
        
            IDLE: begin
                next_iter_count = 4'd0;
                case(start)
                    1'b1: begin
                        load_init = 1'b1;
                        en_calc = 1;
                        next_state = CALC;
                    end
                    1'b0: next_state = IDLE;
                endcase
            end
            
            CALC: begin
                load_init = 1'b0;
                en_calc = 1'b1;
                case(iter_count == 15)
                    1'b1: next_state = DONE_ST;
                    1'b0: next_iter_count = iter_count + 4'd1;
                endcase
            end
            
            DONE_ST: begin
                en_calc = 1'b0;
                done = 1'b1;
                next_state = IDLE;
            end
            
            default: begin
            next_state = IDLE;
            next_iter_count = 4'd0;
            end
        endcase
    end
endmodule