`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2023 09:06:43
// Design Name: 
// Module Name: ahb_slave
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

/////////////// This is the code for the SLAVE //////////////////////////////////
/////////////// Working and code is as per the slave state model ///////////////

 
`define NON_SEQ     2'b10
`define SEQ 	    2'b11
`define BUSY 	    2'b01
`define IDLE        2'b00
 
`define OKAY  1'b0
`define ERROR 1'b1
//`define RETRY 2'b10
//`define SPLIT 2'b11
 
 
module ahb_slave(
input clk,
input [31:0] hwdata,
input [31:0] haddr, 
input [2:0] hsize,
input [2:0] hburst,
input hresetn, hsel, hwrite,
//input hreadyout,
input [1:0] htrans,
output reg hresp,
output reg hready,
output reg [31:0] hrdata
);
 
 
 
reg [7:0] mem[256] = '{default : 10};
 
//////////////////////////// Function for single transaction //////////////////////////////////////////////
function bit[31:0] single_tr (input bit [31:0] addr, input bit [2:0] hsize);
    unique case(hsize)
    3'b000: begin
         mem[addr]  = hwdata[7:0];   
    end 
    
    3'b001: begin
         mem[addr]     = hwdata[7:0];
         mem[addr + 1] = hwdata[15:8];
    end
    
    3'b010: begin
         mem[addr]     = hwdata[7:0];
         mem[addr + 1] = hwdata[15:8];
         mem[addr + 2] = hwdata[23:16];
         mem[addr + 3] = hwdata[31:24];
    end
    endcase
    return addr;
    
endfunction
 
 
////////////////////////// Function for unspecified increment mode /////////////////////////////////////////////////////////
function bit[31:0] unincr_wr (input bit [31:0] addr, input bit [2:0] hsize);
    bit [31:0] raddr;
    unique case(hsize)
    
     3'b000: begin
          mem[addr]    = hwdata[7:0];
          raddr        = addr + 1; 
     end
     
     3'b001: begin
         mem[addr]     = hwdata[7:0];
         mem[addr + 1] = hwdata[15:8];
         raddr         = addr + 2;
     end
 
     3'b010: begin
         mem[addr]     = hwdata[7:0];
         mem[addr + 1] = hwdata[15:8];
         mem[addr + 2] = hwdata[23:16];
         mem[addr + 3] = hwdata[31:24];
         raddr         = addr + 4;
     end
 endcase
    
return raddr;
 
endfunction
 
 
 
 
 
 
////////////////////// Function for defining the boundary when slave in wrap mode , defines the boundary/length of data ////////////////////////////////////////////
function bit[7:0] boundary(input bit [2:0] hburst, input [2:0] hsize);
   bit [7:0] temp;
   unique case(hsize)
      3'b000: begin
           unique case (hburst)
              3'b010 : temp = 4 * 1;
              
              3'b100 : temp =  8 * 1;
              
              3'b110 : temp = 16 * 1;
            endcase
      end
      
      3'b001 : begin
            unique case (hburst)
              3'b010 :  temp = 4 * 2;
              
              3'b100 : temp =  8 * 2;
              
              3'b110 : temp = 16 * 2;
            endcase
      end
      
      
      3'b010 : begin
            unique case (hburst)
              3'b010 :  temp = 4 * 4;
              
              3'b100 : temp =  8 * 4;
              
              3'b110 : temp = 16 * 4;
            endcase
    end
    
    endcase
    
    return temp;
    
endfunction
 
 
 //////////////////// Function for wrap mode, uses the boundary value generated by the boundary function ///////////////////////////////////////////////////////
