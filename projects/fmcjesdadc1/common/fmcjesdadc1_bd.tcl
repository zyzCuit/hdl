
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9250_xcvr
ad_ip_parameter axi_ad9250_xcvr CONFIG.NUM_OF_LANES 4
ad_ip_parameter axi_ad9250_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9250_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9250_xcvr CONFIG.LPM_OR_DFE_N 0
ad_ip_parameter axi_ad9250_xcvr CONFIG.OUT_CLK_SEL "010"
ad_ip_parameter axi_ad9250_xcvr CONFIG.SYS_CLK_SEL "00"

adi_axi_jesd204_rx_create axi_ad9250_jesd 4

ad_ip_instance util_bsplit data_bsplit
ad_ip_parameter data_bsplit CONFIG.CHANNEL_DATA_WIDTH 64
ad_ip_parameter data_bsplit CONFIG.NUM_OF_CHANNELS 2

ad_ip_instance axi_ad9250 axi_ad9250_0_core
ad_ip_instance axi_ad9250 axi_ad9250_1_core

ad_ip_instance util_cpack axi_ad9250_0_cpack
ad_ip_parameter axi_ad9250_0_cpack CONFIG.NUM_OF_CHANNELS 2
ad_ip_instance util_cpack axi_ad9250_1_cpack
ad_ip_parameter axi_ad9250_1_cpack CONFIG.NUM_OF_CHANNELS 2

ad_ip_instance axi_dmac axi_ad9250_0_dma
ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9250_0_dma CONFIG.ID 0
ad_ip_parameter axi_ad9250_0_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9250_0_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9250_0_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9250_0_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance axi_dmac axi_ad9250_1_dma
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9250_1_dma CONFIG.ID 0
ad_ip_parameter axi_ad9250_1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9250_1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9250_1_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9250_1_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# transceiver core

ad_ip_instance util_adxcvr util_fmcjesdadc1_xcvr
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.QPLL_FBDIV 0x80
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_NUM_OF_LANES 4
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_CLK25_DIV 10
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_DFE_LPM_CFG 0x0904
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_PMA_CFG 0x00018480
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_CDR_CFG 0x03000023ff10200020

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  rx_ref_clk_0 util_fmcjesdadc1_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcjesdadc1_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9250_xcvr/up_pll_rst util_fmcjesdadc1_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9250_xcvr/up_pll_rst util_fmcjesdadc1_xcvr/up_cpll_rst_*
ad_connect  sys_cpu_resetn util_fmcjesdadc1_xcvr/up_rstn
ad_connect  sys_cpu_clk util_fmcjesdadc1_xcvr/up_clk

create_bd_port -dir O rx_core_clk

# connections (adc)

ad_xcvrcon  util_fmcjesdadc1_xcvr axi_ad9250_xcvr axi_ad9250_jesd
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_0_core/rx_clk
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 rx_core_clk
ad_connect  axi_ad9250_jesd/rx_sof axi_ad9250_0_core/rx_sof
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_1_core/rx_clk
ad_connect  axi_ad9250_jesd/rx_sof axi_ad9250_1_core/rx_sof

ad_connect  axi_ad9250_jesd/rx_data_tdata data_bsplit/data
ad_connect  axi_ad9250_0_core/rx_data data_bsplit/split_data_0
ad_connect  axi_ad9250_1_core/rx_data data_bsplit/split_data_1

ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_0_cpack/adc_clk
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_1_cpack/adc_clk
ad_connect  axi_ad9250_jesd_rstgen/peripheral_reset axi_ad9250_0_cpack/adc_rst
ad_connect  axi_ad9250_jesd_rstgen/peripheral_reset axi_ad9250_1_cpack/adc_rst

ad_connect  axi_ad9250_0_core/adc_enable_a axi_ad9250_0_cpack/adc_enable_0
ad_connect  axi_ad9250_0_core/adc_valid_a axi_ad9250_0_cpack/adc_valid_0
ad_connect  axi_ad9250_0_core/adc_data_a axi_ad9250_0_cpack/adc_data_0
ad_connect  axi_ad9250_0_core/adc_enable_b axi_ad9250_0_cpack/adc_enable_1
ad_connect  axi_ad9250_0_core/adc_valid_b axi_ad9250_0_cpack/adc_valid_1
ad_connect  axi_ad9250_0_core/adc_data_b axi_ad9250_0_cpack/adc_data_1
ad_connect  axi_ad9250_1_core/adc_enable_a axi_ad9250_1_cpack/adc_enable_0
ad_connect  axi_ad9250_1_core/adc_valid_a axi_ad9250_1_cpack/adc_valid_0
ad_connect  axi_ad9250_1_core/adc_data_a axi_ad9250_1_cpack/adc_data_0
ad_connect  axi_ad9250_1_core/adc_enable_b axi_ad9250_1_cpack/adc_enable_1
ad_connect  axi_ad9250_1_core/adc_valid_b axi_ad9250_1_cpack/adc_valid_1
ad_connect  axi_ad9250_1_core/adc_data_b axi_ad9250_1_cpack/adc_data_1

ad_connect  axi_ad9250_0_core/adc_clk axi_ad9250_0_dma/fifo_wr_clk
ad_connect  axi_ad9250_0_dma/fifo_wr_en axi_ad9250_0_cpack/adc_valid
ad_connect  axi_ad9250_0_dma/fifo_wr_sync axi_ad9250_0_cpack/adc_sync
ad_connect  axi_ad9250_0_dma/fifo_wr_din axi_ad9250_0_cpack/adc_data
ad_connect  axi_ad9250_0_core/adc_dovf axi_ad9250_0_dma/fifo_wr_overflow
ad_connect  axi_ad9250_1_core/adc_clk axi_ad9250_1_dma/fifo_wr_clk
ad_connect  axi_ad9250_1_dma/fifo_wr_en axi_ad9250_1_cpack/adc_valid
ad_connect  axi_ad9250_1_dma/fifo_wr_sync axi_ad9250_1_cpack/adc_sync
ad_connect  axi_ad9250_1_dma/fifo_wr_din axi_ad9250_1_cpack/adc_data
ad_connect  axi_ad9250_1_core/adc_dovf axi_ad9250_1_dma/fifo_wr_overflow

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9250_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9250_0_core
ad_cpu_interconnect 0x44A20000 axi_ad9250_1_core
ad_cpu_interconnect 0x44AA0000 axi_ad9250_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9250_0_dma
ad_cpu_interconnect 0x7c430000 axi_ad9250_1_dma

# xcvr uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9250_xcvr/m_axi

# interconnect (adc)

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_0_dma/m_dest_axi
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_1_dma/m_dest_axi

ad_connect  sys_cpu_resetn axi_ad9250_0_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9250_1_dma/m_dest_axi_aresetn

#interrupts

ad_cpu_interrupt ps-11 mb-14 axi_ad9250_jesd/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9250_1_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9250_0_dma/irq

