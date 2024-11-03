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
    output  logic [7:0] current_delay,
    output  logic current_time_out,
    output  logic current_run,
    output  logic [7:0]data_out
);

logic tick;
assign current_tick = tick;

logic cmd_seq;
assign current_cmd_seq = cmd_seq;

logic cmd_delay;
assign current_cmd_delay = cmd_delay;

logic [7:0] delayo;
assign current_delay = delayo;

logic time_out;
assign current_time_out = time_out;

logic [WIDTH-1:0] current_count;
assign current_count = count;

logic run;
assign current_run = run;

always_comb
    if (cmd_seq)
        run <= tick;
    else
        run <= time_out;

f1_fsm f1_fsm (
    .clk(clk),
    .trigger(trigger),
    .en(run),
    .rst(rst),
    .cmd_seq(cmd_seq),
    .cmd_delay(cmd_delay),
    .data_out(data_out)
);

delay delays (
    .clk(clk),
    .rst(rst),
    .trigger(cmd_delay),
    .n(delayo),
    .time_out(time_out)
);

lfsr_7 lfsr_7 (
    .clk(clk),
    .rst(rst),
    .data_out(delayo)    
);

clktick clktick (
    .clk(clk),
    .en(cmd_seq),
    .rst(trigger),
    .N (N),
    .count (count),
    .tick(tick)
);


endmodule
