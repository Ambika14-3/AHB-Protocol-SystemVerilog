`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2023 14:51:54
// Design Name: 
// Module Name: ahb_master
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



//////////////////////////////////////////////////////////////////////////////////

/////////////// This is the code for the MASTER //////////////////////////////////
////////////// The working and code is written as per the state model ///////////



`define OKAY  1'b0
`define ERROR 1'b1

module ahb_master(
input clk,
input hresetn,
input enable,
input hresp,
input hready,
input [31:0] hrdata,

input [31:0] in_hwdata,
input [31:0] in_haddr, 
input [2:0] in_hsize,
input [2:0] in_hburst,
input [1:0] in_hsel,
input in_hwrite,
input [1:0] in_htrans,
 
output logic [31:0] hwdata,
output logic [31:0] haddr, 
output logic [2:0] hsize,
output logic [2:0] hburst,
output logic [1:0]hsel,
output logic hwrite,
output logic [1:0] htrans,

output logic [31:0] out_hrdata
//output logic hreadyout
);

typedef enum  {idle = 0, busy = 1, error=2} state_type;
state_type master_state, next_state;
 
///////////////////////////////////////////////////////////////////////////////////
 
always_ff@(posedge clk)
begin
if(!hresetn)
master_state <= idle;
else
master_state <= next_state;
end

always_comb
begin
    case(master_state)
    
    idle:
    begin
        if(enable==1)
        begin
    
            next_state= busy;
            hwdata= in_hwdata;
            haddr= in_haddr;
            hsize= in_hsize;
            hburst= in_hburst;
            hsel= in_hsel;
            hwrite= in_hwrite;
            htrans= in_htrans;
        end
	else next_state= idle;
//        if(hresp==`ERROR)
//            next_state= error;   
        
        
    end
    busy:
    begin
  
        if(hresp==`ERROR)
            next_state= error; 
	else next_state=busy;  
        if (hready==1)
        begin
            
            out_hrdata= hrdata;
            next_state= idle;
        end
	else next_state=busy; 
        if(!enable)
            next_state= idle;
	else next_state=busy; 
    end
    error:
    begin
        haddr= 0 ;
        next_state= idle;
    end
    default:
    begin
        hsel= 2'bxx;
    end
    endcase
end

endmodule
