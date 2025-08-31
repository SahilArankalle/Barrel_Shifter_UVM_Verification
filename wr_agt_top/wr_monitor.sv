class wr_monitor extends uvm_monitor;
    `uvm_component_utils(wr_monitor)

    virtual shifter_if.WMON_MP vif;

    wr_agent_config m_cfg;

    uvm_analysis_port #(write_xtn) monitor_port;

    extern function new(string name = "wr_monitor", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task collect_data();
    extern function void report_phase(uvm_phase phase);

endclass


function wr_monitor::new(string name = "wr_monitor", uvm_component parent);
    super.new(name,parent);
    monitor_port = new("monitor_port", this);
endfunction


function void wr_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(wr_agent_config)::get(this,"","wr_agent_config",m_cfg))
        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction


function void wr_monitor::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
endfunction


task wr_monitor::run_phase(uvm_phase phase);
    forever
        collect_data();
endtask


task wr_monitor::collect_data();
    write_xtn data_sent;

    data_sent = write_xtn::type_id::create("data_sent");

    @(vif.wmon_cb);

    data_sent.data = vif.wmon_cb.data;
    data_sent.shift = vif.wmon_cb.shift;
    data_sent.dir = vif.wmon_cb.dir;


    `uvm_info("WR_MONITOR",$sformatf("Transaction collected: \n %s", data_sent.sprint()),UVM_LOW)

    monitor_port.write(data_sent);

    m_cfg.mon_rcvd_xtn_cnt++;
endtask


function void wr_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("Report: %s Collected %0d Transactions", get_full_name(), m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction
