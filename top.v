module top(clk, reset, t_req, t_cmd, t_wdata, t_addr);

input clk, reset, t_req, t_cmd;
input [31:0] t_wdata, t_addr;

wire [31:0] rdata, addr, wdata;
wire req, cmd, ack;

master master_1(.clk(clk),
					 .reset(reset),
					 .ack(ack),
					 .t_req(t_req),
					 .t_cmd(t_cmd),
					 .t_wdata(t_wdata),
					 .t_addr(t_addr),
					 .i_rdata(rdata),
					 .save_req(req),
					 .o_cmd(cmd),
					 .o_addr(addr),
					 .o_wdata(wdata));
					 
slave #(1'b0) slave_1(.clk(clk), 
				  .reset(reset), 
				  .ack(ack), 
				  .i_req(req), 
				  .i_cmd(cmd), 
				  .i_addr(addr), 
				  .i_wdata(wdata), 
				  .o_rdata(rdata));			

endmodule