//See LICENSE.iitm for license details
/*

Author : Bachotti Sai Krishna Shanmukh, Niranjan Nair
Email id : ee19b046@smail.iitm.ac.in
Details: Holds the functions to implement carry-less multiplication.
--------------------------------------------------------------------------------------------------
*/

// Instruction: clmul
// Function: The instruction produces the lower half of the 2-XLEN carry-less products
function Bit#(XLEN) fn_clmul(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) result = 0; 
  Bit#(XLEN) cond;
  for(Integer i = 0; i < valueOf(XLEN); i = i + 1) begin 
    cond = (rs2 >> i) & fromInteger(valueOf(1));
    if(cond[0] == 1)
      result = result ^ (rs1 << i);
  end 
  return result;
endfunction

// Instruction: clmulh
// Function: The instruction produces the upper half of the 2-XLEN carry-less products
function Bit#(XLEN) fn_clmulh(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) result = 0;
  Bit#(XLEN) cond; 
  for(Integer i = 1; i < valueOf(XLEN); i = i + 1) begin 
    cond = (rs2 >> i) & fromInteger(valueOf(1)); 
    if(cond[0] == 1)
      result = result ^ (rs1 >> (valueOf(XLEN) - i));
  end 
  return result;
endfunction

// Instruction: clmulh
// Function: The instruction produces the bits 2XLEN-2:XLEN-1 of the 2-XLEN carry-less products
function Bit#(XLEN) fn_clmulr(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) result = 0; 
  for(Integer i = 0; i < valueOf(XLEN); i = i + 1) begin 
    if(((rs2 >> i) & fromInteger(valueOf(1))) != fromInteger(valueOf(0)))
      result = result ^ (rs1 >> (valueOf(XLEN) - i - valueOf(1)));
  end 
  return result;
endfunction