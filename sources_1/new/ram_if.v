`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2023 08:01:34
// Design Name: 
// Module Name: ram_if
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


module ram_if(
input cache_clk,
input ram_clk,
input [63:0] wdata_c,
input [12:0] addr_c,
input [7:0] rdata_r,
input rack,
input wr,
input rd,
input reset,

output reg [63:0] rdata_c,
output reg [12:0] addr_r,
output reg rnw,
output reg [7:0] wdata_r,
output reg aval,
output reg ack
    );
    
 localparam IDLE = 4'b1111;
 localparam WR_C = 4'b0001;
 localparam WR_R1 = 4'b0010;
 localparam WR_R12 = 4'b1001;
 localparam WR_R2 = 4'b0011;
 localparam WR_A = 4'b0100;
 localparam WR_AA = 4'b1010;
 localparam RD_R = 4'b0101;
 localparam RD_A = 4'b1000;
 localparam RD_AA = 4'b1011;
 localparam RD_AAA = 4'b1100;
 localparam RD_C1 = 4'b0110;
 localparam RD_C2 = 4'b0111;
 localparam RD_C3 = 4'b1101;

reg [3:0] state;
reg wr_rst;
reg rd_rst;
reg wr_en_1;
reg rd_en_1;
reg wr_en_2;
reg rd_en_2;
reg [55:0] buf_1;
reg [63:0] buf_2;
reg [7:0] din;
wire [7:0] dout1;
wire [7:0] dout2;
wire full1;
wire full2;
wire empty1;
wire empty2;
integer c = 0;


  
    
  fifo_generator_0 cache_to_ram (
  cache_clk,
  wr_rst,
  ram_clk,
  rd_rst,
  din,
  wr_en_1,
  rd_en_1,
  dout1,
  full1,
  empty1
    );
    
  fifo_generator_0 ram_to_cache (
  ram_clk,
  wr_rst,
  cache_clk,
  rd_rst,
  din,
  wr_en_2,
  rd_en_2,
  dout2,
  full2,
  empty2
    );
    
  always @(posedge cache_clk) begin
      if (reset == 'b1) begin
        state <= IDLE;
    end
    if (wr == 'b1 && state == IDLE)begin
        state <= WR_C;
        c = 0;
    end
    if (state == WR_C && c!=8)begin
        state <= WR_C;
        c = c + 1;
    end
    if (state == WR_C && c==8)begin
        state <= WR_R1;
    end
    if (state == WR_R1 && empty1 == 'b0)begin
        state <= WR_R12;
        c = 0;
    end
    if (state == WR_A)begin //!!!!!wr_a
        state <= WR_AA;
    end
    if (state == WR_AA)begin //!!!!!wr_a
        state <= IDLE;
    end
    if (rd == 'b1 && state == IDLE)begin
        state <= RD_A;
    end
    if (state == RD_C2 && empty2 == 'b0)begin
        state <= RD_C2;
        buf_2 <= ((buf_2 << 8)+ dout2);
        c = c + 1;
    end
    if (state == RD_C2 && empty2 == 'b1)begin
        state <= RD_C3;
        buf_2 <= ((buf_2 << 8)+ dout2);
    end
    if (state == RD_C3)begin
        state <= IDLE;
    end
  end
  
  always @(posedge ram_clk) begin
      if (reset == 'b1) begin
        state <= IDLE;
    end
    if (state == WR_R12)begin
        state <= WR_R2;
        c = 0;
    end
    if (state == WR_R2 && c!=8)begin
        state <= WR_R2;
        c = c + 1;
    end
    if (state == WR_R2 && rack == 'b1)begin //!!!!!wr_a
        state <= WR_A;
    end
    if (state == RD_A)begin
        state <= RD_AA;
    end
    if (state == RD_AA)begin
        state <= RD_AAA;
    end
    if ((state == RD_AAA || state == RD_AA) && rack == 'b1)begin
        state <= RD_R;
        c = 0;
    end
    if (state == RD_R && c!=8)begin
        state <= RD_R;
        c = c + 1;
    end
    if (state == RD_R && c==8)begin
        state <= RD_C1;
    end
    if (state == RD_C1 && empty2 == 'b0)begin
        state <= RD_C2;
        c = 0;
    end
  end
  
always @(*) begin
    if (reset == 'b1) begin
        state <= IDLE;
    end
    if (state == IDLE) begin
        aval <= 'b0;
        ack <= 'b0;
        rnw <= 'b0;
        rd_en_2 <= 'b0;
        rd_en_1 <= 'b0;
        wr_en_1 <= 'b0;
        wr_en_2 <= 'b0;
        wr_rst <= 'b0;
        rd_rst <= 'b0;
        buf_1 <= 'b0;
        buf_2 <= 'b0;
        addr_r <= addr_c;
    end
    if (state == WR_C) begin
       {din, buf_1} <= (wdata_c << 8*c);
        wr_en_1 <= 'b1; 
    end
    if (state == WR_R1) begin
        wr_en_1 <= 'b0;
    end
    if (state == WR_R12) begin
        rd_en_1 <= 'b1;
        wdata_r <= dout1;
    end
    if (state == WR_R2) begin
        rd_en_1 <= 'b1;
        wdata_r <= dout1;
        if (c==0)
            aval <= 'b1;
        else
            aval <= 'b0;
    end
    if (state == WR_A) begin
        rd_en_1 <= 'b0;
        ack <= 'b0;
    end
    if (state == WR_AA) begin
        ack <= 'b1;
    end
    
    if (state == RD_AA) begin
        rnw <= 'b1;
        aval <= 'b1;
    end
    if (state == RD_AAA) begin
        rnw <= 'b0;
        aval <= 'b0;
    end
    if (state == RD_R) begin
        rnw <= 'b0;
        aval <= 'b0;
        wr_en_2 <= 'b1;
        din <= rdata_r;
    end
    if (state == RD_C1) begin
        wr_en_2 <= 'b0;
    end
    if (state == RD_C2) begin
        rd_en_2 <= 'b1;
        rdata_c <= buf_2;
    end
    if (state == RD_C3) begin
        ack <= 'b1;
        rdata_c <= buf_2;
    end
 end
    
endmodule
