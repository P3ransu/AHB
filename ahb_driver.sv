`timescale 1ns / 1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_driver extends uvm_driver #(ahb_transaction);
  `uvm_component_utils(ahb_driver)

  virtual ahb_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahb_if) :: get(this, "", "vif", vif)) begin 
        `uvm_fatal("NO VIF", "virtual interface not set")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    vif.htrans <= 2'b00;
    
    forever begin 
      seq_item_port.get_next_item(req);
      
      vif.haddr  <= req.haddr;
      vif.hwrite <= req.hwrite;
      vif.hsize  <= req.hsize;
      vif.hburst <= req.hburst;
      vif.htrans <= 2'b10;
      
      @(posedge vif.hclk);
      
      while(vif.hready == 1'b0) begin
        @(posedge vif.hclk);
      end 
      
      fork 
        automatic ahb_transaction data_req = req;
        drive_data_phase(data_req);
      join_none
      
      seq_item_port.item_done();
    end 
  endtask   

  task drive_data_phase(ahb_transaction req);
    if (req.hwrite == 1'b1) begin
      vif.hwdata <= req.hwdata;
    end

    do begin 
      @(posedge vif.hclk);
    end while(vif.hready == 1'b0);
  endtask

endclass