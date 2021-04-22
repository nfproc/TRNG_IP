// Latch-Latch TRNG Unit 2021.03.08 Naoki F., AIT
// (derived from ELEX version in 2018.03)
// ライセンス条件は COPYING ファイルを参照してください

module RNG_UNIT (
    input  logic         CLK, RST_X,
    input  logic         RNG_EN,
    input  logic [31: 0] PARAM,
    output logic [15: 0] DATA_OUT,
    output logic         DATA_EN);

    localparam T_DEASSERT = 8'd4;
    localparam T_ASSERT   = 8'd4;
    localparam RNGS       = 32;

    logic [ 7: 0] cnt, n_cnt;
    logic         asrt_x, n_asrt_x;
    (* DONT_TOUCH = "true" *)
    logic [RNGS*8-1:0] out;
    genvar             i;

    always_comb begin
        if (cnt == 8'd1) begin
            if (RNG_EN) begin
                n_cnt = 8'd2;
            end else begin
                n_cnt = 8'd1;
            end
        end else if (cnt < T_DEASSERT + T_ASSERT - 8'd1) begin
            n_cnt = cnt + 1'b1;
        end else begin
            n_cnt = 8'd0;
        end
    end
    assign n_asrt_x       = (n_cnt < T_DEASSERT);
    assign DATA_EN        = (cnt == 8'd0);
    assign DATA_OUT[15:1] = 15'h0;

    generate for (i = 0; i < RNGS * 8; i = i + 1) begin
        rng1 rng_inst (CLK, ~RST_X, asrt_x, out[i]);
    end endgenerate

    NumLatch NL (out, PARAM[4:0], DATA_OUT[0]);

    always_ff @ (posedge CLK) begin
        if (~ RST_X) begin
            cnt    <= 8'd1;
            asrt_x <= 1'b1;
        end else begin
            cnt    <= n_cnt;
            asrt_x <= n_asrt_x;
        end
    end

endmodule

module rng1 (CLK, RST, ASRT_X, OUT);
    input  logic CLK, RST, ASRT_X;
    output logic OUT;

    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    logic [1:0] nand_o, not_o;

    (* HU_SET = "rng", RLOC = "X0Y0" *)
    LUT1 #(.INIT(2'b01)) NOT_S0 (.O(not_o[0]), .I0(nand_o[1]));
    (* HU_SET = "rng", RLOC = "X0Y0" *)
    LUT1 #(.INIT(2'b01)) NOT_R0 (.O(not_o[1]), .I0(nand_o[0]));
    (* HU_SET = "rng", RLOC = "X0Y0" *)
    LDCE AND_S0 (.D(not_o[0]), .Q(nand_o[0]), .CLR(ASRT_X), .GE(1'b1), .G(1'b1));
    (* HU_SET = "rng", RLOC = "X0Y0" *)
    LDCE AND_R0 (.D(not_o[1]), .Q(nand_o[1]), .CLR(ASRT_X), .GE(1'b1), .G(1'b1));

    FDCE OUTFF_S0 (.Q(OUT)  , .C(CLK), .CE(1'b1), .CLR(RST), .D(nand_o[0]));
    
endmodule

module NumLatch(out, select, out_sel);
    localparam RNGS = 32;
    input  logic [RNGS*8-1:0] out;
    input  logic        [4:0] select;
    output logic              out_sel;
    logic          [RNGS-1:0] out_TRNG;
    
    assign out_sel = out_TRNG[select];
    assign out_TRNG[0] = ^out[7:0];
        generate
            genvar i;
            for (i = 1; i < RNGS; i = i + 1) begin: TRNG_wire
                assign out_TRNG[i] = (^out[8*(i+1) -1:8*i])^out_TRNG[i-1];
            end
        endgenerate
endmodule