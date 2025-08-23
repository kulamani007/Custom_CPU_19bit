`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 22:24:28
// Design Name: 
// Module Name: alu_unit
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


module alu_unit(
    input [18:0]A,
    input [18:0]B,
    input [4:0]opcode,
    output reg [18:0]result,
    output zero
    );
    
    parameter ADD = 5'd0, SUB = 5'd1, MUL = 5'd2, DIV = 5'd3, INC = 5'd4, DEC = 5'd5, AND = 5'd6, OR = 5'd7, XOR = 5'd8, LSL = 5'd9, LSR = 5'd10;
    
    always@(*)
    begin
    case(opcode)
    ADD: result = A + B;
    SUB: result = A - B;
    MUL: result = A * B;
    DIV: result = A / B;
    INC: result = A + 1;
    DEC: result = A - 1;
    AND: result = A & B;
    OR: result = A | B;
    XOR: result = A ^ B;
    LSL: result = A << B;
    LSR: result = A >> B;
    default: result = 0;
    endcase
    end
    
    assign zero = (result == 0);
endmodule
