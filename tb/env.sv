class env extends uvm_env;

    `uvm_component_utils(env);

    wr_agt_top wagt_top;
    rd_agt_top ragt_top;
    scoreboard sb;

    env_config m_cfg;

    extern function new(string name = "env", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass


function env::new(string name = "env", uvm_component parent);
    super.new(name, parent);
endfunction


function void env::build_phase(uvm_phase phase);
    super.build_phase(phase);

	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	  `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    

	uvm_config_db #(wr_agent_config)::set(this,"wagt_top*","wr_agent_config", m_cfg.wr_agt_cfg);
    wagt_top = wr_agt_top::type_id::create("wagt_top", this);

	uvm_config_db #(rd_agent_config)::set(this,"ragt_top*","rd_agent_config", m_cfg.rd_agt_cfg);
    ragt_top = rd_agt_top::type_id::create("ragt_top", this);

    sb = scoreboard::type_id::create("sb", this);
endfunction

function void env::connect_phase(uvm_phase phase);
    wagt_top.agnth.monh.monitor_port.connect(sb.wr_fifo.analysis_export);
    ragt_top.agnth.monh.monitor_port.connect(sb.rd_fifo.analysis_export);
endfunction