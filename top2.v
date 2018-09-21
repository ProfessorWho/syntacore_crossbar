module top2(clk, reset, t_req, t_cmd, t_wdata, t_addr);

input clk, reset, t_req, t_cmd, t2_req, t2_cmd;
input [31:0] t_wdata, t_addr, t2_wdata, t2_addr;

wire [31:0] rdata, addr, wdata, rdata2, addr2, wdata2;
wire [31:0] post_rdata, post_addr, post_wdata, post_rdata2, post_addr2, post_wdata2;
wire post_req, post_cmd, post_ack, post_req2, post_cmd2, post_ack2;


input	CNFG, en_A, en_B;
input	RES;
input	LOAD;
input	CS;

wire	[98:0] in0, in1, out0, out1;
wire	 In_add;
wire	 out_add;

wire	[1:0] dec_add;
wire  sel0, sel1;
wire	conf_en, load_en;

assign conf_en = (CNFG & CS);
assign load_en = (LOAD & CS);

assign in0 = {req, cmd, ack, addr, wdata, rdata};
assign in1 = {req2, cmd2, ack2, addr2, wdata2, rdata2};

assign = Out_add
assign post_req = out0[98];
assign post_cmd = out0[97];
assign post_ask = out0[96];
assign post_addr = out0[95:64];
assign post_wdata = out0[63:32];
assign post_rdata = out0[31:0];

assign post_req2 = out1[98];
assign post_cmd2 = out1[97];
assign post_ask2 = out1[96];
assign post_addr2 = out1[95:64];
assign post_wdata2 = out1[63:32];
assign post_rdata2 = out1[31:0];


always @(out_add)
case (out_add)
	1'b0 : dec_add = 2'b1;
	1'b1 : dec_add = 2'b2;
	default : dec_add = 2'b0;
endcase

switch	b2v_inst0(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[0]),.in_add(In_add),.inadd(sel0), .reset(reset));

switch	b2v_inst1(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[1]),.in_add(In_add),.inadd(sel1), .reset(reset));

Switch_Matrix	b2v_matrix2(.in_0(in0),.in_1(in1),.sel_0(sel0),.sel_1(sel1), .out_0(out0), .out_1(out1));

master master_1(.clk(clk),
					 .reset(reset),
					 .ack(post_ack),
					 .t_req(t_req),
					 .t_cmd(t_cmd),
					 .t_wdata(t_wdata),
					 .t_addr(t_addr),
					 .i_rdata(post_rdata),
					 .o_req(req),
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
					 .o_req(req2),
					 .o_cmd(cmd2),
					 .o_addr(addr2),
					 .o_wdata(wdata2));
					 
slave slave_1(.clk(clk), 
				  .reset(reset), 
				  .ack(ack), 
				  .i_req(post_req), 
				  .i_cmd(post_cmd), 
				  .i_addr(post_addr), 
				  .i_wdata(post_wdata), 
				  .o_rdata(rdata));
				  
slave slave_1(.clk(clk), 
				  .reset(reset), 
				  .ack(ack2), 
				  .i_req(post_req2), 
				  .i_cmd(post_cmd2), 
				  .i_addr(post_addr2), 
				  .i_wdata(post_wdata2), 
				  .o_rdata(rdata2));		  

endmodule