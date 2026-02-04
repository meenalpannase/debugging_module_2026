// =========================================================================
  // SPI MONITOR
  // =========================================================================
  
  class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)
    
    virtual spi_if vif;
    spi_config cfg;
    
    uvm_analysis_port #(spi_transaction) analysis_port;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      analysis_port = new("analysis_port", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
        `uvm_fatal(get_type_name(), "Virtual interface not found")
      
      if (!uvm_config_db#(spi_config)::get(this, "", "cfg", cfg))
        `uvm_warning(get_type_name(), "Config not found")
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      forever begin
        collect_transaction();
      end
    endtask
    
    virtual task collect_transaction();
      spi_transaction tr;
      bit [31:0] mosi_data = 0;
      bit [31:0] miso_data = 0;
      int bit_count = 0;
      
      // Wait for CS_N to go low
      @(negedge vif.cs_n);
      
      tr = spi_transaction::type_id::create("tr");
      tr.start_time = $time;
      
      // Collect data bits
      while (!vif.cs_n && bit_count < 32) begin
        @(posedge vif.sclk or negedge vif.sclk);
        
        // Sample on appropriate edge
        mosi_data = {mosi_data[30:0], vif.mosi};
        miso_data = {miso_data[30:0], vif.miso};
        bit_count++;
      end
      
      tr.mosi_data = mosi_data;
      tr.miso_data = miso_data;
      tr.end_time = $time;
      
      // Determine data width based on bit count
      if (bit_count <= 8)
        tr.data_width = DATA_8BIT;
      else if (bit_count <= 16)
        tr.data_width = DATA_16BIT;
      else
        tr.data_width = DATA_32BIT;
      
      `uvm_info(get_type_name(), $sformatf("Collected transaction:\n%s", 
                tr.convert2string()), UVM_HIGH)
      
      analysis_port.write(tr);
    endtask
    
  endclass
  
