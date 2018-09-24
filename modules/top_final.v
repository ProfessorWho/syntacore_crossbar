module top_final(clk, reset, t_req, t_cmd, t_wdata, t_addr, t2_req, t2_cmd, t2_wdata, t2_addr);

input clk, reset, t_req, t_cmd, t2_req, t2_cmd;
input [31:0] t_wdata, t_addr, t2_wdata, t2_addr;

wire [31:0] rdata, addr, wdata, rdata2, addr2, wdata2;
wire [31:0] post_rdata, post_addr, post_wdata, post_rdata2, post_addr2, post_wdata2;
wire req, cmd, ack, req2, cmd2, ack2;
wire post_req, post_cmd, post_ack, post_req2, post_cmd2, post_ack2;

wire load, cnfg;

wire	[65:0] in0_m, in1_m, out0_m, out1_m;
wire [32:0] in0_s, in1_s, out0_s0, out0_s1, out1_s0, out1_s1, ans1, ans2;
wire	 in_addr;
wire	 out_addr;

reg	[1:0] dec_addr;
wire  sel0, sel1;

assign in0_m = {req, cmd, addr, wdata};
assign in1_m = {req2, cmd2, addr2, wdata2};
assign in0_s = {ack, rdata};
assign in1_s = {ack2, rdata2};

assign ans1 = (addr[31])? out1_s0 : out0_s0;
assign ans2 = (addr2[31])? out1_s1 : out0_s1;

//assign = Out_add
assign post_req = out0_m[65];
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
assign post_rdata2 = ans2[31:0];


always @(out_addr)
case (out_addr)
	1'b0 : dec_addr = 2'd1;
	1'b1 : dec_addr = 2'd2;
	default : dec_addr = 2'd0;
endcase

switch	b2v_inst0(.conf_en(cnfg),.load_en(load),.out_sel(dec_addr[0]),.in_add(in_addr),.inadd(sel0), .reset(reset));

switch	b2v_inst1(.conf_en(cnfg),.load_en(load),.out_sel(dec_addr[1]),.in_add(in_addr),.inadd(sel1), .reset(reset));

Switch_Matrix	b2v_matrix2(.in_0_m(in0_m),.in_1_m(in1_m), .in0_s(in0_s), .in1_s(in1_s), .sel0(sel0),.sel1(sel1), .out_0_m(out0_m), .out_1_m(out1_m), .out_0_s0(out0_s0), .out_0_s1(out0_s1), .out_1_s0(out1_s0), .out_1_s1(out1_s1));

control my_cntr(.req1(req), .req2(req2), .addr1(addr[31]), .addr2(addr2[31]), .ack1(post_ack), .ack2(post_ack2), .load(load), .cnfg(cnfg), .inaddr(in_addr), .outaddr(out_addr), .clk(clk), .reset(reset));

master master_1(.clk(clk),
					 .reset(reset),
					 .ack(post_ack),
					 .t_req(t_req),
					 .t_cmd(t_cmd),
					 .t_wdata(t_wdata),
					 .t_addr(t_addr),
					 .i_rdata(post_rdata),
					 .save_req(req),
					 .o_cmd(cmd),
					 .o_addr(addr),
					 .o_wdata(wdata));
					 
master master_2(.clk(clk),
					 .reset(reset),
					 .ack(post_ack2),
					 .t_req(t2_req),
					 .t_cmd(t2_cmd),
					 .t_wdata(t2_wdata),
					 .t_addr(t2_addr),
					 .i_rdata(post_rdata2),
					 .save_req(req2),
					 .o_cmd(cmd2),
					 .o_addr(addr2),
					 .o_wdata(wdata2));
					 
slave #(1'b0) slave_1(.clk(clk), 
				  .reset(reset), 
				  .ack(ack), 
				  .i_req(post_req), 
				  .i_cmd(post_cmd), 
				  .i_addr(post_addr), 
				  .i_wdata(post_wdata), 
				  .o_rdata(rdata));
				  
slave  #(1'b1) slave_2(.clk(clk), 
				  .reset(reset), 
				  .ack(ack2), 
				  .i_req(post_req2), 
				  .i_cmd(post_cmd2), 
				  .i_addr(post_addr2), 
				  .i_wdata(post_wdata2), 
				  .o_rdata(rdata2));		  

endmodule