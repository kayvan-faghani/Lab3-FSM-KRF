module lfsr_7 (
    input   logic       clk,
    input   logic       rst,
    input   logic       en,
    output  logic [6:0] data_out
);
    logic [7:1] sreg;

    always_ff @(posedge clk, posedge rst) 
        if(rst)
            sreg <= 7'b1;
        else
            sreg <= {sreg[7:1],sreg[3]^sreg[7]};

    assign data_out = sreg;
endmodule