function bit[31:0] wrap_wr (input bit [31:0] addr, input bit [7:0] boundary, input [2:0] hsize);
  bit [31:0] addr1, addr2, addr3,addr4;
  
  unique case(hsize)
    3'b000: begin
       mem[addr] = hwdata[7:0];
       
        if((addr + 1) % boundary == 0)
         addr1 = (addr + 1) - boundary;
        else
         addr1 = (addr + 1);
         
       return addr1;  
    end
    
    3'b001: begin
        mem[addr] = hwdata[7:0];
       
        if((addr + 1) % boundary == 0)
         addr1 = (addr + 1) - boundary;
        else
         addr1 = (addr + 1);
         
         mem[addr1] = hwdata[15:8];
         
       if((addr1 + 1) % boundary == 0)
         addr2 = (addr1 + 1) - boundary;
        else
         addr2 = (addr1 + 1);
         
        return addr2;
        
       end
    
    3'b010: begin
        
        mem[addr] = hwdata[7:0];
       
        if((addr + 1) % boundary == 0)
         addr1 = (addr + 1) - boundary;
        else
         addr1 = (addr + 1);
         
         mem[addr1] = hwdata[15:8];
         
       if((addr1 + 1) % boundary == 0)
         addr2 = (addr1 + 1) - boundary;
        else
         addr2 = (addr1 + 1);
         
         mem[addr2] = hwdata[23:16];
        
         if((addr2 + 1) % boundary == 0)
         addr3 = (addr2 + 1) - boundary;
         else
         addr3 = (addr2 + 1); 
         
        mem[addr3] = hwdata[31:24];
        
        if((addr3 + 1) % boundary == 0)
         addr4 = (addr3 + 1) - boundary;
         else
         addr4 = (addr3 + 1); 
       
       return addr4;
    end
    
  
  endcase
  
endfunction
////////////////////////////////////////////////////////////////////////////////////////////
 
 
 
 ////////////////////////// Function for increment mode, works on hsize /////////////////////////////////////////////////////////
function bit[31:0] incr_wr(input bit [31:0] addr, input bit [2:0] hsize);
    
    bit [31:0] raddr;
    
    unique case(hsize)
    
     3'b000: begin
          mem[addr]    = hwdata[7:0];
          raddr        = addr + 1; 
     end
     
     3'b001: begin
         mem[addr]     = hwdata[7:0];
         mem[addr + 1] = hwdata[15:8];
         raddr         = addr + 2;
     end
 
     3'b010: begin
         mem[addr]     = hwdata[7:0];
         mem[addr + 1] = hwdata[15:8];
         mem[addr + 2] = hwdata[23:16];
         mem[addr + 3] = hwdata[31:24];
         raddr         = addr + 4;
     end
 endcase
 
return raddr;
 
endfunction
 

////////////////////////////  Single transfer read ////////////////////////////////////////////////////////////////////////////////
 
function bit[31:0] single_tr_rd (input bit [31:0] addr, input bit [2:0] hsize);
    unique case(hsize)
    3'b000: begin
         hrdata[7:0] = mem[addr];  
    end 
    
    3'b001: begin
         hrdata[7:0]  = mem[addr];
         hrdata[15:8] = mem[addr + 1];
    end
    
    3'b010: begin
         hrdata[7:0]   = mem[addr];
         hrdata[15:8]  = mem[addr + 1];
         hrdata[23:16] = mem[addr + 2];
         hrdata[31:24] = mem[addr + 3];
    end
    endcase
    return addr;
    
endfunction

 

///////////////////////////// Read for unspecified length ///////////////////////////////////////////////////////
function bit[31:0] unincr_rd (input bit [31:0] addr, input bit [2:0] hsize);
    bit [31:0] raddr;
    unique case(hsize)
    
     3'b000: begin
          hrdata[7:0] = mem[addr];
          raddr        = addr + 1; 
     end
     
     3'b001: begin
         hrdata[7:0] = mem[addr];
         hrdata[15:8] = mem[addr + 1];
         raddr         = addr + 2;
     end
 
     3'b010: begin
         hrdata[7:0]   = mem[addr];
         hrdata[15:8]  = mem[addr + 1];
         hrdata[23:16] = mem[addr + 2];
         hrdata[31:24] = mem[addr + 3];
         raddr         = addr + 4;
     end
 endcase
    
