`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2023 09:58:36
// Design Name: 
// Module Name: tb_cache
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


module tb_cache(

    );
    reg areset = 'b0;
    reg sys_clk = 'b0;
    reg c_clk = 'b0;
    reg ram_clk = 'b0;
    wire [15:0] addr;
    wire wr;
    wire rd;
    wire [31:0] wdata;
    wire [3:0] bval;
    
    wire [7:0] rrdata;
    wire rack;
    
    wire [31:0] rdata;
    wire ack;
    
    wire [12:0] raddr;
    wire rnw;
    wire [7:0]rwdata;
    wire avalid;
    
    
    
    cache dut(

    sys_clk,
    c_clk,
    ram_clk,
    addr,
    wr,
    rd,
    wdata,
    bval,
    areset,
    rrdata,
    rack,
    rdata,
    ack,
    raddr,
    rnw,
    rwdata,
    avalid
    );
    
    ram dut2(
    ram_clk,
    avalid,
    rnw,
    rack, 
    rrdata);
    
    cpu dut3(
    ack,
    sys_clk,
    areset,
    addr,
    wr,
    rd,
    wdata,
    bval
    );
    
    integer i = 0;
    
    always #2 sys_clk <= ~sys_clk;
    always #7 c_clk <= ~c_clk;
    always #23 ram_clk <= ~ram_clk;
    
        initial #100 begin : test
        #10
        
        areset <= 'b1;
        #20
        areset <= 'b0;
        $display("test begin");
        
        for(;i<5000;i=i+1)
        begin
            while(rd == 'b0 && wr == 'b0)
                @(posedge sys_clk);
        @(posedge sys_clk);
        end
        
        $display("test end");
        $finish;
    end : test
endmodule
