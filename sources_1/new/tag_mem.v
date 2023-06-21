`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2023 13:55:12
// Design Name: 
// Module Name: tag_mem
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


module tag_mem#(
  parameter ATEG_WIDTH = 7,
  parameter AINDEX_WIDTH = 6,
  parameter CHANNEL_WIDTH = 3
)(

  input clk,
  input reset_n,
  input [ATEG_WIDTH + AINDEX_WIDTH - 1:0] addr,
  input wr,
  input md,
  output [ATEG_WIDTH + 1:0] tegOut,
  output [CHANNEL_WIDTH - 1:0] chan,
  output hit
);

  localparam CHAN_CNT	= 2**CHANNEL_WIDTH;
  // ??????? ??? ??????????? ???????
  
  reg [CHANNEL_WIDTH - 1:0] hitCh;
  wire hitAll;

  wire [CHANNEL_WIDTH - 1:0] fifo;
    
  wire [CHAN_CNT - 1:0] chHit;
  wire [ATEG_WIDTH + 1:0] chTegOut [CHAN_CNT - 1:0];
  
  integer j;
  
  // generate ???? ??? ??????????? ???? ??????? ? ????????, ??????????? ? ???. 
  genvar i;
  generate
    for (i = 0; i < CHAN_CNT; i = i + 1) begin
  
      tag_channel tegMemCh_inst (
        .clk(clk),    
        .reset(reset_n),
        .addr(addr),
        .wr(wr),
        .md(md),
        .index(i),
        .fifo(fifo),
        .hitAll(hitAll),
        .tegOut(chTegOut[i]),
        .hit(chHit[i])
      );
      
    end
  endgenerate
  
  counter count (
    .reset(reset_n),
    .clk(clk),
    .wr(wr),
    .Addr(addr),
    .hit(hitAll),
    .Q(fifo)
  );
 
  // HIT_KS
  always @(*) begin
    hitCh <= {CHANNEL_WIDTH{1'b0}};
    for (j = 0; j < CHAN_CNT; j = j + 1) begin
      if (chHit[j] == 1'b1) begin
        hitCh <= j;
      end
    end
  end
  
  
  assign hitAll = chHit != {CHAN_CNT{1'b0}};
  
  // MUX1
  assign tegOut = chTegOut[chan];
  
  // MUX2
  assign chan = hitAll ? hitCh : fifo;
  
  assign hit = hitAll;
  
endmodule
