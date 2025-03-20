always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_squares <= 16'b0;
        result <= 8'b0;
        uo_out <= 8'b0;
    end else begin
        sum_squares <= square(ui_in) + square(uio_in);
        result <= 0;

        // Iterative approach to calculate the square root
        for (b = 7; b >= 0; b = b - 1) begin
            if (square(result + (1 << b)) <= sum_squares)
                result <= result + (1 << b);
        end

        uo_out <= result;  // Ensure this updates properly
    end
end
