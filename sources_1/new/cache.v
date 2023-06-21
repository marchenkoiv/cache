`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2023 23:27:59
// Design Name: 
// Module Name: cache
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


module cache(

    input sys_clk,
    input c_clk,
    input ram_clk,
    
    input [15:0] addr,
    input wr,
    input rd,
    input [31:0] wdata,
    input [3:0] bval,
    input reset,
    
    input [7:0] rrdata,
    input rack,
    
    output [31:0] rdata,
    output ack,
    
    output [12:0] raddr,
    output rnw,
    output [7:0] rwdata,
    output avalid

    );
    
    wire [8:0] tegOut;
    wire [2:0] chan;
    wire hit;
    
    wire md;
    wire wrt;
    wire wrd;
    wire wsel; 
    wire tsel;
    wire rdram; 
    wire wrram;
    wire ack_if;
    wire [63:0] OData;
    wire [63:0] Wrdata;
    wire [63:0] RDdata;
    wire [15:0] c_addr;
    wire c_ack;
    wire c_wr;
    wire c_rd;
    wire [31:0] c_wdata;
    wire [31:0] c_rdata;
    wire [3:0] c_bval;
    
    assign c_rdata = c_addr[2]?OData[63:32]:OData[31:0];
    
    
    tag_mem dut (.clk(c_clk), 
    .reset_n(reset), 
    .addr(c_addr[15:3]), 
    .wr(wrt), 
    .md(md), 
    .tegOut(tegOut), 
    .chan(chan), 
    .hit(hit));///!
    
    muu dut2(.clk(c_clk), 
    .reset(reset), 
    .rd(c_rd), 
    .wr(c_wr), 
    .md(tegOut[0]), 
    .hit(hit), 
    .ram_ack(ack_if), 
    .chmd(md), 
    .wrt(wrt), 
    .wrd(wrd), 
    .wsel(wsel), 
    .tsel(tsel), 
    .rdram(rdram), 
    .wrram(wrram), 
    .ack(c_ack));
    
    ks2 dut3(.WData(c_wdata), 
    .RData(RDdata), 
    .OData(OData), 
    .BVal(c_bval), 
    .Offset(c_addr[2:0]), 
    .wsel(wsel), 
    .Q(Wrdata));
    
    data_mem dut4(.clk(c_clk), 
    .reset(reset), 
    .WData(Wrdata), 
    .chan(chan), 
    .Addr(c_addr[8:3]), 
    .wr(wrd), 
    .Q(OData));
    
    ram_if_2 dut5(.reset(reset), 
    .cache_clk(c_clk), 
    .ram_clk(ram_clk), 
    .wdata_c(OData), 
    .addr_c(tsel?c_addr[15:3]:{tegOut[8:2], c_addr[8:3]}), 
    .rdata_r(rrdata), 
    .rack(rack), 
    .wr(wrram), 
    .rd(rdram), 
    .rdata_c(RDdata), 
    .addr_r(raddr), 
    .rnw(rnw), 
    .wdata_r(rwdata), 
    .aval(avalid), 
    .ack(ack_if));
    
    cpu_if dut6(.sys_clk(sys_clk), 
    .c_clk(c_clk),
    .sys_rst(reset),
    .sys_addr(addr),
    .sys_wr(wr),
    .sys_rd(rd),
    .sys_wdata(wdata),
    .sys_bval(bval),
    .c_rdata(c_rdata),
    .c_ack(c_ack),
    .c_addr(c_addr),
    .c_wr(c_wr),
    .c_rd(c_rd),
    .c_wdata(c_wdata),
    .c_bval(c_bval),
    .sys_rdata(rdata),
    .sys_ack(ack)
    );
   
    
endmodule
