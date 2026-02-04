// =========================================================================
  // SPI COVERAGE
  // =========================================================================
  
  class spi_coverage extends uvm_subscriber #(spi_transaction);
    `uvm_component_utils(spi_coverage)
    
    spi_transaction tr;
    
    covergroup spi_cg;
      
      cp_mode: coverpoint tr.spi_mode {
        bins mode_0 = {SPI_MODE_0};
        bins mode_1 = {SPI_MODE_1};
        bins mode_2 = {SPI_MODE_2};
        bins mode_3 = {SPI_MODE_3};
      }
      
      cp_width: coverpoint tr.data_width {
        bins width_8  = {DATA_8BIT};
        bins width_16 = {DATA_16BIT};
        bins width_32 = {DATA_32BIT};
      }
      
      cp_freq: coverpoint tr.sclk_freq_mhz {
        bins low    = {[1:10]};
        bins medium = {[11:25]};
        bins high   = {[26:50]};
      }
      
      cp_lsb_first: coverpoint tr.lsb_first {
        bins msb_first = {0};
        bins lsb_first = {1};
      }
      
      // Cross coverage
      cx_mode_width: cross cp_mode, cp_width;
      
    endgroup
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      spi_cg = new();
    endfunction
    
    virtual function void write(spi_transaction t);
      tr = t;
      spi_cg.sample();
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("SPI Coverage: %.2f%%", 
                spi_cg.get_coverage()), UVM_LOW)
    endfunction
    
  endclass
