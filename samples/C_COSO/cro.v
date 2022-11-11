// Configurable ring oscillator unit
// 2022-11-11 (Original Ver. 2019-10-10) Naoki F., AIT
// Ref: A. Peetermans et al., in FPL 2019, pp. 218-224
// NOTE: Re-implemented by the author.
// New BSD License is applied. See COPYING file for details.

module cro (CLK_100M, ROSEL, EN, OUT);
    input            CLK_100M;
    input      [7:0] ROSEL;
    input            EN;
    output           OUT;

    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [3:0] nand_o;
    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [3:0] mux_o1, mux_o2, mux_o3, mux_o4;
    (* DONT_TOUCH = "true" *)
    wire       mux_o5;

    wire       en_buf;

    // Configurable RO Loop
    (* HU_SET = "cro", RLOC = "X0Y0", BEL = "A6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_0 (.O(nand_o[0]), .I0(mux_o4[0]), .I1(en_buf));
    (* HU_SET = "cro", RLOC = "X0Y0", BEL = "B6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_1 (.O(nand_o[1]), .I0(mux_o4[1]), .I1(en_buf));
    (* HU_SET = "cro", RLOC = "X0Y0", BEL = "C6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_2 (.O(nand_o[2]), .I0(mux_o4[2]), .I1(en_buf));
    (* HU_SET = "cro", RLOC = "X0Y0", BEL = "D6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_3 (.O(nand_o[3]), .I0(mux_o4[3]), .I1(en_buf));

    (* HU_SET = "cro", RLOC = "X0Y1", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_1_0 (.I0(nand_o[0]), .I1(nand_o[1]), .I2(nand_o[2]), .I3(nand_o[3]), 
                 .I4(ROSEL[0]), .I5(ROSEL[1]), .O(mux_o1[0]));
    (* HU_SET = "cro", RLOC = "X0Y1", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_1_1 (.I0(nand_o[0]), .I1(nand_o[1]), .I2(nand_o[2]), .I3(nand_o[3]), 
                 .I4(ROSEL[0]), .I5(ROSEL[1]), .O(mux_o1[1]));
    (* HU_SET = "cro", RLOC = "X0Y1", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_1_2 (.I0(nand_o[0]), .I1(nand_o[1]), .I2(nand_o[2]), .I3(nand_o[3]), 
                 .I4(ROSEL[0]), .I5(ROSEL[1]), .O(mux_o1[2]));
    (* HU_SET = "cro", RLOC = "X0Y1", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_1_3 (.I0(nand_o[0]), .I1(nand_o[1]), .I2(nand_o[2]), .I3(nand_o[3]), 
                 .I4(ROSEL[0]), .I5(ROSEL[1]), .O(mux_o1[3]));

    (* HU_SET = "cro", RLOC = "X0Y2", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_2_0 (.I0(mux_o1[0]), .I1(mux_o1[1]), .I2(mux_o1[2]), .I3(mux_o1[3]), 
                 .I4(ROSEL[2]), .I5(ROSEL[3]), .O(mux_o2[0]));
    (* HU_SET = "cro", RLOC = "X0Y2", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_2_1 (.I0(mux_o1[0]), .I1(mux_o1[1]), .I2(mux_o1[2]), .I3(mux_o1[3]), 
                 .I4(ROSEL[2]), .I5(ROSEL[3]), .O(mux_o2[1]));
    (* HU_SET = "cro", RLOC = "X0Y2", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_2_2 (.I0(mux_o1[0]), .I1(mux_o1[1]), .I2(mux_o1[2]), .I3(mux_o1[3]), 
                 .I4(ROSEL[2]), .I5(ROSEL[3]), .O(mux_o2[2]));
    (* HU_SET = "cro", RLOC = "X0Y2", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_2_3 (.I0(mux_o1[0]), .I1(mux_o1[1]), .I2(mux_o1[2]), .I3(mux_o1[3]), 
                 .I4(ROSEL[2]), .I5(ROSEL[3]), .O(mux_o2[3]));

    (* HU_SET = "cro", RLOC = "X0Y3", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_3_0 (.I0(mux_o2[0]), .I1(mux_o2[1]), .I2(mux_o2[2]), .I3(mux_o2[3]), 
                 .I4(ROSEL[4]), .I5(ROSEL[5]), .O(mux_o3[0]));
    (* HU_SET = "cro", RLOC = "X0Y3", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_3_1 (.I0(mux_o2[0]), .I1(mux_o2[1]), .I2(mux_o2[2]), .I3(mux_o2[3]), 
                 .I4(ROSEL[4]), .I5(ROSEL[5]), .O(mux_o3[1]));
    (* HU_SET = "cro", RLOC = "X0Y3", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_3_2 (.I0(mux_o2[0]), .I1(mux_o2[1]), .I2(mux_o2[2]), .I3(mux_o2[3]), 
                 .I4(ROSEL[4]), .I5(ROSEL[5]), .O(mux_o3[2]));
    (* HU_SET = "cro", RLOC = "X0Y3", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_3_3 (.I0(mux_o2[0]), .I1(mux_o2[1]), .I2(mux_o2[2]), .I3(mux_o2[3]), 
                 .I4(ROSEL[4]), .I5(ROSEL[5]), .O(mux_o3[3]));

    (* HU_SET = "cro", RLOC = "X0Y4", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_4_0 (.I0(mux_o3[0]), .I1(mux_o3[1]), .I2(mux_o3[2]), .I3(mux_o3[3]), 
                 .I4(ROSEL[6]), .I5(ROSEL[7]), .O(mux_o4[0]));
    (* HU_SET = "cro", RLOC = "X0Y4", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_4_1 (.I0(mux_o3[0]), .I1(mux_o3[1]), .I2(mux_o3[2]), .I3(mux_o3[3]), 
                 .I4(ROSEL[6]), .I5(ROSEL[7]), .O(mux_o4[1]));
    (* HU_SET = "cro", RLOC = "X0Y4", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_4_2 (.I0(mux_o3[0]), .I1(mux_o3[1]), .I2(mux_o3[2]), .I3(mux_o3[3]), 
                 .I4(ROSEL[6]), .I5(ROSEL[7]), .O(mux_o4[2]));
    (* HU_SET = "cro", RLOC = "X0Y4", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_4_3 (.I0(mux_o3[0]), .I1(mux_o3[1]), .I2(mux_o3[2]), .I3(mux_o3[3]), 
                 .I4(ROSEL[6]), .I5(ROSEL[7]), .O(mux_o4[3]));
                 
    (* HU_SET = "cro", RLOC = "X0Y5" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        MUX_5 (.I0(mux_o4[0]), .I1(mux_o4[1]), .I2(mux_o4[2]), .I3(mux_o4[3]), 
               .I4(ROSEL[0]), .I5(ROSEL[1]), .O(mux_o5));

    // Input FF to Capture CTR
    (* HU_SET = "cro", RLOC = "X0Y0" *)
    FD INFF (.Q(en_buf), .C(CLK_100M), .D(EN));
    
    BUFR OUTBUF(.CE(1'b1), .CLR(1'b0), .I(mux_o5), .O(OUT));
    
endmodule
