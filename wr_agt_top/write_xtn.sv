class write_xtn extends uvm_sequence_item;
    rand bit [3:0] data;
    rand bit [1:0] shift;
    rand bit dir;

    bit [3:0] result;

    `uvm_object_utils(write_xtn)

    constraint a{
        data inside {[0:15]};
        shift inside {[0:3]};
        dir inside {[0:1]};
    }

    extern function new (string name = "write_xtn");
    extern function void do_print (uvm_printer printer);
endclass

function write_xtn::new(string name = "write_xtn");
    super.new(name);
endfunction 

function void write_xtn::do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("data", data, 4, UVM_BIN);
    printer.print_field("shift", shift, 2, UVM_DEC);
    printer.print_field("dir", dir, 1, UVM_DEC);
    printer.print_field("result", result, 4, UVM_BIN);
endfunction 
