import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_coverage extends uvm_subscriber #(ahb_transaction);
  `uvm_component_utils(ahb_coverage)

  covergroup ahb_cg with function sample(ahb_transaction tx);
    option.per_instance = 1;
    
    cp_hwrite: coverpoint tx.hwrite {
      bins read_op  = {0};
      bins write_op = {1};
    }
    
    cp_hsize: coverpoint tx.hsize {
      bins byte_size = {3'b000};
      bins half_word = {3'b001};
      bins word_size = {3'b010};
    }
  endcovergroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ahb_cg = new();
  endfunction

  virtual function void write(ahb_transaction t);
    ahb_cg.sample(t);
  endfunction

endclass