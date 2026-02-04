// =========================================================================
  // SPI DRIVER
  // =========================================================================
  
  class spi_driver extends uvm_driver #(spi_transaction);
    `uvm_component_utils(spi_driver)
    
    virtual spi_if vif;
    spi_config cfg;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
        `uvm_fatal(get_type_name(), "Virtual interface not found")
      
      if (!uvm_config_db#(spi_config)::get(this, "", "cfg", cfg))
        `uvm_warning(get_type_name(), "Config not found, using defaults")
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      spi_transaction tr;
      
      // Initialize
      vif.cs_n  <= 1'b1;
      vif.sclk  <= 1'b0;
      vif.mosi  <= 1'b0;
      
      forever begin
        seq_item_port.get_next_item(tr);
        
        `uvm_info(get_type_name(), $sformatf("Driving transaction:\n%s", 
                  tr.convert2string()), UVM_MEDIUM)
        
        drive_transaction(tr);
        
        seq_item_port.item_done();
      end
    endtask
    
    virtual task drive_transaction(spi_transaction tr);
      int num_bits = tr.get_num_bits();
      bit [31:0] tx_data = tr.mosi_data;
      bit [31:0] rx_data = 0;
      real half_period;
      
      // Calculate clock period
      half_period = (1000.0 / (2.0 * tr.sclk_freq_mhz)); // in ns
      
      tr.start_time = $time;
      
      // Assert CS_N
      vif.cs_n <= 1'b0;
      #(half_period * 2);
      
      // Transfer bits
      for (int i = num_bits - 1; i >= 0; i--) begin
        // Setup data on MOSI
        if (tr.lsb_first)
          vif.mosi <= tx_data[num_bits - 1 - i];
        else
          vif.mosi <= tx_data[i];
        
        // Clock edge 1 (based on CPHA)
        if (tr.spi_mode[0] == 0) begin  // CPHA=0: sample on first edge
          #(half_period);
          vif.sclk <= ~vif.sclk;
          #1;  // Sample delay
          if (tr.lsb_first)
            rx_data[num_bits - 1 - i] = vif.miso;
          else
            rx_data[i] = vif.miso;
        end else begin  // CPHA=1: sample on second edge
          #(half_period);
          vif.sclk <= ~vif.sclk;
        end
        
        // Clock edge 2
        #(half_period);
        vif.sclk <= ~vif.sclk;
        
        if (tr.spi_mode[0] == 1) begin  // CPHA=1: sample on second edge
          #1;
          if (tr.lsb_first)
            rx_data[num_bits - 1 - i] = vif.miso;
          else
            rx_data[i] = vif.miso;
        end
      end
      
      // Deassert CS_N
      #(half_period);
      vif.cs_n <= 1'b1;
      
      // Update received data
      tr.miso_data = rx_data;
      tr.end_time = $time;
      
      #(half_period * 2);  // Inter-transfer gap
    endtask
    
  endclass
