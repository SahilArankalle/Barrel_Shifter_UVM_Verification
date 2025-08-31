class rd_agent_config extends uvm_object;

    `uvm_object_utils(rd_agent_config)

    virtual shifter_if vif;

    static int mon_rcvd_xtn_cnt = 0;

    extern function new(string name = "rd_agent_config");

endclass

function rd_agent_config::new(string name = "rd_agent_config");
    super.new(name);
endfunction