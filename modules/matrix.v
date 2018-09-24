module Switch_Matrix (in_0_m, in_1_m, in0_s, in1_s, sel0, sel1, out_0_m, out_1_m, out_0_s0, out_0_s1, out_1_s0, out_1_s1);

input [65:0] in_0_m, in_1_m;
input [32:0] in0_s, in1_s;

input  sel0, sel1;
output [65:0] out_0_m, out_1_m; 
output [32:0] out_0_s0, out_1_s0, out_0_s1, out_1_s1;


IO_cell to_slave_1 (.in0_m(in_0_m), .in1_m(in_1_m), .in_s(in0_s), .out0_s(out_0_s0), .out1_s(out_0_s1), .sel(sel0), .out_m(out_0_m));

IO_cell to_slave_2 (.in0_m(in_0_m), .in1_m(in_1_m), .in_s(in1_s), .out0_s(out_1_s0), .out1_s(out_1_s1), .sel(sel1), .out_m(out_1_m));


endmodule