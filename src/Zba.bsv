//See LICENSE.iitm for license details
/*

Author : Niranjan Nair
Email id : ee19b046@smail.iitm.ac.in
Details: 	Holds the instructions to accelerate address generation for indexing 
            into arrays of basic types by computing base + offset for different 
			cases. 
--------------------------------------------------------------------------------------------------
*/

// Instruction: adduw, Defined only for RV64
// Function: Performs XLEN-wide addition b/w rs2 and zero-extended least 
//			 significant word of rs1. 
`ifdef RV64 
	function Bit#(XLEN) fn_adduw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
	  return rs2 + {32'b0,rs1[31:0]};
	endfunction
`endif

// Instruction: sh1add
// Function: Shifts rs1 to the left by 1 bit and adds it to rs2
function Bit#(XLEN) fn_sh1add(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + (rs1<<1);
endfunction

// Instruction: sh1add.uw, Defined only for RV64
// Function: Performs XLEN-wide addition b/w rs2 and zero-extended least 
//			 significant word of rs1 left shifted by 1. 
`ifdef RV64 
	function Bit#(XLEN) fn_sh1adduw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
	  return rs2 + ({32'b0,rs1[31:0]}<<1);
	endfunction
`endif

// Instruction: sh2add
// Function: Shifts rs1 to the left by 2 bits and adds it to rs2
function Bit#(XLEN) fn_sh2add(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + (rs1<<2);
endfunction

// Instruction: sh2add.uw, Defined only for RV64
// Function: Performs XLEN-wide addition b/w rs2 and zero-extended least 
//			 significant word of rs1 left shifted by 2. 
`ifdef RV64 
	function Bit#(XLEN) fn_sh2adduw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
	  return rs2 + ({32'b0,rs1[31:0]}<<2);
	endfunction
`endif

// Instruction: sh3add
// Function: Shifts rs1 to the left by 3 bits and adds it to rs2
function Bit#(XLEN) fn_sh3add(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + (rs1<<3);
endfunction

// Instruction: sh3add.uw, Defined only for RV64
// Function: Performs XLEN-wide addition b/w rs2 and zero-extended least 
//			 significant word of rs1 left shifted by 3. 
`ifdef RV64 
	function Bit#(XLEN) fn_sh3adduw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
	  return rs2 + ({32'b0,rs1[31:0]}<<3);
	endfunction
`endif

// Instruction: slli.uw, Defined only for RV64
// Function: Left shifts the zero-extened least significant word of rs1 by shamt 
`ifdef RV64 
	function Bit#(XLEN) fn_slliuw(Bit#(XLEN) rs1, Bit#(32) instr);
	  return {32'b0,rs1[31:0]}<<instr[25:20];
	endfunction
`endif

