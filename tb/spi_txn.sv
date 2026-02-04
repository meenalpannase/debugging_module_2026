class spi_transaction extends uvm_sequence_item;
    
    // Transaction fields
    rand bit [31:0]    mosi_data;    // Data to transmit (Master->Slave)
    rand bit [31:0]    miso_data;    // Data received (Slave->Master)
    rand spi_mode_e    spi_mode;     // SPI operating mode
    rand data_width_e  data_width;   // Transfer width
    rand int           sclk_freq_mhz; // Clock frequency
    rand bit           lsb_first;    // 0=MSB first, 1=LSB first
    
    // Timing
    time               start_time;
    time               end_time;
    
    `uvm_object_utils_begin(spi_transaction)
      `uvm_field_int(mosi_data, UVM_ALL_ON)
      `uvm_field_int(miso_data, UVM_ALL_ON)
      `uvm_field_enum(spi_mode_e, spi_mode, UVM_ALL_ON)
      `uvm_field_enum(data_width_e, data_width, UVM_ALL_ON)
      `uvm_field_int(sclk_freq_mhz, UVM_ALL_ON)
      `uvm_field_int(lsb_first, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_reasonable {
      sclk_freq_mhz inside {[1:50]};
      soft spi_mode == SPI_MODE_0;
      soft data_width == DATA_8BIT;
      soft lsb_first == 0;
    }
    
    function new(string name = "spi_transaction");
      super.new(name);
    endfunction
    
    function int get_num_bits();
      case (data_width)
        DATA_8BIT:  return 8;
        DATA_16BIT: return 16;
        DATA_32BIT: return 32;
        default:    return 8;
      endcase
    endfunction
    
    function string convert2string();
      return $sformatf(
        "SPI Transaction:\n  MOSI: 0x%0h\n  MISO: 0x%0h\n  Mode: %s\n  Width: %0d bits\n  Freq: %0d MHz",
        mosi_data, miso_data, spi_mode.name(), get_num_bits(), sclk_freq_mhz
      );
    endfunction
    
  endclass
  
  
