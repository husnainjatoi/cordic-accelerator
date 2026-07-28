`timescale 1ns / 1ps

module cordic_datapath(
    input  logic clk, rst, load_init, en_calc,
    input  logic [3:0] iter_count,
    input  logic signed [15:0] angle_in,
    output logic signed [15:0] cos_out,
    output logic signed [15:0] sin_out
    );
    
    logic signed [15:0] x_reg, y_reg, z_reg;
    logic signed [15:0] x_new, y_new, z_new;
    logic signed [15:0] shifted_x, shifted_y;
    logic signed [15:0] atan_val;
    logic d_sign;
    
    localparam signed [15:0] INIT_X = 16'h26DD;
    localparam signed [15:0] INIT_Y = 16'h0000;
    
    assign d_sign = z_reg[15];
    assign shifted_x = x_reg >>> iter_count;
    assign shifted_y = y_reg >>> iter_count;
    
    atan_rom atan_rom_inst (.iter_count(iter_count), .atan_val(atan_val));
    
    always_comb begin
        case(d_sign)
            1'b0: begin
                x_new = x_reg - shifted_y;
                y_new = y_reg + shifted_x;
                z_new = z_reg - atan_val;
            end
            1'b1: begin
                x_new = x_reg + shifted_y;
                y_new = y_reg - shifted_x;
                z_new = z_reg + atan_val;
            end
            default: begin
                x_new = x_reg;
                y_new = y_reg;
                z_new = z_reg;
            end
        endcase
    end
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            x_reg <= 16'd0;
            y_reg <= 16'd0;
            z_reg <= 16'd0;
        end
        else if(load_init) begin
            x_reg <= INIT_X;
            y_reg <= INIT_Y;
            z_reg <= angle_in;
        end
        else if(en_calc) begin
            x_reg <= x_new;
            y_reg <= y_new;
            z_reg <= z_new;
        end
    end
    
    assign cos_out = x_reg;
    assign sin_out = y_reg;
    
endmodule