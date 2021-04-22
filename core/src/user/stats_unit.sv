// Blank Statistics Unit for TRNG IP Core 2021.03.05 Naoki F., AIT
// ライセンス条件は COPYING ファイルを参照してください

module STATS_UNIT (
    input  logic         CLK, RST_X,
    input  logic         STOP,
    input  logic [15: 0] DATA_IN,
    input  logic         DATA_RE,
    output logic [31: 0] STATS);

    // Write some code if you want to get the statistics of RNG_UNIT/DATA_OUT.
    // If not needed, you can leave this file unchanged.
    assign STATS = 0;
endmodule