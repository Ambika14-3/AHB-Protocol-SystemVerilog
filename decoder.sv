`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2023 09:02:12
// Design Name: 
// Module Name: decoder
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


module decoder(
  input [1:0] hsel,
  output reg hsel_1,
  output reg hsel_2,
  output reg hsel_3,
  output reg hsel_4
);

always @(*) begin
  case(hsel)
    2'b00: begin
      hsel_1 = 1'b1;
      hsel_2 = 1'b0;
      hsel_3 = 1'b0;
      hsel_4 = 1'b0;
    end
    2'b01: begin
      hsel_1 = 1'b0;
      hsel_2 = 1'b1;
      hsel_3 = 1'b0;
      hsel_4 = 1'b0;
    end
    2'b10: begin
      hsel_1 = 1'b0;
      hsel_2 = 1'b0;
      hsel_3 = 1'b1;
      hsel_4 = 1'b0;
    end
    2'b11: begin
      hsel_1 = 1'b0;
      hsel_2 = 1'b0;
      hsel_3 = 1'b0;
      hsel_4 = 1'b1;
    end
    default: begin
      hsel_1 = 1'b0;
      hsel_2 = 1'b0;
      hsel_3 = 1'b0;
      hsel_4 = 1'b0;
    end
  endcase
end


endmodule