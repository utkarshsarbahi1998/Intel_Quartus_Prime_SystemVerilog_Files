module clock_gen (
input logic clk, rst, 
output logic clk_out
);
logic [4:0] count_var;
always_ff @ (negedge clk) begin

if (!rst) begin
	clk_out <= 1'b0;
	count_var <= 5'd0;
end 
else begin
	count_var <= count_var + 1;
		if (count_var == 5'd24) begin
			clk_out <= clk_out + 1;
			count_var <= 5'd0;
		end
		
	end
end

endmodule