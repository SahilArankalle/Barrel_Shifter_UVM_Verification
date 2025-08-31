class wr_seqs extends uvm_sequence #(write_xtn);

    `uvm_object_utils(wr_seqs)

    extern function new(string name = "wr_seqs");
    extern task body();
endclass


function wr_seqs::new(string name = "wr_seqs");
    super.new(name);
endfunction


task wr_seqs::body();

    repeat(10)
        begin
            req = write_xtn::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
            `uvm_info("WRITE_SEQ", $sformatf("Generated write transaction: \n%s", req.sprint()), UVM_MEDIUM)

        end
endtask



class wr_seqs_cover extends wr_seqs;
  `uvm_object_utils(wr_seqs_cover)

  function new(string name="wr_seqs_cover");
    super.new(name);
  endfunction

  task body();
    write_xtn req;

    // Generate constrained data values [2..9]
    for (int d = 0; d <= 15; d++) begin
      req = write_xtn::type_id::create($sformatf("req_%0d", d));
      start_item(req);
      assert(req.randomize() with { data == d; });
      finish_item(req);
    end

    // Call base class body() for random rest
    super.body();
  endtask
endclass





