interface ahb_if(input logic hclk, input logic hresetn);
  logic [31:0] haddr;
  logic [31:0] hwdata;
  logic [31:0] hrdata;
  logic        hwrite;
  logic [2:0]  hsize;
  logic [2:0]  hburst;
  logic [1:0]  htrans;
  logic        hready;
  logic [1:0]  hresp;

  property p_hold_signals_during_wait;
    @(posedge hclk) disable iff (!hresetn)
    (!hready |=> ($stable(haddr) && $stable(hwrite)));
  endproperty

  assert_pipeline_stall: assert property (p_hold_signals_during_wait)
    else $error("AHB PROTOCOL VIOLATION: Master changed signals during wait state!");
endinterface