class rd_monitor extends uvm_monitor;
    `uvm_component_utils(rd_monitor)

    virtual shifter_if.RMON_MP vif;

    rd_agent_config m_cfg;

    uvm_analysis_port #(write_xtn) monitor_port;

    extern function new(string name = "rd_monitor", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task collect_data();
    extern function void report_phase(uvm_phase phase);

endclass


function rd_monitor::new(string name = "rd_monitor", uvm_component parent);
    super.new(name,parent);
    monitor_port = new("monitor_port", this);
endfunction


function void rd_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(rd_agent_config)::get(this,"","rd_agent_config", m_cfg))
        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction


function void rd_monitor::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
endfunction


task rd_monitor::run_phase(uvm_phase phase);
    forever
        collect_data();
endtask


task rd_monitor::collect_data();
    write_xtn data_rcvd;

    data_rcvd = write_xtn::type_id::create("data_rcvd");

    @(vif.rmon_cb);
    @(vif.rmon_cb);
    @(vif.rmon_cb);

    data_rcvd.result = vif.rmon_cb.result;

    `uvm_info("RD_MONITOR",$sformatf("Transaction collected: \n %s", data_rcvd.sprint()),UVM_LOW)

    monitor_port.write(data_rcvd);

    m_cfg.mon_rcvd_xtn_cnt++;
endtask


function void rd_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("Report: %s Collected %0d Transactions", get_full_name(), m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction
