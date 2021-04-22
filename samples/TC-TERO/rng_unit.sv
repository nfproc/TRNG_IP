// TC-TERO TRNG Unit 2021.03.04 Naoki F., AIT
// (derived from FPL version on 2019.10.24)
// ライセンス条件は COPYING ファイルを参照してください

module RNG_UNIT (
    input  logic         CLK, RST_X,
    input  logic         RNG_EN,
    input  logic [31: 0] PARAM,
    output logic [15: 0] DATA_OUT,
    output logic         DATA_EN);

    logic ctr;

    assign DATA_OUT[15: 8] = 8'h00;

    (* RLOC_ORIGIN = "X24Y25" *)
    tero_rng RNG (
        .CLK_100M(CLK),
        .CTR     (ctr),
        .RO_SEL  (PARAM[19:0]),
        .OUT     (DATA_OUT[7:0]),
        .OE      (DATA_EN));

    always_ff @ (posedge CLK) begin
        if (~ RST_X) begin
            ctr <= 1'b0;
        end else if (~ ctr & RNG_EN) begin
            ctr <= 1'b1;
        end else if (ctr & DATA_EN) begin
            ctr <= 1'b0;
        end
    end
endmodule