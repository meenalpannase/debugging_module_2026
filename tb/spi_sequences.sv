// =========================================================================
  // SPI SEQUENCES
  // =========================================================================
  
  // Base Sequence
  class spi_base_seq extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_base_seq)
    
    function new(string name = "spi_base_seq");
      super.new(name);
    endfunction
    
  endclass
  
  // Simple sequence - single transaction
  class spi_simple_seq extends spi_base_seq;
    `uvm_object_utils(spi_simple_seq)
    
    function new(string name = "spi_simple_seq");
      super.new(name);
    endfunction
    
    virtual task body();
      spi_transaction tr;
      
      tr = spi_transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize() with {
        mosi_data == 32'hA5;
        spi_mode == SPI_MODE_0;
        data_width == DATA_8BIT;
      });
      finish_item(tr);
    endtask
    
  endclass
  
  // Random sequence - multiple random transactions
  class spi_random_seq extends spi_base_seq;
    `uvm_object_utils(spi_random_seq)
    
    rand int num_transactions;
    
    constraint c_num { num_transactions inside {[5:20]}; }
    
    function new(string name = "spi_random_seq");
      super.new(name);
    endfunction
    
    virtual task body();
      spi_transaction tr;
      
      repeat(num_transactions) begin
        tr = spi_transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        finish_item(tr);
      end
    endtask
    
  endclass
  
  // All modes sequence
  class spi_all_modes_seq extends spi_base_seq;
    `uvm_object_utils(spi_all_modes_seq)
    
    function new(string name = "spi_all_modes_seq");
      super.new(name);
    endfunction
    
    virtual task body();
      spi_transaction tr;
      
      foreach (spi_mode_e[mode]) begin
        tr = spi_transaction::type_id::create($sformatf("tr_mode%0d", mode));
        start_item(tr);
        assert(tr.randomize() with {
          spi_mode == mode;
        });
        finish_item(tr);
      end
    endtask
    
  endclass
  
