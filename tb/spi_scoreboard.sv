// =========================================================================
  // SPI SCOREBOARD
  // =========================================================================
  
  class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)
    
    uvm_analysis_imp #(spi_transaction, spi_scoreboard) analysis_imp;
    
    int transactions_received;
    int transactions_passed;
    int transactions_failed;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      analysis_imp = new("analysis_imp", this);
    endfunction
    
    virtual function void write(spi_transaction tr);
      transactions_received++;
      
      `uvm_info(get_type_name(), $sformatf("Checking transaction #%0d:\n%s",
                transactions_received, tr.convert2string()), UVM_MEDIUM)
      
      // Add your checking logic here
      // For this example, we just count transactions
      transactions_passed++;
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      
      `uvm_info(get_type_name(), $sformatf("\n\
╔════════════════════════════════════════════════════════════╗\n\
║              SPI SCOREBOARD REPORT                         ║\n\
╠════════════════════════════════════════════════════════════╣\n\
║ Transactions Received: %-30d ║\n\
║ Transactions Passed:   %-30d ║\n\
║ Transactions Failed:   %-30d ║\n\
╚════════════════════════════════════════════════════════════╝",
        transactions_received, transactions_passed, transactions_failed), UVM_NONE)
    endfunction
    
  endclass
  
