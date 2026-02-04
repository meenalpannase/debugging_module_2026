// ============================================================================
// TOP MODULE
// ============================================================================

module tb_top;
  import uvm_pkg::*;
  import spi_pkg::*;
  
  logic clk;
  
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  // SPI interface
  spi_if spi_if_inst (clk);
  
  // DUT instantiation
  spi_slave dut (
    .sclk(spi_if_inst.sclk),
    .mosi(spi_if_inst.mosi),
    .cs_n(spi_if_inst.cs_n),
    .miso(spi_if_inst.miso)
  );
  
  // Set interface in config_db
  initial begin
    uvm_config_db#(virtual spi_if)::set(null, "*", "vif", spi_if_inst);
    
    // Run test
    run_test();
  end
  
  // Waveform dump
  initial begin
    $dumpfile("spi.vcd");
    $dumpvars(0, tb_top);
  end
  
  // Timeout
  initial begin
    #100000;
    `uvm_fatal("TIMEOUT", "Simulation timeout!")
  end
  
endmodule
