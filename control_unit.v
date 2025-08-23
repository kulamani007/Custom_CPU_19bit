`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 22:54:49
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input [4:0]opcode,
    input zero,
    output reg mem_to_r, mem_write, mem_read, branch_c, alu_src, r_write,
    output reg [2:0]pc_sel,
    output reg [4:0]alu_op,
    output reg [1:0]sp_sel,
    output reg do_fft, do_encrypt, do_decrypt
    );
    
    parameter ADD = 5'd0, SUB = 5'd1, MUL = 5'd2, DIV = 5'd3, INC = 5'd4, DEC = 5'd5, AND = 5'd6, OR = 5'd7, XOR = 5'd8, LSL = 5'd9, LSR = 5'd10, LD = 5'd11, ST = 5'd12, JMP = 5'd13, BEQ = 5'd14, BNE = 5'd15, CALL = 5'd16, RET = 5'd17, FFT =5'd18, ENCRYPT = 5'd19, DECRYPT = 5'd20;
    
    always@(*)
    begin
    case(opcode)
    ADD:begin
    r_write = 1;
    alu_op =ADD;
    end
    SUB:begin
    r_write = 1;
    alu_op = SUB;
    end
    MUL:begin
    r_write = 1;
    alu_op = MUL;
    end
    DIV:begin
    r_write = 1;
    alu_op = DIV;
    end
    INC:begin
    r_write = 1;
    alu_op = INC;
    end
    DEC:begin
    r_write = 1;
    alu_op = DEC;
    end
    AND:begin
    r_write = 1;
    alu_op = AND;
    end
    OR:begin
    r_write = 1;
    alu_op = OR;
    end
    XOR:begin
    r_write = 1;
    alu_op = XOR;
    end
    LSL:begin
    r_write = 1;
    alu_op = LSL;
    end
    LSR:begin
    r_write = 1;
    alu_op = LSR;
    end
    LD:begin
    r_write = 1;
    mem_read = 1;
    mem_to_r = 1;
    alu_src = 1;
    alu_op =ADD;
    end
    ST:begin
    mem_write = 1;
    alu_src = 1;
    alu_op =ADD;
    end
    JMP:begin
    pc_sel = 3'd2;
    end
    BEQ:begin
    alu_op = SUB;
    pc_sel = 3'd1;
    branch_c = zero;
    end
    BNE:begin
    alu_op = SUB;
    pc_sel = 3'd1;
    branch_c = zero;
    end
    CALL:begin
    mem_write = 1;
    sp_sel = 2'd1;
    pc_sel = 3'd2;
    end
    RET:begin
    mem_read = 1;
    pc_sel = 3'd3;
    sp_sel = 2'd2;
    end
    FFT:begin
    do_fft = 1;
    end
    ENCRYPT:begin
    do_encrypt = 1;
    end
    DECRYPT:begin
    do_decrypt = 1;
    end
    endcase
    end
endmodule
