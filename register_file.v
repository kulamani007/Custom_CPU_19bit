`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 22:35:34
// Design Name: 
// Module Name: register_file
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


module register_file(
    input clk, rst, write_enable,
    input [2:0]read_r1,
    input [2:0]read_r2,
    input [2:0]write_r,
    input [18:0]write_data,
    output [18:0]read_data1,
    output [18:0]read_data2
    );
    
    reg [18:0]registers[0:7]; //register storage
    
    assign read_data1 = registers[read_r1];
    assign read_data2 = registers[read_r2];
    
    always@(posedge clk or posedge rst)
    begin
    if(rst)
    begin
    registers[write_r] <= 0;
    end
    else if(write_enable && (write_r != 0))
    begin
    registers[write_r] <= write_data;
    end
    end
endmodule
