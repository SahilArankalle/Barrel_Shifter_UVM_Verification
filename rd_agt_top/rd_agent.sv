class rd_agent extends uvm_agent;

    `uvm_component_utils(rd_agent)

    rd_agent_config m_cfg;

    rd_monitor monh;

    extern function new(string name = "rd_agent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass


function rd_agent::new(string name = "rd_agent", uvm_component parent);
    super.new(name, parent);
endfunction


function void rd_agent::build_phase(uvm_phase phase);
    super.build_phase(phase); 

	    monh=rd_monitor::type_id::create("monh",this);	
endfunction

