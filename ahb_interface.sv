`timescale 1ns / 1ps
interface ahb_if( input logic hclk, input logic hreset);
    logic [31:0] haddr;
    logic [31:0] hwdata;
    logic [31:0] hrdata;
    logic hwrite;
    logic [2:0] hsize;
    logic hresp;
    logic hready;
    logic [2:0] hburst;
    logic [1:0] htrans;   
endinterface 
