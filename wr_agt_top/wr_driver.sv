class wr_driver extends uvm_driver #(write_xtn);
    `uvm_component_utils(wr_driver)

    virtual shifter_if.WDRV_MP vif;

    wr_agent_config m_cfg;

    write_xtn req;

    extern function new(string name = "wr_driver", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task send_to_dut(write_xtn xtn);
    extern function void report_phase(uvm_phase phase);
endclass


function wr_driver::new(string name = "wr_driver", uvm_component parent);
    super.new(name, parent);
endfunction


function void wr_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(wr_agent_config)::get(this, "", "wr_agent_config", m_cfg)) 
        `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction


function void wr_driver::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
endfunction


task wr_driver::run_phase(uvm_phase phase);
    forever 
        begin
            seq_item_port.get_next_item(req);
            send_to_dut(req);
            seq_item_port.item_done();
        end
endtask


task wr_driver::send_to_dut(write_xtn xtn);

    `uvm_info("WR_DRIVER", $sformatf("Driver sending transaction:\n%s", xtn.sprint()), UVM_LOW)

    
    @(vif.wdrv_cb);
    
    vif.wdrv_cb.data <= xtn.data;
    vif.wdrv_cb.shift <= xtn.shift;
    vif.wdrv_cb.dir <= xtn.dir;

    @(vif.wdrv_cb);

    vif.wdrv_cb.data <= '0;
    vif.wdrv_cb.shift <= '0;
    vif.wdrv_cb.dir <= '0;


    @(vif.wdrv_cb);

    m_cfg.drv_data_sent_cnt++;
endtask


function void wr_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: write driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
endfunction



