 module seven_seg(
     input logic [3:0] seg_in,
     output logic [6:0] seg_out
 );

 always_comb begin
     case (seg_in)
         4'b0000: seg_out = 7'b100_0000; //0
         4'b0001: seg_out = 7'b111_1001; //1
         4'b0010: seg_out = 7'b010_0100; //2
         4'b0011: seg_out = 7'b011_0000; //3
         4'b0100: seg_out = 7'b001_1001; //4
         4'b0101: seg_out = 7'b001_0010; //5
         4'b0110: seg_out = 7'b000_0010; //6
         4'b0111: seg_out = 7'b111_1000; //7
         4'b1000: seg_out = 7'b000_0000; //8
         4'b1001: seg_out = 7'b001_0000; //9
			4'b1010: seg_out = 7'b001_0001; //10 Display Y
			4'b1011: seg_out = 7'b010_0001; //11 Display D
			4'b1100: seg_out = 7'b000_1000; //12 Display A
			4'b1101: seg_out = 7'b000_0110; //13 Display E
			4'b1110: seg_out = 7'b100_1110; //14 Display R
         default: seg_out = 7'b111_1111; //OFF
     endcase
 end
 endmodule


module AriLogCal(
    input logic [3:0] Operand,
    input logic Set, CLK, AC, EqualTo,
    input logic [2:0] DoOpt,
    output logic [6:0] Seg0, Seg1, Seg2, Seg3, Seg4, Seg5
);
logic [3:0] Hex0, Hex1, Hex2, Hex3, Hex4, Hex5;
logic [2:0] state, next_state;
logic [3:0] OpA,OpB;
logic [2:0] Ope;

// DFF for storing Operand A
always_ff@(posedge CLK) begin
	if (state == 3'b000)
		OpA <= Operand;
end

// DFF for storing DoOpt
always_ff@(posedge CLK) begin
	if (state == 3'b001)
		Ope <= DoOpt;
end

// DFF for storing Operand B
always_ff@(posedge CLK) begin
	if (state == 3'b010)
		OpB <= Operand;
end


logic is_pressed;
logic store;

 always_ff @(posedge CLK, negedge AC) begin
    if(!AC)
      is_pressed <= 1'b0;
    else
      is_pressed <= !Set;
 end

assign store = !is_pressed & !Set;
 
// FMS
// DFF
always_ff @(posedge CLK, negedge AC) begin
    if (!AC) 
        state <= 3'b000;
    else
        state <= next_state;
end

// State Transition
always_comb begin
    next_state = state; //this is equivalent to the default statement in the case statement
    case(state)
        3'b000: begin
            if (store) 
                next_state = 3'b001;
			else if (!store) 
             next_state = 3'b000;
        end
        3'b001: begin
            if (store && (Ope == 1 || Ope == 2 || Ope == 3 || Ope == 4 || Ope == 5))
                next_state = 3'b010;
			else if (!store)
                next_state = 3'b001;
        end
        3'b010: begin
            if (store)
                next_state = 3'b011;
			 else if (!store)
                next_state = 3'b010;
        end
        3'b011: begin
            if (!EqualTo)
                next_state = 3'b100;
            else if (EqualTo)
                next_state = 3'b011;
        end
        default: begin
        end
    endcase
end



//Output circuit block
always_comb begin
    case (state)
        3'b000: begin
			Hex5 = 14;
			Hex4 = 13;
			Hex3 = 12;
			Hex2 = 11;
			Hex1 = 10;
			Hex0 = 15;
        end
		  3'b001: begin
			Hex5 = OpA / 10;
			Hex4 = OpA % 10;
			Hex3 = 15;
			Hex2 = 15;
			Hex1 = 15;
			Hex0 = 15;
		  end
		  3'b010: begin
			Hex5 = OpA / 10;
			Hex4 = OpA % 10;
			Hex3 = 15;
			Hex2 = Ope;
			Hex1 = 15;
			Hex0 = 15;
		  end
		  3'b011: begin
			Hex5 = OpA / 10;
			Hex4 = OpA % 10;
			Hex3 = 15;
			Hex2 = Ope;
			Hex1 = OpB / 10;
			Hex0 = OpB % 10;
		  end
		  3'b100: begin
		  case(Ope)
			1: begin
				Hex5 = 15;
				Hex4 = 15;
				Hex3 = 15;
				Hex2 = 0;
				Hex1 = (OpA + OpB) / 10;
				Hex0 = (OpA + OpB) % 10;
			end
			2: begin
				Hex5 = 15;
				Hex4 = 15;
				Hex3 = 15;
				Hex2 = (OpA * OpB) / 100;
				Hex1 = ((OpA * OpB) % 100) / 10;
				Hex0 = ((OpA * OpB) % 100) % 10;
			end
			3: begin
			if(OpB == 0) begin
				Hex5 = 15;
				Hex4 = 15;
				Hex3 = 15;
				Hex2 = 13;
				Hex1 = 14;
				Hex0 = 14;
			end
			else begin 
				Hex5 = 15;
				Hex4 = 15;
				Hex3 = 15;
				Hex2 = 0;
				Hex1 = (OpA / OpB) / 10;
				Hex0 = (OpA / OpB) % 10;
			end
			end
			4: begin
			if (OpA && OpB) begin
				Hex5 = 15;
				Hex4 = 15;
				Hex3 = 15;
				Hex2 = 1;
				Hex1 = 1;
				Hex0 = 1;
			end
			else begin
				Hex5 = 15;
				Hex4 = 15;
				Hex3 = 15;
				Hex2 = 0;
				Hex1 = 0;
				Hex0 = 0;
			end
			end
			5: begin
			if (OpA || OpB) begin
				Hex5 = 15;
				Hex4 = 15;
				Hex3 = 15;
				Hex2 = 1;
				Hex1 = 1;
				Hex0 = 1;
			end
			else begin
				Hex5 = 15;
				Hex4 = 15;
				Hex3 = 15;
				Hex2 = 0;
				Hex1 = 0;
				Hex0 = 0;
			end
			end
			default: begin
				Hex5 = 14;
				Hex4 = 13;
				Hex3 = 12;
				Hex2 = 11;
				Hex1 = 10;
				Hex0 = 15;
			end		
			endcase
		  end
        default: begin
        end
    endcase
end

seven_seg s0 (.seg_in(Hex0),.seg_out(Seg0));
seven_seg s1 (.seg_in(Hex1),.seg_out(Seg1));
seven_seg s2 (.seg_in(Hex2),.seg_out(Seg2));
seven_seg s3 (.seg_in(Hex3),.seg_out(Seg3));
seven_seg s4 (.seg_in(Hex4),.seg_out(Seg4));
seven_seg s5 (.seg_in(Hex5),.seg_out(Seg5));

endmodule

