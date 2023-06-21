`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2023 21:24:59
// Design Name: 
// Module Name: tb_cpu_if
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


module tb_cpu_if(

    );
    
    reg areset = 'b0;
    reg clk = 'b0;
    reg c_clk = 'b0;
    reg [15:0] addr = 'b0000100001111;
    reg [31:0] sys_wdata = 'h12343;
    reg [3:0] sys_bval = 'b0010;
    
    
    reg [31:0] c_rdata = 'h1234ab;
    reg c_ack = 'b0;
    wire [15:0] addr_r;
    wire c_rd;
    wire c_wr;
    wire [31:0] c_wdata;
    wire [3:0] c_bval;
    wire [31:0] sys_rdata;
    wire ack_if;

    reg rd = 'b0; 
    reg wr = 'b0;
    
    
    cpu_if dut5(.sys_clk(clk), 
    .c_clk(c_clk),
    .sys_rst(areset),
    .sys_addr(addr),
    .sys_wr(wr),
    .sys_rd(rd),
    .sys_wdata(sys_wdata),
    .sys_bval(sys_bval),
    .c_rdata(c_rdata),
    .c_ack(c_ack),

    .c_addr(addr_r),
    .c_wr(c_wr),
    .c_rd(c_rd),
.c_wdata(c_wdata),
.c_bval(c_bval),

.sys_rdata(sys_rdata),
.sys_ack(ack_if)
    );
    
    
    always #5 clk <= ~clk;
    always #16 c_clk <= ~c_clk;
    
    initial #100 begin : test
        #10
        
        areset <= 'b1;
        #20
        areset <= 'b0;
                
        $display("test begin");
        @(posedge clk);
        #10
        wr = 'b1;
        addr = $urandom%32767;
        #10
        wr = 'b0;
        #107
        @(posedge c_clk);
        c_ack = 'b1;
        #32
        c_ack = 'b0;
        #50
        @(posedge clk);
        wr = 'b1;
        addr = $urandom%32767;
        #10
        wr = 'b0;
        #107
        
        $display("test end");
        $finish;
    end : test
endmodule
