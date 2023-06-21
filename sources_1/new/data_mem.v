`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2023 21:32:24
// Design Name: 
// Module Name: data_mem
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


module data_mem#(
  parameter AINDEX_WIDTH = 6,
  parameter CHANNEL_WIDTH = 3
)(
    input               clk,
    input               reset,
    input               [2**AINDEX_WIDTH-1:0] WData,
    input               [CHANNEL_WIDTH-1:0] chan,
    input               [AINDEX_WIDTH-1:0] Addr,
    input               wr,
    output  wire        [2**AINDEX_WIDTH-1:0] Q
    );
    
    localparam width = 2**CHANNEL_WIDTH;   
    localparam hight = 2**AINDEX_WIDTH; 
    
    integer i;
    integer j;
    reg [63:0] mem [0:hight-1][0:width-1];
    
    always @(posedge clk) begin
        
        if (reset == 'b1) begin
            for(i = 0; i < hight; i = i + 1)
                for(j = 0; j < width; j = j + 1)
                    mem[i][j] <= 'b0;
            end
        else if (wr == 'b1)
            mem[Addr][chan] <=  WData;
    end
    assign Q = mem[Addr][chan];
    
    
endmodule
