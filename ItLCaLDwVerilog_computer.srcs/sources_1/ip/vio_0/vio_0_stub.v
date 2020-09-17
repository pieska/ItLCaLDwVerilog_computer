// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1.3 (lin64) Build 2644227 Wed Sep  4 09:44:18 MDT 2019
// Date        : Wed Sep 16 21:54:50 2020
// Host        : laptop.crack-n-hack.org running 64-bit Fedora release 32 (Thirty Two)
// Command     : write_verilog -force -mode synth_stub
//               /home/pharaoh/Projekte/FPGA/ItLCaLDwVerilog_computer/ItLCaLDwVerilog_computer.srcs/sources_1/ip/vio_0/vio_0_stub.v
// Design      : vio_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.1.3" *)
module vio_0(clk, probe_in0, probe_in1, probe_in2, probe_in3, 
  probe_in4, probe_in5, probe_in6, probe_in7, probe_in8, probe_in9, probe_in10)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[7:0],probe_in1[7:0],probe_in2[7:0],probe_in3[7:0],probe_in4[7:0],probe_in5[7:0],probe_in6[3:0],probe_in7[7:0],probe_in8[7:0],probe_in9[0:0],probe_in10[0:0]" */;
  input clk;
  input [7:0]probe_in0;
  input [7:0]probe_in1;
  input [7:0]probe_in2;
  input [7:0]probe_in3;
  input [7:0]probe_in4;
  input [7:0]probe_in5;
  input [3:0]probe_in6;
  input [7:0]probe_in7;
  input [7:0]probe_in8;
  input [0:0]probe_in9;
  input [0:0]probe_in10;
endmodule
