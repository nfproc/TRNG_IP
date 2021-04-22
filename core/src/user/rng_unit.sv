// Blank TRNG Unit for TRNG IP Core 2021.03.05 Naoki F., AIT
// ライセンス条件は COPYING ファイルを参照してください

module RNG_UNIT (
    input  logic         CLK, RST_X,
    input  logic         RNG_EN,
    input  logic [31: 0] PARAM,
    output logic [15: 0] DATA_OUT,
    output logic         DATA_EN);

    // Write your TRNG code. Assert DATA_EN if DATA_OUT is valid.
    // Concatenation of DATA_OUT[0] will be sent as random bitstream.
    // If your TRNG is based on a counter, you may output its value as DATA_OUT.
    // Otherwise, set the other bits of DATA_OUT to zero.
    assign DATA_OUT = 16'h0000;
    assign DATA_EN  = 1'b0;
endmodule