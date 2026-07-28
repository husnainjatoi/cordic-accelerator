`timescale 1ns / 1ps

module atan_rom(
    input logic [3:0] iter_count,
    output logic signed [15:0] atan_val
    );
    
    always_comb begin
        case(iter_count)
            4'd0:  atan_val = 16'h3243; 
            4'd1:  atan_val = 16'h1DAC; 
            4'd2:  atan_val = 16'h0FAD; 
            4'd3:  atan_val = 16'h07F5;
            4'd4:  atan_val = 16'h03FE; 
            4'd5:  atan_val = 16'h01FF; 
            4'd6:  atan_val = 16'h00FF; 
            4'd7:  atan_val = 16'h007F; 
            4'd8:  atan_val = 16'h003F; 
            4'd9:  atan_val = 16'h001F; 
            4'd10: atan_val = 16'h000F; 
            4'd11: atan_val = 16'h0007; 
            4'd12: atan_val = 16'h0003; 
            4'd13: atan_val = 16'h0001; 
            4'd14: atan_val = 16'h0000; 
            4'd15: atan_val = 16'h0000; 
            default: atan_val = 16'h0000; 
        endcase
    end  
endmodule