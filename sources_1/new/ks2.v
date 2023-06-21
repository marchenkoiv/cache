`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2023 21:57:35
// Design Name: 
// Module Name: ks2
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


module ks2(
    input               [31:0] WData,
    input               [63:0] RData,
    input               [63:0] OData,
    input               [3:0] BVal,
    input               [2:0] Offset,
    input               wsel,
    output  reg         [63:0] Q

    );
    
    wire [63:0] ActiveData = wsel == 'b0 ? OData : RData;
    
    always@(*) begin
        if (Offset[2] == 'b0) begin
            case(BVal)
                'b0001: Q <= {ActiveData[63:8], WData[7:0]};
                'b0010: Q <= {ActiveData[63:16], WData[15:8], ActiveData[7:0]};
                'b0100: Q <= {ActiveData[63:24], WData[23:16], ActiveData[15:0]};
                'b1000: Q <= {ActiveData[63:32], WData[31:24], ActiveData[23:0]};
                'b0000: Q <= ActiveData;
            endcase
        end
        else begin
            case(BVal)
                'b0001: Q <= {ActiveData[63:40], WData[7:0], ActiveData[31:0]} ;
                'b0010: Q <= {ActiveData[63:48], WData[15:8], ActiveData[39:0]};
                'b0100: Q <= {ActiveData[63:56], WData[23:16], ActiveData[47:0]};
                'b1000: Q <= {WData[31:24], ActiveData[55:0]};
                'b0000: Q <= ActiveData;
            endcase
        end
    end
    
endmodule
