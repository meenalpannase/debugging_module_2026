// =========================================================================
  // SPI CONFIGURATION
  // =========================================================================
  
  class spi_config extends uvm_object;
    
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    bit has_coverage = 1;
    bit has_scoreboard = 1;
    
    spi_mode_e default_mode = SPI_MODE_0;
    int default_freq_mhz = 10;
    
    `uvm_object_utils_begin(spi_config)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
      `uvm_field_int(has_coverage, UVM_ALL_ON)
      `uvm_field_int(has_scoreboard, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "spi_config");
      super.new(name);
    endfunction
    
  endclass
  
