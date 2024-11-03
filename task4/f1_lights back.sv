module f1_lights #(
        parameter WIDTH = 16
)(
    input   logic     clk,
    input   logic     rst,
    input   logic en,
    input   logic trigger,
    input   logic [WIDTH-1:0] N,
    output  logic [WIDTH-1:0] count,
    output  logic current_tick,
    output  logic current_cmd_seq,
    output  logic current_cmd_delay,
    output  logic [5:0] current_delay,
    output  logic current_time_out,
    output  logic [7:0]data_out
);

logic tick;
assign current_tick = tick;

logic cmd_seq;
assign current_cmd_seq = cmd_seq;

logic cmd_delay;
assign current_cmd_delay = cmd_delay;

logic [5:0] delayo;
assign current_delay = delayo;

logic time_out;
assign current_time_out = time_out;

logic [WIDTH-1:0] current_count;
assign current_count = count;

logic run;

always_comb 
    if (cmd_seq)
        run <= 1'b1;

    else
        run <= 1'b0;

clktick clktick (
    .clk (clk),
    .rst (rst),
    .en (run),
    .N (N),
    .count (count),
    .tick (tick)
);

f1_fsm f1_fsm (
    .clk(tick),
    .rst(rst),
    .data_out(data_out),
    .trigger(trigger),
    .cmd_seq(cmd_seq),
    .cmd_delay(cmd_delay)
);

delay delays (
    .clk(clk),
    .rst(rst),
    .trigger(cmd_delay),
    .n({delayo}),
    .time_out(time_out)
);

lfsr_7 lfsr_7(
    .clk(clk),
    .rst(rst),
    .data_out(delayo)
);

endmodule
