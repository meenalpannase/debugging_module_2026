// ============================================================================
// SPI INTERFACE
// ============================================================================

interface spi_if (input logic clk);
  
  logic sclk;
  logic mosi;
  logic miso;
  logic cs_n;
  
  // Master signals
  clocking master_cb @(posedge clk);
    output sclk;
    output mosi;
    output cs_n;
    input  miso;
  endclocking
  
  // Slave signals
  clocking slave_cb @(posedge clk);
    input  sclk;
    input  mosi;
    input  cs_n;
    output miso;
  endclocking
  
  modport master (clocking master_cb);
  modport slave (clocking slave_cb);
  
endinterface

