`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2025 00:33:54
// Design Name: 
// Module Name: cpu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_tb( );

reg clk;
    reg rst;
    reg [13:0] prog_addr;
    reg [18:0] prog_data;
    reg prog_we;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .rst(rst),
        .address(prog_addr),
        .data(prog_data),
        .we(prog_we)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // The main test sequence
    initial begin
        // These lines create the waveform file for Vivado
        $dumpfile("cpu_waveform.vcd");
        $dumpvars(0, uut);

        // --- Step 1: Load the program into the CPU's instruction memory ---
        prog_we = 0;
        prog_addr = 0; prog_data = 19'h40864; prog_we = 1; #1; prog_we = 0; // LD r1, 100
        prog_addr = 1; prog_data = 19'h42865; prog_we = 1; #1; prog_we = 0; // LD r2, 101
        prog_addr = 2; prog_data = 19'h06480; prog_we = 1; #1; prog_we = 0; // ADD r3, r1, r2
        prog_addr = 3; prog_data = 19'h4B066; prog_we = 1; #1; prog_we = 0; // ST 102, r3
        prog_addr = 4; prog_data = 19'h60004; prog_we = 1; #1; prog_we = 0; // JMP 4

        // --- Step 2: Place initial data into the data memory ---
        // We use a hierarchical reference here for simplicity.
        uut.data1.mem[100] = 19'd5;
        uut.data1.mem[101] = 19'd7;

        // --- Step 3: Reset the CPU to start it ---
        rst = 1;
        #15;
        rst = 0;

        // --- Step 4: Let the simulation run for a bit ---
        #100;

        // --- Step 5: Check the final result ---
        if (uut.data1.mem[102] == 12) begin
            $display("SUCCESS: Correct value (12) was stored in memory.");
        end else begin
            $display("FAILURE: Incorrect value (%d) in memory. Expected 12.", uut.data1.mem[102]);
        end

        $finish;
    end

endmodule
