`timescale 1ns / 1ps
import uvm_pkg::*;
`include "uvm_macros.svh"


module tb_top;
    
    //clock and reset
    logic hclk;
    logic hresetn;
    
    // instantiating physical interface
    ahb_if vif( .hclk(hclk), .hresetn(hresetn));
    assign vif.hready = 1'b1;
    assign vif.hresp = 2'b00;
    assign vif.hrdata = 32'h000000000;
    
    // setting clk
    initial begin
        hclk = 0;
        forever #5 hclk = ~hclk;
    end 
    // setting the reset
    initial begin 
        hresetn = 0;
        #20 hresetn = 1;
    end
    
    initial begin 
        uvm_config_db#(virtual ahb_if) ::set (null, "uvm_test_top.*", "vif" , vif);
        run_test("ahb_base_test");
    end 
    


endmodule
