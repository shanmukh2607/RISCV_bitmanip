//See LICENSE.iitm for license details
/*

Author : Sai Gautham Ravipati, Bachotti Sai Krishna Shanmukh
Email id : sai.gautham@smail.iitm.ac.in
Details: Holds the functions to implement basic bit manupulation operations 
         like: 
          1 - Logical with negate 
          2 - Count leading/trailing zeros 
          3 - Count population 
          4 - Maximum/Minimum of integers
          5 - Sign and Zero extension
         On synthesis and scheduling these functions perform the corresponding 
         combinational processing for each of the instruction types. A given 
         function is valid for both RV32/RV64 unless explicitly defined. Inbuilt 
         methods like SignExtend, ZeroExtend and Counting have been used. 
--------------------------------------------------------------------------------------------------
*/

// Instruction: andn 
// Function: The instruction performs the bitwise logical AND b/w rs1 and negated rs2.
function Bit#(XLEN) fn_andn(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs1 & ~rs2;
endfunction

// Instruction: clz
// Function: Counts the number of 0's before the first 1 starting at MSB. Inbuilt funcs, 
//           have been used to count and appropriately extend the result. 0 -> XLEN, and
//           a number with MSB as 1, gives 0. 
function Bit#(XLEN) fn_clz(Bit#(XLEN) rs1); 
  return pack(zeroExtend(countZerosMSB(rs1)));
endfunction 

// Instruction: clzw, Defined only for RV64
// Function: Counts the number of 0's before the first 1 in a 32-bit word of 64 bit input. 
//           Input being 0 -> 32, and if rs1[31] is 1, the result is 0. 
`ifdef RV64
  function Bit#(XLEN) fn_clzw(Bit#(XLEN) rs1);
    return pack(zeroExtend(countZerosMSB(rs1[31:0]))); 
  endfunction 
`endif

// Instruction: cpop
// Function: Counts the number of bits set to 1 in the source register. 
function Bit#(XLEN) fn_cpop(Bit#(XLEN) rs1);
  return pack(zeroExtend(countOnes(rs1)));
endfunction 

// Instruction: cpopw, Defined only for RV64
// Function: Counts the number of bits set to 1 in least significant word of 64 bit register. 
`ifdef RV64 
  function Bit#(XLEN) fn_cpopw(Bit#(XLEN) rs1);
    return pack(zeroExtend(countOnes(rs1[31:0])));
  endfunction
`endif

// Instruction: clz
// Function: Counts the number of trailing zeros before the first 1 starting from the LSB. 
//           Input 0 gives XLEN, while and input of 1 gives 0. 
function Bit#(XLEN) fn_ctz(Bit#(XLEN) rs1); 
  return pack(zeroExtend(countZerosLSB(rs1)));
endfunction 

// Instruction: ctzw, Defined only for RV64
// Function: Counts the number of trailing zeros before the first 1 starting from the LSB, 
//           in the least significant word of 64 bit input. Input 0 gives 32, while 1 -> 0.
`ifdef RV64 
  function Bit#(XLEN) fn_ctzw(Bit#(XLEN) rs1); 
    return pack(zeroExtend(countZerosLSB(rs1[31:0])));
  endfunction 
`endif 

// Instruction: max
// Function: Returns the signed maximum of rs1 and rs2. 
function Bit#(XLEN) fn_max(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Int#(XLEN) element1 = unpack(rs1);
  Int#(XLEN) element2 = unpack(rs2);
  return pack(max(element1, element2)); 
endfunction

// Instruction: maxu
// Function: Returns the unsigned maximum of rs1 and rs2. 
function Bit#(XLEN) fn_maxu(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  UInt#(XLEN) element1 = unpack(rs1);
  UInt#(XLEN) element2 = unpack(rs2);
  return pack(max(element1, element2)); 
endfunction

// Instruction: min
// Function: Returns the signed minimum of rs1 and rs2.
function Bit#(XLEN) fn_min(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Int#(XLEN) element1 = unpack(rs1);
  Int#(XLEN) element2 = unpack(rs2);
  return pack(min(element1, element2));
endfunction

// Instruction: minu
// Function: Returns the unsigned minimum of rs1 and rs2.
function Bit#(XLEN) fn_minu(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  UInt#(XLEN) element1 = unpack(rs1);
  UInt#(XLEN) element2 = unpack(rs2); 
  return pack(min(element1, element2));
endfunction

