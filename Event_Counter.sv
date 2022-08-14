module excercise3(
    input logic clk, rst, count_en,
    output logic [6:0] seg_display,
    output logic count_flag
);

logic [3:0] count;
logic count_press;

always_ff @(posedge clk, negedge rst) begin
    if (!rst) begin
        count <= 4'b0;
    end else if (!count_en) begin
        if (count_press == 0) begin
            count <= count + 1;
            count_press <= 1;
        end
    end else if (count_en) begin
        count <= count;
        count_press <= 0;
    end
end

always_comb begin
    case (count)
        4'b0000: seg_display = 7'b1000000;
        4'b0001: seg_display = 7'b1111001; 
        4'b0010: seg_display = 7'b0100100; 
        4'b0011: seg_display = 7'b0110000; 
        4'b0100: seg_display = 7'b0011001; 
        4'b0101: seg_display = 7'b0010010; 
        4'b0110: seg_display = 7'b0000010; 
        4'b0111: seg_display = 7'b1111000; 
        4'b1000: seg_display = 7'b0000000;
        4'b1001: seg_display = 7'b0010000; 
        4'b1010: seg_display = 7'b0001000; 
        4'b1011: seg_display = 7'b0000011; 
        4'b1100: seg_display = 7'b0100111; 
        4'b1101: seg_display = 7'b0100001; 
        4'b1110: seg_display = 7'b0000110;
        4'b1111: begin
            seg_display = 7'b0001110;
        end
        default: begin
            seg_display = 7'b1111111;
        end
    endcase
end

assign count_flag = (count == 4'b1111);

endmodule
