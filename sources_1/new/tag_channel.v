`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2023 12:44:41
// Design Name: 
// Module Name: tag_channel
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


module tag_channel #(
  parameter ATEG_WIDTH = 7,
  parameter AINDEX_WIDTH = 6,
  parameter ACH_WIDTH = 3
)
(
  input clk,
  input reset,
  input [ATEG_WIDTH + AINDEX_WIDTH - 1:0] addr,
  input wr,
  input md,
  input [ACH_WIDTH-1:0] index,
  input [ACH_WIDTH-1:0] fifo,
  input hitAll,
  output [ATEG_WIDTH + 1:0] tegOut,
  output hit
);

  
  // ??????????????? ?????????
  localparam MEM_SIZE   = 2**AINDEX_WIDTH;
  localparam MEM_WIDTH  =  ATEG_WIDTH + 2;
  localparam VAL_BIT    = 1;
  localparam MOD_BIT    = 0;

  // ???????? ??? ????????? ? ????????? ???????? ???? ??????
  wire [ATEG_WIDTH - 1:0]   aTeg = addr[ATEG_WIDTH + AINDEX_WIDTH - 1:AINDEX_WIDTH];
  wire [AINDEX_WIDTH - 1:0] aIndex = addr[AINDEX_WIDTH - 1:0];

  // ?????? - ????????? ?????? ???
  reg [MEM_WIDTH - 1:0] tegMem [0:MEM_SIZE-1];
  
  // ????? ??????. ???????? ??? ????????? ? ?????? ????
      wire [MEM_WIDTH - 1:0]    tegMemOut = tegMem[aIndex];
      wire [ATEG_WIDTH - 1:0]   moTeg = tegMemOut[MEM_WIDTH - 1:VAL_BIT + 1];
      wire                      moVal = tegMemOut[VAL_BIT];
      wire                      moMod = tegMemOut[MOD_BIT];

  // ???? ??????. ???????? ??? ????????? ? ?????? ????
      wire [ATEG_WIDTH - 1:0]   miTeg = wr ? aTeg : moTeg;
      wire                      miVal = wr ? 1'b1 : moVal;
      wire                      miMod = md ? 1'b1 : wr ? 1'b0 : moMod;
      wire [MEM_WIDTH - 1:0]    tegMemIn = {miTeg,miVal,miMod};

	
  wire ce = (((hit == 1'b1 && md == 1'b1) || (index == fifo && wr == 1'b1 && hitAll == 1'b0))) ? 1'b1 : 1'b0 ;


  assign hit    = (moTeg == aTeg && moVal == 1'b1) ? 1'b1 : 1'b0 ;
  assign tegOut = tegMemOut; //!!!
  
  integer i;
  reg [MEM_WIDTH - 1:0] rstVal;
  always @(posedge clk) begin
    rstVal[MOD_BIT] = 1'b0;
    rstVal[VAL_BIT] = 1'b0;
    if (reset) begin
      for(i = 0; i < MEM_SIZE; i = i + 1)
        tegMem[i] <= 'b0;
    end else if (ce) begin
        tegMem[aIndex] <= tegMemIn;
    end
  end
  

endmodule
