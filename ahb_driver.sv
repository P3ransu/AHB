`timescale 1ns / 1ps
virtual task run_phase(uvm_phase phase);
    ahb_transaction req;
    vif.htrans <= 2'b00;
    forever begin 
    // getting transaction from sequencer
    seq_item_port.get_next_item(req);
    // address phase
    vif.haddr <= req.haddr;
    vif.hwdata <= req.hwdata;
    vif.hsize <= req.hsize;
    vif.hburst <= req.hburst
    vif.htrans <= 2'b10;
    
    @(posedge vif.hclk);
    
    //stalling pipeline incase of address phase not complete 
    while( vif.hready == 1'b0) begin
        @(posedge vif.hclk);
    end 
    
    // data phase 
    
    fork 
        automatic ahb_transaction data_req = req;
        drive_data_phase(data_req)
    join_none
    
    seq_item_port.item.done()
    end 
    endtask   
task drive_data_phase(ahb_transaction req);

    vif.hwdata <= hwdata ;
end

do begin 
    @(posedge vif.hclk);
end while(vif.hready ==1'b0);

endtask