//See LICENSE.iitm for license details
/*

Author : Mouna Krishna
Email id : mounakrishna@mindgrovetech.in
Details: The top function which calls the required function depending 
         on the instruction.

Edited by : Bachotti Sai Krishna Shanmukh, 
            Sai Gautham Ravipati, 
            Niranjan Nair 
--------------------------------------------------------------------------------------------------
*/

/****** Imports *******/
`include "bbox.defines"
import bbox_types :: *;
`include "Zba.bsv"
`include "Zbb.bsv"
`include "Zbc.bsv"
`include "Zbs.bsv"
/*********************/


/* 
  fn_compute: is the TOP FUNCTION where depending on the instruction the 
  required function is called, result is computed and returned.
  The output of the function is 1b valid signal and XLEN width result

  Consider an example instruction ANDN of the Zbb group that has been implemented.
  The 32b instruction format of ANDN is defined in bbox.defines and case statement matches 
  when instr is of type ANDN.

  Similarly all instruction groups like Zba, Zbb, Zbc, Zbs are defined and called in 
  fn_compute appropriately

  ifdef directive is used for some cases in the 'case ladder' if that instruction is defined only 
  for RV64 mode
*/

function BBoxOutput fn_compute(BBoxInput inp);
  Bit#(XLEN) result;
  Bool valid;
  case(inp.instr) matches
    //ADDUW is defined only in RV64
    `ifdef RV64
      `ADDUW: begin
        result = fn_adduw(inp.rs1, inp.rs2);
        valid = True;
      end
    `endif 

    //ANDN
    `ANDN: begin
      result = fn_andn(inp.rs1, inp.rs2);
      valid = True;
    end

    //BLCR 
    `BCLR: begin
      result = fn_bclr(inp.rs1, inp.rs2);
      valid = True;
    end

    //BEXT
    `BEXT: begin
      result = fn_bext(inp.rs1, inp.rs2);
      valid = True;
    end

    //BINV
    `BINV: begin
      result = fn_binv(inp.rs1, inp.rs2);
      valid = True;
    end

    //BSET
    `BSET: begin
      result = fn_bset(inp.rs1, inp.rs2);
      valid = True;
    end

    // BCLRI
    `ifdef RV32
    // In RV32 mode
      `BCLRI: begin
        if(inp.instr[25] == 1'b0) begin
          result = fn_bclri(inp.rs1, inp.instr);
          valid = True;
        end
        // if shamt[5] == 1 in RV32 then don't implement
        else begin
          result = 0;
          valid = True;
        end
      end
    `endif

    `ifdef RV64
    // In RV64 mode
      `BCLRI: begin  
          result = fn_bclri(inp.rs1, inp.instr);
          valid = True;
      end
    `endif
    
    //BEXTI
    `ifdef RV32
    // In RV32 mode
      `BEXTI: begin
        if(inp.instr[25] == 1'b0) begin
          result = fn_bexti(inp.rs1, inp.instr);
          valid = True;
        end
        // if shamt[5] == 1 in RV32 then dont implement
        else begin
          result = 0;
          valid = True;
        end
      end
    `endif

    `ifdef RV64
    // In RV64 mode
      `BEXTI: begin  
          result = fn_bexti(inp.rs1, inp.instr);
          valid = True;
      end
    `endif

    // BINVI
    `ifdef RV32
    // In RV32 mode
      `BINVI: begin
        if(inp.instr[25] == 1'b0) begin
          result = fn_binvi(inp.rs1, inp.instr);
          valid = True;
        end
        // if shamt[5] == 1 in RV32 then dont implement
        else begin
          result = 0;
          valid = True;
        end
      end
    `endif

    `ifdef RV64
    // In RV64 mode
      `BINVI: begin  
          result = fn_binvi(inp.rs1, inp.instr);
          valid = True;
      end
    `endif

    //BSETI
    `ifdef RV32
    // In RV32 mode
      `BSETI: begin
        if(inp.instr[25] == 1'b0) begin
          result = fn_bseti(inp.rs1, inp.instr);
          valid = True;
        end
        // if shamt[5] == 1 in RV32 then dont implement
        else begin
          result = 0;
          valid = True;
        end
      end
    `endif

    `ifdef RV64
    // In RV64 mode
      `BSETI: begin  
          result = fn_bseti(inp.rs1, inp.instr);
          valid = True;
      end
    `endif

    // CLMUL
    `CLMUL : begin
      result = fn_clmul(inp.rs1, inp.rs2);
      valid = True;
    end

    // CLMULH
    `CLMULH : begin
      result = fn_clmulh(inp.rs1, inp.rs2);
      valid = True;
    end

    // CLMULR
    `CLMULR : begin
      result = fn_clmulr(inp.rs1, inp.rs2);
      valid = True;
    end

    // CLZ
    `CLZ : begin
      result = fn_clz(inp.rs1);
      valid = True;
    end

    // CLZW is defined in RV64 mode only
    `ifdef RV64
    `CLZW : begin
        result = fn_clzw(inp.rs1);
        valid = True;
    end
    `endif

    // CPOP
    `CPOP : begin
      result = fn_cpop(inp.rs1);
      valid = True;
    end

    // CPOPW is defined in RV64 mode only
    `ifdef RV64
    `CPOPW : begin
        result = fn_cpopw(inp.rs1);
        valid = True;
    end
    `endif

    // CTZ
    `CTZ : begin
      result = fn_ctz(inp.rs1);
      valid = True;
    end

    // CTZW is defined in RV64 mode only
    `ifdef RV64
    `CTZW : begin
        result = fn_ctzw(inp.rs1);
        valid = True;
    end
    `endif

    // MAX
    `MAX : begin
      result = fn_max(inp.rs1, inp.rs2);
      valid = True;
    end

    // MAXU
    `MAXU : begin
      result = fn_maxu(inp.rs1, inp.rs2);
      valid = True;
    end

    // MIN
    `MIN : begin
      result = fn_min(inp.rs1, inp.rs2);
      valid = True;
    end
    
    // MINU
    `MINU : begin
      result = fn_minu(inp.rs1, inp.rs2);
      valid = True;
    end

    // ORCB
    `ORCB : begin
      result = fn_orcb(inp.rs1);
      valid = True;
    end

    // ORN
    `ORN : begin
      result = fn_orn(inp.rs1, inp.rs2);
      valid = True;
    end

    // REV8 opcodes are different in RV32 and RV64 mode by a bit
    `ifdef RV32
      //RV32 mode
      `REV8: begin
        if(inp.instr[25] == 0) begin
            result = fn_rev8(inp.rs1);
            valid = True;
        end
        else begin
          result = 0;
          valid = True;
        end
      end
    `endif

    `ifdef RV64
      // RV64 mode
      `REV8: begin
        if(inp.instr[25] == 1) begin
            result = fn_rev8(inp.rs1);
            valid = True;
        end
        else begin
          result = 0;
          valid = True;
        end
      end
    `endif

    `ROL: begin
      result = fn_rol(inp.rs1, inp.rs2);
      valid = True;
    end

    `ifdef RV64
    //ROLW defined in RV64 mode only
    `ROLW : begin
        result = fn_rolw(inp.rs1, inp.rs2);
        valid = True;
    end
    `endif

    `ROR: begin
      result = fn_ror(inp.rs1, inp.rs2);
      valid = True;
    end

    // RORI
    `ifdef RV32
      // RV32 mode
      `RORI: begin
        if(inp.instr[25] == 1'b0) begin
          result = fn_rori(inp.rs1, inp.instr);
          valid = True;
        end
        // if shamt[5] == 1 in RV32 then dont implement
        else begin
          result = 0;
          valid = True;
        end
      end
    `endif

    `ifdef RV64
      // RV64 mode
      `RORI: begin  
          result = fn_rori(inp.rs1, inp.instr);
          valid = True;
      end
    `endif

    `ifdef RV64
    // RORIW defined in RV64 mode
    `RORIW : begin
        result = fn_roriw(inp.rs1, inp.instr);
        valid = True;
    end
    `endif

    `ifdef RV64
    // RORW defined in RV64 mode
    `RORW : begin
        result = fn_rorw(inp.rs1, inp.rs2);
        valid = True;
    end
    `endif

    // SEXTB
    `SEXTB : begin
      result = fn_sextb(inp.rs1);
      valid = True;
    end

    // SEXTH
    `SEXTH : begin
      result = fn_sexth(inp.rs1);
      valid = True;
    end
    // SH1ADD
    `SH1ADD : begin
      result = fn_sh1add(inp.rs1, inp.rs2);
      valid = True;
    end

    `ifdef RV64
    // SH1ADDUW defined in RV64 mode
    `SH1ADDUW : begin
        result = fn_sh1adduw(inp.rs1, inp.rs2);
        valid = True;
    end
    `endif
    // SH2ADD
    `SH2ADD : begin
      result = fn_sh2add(inp.rs1, inp.rs2);
      valid = True;
    end

    `ifdef RV64
    // SH2ADDUW defined in RV64 mode
    `SH2ADDUW : begin
        result = fn_sh2adduw(inp.rs1, inp.rs2);
        valid = True;
    end
    `endif

    // SH3ADD
    `SH3ADD : begin
      result = fn_sh3add(inp.rs1, inp.rs2);
      valid = True;
    end

    `ifdef RV64
    // SH3ADDUW defined in RV64 mode only
    `SH3ADDUW : begin
        result = fn_sh3adduw(inp.rs1, inp.rs2);
        valid = True;
    end
    `endif

    `ifdef RV64
    // SLLIUW defined in RV64 mode only
    `SLLIUW : begin
        result = fn_slliuw(inp.rs1, inp.instr);
        valid = True;
    end
    `endif
    
    `XNOR : begin
      result = fn_xnor(inp.rs1,inp.rs2);
      valid = True;
    end

    // ZEXTH opcode is different in RV32 and 64 by a bit
    `ifdef RV32
      // RV32 mode
      `ZEXTH : begin
        if(inp.instr[3] == 0) begin
        result = fn_zexth(inp.rs1);
        valid = True;
        end
        else begin
        result = 0;
        valid = True;
        end
      end
    `endif

    `ifdef RV64
    // RV64 mode
      `ZEXTH : begin
        if(inp.instr[3] == 1'b1) begin
        result = fn_zexth(inp.rs1);
        valid = True;
        end
        else begin
        result = 0;
        valid = True;
        end
      end
    `endif
    // default case 

    default: begin
      result = 0;
      valid = False;
    end
  endcase
  return BBoxOutput{valid: valid, data: result};
endfunction
