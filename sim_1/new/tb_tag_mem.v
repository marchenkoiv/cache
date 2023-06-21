`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2023 14:59:13
// Design Name: 
// Module Name: tb_tag_mem
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


module tb_tag_mem(
    );
    
    reg areset = 'b0;
    reg clk = 'b0;
    reg [13:0] addr;
    reg WR;
    reg md = 'b0;

    wire [8:0] tegOut;
    wire [2:0] chan;
    wire hit;
    
    tag_mem dut (.clk(clk), .reset_n(areset), .addr(addr), .wr(WR), .md(md), .tegOut(tegOut), .chan(chan), .hit(hit));
    
    always #5 clk <= ~clk;
    
    initial #100 begin : test
        #10
        
        areset <= 'b1;
        #20
        areset <= 'b0;
        $display("test begin");
        @(negedge clk);
        WR = 'b0;
        md = 'b0;
        addr = 'b0;
        #15
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        
      //  @(posedge clk);
      //  md = 'b1;
        addr = 'b01_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        
      //  @(posedge clk);
      //  md = 'b1;
        addr = 'b010_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        
      //  @(posedge clk);
      //  md = 'b1;
        addr = 'b011_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        
       // @(posedge clk);
        //md = 'b1;
        addr = 'b0100_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        #20
        @(negedge clk);
        //md = 'b1;
        addr = 'b0101_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        #20
        @(negedge clk);
        //md = 'b1;
        addr = 'b0110_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        #20
        @(negedge clk);
       // md = 'b1;
        addr = 'b0111_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        #20
        @(negedge clk);
       // md = 'b1;
        addr = 'b01000_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        #20
        @(negedge clk);
       // md = 'b1;
        addr = 'b01001_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        #20
        @(negedge clk);
        WR = 'b0;
        #20
        @(negedge clk);
       // md = 'b1;
        addr = 'b0101_000000;
        #20
        @(negedge clk);
        md = 'b1;
        #10
        @(negedge clk);
        md = 'b0;
        #20
        
        @(negedge clk);
       // md = 'b1;
        addr = 'b01100_000000;
        #20
        @(negedge clk);
        WR = 'b1;
        #10
        @(negedge clk);
        WR = 'b0;
        #20
        
        areset <= 'b1;
        #20
        areset <= 'b0;
        
        #20
        
        @(negedge clk);
       // md = 'b1;
        addr = 'b01100_000000;
        #20
        @(negedge clk);
        
        
        
//        @(posedge clk);
//        WR = 'b1;
//        addr = 5'h9;
//        md = 'b0;
//        @(posedge clk);
//        WR = 'b0;
//        #105;
        
//        addr = 'b0;
        
//        #100;
        
        
        $display("test end");
        $finish;
    end : test

endmodule
