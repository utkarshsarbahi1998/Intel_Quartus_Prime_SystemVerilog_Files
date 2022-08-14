module dec_display(
input logic [7:0] data_in,
output logic [6:0] dec_digit_0_out, dec_digit_1_out, dec_digit_2_out
);

logic [3:0] digit_0, digit_1; //Both Digit 0 and Digit 1 can range from 0 to 9; hence they are 4 bits in size
logic [1:0] digit_2; //Digit 2 can only be either 0, 1 or 2; hence it is 2 bits in size

//The following algorithm gives the respective digits of the 3-digit number
assign digit_2 = (data_in / 100);
assign digit_1 = ((data_in - (digit_2 * 100)) / 10);
assign digit_0 = (data_in - (digit_2 * 100) - (digit_1 * 10));

//Module instantiation technique to re-use the 7-Segment LED circuit below 
seven_seg seven_seg_0 (.seg_in(digit_0), .seg_out(dec_digit_0_out));
seven_seg seven_seg_1 (.seg_in(digit_1), .seg_out(dec_digit_1_out));
seven_seg seven_seg_2 (.seg_in(digit_2), .seg_out(dec_digit_2_out));

endmodule


module seven_seg(
input logic [3:0] seg_in,
output logic [6:0] seg_out
);

always_comb begin

//The inputs will light the respective segements of the LED to get the decimal displayed
case(seg_in)
4'b0000: seg_out = 7'b100_0000;
4'b0001: seg_out = 7'b111_1001;
4'b0010: seg_out = 7'b010_0100;
4'b0011: seg_out = 7'b011_0000;
4'b0100: seg_out = 7'b001_1001;
4'b0101: seg_out = 7'b001_0010;
4'b0110: seg_out = 7'b000_0010;
4'b0111: seg_out = 7'b111_1000;
4'b1000: seg_out = 7'b000_0000;
4'b1001: seg_out = 7'b001_0000;
default: seg_out = 7'b111_1111;
endcase

end

endmodule
