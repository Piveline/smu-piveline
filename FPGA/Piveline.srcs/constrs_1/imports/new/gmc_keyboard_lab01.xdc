## ============================================================================
## Nexys Video - PS/2 Keyboard + HDMI Text Display Constraints
## ============================================================================
## Board: Digilent Nexys Video Rev. A (Xilinx Artix-7 XC7A200T-1SBG484C)
## Pin assignments verified against Digilent official Master XDC:
##   https://github.com/Digilent/digilent-xdc/blob/master/Nexys-Video-Master.xdc
## ============================================================================

## --------------------------------------------------------------------------
## 100 MHz System Clock
## --------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports CLK100MHZ]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports CLK100MHZ]

## --------------------------------------------------------------------------
## Reset Button (active-low)
## --------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS15} [get_ports CPU_RESETN]

## --------------------------------------------------------------------------
## HDMI TX (Digilent Master XDC verified)
## --------------------------------------------------------------------------
## Clock
set_property -dict {PACKAGE_PIN T1 IOSTANDARD TMDS_33} [get_ports HDMI_TX_CLK_P]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD TMDS_33} [get_ports HDMI_TX_CLK_N]

## Data Channel 0
set_property -dict {PACKAGE_PIN W1  IOSTANDARD TMDS_33} [get_ports {HDMI_TX_P[0]}]
set_property -dict {PACKAGE_PIN Y1  IOSTANDARD TMDS_33} [get_ports {HDMI_TX_N[0]}]

## Data Channel 1
set_property -dict {PACKAGE_PIN AA1 IOSTANDARD TMDS_33} [get_ports {HDMI_TX_P[1]}]
set_property -dict {PACKAGE_PIN AB1 IOSTANDARD TMDS_33} [get_ports {HDMI_TX_N[1]}]

## Data Channel 2
set_property -dict {PACKAGE_PIN AB3 IOSTANDARD TMDS_33} [get_ports {HDMI_TX_P[2]}]
set_property -dict {PACKAGE_PIN AB2 IOSTANDARD TMDS_33} [get_ports {HDMI_TX_N[2]}]

## --------------------------------------------------------------------------
## LEDs (PS/2 Debug)
## --------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS25} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS25} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS25} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS25} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS25} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS25} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS25} [get_ports {LED[7]}]

## --------------------------------------------------------------------------
## PS/2 Keyboard (PIC24FJ128 USB-to-PS/2 bridge)
## --------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports PS2_CLK]
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports PS2_DATA]

## --------------------------------------------------------------------------
## Configuration
## --------------------------------------------------------------------------
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]