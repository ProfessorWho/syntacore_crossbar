`timescale 1ps/1ps
module master (clk, reset, ack, t_req, t_cmd, t_wdata, t_addr, i_rdata, save_req, o_cmd, o_addr, o_wdata);

input clk, reset;
input ack;
input t_req, t_cmd;
input [31:0] i_rdata, t_wdata, t_addr;

output reg o_cmd;
output reg [31:0] o_addr, o_wdata;
reg o_req;

reg req, cmd;
reg [31:0] wdata, rdata, addr;

parameter IDLE = 2'b00, REQ = 2'b01, WAIT = 2'b10, READ = 2'b11;

reg [1:0] state, nextstate;
output wire save_req;
assign save_req = o_req & ~ack;

//assign o_req = ~ack & out_req;


always @*
begin
		case (state)
			IDLE: if(t_req) nextstate = REQ;
			REQ: nextstate = WAIT;
			WAIT:	begin 
				if(ack && ~o_cmd) nextstate = READ;
				else if(ack) nextstate = IDLE;
				else nextstate = WAIT;
			end
			READ: nextstate = IDLE;
			default: nextstate = IDLE;
		endcase
end

 

always @(posedge clk or negedge reset)
begin
	if(~reset) begin
		o_req <= 0;
		o_wdata <= 0;
		o_addr <= 0;
		o_cmd <= 0;
		wdata <= 0;
		addr <= 0;
		cmd <= 0;
		req <= 0;
	end
	else if(state == IDLE && t_req) begin
		wdata <= t_wdata;
		addr <= t_addr;
		cmd <= t_cmd;
		req <= t_req;
	end
	else if(state == REQ) begin
		o_req <= req;
		o_wdata <= wdata;
		o_addr <= addr;
		o_cmd <= cmd;
	end
	else if(state == WAIT && ack)
		o_req <= 0;
	else if(state == IDLE)begin
		o_req <= 0;
		o_wdata <= 0;
		o_addr <= 0;
		o_cmd <= 0;
	end
end

always @(posedge clk or negedge reset)
begin
	if(~reset)
		rdata <= 0;
	else if(state == READ)
		rdata <= i_rdata;
end

always @(posedge clk or negedge reset)
begin
	if(~reset)
		state <= IDLE;
	else
		state <= nextstate;
end

endmodule