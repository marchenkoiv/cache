`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2023 09:13:16
// Design Name: 
// Module Name: ram
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


module ram(
    input clk,
    input avalid,
    input rnw,
    
    output reg ack,
    output reg [7:0]rdata
    );
    
    integer i = 0;
    
    reg rw = 'b0;
    

    always @(posedge clk) begin
        if(avalid == 'b1 && rnw == 'b0 && i == 0) begin
            rw <= 'b0;
            i <= 1;
        end
        if(rw == 'b0 && i > 0 && i < 9)
            i <= i+1;
        if(rw == 'b0 && i == 9)begin
            i <= 0;
            ack <= 'b1;
        end
        if(rw == 'b0 && ack == 'b1)begin
            ack <= 'b0;
        end
        if(avalid == 'b1 && rnw == 'b1 && i == 0) begin
            rw <= 'b1;
            i <= 1;
        end
        if(rw == 'b1 && i == 1)begin
            i <= 2;
        end
        if(rw == 'b1 && i >1 && i < 10)begin
            i <= i + 1;
            rdata <= $urandom%63;
            ack <= 1;
        end
       if(rw == 'b1 && i == 10)begin
            i <= 0;
            ack <= 'b0;
        end 
       if(avalid == 'b0 && i == 0)
            ack <= 'b0;
    end
endmodule
