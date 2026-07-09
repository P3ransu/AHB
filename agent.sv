import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_agent extends uvm_agent ;
    `uvm_component_utils(uvm_agent)
    
    ahb_driver driver;
    ahb_sequencer sequencer ;
    ahb_monitor monitor;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        monitor = ahb_monitor :: type_id::create("monitor", this);
     
        if (get_is_active() == UVM_ACTIVE) begin 
            driver = ahb_driver :: type_id :: create("Driver",this);
            sequencer = ahb_sequencer :: type_id ::create("Sequencer", this);
        end
     endfunction
     
     virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active() == UVM_ACTIVE) begin 
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
        endfunction
        
endclass