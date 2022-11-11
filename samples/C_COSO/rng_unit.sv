// Configurable COSO-based TRNG Unit 2022-11-11 Naoki F., AIT
// Ref: A. Peetermans et al., in FPL 2019, pp. 218-224
// NOTE: Re-implemented by the author. The controller unit for auto
//       calibration, presented in the reference, is not included.
// New BSD License is applied. See COPYING file for details.

module RNG_UNIT (
    input  logic         CLK, RST_X,
    input  logic         RNG_EN,
    input  logic [31: 0] PARAM,
    output logic [15: 0] DATA_OUT,
    output logic         DATA_EN);

    assign DATA_OUT[15: 8] = 8'h00;

    logic CLK_A, CLK_B;

    (* RLOC_ORIGIN = "X40Y80" *)
    cro cro_a (CLK, PARAM[15: 8], RNG_EN, CLK_A);
    (* RLOC_ORIGIN = "X44Y80" *)
    cro cro_b (CLK, PARAM[ 7: 0], RNG_EN, CLK_B);

    COUNTER cnt (CLK, ~RST_X, CLK_A, CLK_B, DATA_OUT[7:0], DATA_EN);

endmodule