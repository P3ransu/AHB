import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_transaction extends uvm_sequence_item;
   
    rand logic [31:0] haddr;
    rand logic [31:0] hwdata;
    logic [31:0] hrdata;
    rand logic [2:0] hsize;
    rand logic [2:0] hburst;
    rand logic hwrite;
    logic [1:0] hresp;
    
    `uvm_object_utils_begin(ahb_transaction)
        `uvm_field_int(haddr,UVM_ALL_ON)
        `uvm_field_int(hwdata, UVM_ALL_ON)
        `uvm_field_int(hrdata , UVM_ALL_ON)
        `uvm_field_int(hsize, UVM_ALL_ON)
        `uvm_field_int(hburst, UVM_ALL_ON)
        `uvm_field_int(hwrite, UVM_ALL_ON)
        `uvm_field_int(hresp, UVM_ALL_ON)
     `uvm_object_utils_end 
 
    function new(string name  = "ahb_transaction");
        super.new(name);
    endfunction
 endclass         
      
    

        