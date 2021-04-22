// Top Module of TRNG IP Core 2021.03.05 Naoki F., AIT
// ライセンス条件は COPYING ファイルを参照してください

module RNG_IP_TOP (
    input          ACLK,
    input          ARESETN,
    // AXI Lite（制御用）関連信号
    input  [ 3: 0] AXI_CTRL_AWADDR,
    input  [ 2: 0] AXI_CTRL_AWPROT,
    input          AXI_CTRL_AWVALID,
    output         AXI_CTRL_AWREADY,
    input  [31: 0] AXI_CTRL_WDATA,
    input  [ 3: 0] AXI_CTRL_WSTRB,
    input          AXI_CTRL_WVALID,
    output         AXI_CTRL_WREADY,
    output [ 1: 0] AXI_CTRL_BRESP,
    output         AXI_CTRL_BVALID,
    input          AXI_CTRL_BREADY,
    input  [ 3: 0] AXI_CTRL_ARADDR,
    input  [ 2: 0] AXI_CTRL_ARPROT,
    input          AXI_CTRL_ARVALID,
    output         AXI_CTRL_ARREADY,
    output [31: 0] AXI_CTRL_RDATA,
    output [ 1: 0] AXI_CTRL_RRESP,
    output         AXI_CTRL_RVALID,
    input          AXI_CTRL_RREADY,
    // AXI Stream 関連信号
    output [31: 0] AXIS_RNG_TDATA,
    output         AXIS_RNG_TLAST,
    output         AXIS_RNG_TVALID,
    input          AXIS_RNG_TREADY);
    
    // AXI Lite（制御用）<-> 乱数回路
    wire           rng_go, rng_stop, rng_run, rng_over;
    wire   [31: 0] rng_send_bytes, rng_sent_bytes, rng_dma_bytes;
    wire   [31: 0] rng_sum_data, rng_parameter, rng_stats;

    AXI_ctrl ctrl (
        .AXI_CTRL_ACLK   (ACLK),
        .AXI_CTRL_ARESETN(ARESETN),
        .AXI_CTRL_AWADDR (AXI_CTRL_AWADDR),
        .AXI_CTRL_AWPROT (AXI_CTRL_AWPROT),
        .AXI_CTRL_AWVALID(AXI_CTRL_AWVALID),
        .AXI_CTRL_AWREADY(AXI_CTRL_AWREADY),
        .AXI_CTRL_WDATA  (AXI_CTRL_WDATA),
        .AXI_CTRL_WSTRB  (AXI_CTRL_WSTRB),
        .AXI_CTRL_WVALID (AXI_CTRL_WVALID),
        .AXI_CTRL_WREADY (AXI_CTRL_WREADY),
        .AXI_CTRL_BRESP  (AXI_CTRL_BRESP),
        .AXI_CTRL_BVALID (AXI_CTRL_BVALID),
        .AXI_CTRL_BREADY (AXI_CTRL_BREADY),
        .AXI_CTRL_ARADDR (AXI_CTRL_ARADDR),
        .AXI_CTRL_ARPROT (AXI_CTRL_ARPROT),
        .AXI_CTRL_ARVALID(AXI_CTRL_ARVALID),
        .AXI_CTRL_ARREADY(AXI_CTRL_ARREADY),
        .AXI_CTRL_RDATA  (AXI_CTRL_RDATA),
        .AXI_CTRL_RRESP  (AXI_CTRL_RRESP),
        .AXI_CTRL_RVALID (AXI_CTRL_RVALID),
        .AXI_CTRL_RREADY (AXI_CTRL_RREADY),
        .RNG_GO          (rng_go),
        .RNG_STOP        (rng_stop),
        .RNG_RUN         (rng_run),
        .RNG_OVER        (rng_over),
        .RNG_SEND_BYTES  (rng_send_bytes),
        .RNG_SENT_BYTES  (rng_sent_bytes),
        .RNG_DMA_BYTES   (rng_dma_bytes),
        .RNG_SUM_DATA    (rng_sum_data),
        .RNG_PARAMETER   (rng_parameter),
        .RNG_STATS       (rng_stats));

    RNG_TOP RNG (
        .CLK             (ACLK),
        .RST_X           (ARESETN),
        .AXIS_RNG_TDATA  (AXIS_RNG_TDATA),
        .AXIS_RNG_TLAST  (AXIS_RNG_TLAST),
        .AXIS_RNG_TVALID (AXIS_RNG_TVALID),
        .AXIS_RNG_TREADY (AXIS_RNG_TREADY),
        .RNG_GO          (rng_go),
        .RNG_STOP        (rng_stop),
        .RNG_RUN         (rng_run),
        .RNG_OVER        (rng_over),
        .RNG_SEND_BYTES  (rng_send_bytes),
        .RNG_SENT_BYTES  (rng_sent_bytes),
        .RNG_DMA_BYTES   (rng_dma_bytes),
        .RNG_SUM_DATA    (rng_sum_data),
        .RNG_PARAMETER   (rng_parameter),
        .RNG_STATS       (rng_stats));
endmodule