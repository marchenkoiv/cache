`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2023 21:57:29
// Design Name: 
// Module Name: tb_if_simple
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


module tb_if_simple(

    );
    reg areset = 'b0;
    reg clk = 'b0;
    reg ram_clk = 'b0;
    reg [12:0] addr = 'b0000100001111;
    reg ram_ack = 'b0;
    reg [7:0] rdata_r = 'h1a;
    
    wire [63:0] OData = 'h1234567890abcdef;
    wire [63:0] rdata_c;
    wire [12:0] addr_r;
    wire rnw;
    wire [7:0] wdata_r;
    wire aval;
    wire ack_if;

    reg rdram = 'b0; 
    reg wrram = 'b0;
    
    
    ram_if_2 dut5(.reset(areset), .cache_clk(clk), .ram_clk(ram_clk), .wdata_c(OData), .addr_c(addr), .rdata_r(rdata_r), .rack(ram_ack), .wr(wrram), .rd(rdram), .rdata_c(rdata_c), .addr_r(addr_r), .rnw(rnw), .wdata_r(wdata_r), .aval(aval), .ack(ack_if));
    
    
    always #5 clk <= ~clk;
    always #16 ram_clk <= ~ram_clk;
    
    initial #100 begin : test
        #10
        
        areset <= 'b1;
        #20
        areset <= 'b0;
                
        $display("test begin");
        @(negedge clk);
        
        // wr ram_clk > cache_clk 
//        wrram <= 'b1;
//        #430
//        ram_ack <= 'b1;
//        #32
//        ram_ack <= 'b0;
//        #550
//        ram_ack <= 'b1;
//        #32
//        ram_ack <= 'b0;
//        #50
        
        // wr ram_clk < cache_clk 
//        wrram <= 'b1;
//        #385
//        ram_ack <= 'b1;
//        #10
//        ram_ack <= 'b0;
//        #600
//        ram_ack <= 'b1;
//        #10
//        ram_ack <= 'b0;
//        #50
        
        // rd ram_clk > cache_clk
        rdram <= 'b1;
        #238
        #32
        ram_ack <= 'b1;
        #32
        rdata_r <= 'h2b;
        #32
        rdata_r <= 'h3c;
        #32
        rdata_r <= 'h4d;
        #32
        rdata_r <= 'h5e;
        #32
        rdata_r <= 'h6f;
        #32
        rdata_r <= 'h78;
        #32
        rdata_r <= 'h90;
        #32
        ram_ack <= 'b0;
        #400
        rdata_r <= 'haa;
        ram_ack <= 'b1;
        #256
        ram_ack <= 'b0;
        #300

        // rd ram_clk < cache_clk
//        rdram <= 'b1;
//        #200
//        ram_ack <= 'b1;
//        #10
//        rdata_r <= 'h2b;
//        #10
//        rdata_r <= 'h3c;
//        #10
//        rdata_r <= 'h4d;
//        #10
//        rdata_r <= 'h5e;
//        #10
//        rdata_r <= 'h6f;
//        #10
//        rdata_r <= 'h78;
//        #10
//        rdata_r <= 'h90;
//        #10
//        ram_ack <= 'b0;
//        #540
//        rdata_r <= 'haa;
//        ram_ack <= 'b1;
//        #80
//        ram_ack <= 'b0;
//        #500
        
        $display("test end");
        $finish;
    end : test

endmodule
