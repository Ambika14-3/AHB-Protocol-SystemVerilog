`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2023 09:04:04
// Design Name: 
// Module Name: mux
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

////////////////////// BELOW IS THE CODE FOR MULTIPLEXOR WHICH ROUTES THE SELECTED SLAVE DATA AND SIGNALS TO THE MASTER ///////////////////////////////////////////


module mux(
  input [31:0] hrdata_1,
  input [31:0] hrdata_2,
  input [31:0] hrdata_3,
  input [31:0] hrdata_4,
  input hready_1,
  input hready_2,
  input hready_3,
  input hready_4,
  input hresp_1,
  input hresp_2,
  input hresp_3,
  input hresp_4,
  input [1:0] sel,
  output reg [31:0] hrdata,
  output reg hready,
  output reg hresp
);

always @(*) begin
  case(sel)
    2'b00: begin
      hrdata = hrdata_1;
      hready = hready_1;
      hresp = hresp_1;
    end
    2'b01: begin
      hrdata = hrdata_2;
      hready = hready_2;
      hresp = hresp_2;
    end
    2'b10: begin
      hrdata = hrdata_3;
      hready = hready_3;
      hresp = hresp_3;
    end
    2'b11: begin
      hrdata = hrdata_4;
      hready = hready_4;
      hresp = hresp_4;
    end
    default: begin
      hrdata = 32'h0000_0000;
      hready = 1'b0;
      hresp = 1'b0;
    end
  endcase
end

endmodule
