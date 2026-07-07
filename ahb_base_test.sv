import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_base_test extends uvm_test;
  `uvm_component_utils(ahb_base_test)
  
  ahb_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_env::type_id::create("env", this);
  endfunction
endclass