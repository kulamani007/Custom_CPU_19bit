`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 22:43:56
// Design Name: 
// Module Name: memory
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


module memory(
    input clk,
    input [13:0]address,
    input [18:0]write_data,
    input mem_read, mem_write,
    output reg [18:0]read_data,
    
    //for cpu program showcase
    input [13:0]prog_addr,
    input [18:0]prog_data,
    input prog_we
    );
    
    reg [18:0]mem[0:16000];
    
    //write into memory
    always@(posedge clk)
    begin
    if(mem_write)
    begin
    mem[address] <= write_data;
    end
    end
    //read from memory
    always@(*)
    begin
    if(mem_read)
    begin
    read_data <= mem[address];
    end
    end
    
    always@(*)
    begin
    if(prog_we)
    begin
    mem[prog_addr] <= prog_data;
    end
    end
endmodule
