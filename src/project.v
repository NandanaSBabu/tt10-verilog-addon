// simple_module.v
module simple_module (
    input clk,
    output reg out
);

always @(posedge clk) begin
    out <= ~out;
end

endmodule
