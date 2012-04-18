module tb_dffa;

wire q;
reg d;
reg clk;
reg rst;

initial begin
    $from_myhdl(
        d,
        clk,
        rst
    );
    $to_myhdl(
        q
    );
end

dffa dut(
    q,
    d,
    clk,
    rst
);

endmodule
