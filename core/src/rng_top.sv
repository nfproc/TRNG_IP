// TRNG IP Core (General Purpose) 2021.03.05 Naoki F., AIT
// ライセンス条件は COPYING ファイルを参照してください

module RNG_TOP (
    input  logic         CLK, RST_X,
    // AXI Stream
    output logic [31: 0] AXIS_RNG_TDATA,
    output logic         AXIS_RNG_TLAST,
    output logic         AXIS_RNG_TVALID,
    input  logic         AXIS_RNG_TREADY,
    // from AXI_ctrl
    input  logic         RNG_GO,
    input  logic         RNG_STOP,
    output logic         RNG_RUN,
    output logic         RNG_OVER,
    input  logic [31: 0] RNG_SEND_BYTES,
    output logic [31: 0] RNG_SENT_BYTES,
    input  logic [31: 0] RNG_DMA_BYTES,
    output logic [31: 0] RNG_SUM_DATA,
    input  logic [31: 0] RNG_PARAMETER,
    output logic [31: 0] RNG_STATS);

    // RNG_UNIT 関連信号
    logic         unit_data_en;
    logic [15: 0] unit_data_out;
    // fifo 関連信号
    logic [32: 0] fifo_data_w, fifo_data_r;
    logic         fifo_we, fifo_re, fifo_empty, fifo_full;

    // AXI Stream
    assign AXIS_RNG_TDATA  = fifo_data_r[31: 0];
    assign AXIS_RNG_TLAST  = fifo_data_r[32];
    assign AXIS_RNG_TVALID = ~ fifo_empty;
    assign fifo_re         = AXIS_RNG_TVALID & AXIS_RNG_TREADY;

    // インスタンス化
    RNG_UNIT unit (
        .CLK     (CLK),
        .RST_X   (RST_X),
        .RNG_EN  (RNG_RUN),
        .PARAM   (RNG_PARAMETER),
        .DATA_OUT(unit_data_out),
        .DATA_EN (unit_data_en));

    RNG_CTRL ctrl (
        .CLK       (CLK),
        .RST_X     (RST_X),
        .DATA_IN   (unit_data_out),
        .DATA_RE   (unit_data_en),
        .DATA_OUT  (fifo_data_w),
        .DATA_WE   (fifo_we),
        .FIFO_FULL (fifo_full),
        .GO        (RNG_GO),
        .STOP      (RNG_STOP),
        .RUN       (RNG_RUN),
        .OVER      (RNG_OVER),
        .SEND_BYTES(RNG_SEND_BYTES),
        .SENT_BYTES(RNG_SENT_BYTES),
        .DMA_BYTES (RNG_DMA_BYTES),
        .SUM_DATA  (RNG_SUM_DATA),
        .STATS     (RNG_STATS));

    fifo # (
        .WIDTH   (33),
        .SIZE    (1024))
    data_fifo (
        .CLK     (CLK),
        .RST     (~RST_X),
        .DATA_W  (fifo_data_w),
        .DATA_R  (fifo_data_r),
        .WE      (fifo_we),
        .RE      (fifo_re),
        .EMPTY   (fifo_empty),
        .FULL    (fifo_full),
        .SOFT_RST(RNG_STOP));
endmodule