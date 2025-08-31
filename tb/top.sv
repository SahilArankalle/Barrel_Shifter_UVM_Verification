module top;

    import uvm_pkg::*;
    import test_pkg::*;


    logic clk;

    shifter_if if0(clk);
    shifter_if if1(clk);

    barrel_shifter dut(
        .clk(clk),
        .data(if0.data),
        .shift(if0.shift),
        .dir(if0.dir),
        .result(if1.result)
    );

    initial clk = 0;
    always #5 clk = ~clk;

  
    
    property shift_left;
        @(posedge clk) 
        (if0.dir == 0) |-> (
            (if0.shift == 2'b00) -> (if1.result == if0.data) &&
            (if0.shift == 2'b01) -> (if1.result == {if0.data[2:0],1'b0}) &&
            (if0.shift == 2'b10) -> (if1.result == {if0.data[1:0],2'b00}) &&
            (if0.shift == 2'b11) -> (if1.result == {if0.data[0],3'b000})
        );

    endproperty
    assert property(shift_left)
    else $error("Shift Left assertion failed");

    property shift_right;
        @(posedge clk) 
        (if0.dir == 1) |-> (
            (if0.shift == 2'b00) -> (if1.result == if0.data) &&
            (if0.shift == 2'b01) -> (if1.result == {1'b0,if0.data[3:1]}) &&
            (if0.shift == 2'b10) -> (if1.result == {2'b00,if0.data[3:2]}) &&
            (if0.shift == 2'b11) -> (if1.result == {3'b000,if0.data[3]}));
    endproperty
    assert property(shift_right)
    else $error("Shift Right assertion failed");

    initial 
        begin

        `ifdef VCS
            $fsdbDumpvars(0, top);
        `endif

            uvm_config_db #(virtual shifter_if)::set(null, "*", "vif0", if0);
            uvm_config_db #(virtual shifter_if)::set(null, "*", "vif1", if1);
            run_test();
        end

endmodule
