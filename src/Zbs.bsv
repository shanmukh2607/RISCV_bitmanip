//See LICENSE.iitm for license details
/*

Author : Bachotti Sai Krishna Shanmukh
Email id : ee19b009@smail.iitm.ac.in
Details: Holds the functions to implement single-bit operations to set, clear,
         invert, extract a single bit the register. For regular instructions, 
         the value of index is taken from least significant log2(XLEN) bits of 
         rs2 and for immediate instructions shamt = instr[25:20 (instr[25] is 
         reserved in case of RV32).
--------------------------------------------------------------------------------------------------
*/

// Instruction: bclr
// Function: Clears the bit present in ith position of rs1 to 0. The value of
//           i comes from lsb log2(XLEN) bits of rs2.
function Bit#(XLEN) fn_bclr(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) one = 1;       
  return rs1 & ~(one << (rs2 & fromInteger(valueOf(XLEN) - valueOf(1))));
endfunction

// Instruction: bclri
// Function: Clears the bit present in ith position of rs1 to 0. The value of
//           i comes from lsb log2(XLEN) bits of shamt.
function Bit#(XLEN) fn_bclri(Bit#(XLEN) rs1, Bit#(32) instr);
  Bit#(XLEN) one = 1; 
  return rs1 & ~(one << (instr[25:20] & fromInteger(valueOf(XLEN) - valueOf(1))));
endfunction

// Instruction: bext
// Function: Extracts the bit present in ith position of rs1. The value of
//           i comes from lsb log2(XLEN) bits of rs2.
function Bit#(XLEN) fn_bext(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) one = 1;
  return (rs1 >> (rs2 & fromInteger(valueOf(XLEN) - valueOf(1)))) & one;
endfunction

// Instruction: bexti
// Function: Extracts the bit present in ith position of rs1. The value of
//           i comes from lsb log2(XLEN) bits of shamt.
function Bit#(XLEN) fn_bexti(Bit#(XLEN) rs1, Bit#(32) instr);
  Bit#(XLEN) one = 1;
  return (rs1 >> (instr[25:20] & fromInteger(valueOf(XLEN) - valueOf(1)))) & one;
endfunction

// Instruction: binv
// Function: Inverts the bit present in ith position of rs1. The value of
//           i comes from lsb log2(XLEN) bits of rs2.
function Bit#(XLEN) fn_binv(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) one = 1; 
  return rs1 ^ (one << (rs2 & fromInteger(valueOf(XLEN) - valueOf(1))));
endfunction

// Instruction: binvi
// Function: Inverts the bit present in ith position of rs1. The value of
//           i comes from lsb log2(XLEN) bits of shamt.
function Bit#(XLEN) fn_binvi(Bit#(XLEN) rs1, Bit#(32) instr);
  Bit#(XLEN) one = 1; 
  return rs1 ^ (one << (instr[25:20] & fromInteger(valueOf(XLEN) - valueOf(1))));
endfunction

// Instruction: bset
// Function: Sets the bit present in ith position to 1 The value of
//           i comes from lsb log2(XLEN) bits of rs2.
function Bit#(XLEN) fn_bset(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) one = 1; 
  return rs1 | (one << (rs2 & fromInteger(valueOf(XLEN) - valueOf(1))));
endfunction

// Instruction: bseti
// Function: Sets the bit present in ith position to 1 The value of
//           i comes from lsb log2(XLEN) bits of shamt.
function Bit#(XLEN) fn_bseti(Bit#(XLEN) rs1, Bit#(32) instr);
  Bit#(XLEN) one = 1; 
  return rs1 | (one << (instr[25:20] & fromInteger(valueOf(XLEN) - valueOf(1))));
endfunction