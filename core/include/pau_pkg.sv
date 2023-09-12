// Copyright 2023 Raul Murillo
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Author: Raul Murillo <ramuri01@ucm.es>


package pau_pkg;

  // --------------
  // PAU OPERATIONS
  // --------------
  localparam int unsigned OP_BITS = 4;

  typedef enum logic [OP_BITS-1:0] {
    PADD, PSUB, PMUL, PDIV, PSQRT,     // Computational Instructions
    QMADD, QMSUB, QCLR, QNEG, QROUND,  // Quire Instructions
    PCVT_P2I, PCVT_P2L, PCVT_P2U, PCVT_P2LU, PCVT_I2P, PCVT_L2P, PCVT_U2P, PCVT_LU2P, // Conversion Instructions
    PSGNJ, PSGNJN, PSGNJX, PMV_P2X, PMV_X2P  // Move Instructions
  } operation_e;

  // ------------------
  // FPU configuration
  // ------------------

  // PAU configuration: features
  typedef struct packed {
    int unsigned Width;
    int unsigned PositLength;
    logic        EnablePAU;
    logic        EnableQuire;
    logic        EnableApproxMult;
    logic        EnableApproxDiv;
    logic        EnableApproxSqrt;
    // logic        EnableVectors;
    // logic        EnableNanBox;
    // fmt_logic_t  FpFmtMask;
    // ifmt_logic_t IntFmtMask;
  } pau_features_t;

  localparam pau_features_t RV64 = '{
    Width:             64,
    EnablePAU:         1'b1,
    EnableQuire:       1'b1,
    EnableApproxMult:  1'b0,
    EnableApproxDiv:   1'b0,
    EnableApproxSqrt:  1'b0
  };

  localparam fpu_features_t RV32 = '{
    Width:             32,
    EnablePAU:         1'b1,
    EnableQuire:       1'b1,
    EnableApproxMult:  1'b0,
    EnableApproxDiv:   1'b0,
    EnableApproxSqrt:  1'b0
  };

//   // PAU configuraion: implementation
//   typedef struct packed {
//     opgrp_fmt_unsigned_t   PipeRegs;
//     opgrp_fmt_unit_types_t UnitTypes;
//     pipe_config_t          PipeConfig;
//   } fpu_implementation_t;

endpackage