// =========================================================================
  // SPI TEST
  // =========================================================================
  
  class spi_base_test extends uvm_test;
    `uvm_component_utils(spi_base_test)
    
    spi_env env;
    spi_config cfg;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      cfg = spi_config::type_id::create("cfg");
      uvm_config_db#(spi_config)::set(this, "*", "cfg", cfg);
      
      env = spi_env::type_id::create("env", this);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
    endfunction
    
  endclass
  
  // Simple test
  class spi_simple_test extends spi_base_test;
    `uvm_component_utils(spi_simple_test)
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      spi_simple_seq seq;
      
      phase.raise_objection(this);
      
      seq = spi_simple_seq::type_id::create("seq");
      seq.start(env.agent.sequencer);
      
      #1000;
      phase.drop_objection(this);
    endtask
    
  endclass
  
  // Random test
  class spi_random_test extends spi_base_test;
    `uvm_component_utils(spi_random_test)
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      spi_random_seq seq;
      
      phase.raise_objection(this);
      
      seq = spi_random_seq::type_id::create("seq");
      assert(seq.randomize() with { num_transactions == 10; });
      seq.start(env.agent.sequencer);
      
      #5000;
      phase.drop_objection(this);
    endtask
    
  endclass
