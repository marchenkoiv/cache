`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2023 09:32:43
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
    input ack,
    input clk,
    input reset,
    
    output reg [15:0] addr,
    output reg wr,
    output reg rd,
    output reg [31:0]wdata,
    output reg [3:0]bval = 'b0
    );
    
    reg rw = 'b1;
    reg sur_ack = 'b0;
    
    integer i = 0;
    
    always @(posedge clk) begin

        if((ack == 'b1 || sur_ack == 'b1) && rw == 'b0 && reset == 'b0)begin
            if($urandom%2 == 1)begin
                wr <= 'b1;
                rd <= 'b0;
                bval[$urandom%4] <= 'b1;
            end
            else begin
                wr <= 'b0;
                rd <= 'b1;
            end
            addr <= $urandom%(16'hffff); // cache size
            //addr <= $urandom%(16'h1fff); // 2 cache size
            wdata <= $urandom%(32'hffff_ffff);
            rw <= 'b1;
            sur_ack <= 'b0;
        end
        if(rw == 'b1 && i < 4)
        begin
                i = i+1;
                bval <= 'b0;
                wr <= 'b0;
                rd <= 'b0;
        end
        if(reset == 'b1)
            sur_ack <= 'b1;
        if(rw == 'b1 && i == 4)
        begin
                i = 0;
                wr <= 'b0;
                rd <= 'b0;
                rw <= 'b0;
        end
     end
    
endmodule
