// Controller of TRNG IP Core 2021.03.05 Naoki F., AIT
// ライセンス条件は COPYING ファイルを参照してください

module RNG_CTRL (
    input  logic         CLK, RST_X,
    // from RNG_UNIT
    input  logic [15: 0] DATA_IN,
    input  logic         DATA_RE,
    // to FIFO
    output logic [32: 0] DATA_OUT,
    output logic         DATA_WE,
    input  logic         FIFO_FULL,
    // from AXI_ctrl
    input  logic         GO,
    input  logic         STOP,
    output logic         RUN,
    output logic         OVER,
    input  logic [31: 0] SEND_BYTES,
    output logic [31: 0] SENT_BYTES,
    input  logic [31: 0] DMA_BYTES,
    output logic [31: 0] SUM_DATA,
    output logic [31: 0] STATS);

    logic [ 4: 0] count, n_count;
    logic [30: 0] data_reg, n_data_reg;
    logic [31: 0] sent_dma, n_sent_dma;
    logic         n_run, n_over;
    logic [31: 0] n_sent, n_sum;
    logic         dma_last;

    assign DATA_OUT = {dma_last, data_reg, DATA_IN[0]};
    assign DATA_WE  = RUN && DATA_RE && ~FIFO_FULL && (n_count == 5'd0);

    // 統計情報を取る回路のインスタンス化
    STATS_UNIT stat (
        .CLK     (CLK),
        .RST_X   (RST_X),
        .STOP    (STOP),
        .DATA_IN (DATA_IN),
        .DATA_RE (RUN & DATA_RE),
        .STATS   (STATS));

    // control logic
    always_comb begin
        n_run      = RUN;
        n_over     = OVER;
        n_sent     = SENT_BYTES;
        n_sum      = SUM_DATA;
        n_count    = count;
        n_data_reg = data_reg;
        n_sent_dma = sent_dma;
        dma_last   = 1'b0;

        if (STOP) begin
            n_run      = 1'b0;
            n_over     = 1'b0;
            n_sent     = 0;
            n_sum      = 0;
            n_count    = 5'd0;
            n_data_reg = 31'h0;
            n_sent_dma = 0;
        end else if (GO) begin
            n_run      = 1'b1;
        end else if (RUN & DATA_RE) begin
            n_sum      = SUM_DATA + DATA_IN;
            n_count    = count + 1'b1;
            n_data_reg = DATA_OUT[30:0];
            if (n_count == 5'd0) begin
                if (FIFO_FULL) begin 
                    n_over     = 1'b1;
                end else begin
                    n_sent     = SENT_BYTES + 3'd4;
                    n_sent_dma = sent_dma + 3'd4;
                    n_run      = (n_sent < SEND_BYTES || SEND_BYTES == 0);
                    if (sent_dma + 3'd4 >= DMA_BYTES) begin
                        n_sent_dma = 0;
                        dma_last   = 1'b1;
                    end
                end
            end
        end
    end 
    
    always_ff @ (posedge CLK) begin
        if (~ RST_X) begin
            RUN        <= 1'b0;
            OVER       <= 1'b0;
            SENT_BYTES <= 0;
            SUM_DATA   <= 0;
            count      <= 5'd0;
            data_reg   <= 31'h0;
            sent_dma   <= 0;
        end else begin
            RUN        <= n_run;
            OVER       <= n_over;
            SENT_BYTES <= n_sent;
            SUM_DATA   <= n_sum;
            count      <= n_count;
            data_reg   <= n_data_reg;
            sent_dma   <= n_sent_dma;
        end
    end
endmodule