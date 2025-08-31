package test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "write_xtn.sv"
  `include "wr_agent_config.sv"
  `include "rd_agent_config.sv"
  `include "env_config.sv"

  `include "wr_driver.sv"
  `include "wr_monitor.sv"
  `include "wr_sequencer.sv"
  `include "wr_agent.sv"
  `include "wr_agt_top.sv"
  `include "wr_seqs.sv"

  `include "rd_monitor.sv"
  `include "rd_agent.sv"
  `include "rd_agt_top.sv"

  `include "scoreboard.sv"
  `include "env.sv"
  `include "test.sv"   
endpackage : test_pkg
