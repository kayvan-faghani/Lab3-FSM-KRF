module lfsr_7 (
    input   logic       clk,
    input   logic       rst,
    output  logic [8:1] data_out
);
    logic [8:1] sreg;

    always_ff @(posedge clk) 
        if(rst)
            sreg <= 8'b1;
        else
            sreg <= {sreg[8:1],sreg[3]^sreg[7]};

    assign data_out = sreg;
endmodule
