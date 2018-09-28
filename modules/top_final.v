module top_final(clk, reset, in0_m, in1_m, in0_s, in1_s, out0_m, out1_m, ans1, ans2);

input clk, reset;

wire load, cnfg;

input	[65:0] in0_m, in1_m;
input [32:0] in0_s, in1_s;
 
output [65:0] out0_m, out1_m;
output [32:0] ans1, ans2;

wire [32:0] out1_s0, out1_s1, out0_s0, out0_s1;

wire	 in_addr;
wire	 out_addr;

reg	[1:0] dec_addr;
wire  sel0, sel1;
wire req1, req2, post_ack1, post_ack2;

/*assign in0_m = {req, cmd, addr, wdata};
assign in1_m = {req2, cmd2, addr2, wdata2};
assign in0_s = {ack, rdata};
assign in1_s = {ack2, rdata2};*/

assign ans1 = (in0_m[63])? out1_s0 : out0_s0;
assign ans2 = (in1_m[63])? out1_s1 : out0_s1;
assign post_ack1 = ans1[32];
assign post_ack2 = ans2[32];
assign req1 = in0_m[65];
assign req2 = in1_m[65];

//assign = Out_add
/*assign post_req = out0_m[65];
assign post_cmd = out0_m[64];
assign post_ack = ans1[32];
assign post_addr = out0_m[63:32];
assign post_wdata = out0_m[31:0];
assign post_rdata = ans1[31:0];

assign post_req2 = out1_m[65];
assign post_cmd2 = out1_m[64];
assign post_ack2 = ans2[32];
assign post_addr2 = out1_m[63:32];
assign post_wdata2 = out1_m[31:0];
assign post_rdata2 = ans2[31:0];*/


always @(out_addr)
case (out_addr)
	1'b0 : dec_addr = 2'd1;
	1'b1 : dec_addr = 2'd2;
	default : dec_addr = 2'd0;
endcase

switch	b2v_inst0(.conf_en(cnfg),.load_en(load),.out_sel(dec_addr[0]),.in_add(in_addr),.inadd(sel0), .reset(reset));

switch	b2v_inst1(.conf_en(cnfg),.load_en(load),.out_sel(dec_addr[1]),.in_add(in_addr),.inadd(sel1), .reset(reset));

Switch_Matrix	b2v_matrix2(.in_0_m(in0_m),.in_1_m(in1_m), .in0_s(in0_s), .in1_s(in1_s), .sel0(sel0),.sel1(sel1), .out_0_m(out0_m), .out_1_m(out1_m), .out_0_s0(out0_s0), .out_0_s1(out0_s1), .out_1_s0(out1_s0), .out_1_s1(out1_s1));

control my_cntr(.req1(req1), .req2(req2), .addr1(in0_m[63]), .addr2(in1_m[63]), .ack1(post_ack1), .ack2(post_ack2), .load(load), .cnfg(cnfg), .inaddr(in_addr), .outaddr(out_addr), .clk(clk), .reset(reset));	  

endmodule