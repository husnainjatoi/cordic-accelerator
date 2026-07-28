`timescale 1ns / 1ps

module tb_cordic_top();

    logic clk = 0, rst, start;
    logic signed [15:0] angle_in;
    logic signed [15:0] cos_out;
    logic signed [15:0] sin_out;
    logic done;

    cordic_top dut (.clk(clk), .rst(rst), .start(start), .angle_in(angle_in),
                    .cos_out(cos_out), .sin_out(sin_out), .done(done));

    always #5 clk = ~clk;

    task check(input logic signed [15:0] actual, input logic signed [15:0] expected, input string name);
        logic signed [15:0] diff;
        diff = actual - expected;
        
        if (diff > 15 || diff < -15)
            $display("[FAIL] %s: Actual = %0d, Expected = %0d", name, actual, expected);
        else
            $display("[PASS] %s: Value = %0d", name, actual);
    endtask

    task test_angle(
        input logic signed [15:0] test_angle, 
        input logic signed [15:0] exp_cos, 
        input logic signed [15:0] exp_sin, 
        input string name
    );
        $display("--------------------------------------------------");
        $display("Testing %s", name);
        
        angle_in = test_angle;
        start = 1;
        
        @(posedge clk);
        start = 0;
        
        wait(done == 1'b1);
        @(posedge clk);
        
        check(cos_out, exp_cos, {"Cosine of ", name});
        check(sin_out, exp_sin, {"Sine of ", name});
    endtask

    initial begin
        rst = 1;
        start = 0;
        angle_in = 0;
        #25;
        rst = 0;
        #10;
        
        test_angle(16'h0000, 16'h4000, 16'h0000, "0 Degrees");
        test_angle(16'h3244, 16'h2D41, 16'h2D41, "45 Degrees");
        test_angle(16'h6488, 16'h0000, 16'h4000, "90 Degrees");
        
        $display("--------------------------------------------------");
        $display("Verification Complete.");
        $finish;
    end

endmodule