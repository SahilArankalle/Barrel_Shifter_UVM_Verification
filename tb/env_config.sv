class env_config extends uvm_object;

    wr_agent_config wr_agt_cfg;
    rd_agent_config rd_agt_cfg;

    `uvm_object_utils(env_config)

    extern function new(string name = "env_config");

endclass


function env_config::new(string name = "env_config");
    super.new(name);
endfunction