return raddr;
 
endfunction
 

///////////////////////////// Wrapping Read, uses the Boundary length ////////////////////////////////////////////////////
function bit[31:0] wrap_rd (input bit [31:0] addr, input bit [7:0] boundary, input [2:0] hsize);
  bit [31:0] addr1, addr2, addr3,addr4;
  
  unique case(hsize)
    3'b000: begin
       hrdata[7:0] = mem[addr];
       
        if((addr + 1) % boundary == 0)
         addr1 = (addr + 1) - boundary;
        else
         addr1 = (addr + 1);
         
       return addr1;  
    end
    
    3'b001: begin
         hrdata[7:0] = mem[addr];
       
        if((addr + 1) % boundary == 0)
         addr1 = (addr + 1) - boundary;
        else
         addr1 = (addr + 1);
         
         hrdata[15:8] = mem[addr1];
         
       if((addr1 + 1) % boundary == 0)
         addr2 = (addr1 + 1) - boundary;
        else
         addr2 = (addr1 + 1);
         
        return addr2;
        
       end
    
    3'b010: begin
        
        hrdata[7:0] = mem[addr];
       
        if((addr + 1) % boundary == 0)
         addr1 = (addr + 1) - boundary;
        else
         addr1 = (addr + 1);
         
        hrdata[15:8] = mem[addr1];
         
       if((addr1 + 1) % boundary == 0)
         addr2 = (addr1 + 1) - boundary;
        else
         addr2 = (addr1 + 1);
         
         hrdata[23:16] = mem[addr2];
        
         if((addr2 + 1) % boundary == 0)
         addr3 = (addr2 + 1) - boundary;
         else
         addr3 = (addr2 + 1); 
         
        hrdata[31:24] = mem[addr3];
        
         if((addr3 + 1) % boundary == 0)
         addr4 = (addr3 + 1) - boundary;
         else
         addr4 = (addr3 + 1); 
       
       return addr4;
    end
    
  
  endcase
  
endfunction
 
//////////////////////////////  Increment mode Read ///////////////////////////////////////////////////////////
function bit[31:0] incr_rd(input bit [31:0] addr, input bit [2:0] hsize);
    
    bit [31:0] raddr;
    
    unique case(hsize)
    
     3'b000: begin
          hrdata[7:0]  = mem[addr];
          raddr        = addr + 1; 
     end
     
     3'b001: begin
         hrdata[7:0]  = mem[addr];
         hrdata[15:8] = mem[addr + 1];
         raddr         = addr + 2;
     end
 
     3'b010: begin
         hrdata[7:0]   = mem[addr];
         hrdata[15:8]  = mem[addr + 1];
         hrdata[23:16] = mem[addr + 2];
         hrdata[31:24] = mem[addr + 3];
         raddr         = addr + 4;
     end
 endcase
 
return raddr;
 
endfunction
 
 
//////////////////////// Defining the state modes ////////////////////////////////////
 
typedef enum  {idle = 0, check_mode = 1, write = 2, read = 3} state_type;
state_type slave_state, next_state;
 
///////////////////////////////// Below starts the FSM working //////////////////////////////////////////////
 
//////////////////////////////////\\\\\\\\\ CHANGING STATE AT EVERY CLOCK \\\\\\\\/////////////////////////////////////////////////
always_ff@(posedge clk)
begin
if(!hresetn)
slave_state <= idle;
else
slave_state <= next_state;
end

 
integer len_count = 0;
reg [31:0] retaddr;
reg [31:0] next_addr;
reg [7:0] wboundary;
 
 
 

