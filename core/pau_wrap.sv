// Copyright 2023 Raul Murillo.
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Raul Murillo <ramuri01@ucm.es>
// Date: 11.09.2023
// Description: Posit Arithmetic Unit wrapper for the CVA6 core

module pau_ariane_wrapper 
import ariane_pkg::*;
// import pau_pkg::*;
(
    input  logic                     clk_i,          // Clock
    input  logic                     rst_ni,         // Asynchronous reset active low
    input  fu_data_t                 fu_data_i,
    input  logic                     pau_valid_i,
    output logic                     pau_ready_o,
    output logic [TRANS_ID_BITS-1:0] pau_trans_id_o,
    output logic                     pau_valid_o,
    output riscv::xlen_t             result_o
);


    //-----------------------------------
    // PAU config from PAU package
    //-----------------------------------

    // Features -- given by the core configuration
    localparam pau_pkg::pau_features_t PAU_FEATURES = '{
        Width:            riscv::XLEN, // parameterized using XLEN
        PositLength:      ariane_pkg::POSLEN,
        EnablePAU:        ariane_pkg::POS_PRESENT,
        EnableQuire:      ariane_pkg::QUIRE_PRESENT,
        EnableApproxMult: ariane_pkg::POS_LOG_MULT,
        EnableApproxDiv:  ariane_pkg::POS_LOG_DIV,
        EnableApproxSqrt: ariane_pkg::POS_LOG_SQRT
    };

    
    //-------------------------------------------------
    // Inputs to the PAU 
    //-------------------------------------------------
    logic [1:0][POSLEN-1:0] pau_operands;
    pau_pkg::operation_e pau_op;
    logic [TRANS_ID_BITS-1:0] pau_tag;

    //-----------------------------
    // Translate inputs
    //-----------------------------

    always_comb begin : input_translation
        // Default Values
        pau_operands[0]  = fu_data_i.operand_a;
        pau_operands[0]  = fu_data_i.operand_b;

        pau_tag = fu_data_i.trans_id;
        
        // Operations
        unique case (fu_data_i.operator)
            // Computational Instructions
            ariane_pkg::PADD: begin    
                pau_op = pau_pkg::PADD;
            end
            ariane_pkg::PSUB: begin    
                pau_op = pau_pkg::PSUB;
            end
            ariane_pkg::PMUL: begin  
                pau_op = pau_pkg::PMUL;
            end
            ariane_pkg::PDIV: begin  
                pau_op = pau_pkg::PDIV;
            end
            ariane_pkg::PSQRT: begin  
                pau_op = pau_pkg::PSQRT;
            end
            // Conversion Instructions
            ariane_pkg::PCVT_P2I: begin  
                pau_op = pau_pkg::PCVT_P2I;
            end
            ariane_pkg::PCVT_P2L: begin  
                pau_op = pau_pkg::PCVT_P2L;
            end
            ariane_pkg::PCVT_P2U: begin  
                pau_op = pau_pkg::PCVT_P2U;
            end
            ariane_pkg::PCVT_P2LU: begin  
                pau_op = pau_pkg::PCVT_P2LU;
            end
            ariane_pkg::PCVT_I2P: begin  
                pau_op = pau_pkg::PCVT_I2P;
            end
            ariane_pkg::PCVT_L2P: begin  
                pau_op = pau_pkg::PCVT_L2P;
            end
            ariane_pkg::PCVT_U2P: begin  
                pau_op = pau_pkg::PCVT_U2P;
            end
            ariane_pkg::PCVT_LU2P: begin  
                pau_op = pau_pkg::PCVT_LU2P;
            end
            // Move Instructions
            ariane_pkg::PSGNJ: begin  
                pau_op = pau_pkg::PSGNJ;
            end
            ariane_pkg::PSGNJN: begin  
                pau_op = pau_pkg::PSGNJN;
            end
            ariane_pkg::PSGNJX: begin  
                pau_op = pau_pkg::PSGNJX;
            end
            ariane_pkg::PMV_P2X: begin  
                pau_op = pau_pkg::PMV_P2X;
            end
            ariane_pkg::PMV_X2P: begin  
                pau_op = pau_pkg::PMV_X2P;
            end
            default: ; // default case to suppress unique warning
        endcase

        if (ariane_pkg::QUIRE_PRESENT) begin
            // Quire Instructions
            unique case (fu_data_i.operator)
                ariane_pkg::QMADD: begin    
                    pau_op = pau_pkg::QMADD;
                end
                ariane_pkg::QMSUB: begin    
                    pau_op = pau_pkg::QMSUB;
                end
                ariane_pkg::QCLR: begin  
                    pau_op = pau_pkg::QCLR;
                end
                ariane_pkg::QNEG: begin  
                    pau_op = pau_pkg::QNEG;
                end
                ariane_pkg::QROUND: begin  
                    pau_op = pau_pkg::QROUND;
                end
                default: ; // default case to suppress unique warning
            endcase
        end
    end

    //---------------
    // PAU instance
    //---------------
    pau_top #(
        .Features       ( PAU_FEATURES              ),
        .TagType        ( logic [TRANS_ID_BITS-1:0] )
    ) i_pau_top (
        .clk_i,
        .rst_ni,
        .operands_i     ( pau_operands              ),
        .op_i           ( pau_op                    ),
        .pau_trans_id_i ( pau_tag                   ),
        .pau_valid_i,
        .pau_ready_o,
        .pau_trans_id_o,
        .pau_valid_o,
        .result_o
    );

    //-------------------------------------------------
    // Output PAU accomodation
    //-------------------------------------------------

    // Nothing to do



endmodule