module slave (clk, reset, ack, i_req, i_cmd, i_addr, i_wdata, o_rdata);

parameter ADDR = 1'b0;

input clk, reset;
input i_req, i_cmd;
input [31:0] i_wdata, i_addr;

output reg ack;
output reg [31:0] o_rdata;

reg cmd;
reg [31:0] wdata, addr;
reg [31:0] rdata;

parameter IDLE = 2'b00, ANS = 2'b01, WRITE = 2'b10;

reg [1:0] state, nextstate;
wire to_me;
assign to_me = i_addr[31] == ADDR;

always @*
begin
		case (state)
			IDLE: if(i_req & to_me) nextstate = ANS;
				else nextstate = IDLE;
			ANS: nextstate = WRITE;
			WRITE: nextstate = IDLE;
			default: nextstate = IDLE;
		endcase
end

//assign nextstate = ~state & i_req;
//assign rdata = 32'd1342;

always @(*)
begin
	
end


always @(posedge clk or negedge reset)
begin
	if(~reset) begin
		wdata <= 0;
		addr <= 0;
		cmd <= 0;
		ack <= 0;
		o_rdata <= 0;
		rdata <= 0;
	end
	else if(state == ANS) begin
		if(i_cmd)
			wdata <= i_wdata;
		addr <= i_addr;
		cmd <= i_cmd;
		ack <= 1;
	end
	else if(state == WRITE)begin
		ack <= 1;
		o_rdata <= rdata;
		rdata <= rdata + 1;
		end
	else
		ack <= 0;
end

always @(posedge clk or negedge reset)
begin
	if(~reset)
		state <= IDLE;
	else
		state <= nextstate;
end

endmodule