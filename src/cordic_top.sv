`timescale 1ns / 1ps

module cordic_top (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic signed [15:0] angle_in,
    output logic signed [15:0] cos_out,
    output logic signed [15:0] sin_out,
    output logic done
);

    logic load_init;
    logic en_calc;
    logic [3:0] iter_count;

    cordic_controller u_controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .load_init(load_init),
        .en_calc(en_calc),
        .iter_count(iter_count),
        .done(done)
    );

    cordic_datapath u_datapath (
        .clk(clk),
        .rst(rst),
        .load_init(load_init),
        .en_calc(en_calc),
        .iter_count(iter_count),
        .angle_in(angle_in),
        .cos_out(cos_out),
        .sin_out(sin_out)
    );

endmodule