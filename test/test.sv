// test.sv  -- corrected and ready-to-compile

class test extends uvm_test;
  `uvm_component_utils(test)

  env_config        env_cfg;
  wr_agent_config   wr_agt_cfg;
  rd_agent_config   rd_agt_cfg;

  env               e;
  wr_seqs           wseq;

  extern function new(string name = "test", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

function test::new(string name = "test", uvm_component parent = null);
  super.new(name, parent);
endfunction


function void test::build_phase(uvm_phase phase);
  // create config objects
  env_cfg = env_config::type_id::create("env_cfg");

  wr_agt_cfg = wr_agent_config::type_id::create("wr_agt_cfg");
  if (!uvm_config_db#(virtual shifter_if)::get(this, "", "vif0", wr_agt_cfg.vif))
    `uvm_fatal("VIRTUAL CONFIG", "cannot get the vif have you set it?")

  env_cfg.wr_agt_cfg = this.wr_agt_cfg;

  rd_agt_cfg = rd_agent_config::type_id::create("rd_agt_cfg");
  if (!uvm_config_db#(virtual shifter_if)::get(this, "", "vif1", rd_agt_cfg.vif))
    `uvm_fatal("VIRTUAL CONFIG", "cannot get the vif have you set it?")

  env_cfg.rd_agt_cfg = this.rd_agt_cfg;

  uvm_config_db#(env_config)::set(this, "*", "env_config", env_cfg);

  super.build_phase(phase);

  // instantiate environment under this test
  e = env::type_id::create("e", this);
endfunction


task test::run_phase(uvm_phase phase);
  // declarations must come before executable statements
  wseq = wr_seqs::type_id::create("wseq");

  phase.raise_objection(this);

  // start baseline sequence (this blocks until sequence completes)
  wseq.start(e.wagt_top.agnth.seqrh);

  #500;

  phase.drop_objection(this);
endtask


function void test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology;
endfunction


// -----------------------------------------------------------------
// cover_test: an extended test that runs the cover-directed sequence
// -----------------------------------------------------------------
class cover_test extends test;
  `uvm_component_utils(cover_test)

  function new(string name = "cover_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // override run_phase: declaration before statements
  task run_phase(uvm_phase phase);
    // declare local sequence handle before any statements
    wr_seqs_cover wseq_c;

    phase.raise_objection(this);

    // create and start the directed coverage sequence
    wseq_c = wr_seqs_cover::type_id::create("wseq_c");
    wseq_c.start(e.wagt_top.agnth.seqrh);

    #500;
    phase.drop_objection(this);
  endtask
endclass
