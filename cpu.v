`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 21:50:43
// Design Name: 
// Module Name: cpu
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


module cpu(
    input clk, rst,
    input [13:0]address, // depth
    input [18:0]data, // data width 19bit
    input we // write enable
    );
    
    // internal signal ports
    wire [18:0]pc;
    wire [18:0]pc_next;
    wire [18:0]instruction;
    wire [18:0]alu_result;
    wire [18:0]write_data_r;
    wire [18:0]mem_data_read;
    wire [18:0]read_data1;
    wire [18:0]read_data2;
    wire [18:0]sp_r;
    wire [18:0]alu_op;
    wire mem_to_r, mem_write, mem_read, alu_src, r_write, zero_flag, branch_c;
    wire [2:0]pc_sel;
    wire [1:0]sp_sel;
    wire d_fft, d_encrypt, d_decrypt;
    
    reg [18:0]pc_r;
    always@(posedge clk or posedge rst)
    begin
    if(rst)
    begin
    pc_r <= 0;
    end
    else
    begin
    pc_r <= pc_next;
    end
    end
    
    assign pc = pc_r; // program counter
    
    wire [18:0]pc_p1;
    assign pc_p1 = pc_r + 1;
    wire [18:0]jump_addr;
    assign jump_addr = {5'd0,instruction[13:0]};
    wire [18:0]branch_addr;
    assign branch_addr = pc_p1 + {{11{instruction[7]}}, instruction[7:0]};
    assign pc_next = (pc_sel == 3'd1 && branch_c) ? branch_addr : (pc_sel == 3'd2) ? jump_addr : (pc_sel == 3'd3) ? mem_data_read : pc_p1;
    
    reg [18:0]internal_sp_r;
    assign sp_r = internal_sp_r;
    
    always@(posedge clk or posedge rst)
    begin
    if(rst)
    begin
    internal_sp_r <= 19'd32767;
    end
    else
    begin
    case(sp_sel)
    2'd1: internal_sp_r <= internal_sp_r - 1;
    2'd2: internal_sp_r <= internal_sp_r + 1;
    default: internal_sp_r <= internal_sp_r;
    endcase
    end
    end
    
    wire [18:0]alu_b_operand = alu_src ? {{8{instruction[10]}}, instruction[10:0]} : read_data2;
    wire [13:0]data_mem_addr = (pc_sel == 3'd3) ? sp_r[13:0] : alu_result[13:0];
    wire [18:0]data_mem_write_data = (sp_sel == 2'd1) ? pc_p1 : read_data1;
    assign write_data_r = mem_to_r ? data_mem_read_data : alu_result;
    wire [18:0]fft_result, encrypt_result, decrypt_result;
    //module instantiations
    memory inst(.clk(clk), .address(pc[13:0]), .write_data(19'h0), .mem_read(1'b1), .mem_write(1'b0), .read_data(instruction), .prog_addr(address), .prog_data(data), .prog_we(we));
    control_unit ctrl(.opcode(instruction[18:14]), .zero(zero_flag), .mem_to_r(mem_to_r), .mem_write(mem_write), .mem_read(mem_read), .branch_c(branch_c), .alu_src(alu_src), .r_write(r_write), .pc_sel(pc_sel), .alu_op(alu_op), .sp_sel(sp_sel), .do_fft(d_fft), .do_encrypt(d_encrypt), .do_decrypt(d_decrypt));
    register_file rest(.clk(clk), .rst(rst), .write_enable(r_write), .read_r1(instruction[10:8]), .read_r2(instruction[7:5]), .write_r(instruction[13:11]), .write_data(write_data_r), .read_data1(read_data1), .read_data2(read_data2));
    alu_unit alu(.A(read_data1), .B(alu_b_operand), .opcode(alu_op), .result(alu_result), .zero(zero_flag));
    memory data1(.clk(clk), .address(data_mem_addr), .write_data(data_mem_write_data), .mem_read(mem_read), .mem_write(mem_write), .read_data(data_mem_read_data), .prog_addr(14'd0), .prog_data(19'd0), .prog_we(1'b0));
    FFT_unit f(.clk(clk), .enable(d_fft), .in_addr(read_data1), .out_addr(read_data2), .result(fft_result));
    ENCRYPT_unit en(.clk(clk), .enable(d_encrypt), .data_addr(read_data1), .key_addr(read_data2), .result(encrypt_result));
    DECRYPT_unit de(.clk(clk), .enable(d_decrypt), .data_addr(read_data1), .key_addr(read_data2), .result(decrypt_result));
    
endmodule

module FFT_unit(
   input clk, enable,
   input [18:0]in_addr, out_addr,
   output reg [18:0]result
   );
   
   always@(posedge clk)
   begin
   if(enable)
   begin
   result <= in_addr + out_addr;
   end
   end
endmodule

module ENCRYPT_unit(
  input clk, enable,
  input [18:0]data_addr, key_addr,
  output reg [18:0]result
  );   
  
  always@(posedge clk)
  begin
  if(enable)
  begin
  result <= data_addr ^ key_addr;
  end
  end
endmodule

module DECRYPT_unit(
  input clk, enable,
  input [18:0]data_addr, key_addr,
  output reg [18:0]result
  );   
  
  always@(posedge clk)
  begin
  if(enable)
  begin
  result <= data_addr ^ key_addr;
  end
  end
endmodule  