always_comb
begin
    case(slave_state)
  
          idle : 
          begin
           
            if (hsel) begin
              next_state = check_mode;
              hready = 1'b0;
              len_count = 0;
            end
           
          end
  
     
     ////////////////////--------------------------------------- WE ARE IN CHECK MODE ---------------------------//////////////////////////////////////////////
          check_mode : 
          begin
                            
                            hready = 1'b0;
                            if(hresetn && hsel)  ///hreadyout
                            begin
                                if(haddr>255)
                                begin
                                    hresp=`ERROR;
                                    next_state= idle;
                                end
                                    
                            
                                else if(htrans == `NON_SEQ)
                                 begin
                                           next_addr = haddr;
                                           hresp=`OKAY;
                                           
                                           if(hwrite)
                                           next_state = write;
                                           else
                                           next_state = read;
                                           
                                           
                                 end 
                                else if (htrans == `SEQ)  
                                 begin
                                         next_addr  = retaddr;
                                         hresp=`OKAY;
                                                
                                               if(hwrite)
                                               next_state = write;
                                               else
                                               next_state = read;
     
                                end
                            
                            end
                            else begin
                                hresp=`OKAY;
                                next_state=idle;
                            end
         
           
          end
  

////////////////////--------------------------------------- WE ARE IN WRITE MODE ---------------------------//////////////////////////////////////////////  
         write:
          begin
               case(hburst)
  
  //////////////////////////Single Write at HADDR //////////////////////////////
                    3'b000: begin 
                       retaddr = single_tr(next_addr,hsize);
                       hready     = 1'b1;
                       next_state = idle;
                       hresp = `OKAY;
                    end
   
   /////////////////////Increment for Unspecified Length ////////////////////////////       
            
                   3'b001: 
                       begin   ////incr mode
                       
                       if(!hwrite) begin
                              next_state=idle;
                              end
                       else begin
                       hready = 1'b1;
                       retaddr = unincr_wr(next_addr, hsize);
                       hresp = `OKAY;      
                       
                       if(len_count < 32)
                          begin
                          len_count = len_count + 1;
                          next_state = check_mode; 
                          end
                       else
                          begin
                          len_count = 0;
                          next_state = idle;
                          end   
                                    
                    end
                    end
                
 //////////////////////////// 4 beat wrapping ////////////////////////////////////////////
 
 
                  3'b010: 
                        begin
                        
                          
                          hready = 1'b1; 
                          wboundary = boundary(hburst, hsize);
                          retaddr   = wrap_wr(next_addr, wboundary, hsize);
                          hresp = `OKAY;
                                
                               
                                 if(len_count <= 2) // 0 1 2 3
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                      end 
        
///////////////////////////////  4 beat Incrementing /////////////////////////////////////////
 
                 3'b011:
                               begin
                               
                                   hready = 1'b1;
                                   retaddr = incr_wr(next_addr, hsize);
                                   hresp = `OKAY;
                                   
                                   if(len_count <= 2)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                                   
                               
                               end    
                               
//////////////////////////////////////////////// 8 beat wrapping //////////////////////////////////////////////
 
 
                  3'b100: 
                      begin
                                          
                                          hready = 1'b1; 
                                          wboundary = boundary(hburst, hsize);
                                          retaddr = wrap_wr(next_addr, wboundary, hsize);
                                          hresp = `OKAY;
                                           
                                   if(len_count <= 6)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                                    end
                                       
 
 ///////////////////////////////////////// 8 beat Incrementing ////////////////////////////////////////
                        3'b101:
                               begin
                                   hready = 1'b1;
                                   retaddr = incr_wr(next_addr, hsize);
                                   hresp = `OKAY;
                                   
                                 if(len_count <= 6)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                               
                               end  
 
 
 ///////////////////////////////////////////////// 16 beat wrapping ///////////////////////////////////////////
 
                       3'b110: 
                          begin
                              
                              hready = 1'b1; 
                              wboundary = boundary(hburst, hsize);
                              retaddr = wrap_wr(next_addr, wboundary, hsize);
                              hresp = `OKAY;
                               
                                 if(len_count <= 14)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                        end
 

 /////////////////////////////////////////// 16 beat increment ///////////////////////////////////////
                            3'b111:
                               begin
                                   hready = 1'b1;
                                   retaddr = incr_wr(next_addr, hsize);
                                   hresp = `OKAY;
                                   
                                 if(len_count <= 14)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                               
                                     end 
       
                 endcase
  end
 
     
