module IO_cell (in0_m, in1_m, in_s, out0_s, out1_s, sel, out_m);

input [65:0] in0_m, in1_m;
input [32:0] in_s;
input sel;

output reg [65:0] out_m;
output reg [32:0] out0_s, out1_s;

always @*
begin
	case (sel)
	1'b0: begin out_m = in0_m; out0_s = in_s; out1_s = 0; end 
	1'b1: begin out_m = in1_m; out1_s = in_s; out0_s = 0; end
	default: begin out_m = 66'hx; out0_s = 32'hx; out1_s = 32'hx; end
	endcase
end
										
endmodule