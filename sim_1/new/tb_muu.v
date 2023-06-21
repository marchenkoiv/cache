`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2023 00:30:08
// Design Name: 
// Module Name: tb_muu
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


module tb_muu();

    reg areset = 'b0;
    reg clk = 'b0;
    reg [13:0] addr;
    reg [2:0] offset = 'b000;
    reg WR;
    reg RD;
    reg ram_ack = 'b0;
    reg [31:0] WData;
    reg [63:0] RData;
    wire [63:0] OData;
    reg [3:0] BVal = 'b0001;

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
    wire ack;
    
    wire [63:0] Wrdata;
    
    tag_mem dut (.clk(clk), .reset_n(areset), .addr(addr), .wr(wrt), .md(md), .tegOut(tegOut), .chan(chan), .hit(hit));
    muu dut2(.clk(clk), .reset(areset), .rd(RD), .wr(WR), .md(tegOut[0]), .hit(hit), .ram_ack(ram_ack), .chmd(md), .wrt(wrt), .wrd(wrd), .wsel(wsel), .tsel(tsel), .rdram(rdram), .wrram(wrram), .ack(ack));
    ks2 dut3(.WData(WData), .RData(RData), .OData(OData), .BVal(BVal), .Offset(offset), .wsel(wsel), .Q(Wrdata));
    data_mem dut4(.clk(clk), .reset(areset), .WData(Wrdata), .chan(chan), .Addr(addr[5:0]), .wr(wrd), .Q(OData));
    
    
    always #5 clk <= ~clk;
    
    initial #100 begin : test
        #10
        
        areset <= 'b1;
        #20
        areset <= 'b0;
        $display("test begin");
        @(negedge clk);
        WData = 'b10101010101;
        RData = 'b11111111111;
        RD = 'b0;
        WR = 'b1;
        addr = 'b0;
        @(negedge clk);
        WR = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        #10
        @(negedge clk);
        //WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        
      //  @(posedge clk);
      //  md = 'b1;
        addr = 'b01_000000;
        WR = 'b1;
        @(negedge clk);
        WR = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        
      //  @(posedge clk);
      //  md = 'b1;
        addr = 'b010_000000;
        WR = 'b0;
        RD = 'b1;
        BVal = 'b0000;
        @(negedge clk);
        RD = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b1111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        
      //  @(posedge clk);
      //  md = 'b1;
        addr = 'b011_000000;
        RD = 'b1;
        @(negedge clk);
        RD = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b1111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        
       // @(posedge clk);
        //md = 'b1;
        addr = 'b0100_000000;
        RD = 'b0;
        WR = 'b1;
        BVal = 'b0001;
        @(negedge clk);
        WR = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b11111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        //md = 'b1;
        addr = 'b0101_000000;
        WR = 'b0;
        RD = 'b1;
         BVal = 'b0000;
        @(negedge clk);
        RD = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b111111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        //md = 'b1;
        addr = 'b0110_000000;
        WR = 'b0;
        RD = 'b1;
        @(negedge clk);
        RD = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b1111111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
       // md = 'b1;
        addr = 'b0111_000000;
        WR = 'b0;
        RD = 'b1;
        @(negedge clk);
        RD = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b11111111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
       // md = 'b1;
        addr = 'b01000_000000;
       RD = 'b1;
       BVal = 'b0000;
        @(negedge clk);
        RD = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b111111111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b111111111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
       // md = 'b1;
        addr = 'b01001_000000;
        WR = 'b1;
        BVal = 'b0001;
        @(negedge clk);
        WR = 'b0;
        #15
       @(negedge clk);
        ram_ack = 'b1;
        RData = 'b1111111111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b1111111111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
       // md = 'b1;
        addr = 'b0101_000000;
        WR = 'b1;
        RD = 'b0;
        BVal = 'b0001;
        @(negedge clk);
        WR = 'b0;
        @(negedge clk);
        WR = 'b0;
        RD = 'b1;
        BVal = 'b000;
        @(negedge clk);
        RD = 'b0;
        #10
        @(negedge clk);
        BVal = 'b001;

        
        @(negedge clk);
       // md = 'b1;
        addr = 'b01100_000000;
        RD = 'b0;
        WR = 'b1;
        @(negedge clk);
        WR = 'b0;
        #15
        @(negedge clk);
        ram_ack = 'b1;
        RData = 'b11111111111111111111111;
        #10
        @(negedge clk);
        WR = 'b0;
        ram_ack = 'b0;
        @(negedge clk);
        
        areset <= 'b1;
        #20
        areset <= 'b0;
        
        #20
        
        @(negedge clk);
       // md = 'b1;
        addr = 'b01100_000000;
        #20
        @(negedge clk);
        
        $display("test end");
        $finish;
    end : test
endmodule
