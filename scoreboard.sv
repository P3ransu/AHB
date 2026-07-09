import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(ahb_scoreboard)

  uvm_analysis_imp #(ahb_transaction, ahb_scoreboard) item_collected_export;

  logic [31:0] ref_memory [logic [31:0]];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_export = new("item_collected_export", this);
  endfunction

  virtual function void write(ahb_transaction tx);
    if (tx.hresp == 2'b00) begin
      if (tx.hwrite == 1'b1) begin
        ref_memory[tx.haddr] = tx.hwdata;
        `uvm_info("SCB_WRITE", $sformatf("Stored Data %0h at Address %0h", tx.hwdata, tx.haddr), UVM_LOW)
      end else begin
        if (ref_memory.exists(tx.haddr)) begin
          if (tx.hrdata == ref_memory[tx.haddr]) begin
            `uvm_info("SCB_PASS", $sformatf("Read MATCH! Addr: %0h, Expected: %0h, Actual: %0h", tx.haddr, ref_memory[tx.haddr], tx.hrdata), UVM_LOW)
          end else begin
            `uvm_error("SCB_FAIL", $sformatf("Read MISMATCH! Addr: %0h, Expected: %0h, Actual: %0h", tx.haddr, ref_memory[tx.haddr], tx.hrdata))
          end
        end else begin
           `uvm_info("SCB_WARN", $sformatf("Read from uninitialized address: %0h", tx.haddr), UVM_LOW)
        end
      end
    end
  endfunction
endclass