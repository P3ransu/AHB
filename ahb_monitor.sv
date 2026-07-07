import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)

  uvm_analysis_port #(ahb_transaction) item_collected_port;
  virtual ahb_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("No VIF", "Virtual Interface not set for monitor")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    ahb_transaction pending_tx = null;
    
    forever begin
      @(posedge vif.hclk);
      
      if (vif.hready == 1'b1) begin
        
        if (pending_tx != null) begin
          if (pending_tx.hwrite == 1'b0) begin
            pending_tx.hrdata = vif.hrdata;
          end else begin
            pending_tx.hwdata = vif.hwdata;
          end
          pending_tx.hresp = vif.hresp;
          
          item_collected_port.write(pending_tx);
          
          `uvm_info("MONITOR", $sformatf("Captured Transfer: Addr=%0h, Data=%0h, Write=%0b", 
                                         pending_tx.haddr, 
                                         (pending_tx.hwrite ? pending_tx.hwdata : pending_tx.hrdata), 
                                         pending_tx.hwrite), UVM_LOW)
          
          pending_tx = null;
        end

        if (vif.htrans == 2'b10 || vif.htrans == 2'b11) begin
          pending_tx = ahb_transaction::type_id::create("pending_tx");
          pending_tx.haddr  = vif.haddr;
          pending_tx.hwrite = vif.hwrite;
          pending_tx.hsize  = vif.hsize;
          pending_tx.hburst = vif.hburst;
        end
        
      end
    end
  endtask

endclass