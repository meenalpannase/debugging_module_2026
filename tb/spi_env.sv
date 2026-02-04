// =========================================================================
  // SPI ENVIRONMENT
  // =========================================================================
  
  class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)
    
    spi_agent      agent;
    spi_scoreboard scoreboard;
    spi_coverage   coverage;
    spi_config     cfg;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if (!uvm_config_db#(spi_config)::get(this, "", "cfg", cfg))
        `uvm_fatal(get_type_name(), "Config not found")
      
      agent = spi_agent::type_id::create("agent", this);
      
      if (cfg.has_scoreboard)
        scoreboard = spi_scoreboard::type_id::create("scoreboard", this);
      
      if (cfg.has_coverage)
        coverage = spi_coverage::type_id::create("coverage", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      if (cfg.has_scoreboard)
        agent.analysis_port.connect(scoreboard.analysis_imp);
      
      if (cfg.has_coverage)
        agent.analysis_port.connect(coverage.analysis_export);
    endfunction
    
  endclass
  
  
