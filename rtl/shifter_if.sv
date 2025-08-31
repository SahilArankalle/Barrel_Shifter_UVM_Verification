interface shifter_if (input bit clk);

    logic [3:0] data;
    logic [1:0] shift;
    logic dir;
    logic [3:0] result;

    clocking wdrv_cb @(posedge clk);
        default input #1 output #0;
        output data, shift, dir;
    endclocking

    clocking wmon_cb @(posedge clk);
        default input #1 output #0;
        input data, shift, dir;
    endclocking

    clocking rmon_cb @(posedge clk);
        default input #1 output #0;
        input result;
    endclocking

    modport WDRV_MP (clocking wdrv_cb);
    modport WMON_MP (clocking wmon_cb);
    modport RMON_MP (clocking rmon_cb);

endinterface 