////////////////////--------------------------------------- WE ARE IN READ MODE ---------------------------//////////////////////////////////////////////
read : begin
 
               case(hburst)
  
  ///////////////////////////////////////////// Single Write at HADDR ///////////////////////////////////////////
                    3'b000: begin  ////single transfer
                       retaddr = single_tr_rd(haddr,hsize);
                       hready     = 1'b1;
                       next_state = idle;
                       hresp = `OKAY;
                    end
   
   /////////////////////////////////////// INCREMENT for UNSPECIFIED LENGTH ////////////////////////////////////////////////////////      
            
                   3'b001: 
                       begin   ////incr mode
                       if(hwrite) begin
                              next_state=idle;
                              end
                       else begin
                       hready = 1'b1;
                       retaddr = unincr_rd(next_addr, hsize);
                       hresp = `OKAY;
                       
                              
                              if( len_count < 32) 
                              begin
                              len_count = len_count + 1;
                              next_state = check_mode;
                              end
                              else
                              begin
                              len_count = 0;  
                              next_state = idle;
                              end                            
                       end
                       end  
                
 /////////////////////////////////////////////////////// 4 beat wrapping //////////////////////////////////////////////////////
 
 
                  3'b010: 
                        begin
                         
                          hready = 1'b1; 
                          wboundary = boundary(hburst, hsize);
                          retaddr = wrap_rd(next_addr, wboundary, hsize);
                          hresp = `OKAY;
                          
                                   if(len_count <= 2)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end 
                           
                            
                        end 
        
/////////////////////////////// 4 beat Incrementing read /////////////////////////////////////////////////////////
 
                 3'b011:
                               begin
                                   hready = 1'b1;
                                   retaddr = incr_rd(next_addr, hsize);
                                   hresp = `OKAY;
                                   
                                 if(len_count <= 2)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                               
                               end    
                               
//////////////////////////////////////////////// 8 beat wrapping ///////////////////////////////////////////////////////////
 
 
                  3'b100: 
                      begin
                                          
                                          hready = 1'b1; 
                                          wboundary = boundary(hburst, hsize);
                                          retaddr = wrap_rd(next_addr, wboundary, hsize);
                                          hresp = `OKAY;
                                           
                                  if(len_count <= 6)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                                     
                                     
                                    end
                                       

 ///////////////////////////////////////// 8 beat Incrementing ///////////////////////////////////////////////////
                        3'b101:
                               begin
                                   hready = 1'b1;
                                   retaddr = incr_rd(next_addr, hsize);
                                   hresp = `OKAY;
                                   
                                 if(len_count <= 6)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                               
                               end  
 

 ///////////////////////////////////////////////// 16 beat wrapping /////////////////////////////////////////////////////////
 
                       3'b110: 
                          begin
                              
                              hready = 1'b1; 
                              wboundary = boundary(hburst, hsize);
                              retaddr = wrap_rd(next_addr, wboundary, hsize);
                              hresp = `OKAY;
                               
                                  if(len_count <= 14)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                        end
 
 
 /////////////////////////////////////////////////// 16 beat increment ///////////////////////////////////
                            3'b111:
                               begin
                                   hready = 1'b1;
                                   retaddr = incr_rd(next_addr, hsize);
                                   hresp = `OKAY;
                                   
                                 if(len_count <= 14)
                                     begin
                                     len_count = len_count + 1;
                                     next_state = check_mode;
                                     end
                                     else
                                     begin
                                     next_state = idle;
                                     len_count = 0;
                                     end
                               
                                     end 
       
                 endcase
 
end
 
endcase
 
end
endmodule
