// Coherent Sampling Module (Counting the number of CONTINUOUS ones)
// 2022-11-11 (Original Ver. 2020-02-21) Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module COUNTER (CLK, RST, CLK_FF, D_FF, COUNT, COUNT_EN);
    input            CLK, RST;
    input            CLK_FF, D_FF;
    output reg [7:0] COUNT;
    output           COUNT_EN;

    reg              q_ff, max_set;
    reg        [8:0] cur_count;
    reg        [8:0] max;
    reg        [2:0] set_hist;

    // first stage: D Flip-flop (driven by CLK_FF)
    always @(posedge CLK_FF) begin
        q_ff <= D_FF;
    end

    // second stage: Counter (driven by CLK_FF)
    always @(posedge CLK_FF) begin
        if (RST) begin
            cur_count <= 9'h000;
            max       <= 9'h000;
            max_set   <= 1'b0;
        end else if (q_ff) begin
            // MSB (2^8) is sticky to let the count saturate at 255
            cur_count <= (cur_count + 1'b1) | (cur_count & 9'h100);
            max_set   <= 1'b0;
        end else begin
            cur_count <= 9'h000;
            max_set   <= 1'b1;
            if (cur_count != 9'h000) begin
                max       <= cur_count;
            end
        end
    end

    // last stage: Output Enable (driven by CLK)
    //   set_hist[1:0] - for double flop synchronization
    //   set_hist[2]   - for edge detection
    assign COUNT_EN = ~ set_hist[2] & set_hist[1];
    always @(posedge CLK) begin
        if (RST) begin
            set_hist  <= 3'b000;
            COUNT     <= 8'h00;
        end else begin
            set_hist  <= {set_hist[1:0], max_set};
            if (set_hist[0]) begin
                COUNT     <= (max[8]) ? 8'hff : max[7:0];
            end
        end
    end

endmodule