module barrel_shifter(
    input clk,
    input [3:0] data,
    input [1:0] shift,
    input dir,    // 0 for left, 1 for right
    output reg [3:0] result
);

always @ (posedge clk) begin
    if (dir == 1'b0) begin
        case(shift)
            2'b00: result = data;
            2'b01: result = {data[2:0], 1'b0};
            2'b10: result = {data[1:0], 2'b00};
            2'b11: result = {data[0], 3'b000};
        endcase
    end else begin
        case(shift)
            2'b00: result = data;
            2'b01: result = {1'b0, data[3:1]};
            2'b10: result = {2'b00, data[3:2]};
            2'b11: result = {3'b000, data[3]};
        endcase
    end
end

endmodule
