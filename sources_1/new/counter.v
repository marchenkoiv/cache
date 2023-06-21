`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2023 12:32:08
// Design Name: 
// Module Name: counter
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


module counter#(
    parameter WIDTH = 3,
    parameter AWIDTH = 6
    )
    (
    input               reset,
    input               clk,
    input               wr,
    input               [AWIDTH-1:0] Addr,
    input               hit,
    output  wire        [WIDTH-1:0] Q
    );
    localparam MAX_VAL = 7;
    
    reg [WIDTH-1:0] counter [0:2**AWIDTH-1];
    
    integer i;
    
    wire [WIDTH:0] cnt_next = counter[Addr] == MAX_VAL ? 0 : counter[Addr] + 1;
    
always @(posedge clk) begin
        
        if (reset == 'b1) begin
            for(i = 0; i < 2**AWIDTH; i = i + 1)
                counter[i] <= 'b0;
            end
        else if (wr == 'b1 && hit == 'b0)
            counter[Addr] <= cnt_next;
    end
    assign Q = counter[Addr];
    
endmodule
