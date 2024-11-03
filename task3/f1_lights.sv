module f1_lights #(
        parameter WIDTH = 16
)(
    input logic     clk,
    input logic     rst,
    input logic en,
    input  logic [WIDTH-1:0] N,
    output logic current_tick,
    output logic [7:0]data_out
);

logic tick;
assign current_tick = tick;

clktick clktick (
    .clk (clk),
    .rst (rst),
    .en (en),
    .N (N),
    .tick (tick)
);

f1_fsm f1_fsm (
    .clk(current_tick),
    .rst(rst),
    .en(en),
    .data_out(data_out)
);

endmodule