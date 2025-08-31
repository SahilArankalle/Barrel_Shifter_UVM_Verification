class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_tlm_analysis_fifo #(write_xtn) wr_fifo;
    uvm_tlm_analysis_fifo #(write_xtn) rd_fifo;

    write_xtn sample_xtn;

    int pass, fail;

    covergroup fcov1;
        option.per_instance = 1;

        cp_shift : coverpoint sample_xtn.shift {
            bins shift_0 = {0};
            bins shift_1 = {1};
            bins shift_2 = {2};
            bins shift_3 = {3};
        }

        cp_dir : coverpoint sample_xtn.dir {
            bins left  = {0};
            bins right = {1};
        }

        cp_data : coverpoint sample_xtn.data {
            bins vals[] = {[0:15]};
        }

        cp_dir_x_shift : cross cp_dir, cp_shift;
    endgroup : fcov1

    extern function new(string name = "scoreboard", uvm_component parent = null);
    extern function bit [3:0] ref_model(input bit [3:0] data, input [1:0] shift, input bit dir);
    extern task check_and_cover(write_xtn in_xtn);
    extern task run_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
endclass


function scoreboard::new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);

    wr_fifo = new("wr_fifo", this);
    rd_fifo = new("rd_fifo", this);

    fcov1 = new();

    pass = 0;
    fail = 0;

    sample_xtn = null;
endfunction


function bit [3:0] scoreboard::ref_model(input bit [3:0] data, input [1:0] shift, input bit dir);
    if (dir == 1'b0)
        ref_model = data << shift;
    else
        ref_model = data >> shift;
endfunction


task scoreboard::check_and_cover(write_xtn in_xtn);
    bit [3:0] exp_result;

    if (in_xtn == null) begin
        `uvm_error("SCOREBOARD", "check_and_cover called with null transaction")
        return;
    end

    exp_result = ref_model(in_xtn.data, in_xtn.shift, in_xtn.dir);

    if (exp_result == in_xtn.result) begin
        pass++;
        `uvm_info("SCOREBOARD", $sformatf("PASS: data=%0b shift=%0d dir=%0d => result=%0b (expected=%0b)",
                                          in_xtn.data, in_xtn.shift, in_xtn.dir, in_xtn.result, exp_result),
                  UVM_LOW)
    end else begin
        fail++;
        `uvm_info("SCOREBOARD", $sformatf("FAIL: data=%0b shift=%0d dir=%0d => result=%0b (expected=%0b)",
                                          in_xtn.data, in_xtn.shift, in_xtn.dir, in_xtn.result, exp_result),
                  UVM_LOW)
    end

    sample_xtn = in_xtn;

    if (sample_xtn != null) begin
        fcov1.sample();
    end
endtask


task scoreboard::run_phase(uvm_phase phase);
    write_xtn rx;
    forever begin
        wr_fifo.get(rx);
        check_and_cover(rx);
    end
endtask


function void scoreboard::report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", $sformatf("Final Report: PASS=%0d FAIL=%0d", pass, fail), UVM_NONE)
endfunction