// Instruction: orcb
// Function: Combines the bits within each byte using logical OR. If the bit is set then
//           the byte is replaced by all ones or else it is replaced by 0 in the output.
function Bit#(XLEN) fn_orcb(Bit#(XLEN) rs1); 
  Bit#(XLEN) result = 0; 
  for(Integer i = 0; i < valueOf(XLEN); i = i + 8) begin 
    if(rs1[i+7:i] == 8'b00000000)
      result[i+7:i] = 8'b00000000; 
    else
      result[i+7:i] = 8'b11111111; 
  end 
  return result;
endfunction 


// Instruction: orn
// Function: The instruction performs the bitwise logical OR b/w rs1 and negated rs2.
function Bit#(XLEN) fn_orn(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs1 | ~rs2;
endfunction

// Instruction: rev8 
// Function: The instruction reverses the order of bytes in the source register. 
function Bit#(XLEN) fn_rev8(Bit#(XLEN) rs1);
  Bit#(XLEN) result = 0; 
  Bit#(8) temp_byte; 
  Integer j = valueOf(XLEN) - 1;
  for(Integer i = 0; i < valueOf(XLEN); i = i + 8) begin 
    temp_byte = rs1[j:j-7];
    result[i+7:i] = temp_byte;
    j = j - 8; 
  end 
  return result; 
endfunction 

// Instruction: rol
// Function: The instruction performs rotate left of rs1 by the considering log2(XLEN) 
//           bits of rs2 as the shift amount.
function Bit#(XLEN) fn_rol(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) result;
  UInt#(8) shamt; 
  if(valueOf(XLEN) == 32)
    shamt = unpack(zeroExtend(rs2[4:0])); 
  else
    shamt = unpack(zeroExtend(rs2[5:0])); 
  result = (rs1 << shamt) | (rs1 >> (fromInteger(valueOf(XLEN)) - shamt)); 
  return result; 
endfunction

// Instruction: rolw, Defined only for RV64
// Function: The instruction performs rotate left of least significant word of rs1 by 
//           considering 5 bits of rs2 as the shift amount. Sign-extends the result to 
//           obtain a 64 bit value. 
`ifdef RV64 
  function Bit#(XLEN) fn_rolw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(XLEN) result;
    Bit#(32) op1 = rs1[31:0];
    UInt#(6) shamt = unpack(zeroExtend(rs2[4:0])); 
    result = signExtend((op1 << shamt) | (op1 >> (fromInteger(valueOf(32)) - shamt))); 
    return result;
  endfunction
`endif 

// Instruction: ror
// Function: The instruction performs rotate right of rs1 by the considering log2(XLEN) 
//           bits of rs2 as the shift amount.
function Bit#(XLEN) fn_ror(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) result;
  UInt#(8) shamt; 
  if(valueOf(XLEN) == 32)
    shamt = unpack(zeroExtend(rs2[4:0])); 
  else
    shamt = unpack(zeroExtend(rs2[5:0])); 
  result = (rs1 >> shamt) | (rs1 << (fromInteger(valueOf(XLEN)) - shamt)); 
  return result; 
endfunction

// Instruction: rori
// Function: The instruction performs rotate right of rs1 by considering shamt from the
//           instruction. shamt[5] (instr[25]) being 1 is reserved for RV32 type. 
function Bit#(XLEN) fn_rori(Bit#(XLEN) rs1, Bit#(32) instr);
  Bit#(XLEN) result;
  UInt#(8) shamt; 
  if(valueOf(XLEN) == 32)
    shamt = unpack(zeroExtend(instr[24:20])); 
  else
    shamt = unpack(zeroExtend(instr[25:20])); 
  result = (rs1 >> shamt) | (rs1 << (fromInteger(valueOf(XLEN)) - shamt)); 
  return result; 
endfunction

// Instruction: roriw, Defined only for RV64
// Function: The instruction performs rotate right of least significant word of rs1 by 
//           considering 5-bit shamt from the instruction. 
`ifdef RV64 
  function Bit#(XLEN) fn_roriw(Bit#(XLEN) rs1, Bit#(32) instr);
    Bit#(XLEN) result;
    UInt#(6) shamt = unpack(zeroExtend(instr[24:20])); 
    Bit#(32) op1 = rs1[31:0]; 
    result = signExtend((op1 >> shamt) | (op1 << (fromInteger(valueOf(32)) - shamt))); 
    return result; 
  endfunction
`endif

// Instruction: rolw, Defined only for RV64
// Function: The instruction performs rotate right of least significant word of rs1 by 
//           considering 5 bits of rs2 as the shift amount. Sign-extends the result to 
//           obtain a 64 bit value. 
`ifdef RV64
  function Bit#(XLEN) fn_rorw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(XLEN) result;
    UInt#(6) shamt = unpack(zeroExtend(rs2[4:0])); 
    Bit#(32) op1 = rs1[31:0]; 
    result = signExtend((op1 >> shamt) | (op1 << (fromInteger(valueOf(32)) - shamt))); 
    return result;
  endfunction
`endif 

// Instruction: sextb
// Function: Sign extends the least significant byte (8 bits) in rs1
function Bit#(XLEN) fn_sextb(Bit#(XLEN) rs1);
  return signExtend(rs1[7:0]);
endfunction

// Instruction: sexth
// Function: Sign extends the least significant half-word (16 bits) in rs1
function Bit#(XLEN) fn_sexth(Bit#(XLEN) rs1);
  return signExtend(rs1[15:0]);
endfunction

// Instruction: xnor
// Function: Computes bitwise exclusive-nor of rs1 and rs2
function Bit#(XLEN) fn_xnor(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return ~(rs1 ^ rs2);
endfunction

// Instruction: zexth
// Function: Zero extends the least significant half-word (16 bits) in rs1
function Bit#(XLEN) fn_zexth(Bit#(XLEN) rs1);
  return zeroExtend(rs1[15:0]);
endfunction