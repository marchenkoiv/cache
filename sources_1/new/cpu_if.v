`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2023 20:28:53
// Design Name: 
// Module Name: cpu_if
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


module cpu_if(
input sys_clk,
input c_clk,
input sys_rst,
input [15:0] sys_addr,
input sys_wr,
input sys_rd,
input [31:0] sys_wdata,
input [3:0] sys_bval,

input [31:0] c_rdata,
input c_ack,

output reg [15:0] c_addr,
output reg c_wr,
output reg c_rd,
output reg [31:0] c_wdata,
output reg [3:0] c_bval,

output reg [31:0] sys_rdata,
output reg sys_ack
    );
    
    localparam IDLE = 'b0;
    localparam EXEC1 = 'b01;
    localparam EXEC2 = 'b10;
    localparam EXEC3 = 'b11;
    
    reg [1:0] state = 0;
    
    
    always @(*) begin
    if (sys_rst == 'b1) begin
        state <= IDLE;
    end
    end
    
    always @(posedge sys_clk) begin
    if (state == IDLE && (sys_wr == 'b1 || sys_rd == 'b1)) begin
        state <= EXEC1;
        sys_ack <= 0;
        c_addr <= sys_addr;
        c_wr <= sys_wr;
        c_rd <= sys_rd;
        c_wdata <= sys_wdata;
        c_bval <= sys_bval;
    end
//    if (state == IDLE && (c_ack == 'b1) && (sys_wr == 'b0 || sys_rd == 'b0)) begin
//        state <= IDLE;
//        sys_ack <= c_ack;
//        sys_rdata <= c_rdata;
//    end
    if (state == EXEC3 && (c_ack == 'b1)) begin
        state <= IDLE;
        sys_ack <= c_ack;
        sys_rdata <= c_rdata;
    end
    end
    
    always @(posedge c_clk) begin
    if (state == EXEC1 && c_ack == 'b0) begin
        state <= EXEC2;
        sys_ack <= c_ack;
        c_wr <= 'b0;
        c_rd <= 'b0;
    end
    if (state == EXEC2 ) begin
        state <= EXEC3;
        c_wr <= 'b0;
        c_rd <= 'b0;
//        c_wr <= 'b0;
//        c_rd <= 'b0;
//        sys_ack <= c_ack;
//        sys_rdata <= c_rdata;
    end
    end
    
endmodule
