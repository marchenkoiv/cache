`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2023 20:16:24
// Design Name: 
// Module Name: muu
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


module muu(
  input clk,
  input reset,
  input rd,
  input wr,
  input md,
  input hit,
  input ram_ack,
  
  output reg chmd,
  output reg wrt,
  output reg wrd,
  output reg wsel, 
  output reg tsel,
  output reg rdram, 
  output reg wrram,
  output reg ack
    );
 
 localparam IDLE = 3'b000;
 localparam HIT_WR = 3'b001;
 localparam HIT_RD = 3'b010;
 localparam RAM_WR_RD = 3'b011;
 localparam RAM_WR_WR = 3'b111;
 localparam RAM_RD_RD = 3'b100;
 localparam RAM_RD_WR = 3'b101;
 reg [2:0] state;  
 
 
  always@(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
    end else begin
        if (state == IDLE && hit == 'b1 && wr == 'b1)
            state <= HIT_WR;
        if (state == HIT_WR)
            state <= IDLE;
        if (state == IDLE && hit == 'b1 && rd == 'b1)
            state <= HIT_RD;
        if (state == HIT_RD)
            state <= IDLE;
        if (state == IDLE && hit == 'b0 && md == 'b0 && (wr == 'b1))
            state <= RAM_RD_WR;
        if (state == IDLE && hit == 'b0 && md == 'b0 && (rd == 'b1))
            state <= RAM_RD_RD;
        if (state == IDLE && hit == 'b0 && md == 'b1 && (wr == 'b1))
            state <= RAM_WR_WR;
        if (state == IDLE && hit == 'b0 && md == 'b1 && (rd == 'b1))
            state <= RAM_WR_RD;
        if (state == RAM_WR_WR && ram_ack == 'b1)
            state <= RAM_RD_WR;
        if (state == RAM_WR_RD && ram_ack == 'b1)
            state <= RAM_RD_RD;
        if ((state == RAM_RD_RD || state == RAM_RD_WR) && ram_ack == 'b1)
            state <= IDLE;
    end
   end  
    
    always@(*) begin
        case(state)
            IDLE: {chmd, wrt, wrd, wsel, tsel, rdram, wrram, ack} <=
                  {8'b0___0_____0_____0____0______0_______0____1};
            HIT_WR: {chmd, wrt, wrd, wsel, tsel, rdram, wrram, ack} <=
                    {8'b1___0_____1_____0____0______0_______0____0};
            HIT_RD: {chmd, wrt, wrd, wsel, tsel, rdram, wrram, ack} <=
                    {8'b0___0_____0_____0____0______0_______0____0};
            RAM_WR_WR: {chmd, wrt, wrd, wsel, tsel, rdram, wrram, ack} <=
                    {8'b0___0_____0_____0____0______0_______1____0};
            RAM_WR_RD: {chmd, wrt, wrd, wsel, tsel, rdram, wrram, ack} <=
                    {8'b0___0_____0_____0____0______0_______1____0};
            RAM_RD_RD: {chmd, wrt, wrd, wsel, tsel, rdram, wrram, ack} <=
                    {8'b0___1_____1_____1____1______1_______0____0};
            RAM_RD_WR: {chmd, wrt, wrd, wsel, tsel, rdram, wrram, ack} <=
                    {8'b1___1_____1_____1____1______1_______0____0};
            //TODO
        endcase
    end
  
endmodule
