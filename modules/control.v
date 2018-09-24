module control (req1, req2, addr1, addr2, ack1, ack2, load, cnfg, inaddr, outaddr, clk, reset);

input req1, req2, addr1, addr2, ack1, ack2, clk, reset;
output load, cnfg;
output reg inaddr, outaddr;

parameter IDLE = 2'b00, LOAD = 2'b01, CNFG = 2'b10;

reg [1:0] state;
reg [1:0] nextstate;

reg [1:0] block, ncw;	//now connected with
reg [1:0] approved;		//access to matrix configuration for 1st master (0-bit) and for 2nd master (1-bit)

wire need_cnfg; 					
reg vip;						//chosen master by round-robin

//wire req1_en;
//assign req1_en = (~approved[0] & req1)
//assign req2_en = (~approved[1] & req2)

assign need_cnfg = (approved != 0);
assign load = (state == LOAD);
assign cnfg = (state == CNFG);

always @*
begin
	case(state)
		IDLE: if(need_cnfg) nextstate = LOAD;
				 else nextstate = IDLE;
		LOAD: if(approved > 0) nextstate = LOAD;
					else nextstate = CNFG;
		CNFG:  nextstate = IDLE;
	endcase
end


always @(posedge clk or negedge reset) begin
	if(~reset) begin
		ncw <= 2'bZZ;
		block <= 2'b00;
		approved <= 2'b00;
		vip <= 0;
		outaddr <= 1'bZ;
	end
	else begin
		case(state)
			IDLE: begin
				if(req1 & req2) begin
					if(addr1 == addr2) begin
						if(ncw[addr1] != vip & ~block[addr1]) begin
							approved[vip] <= 1;
							block[addr1] <= 1;
							vip <= ~vip;
							end
						else if(ncw[addr1] == vip & ~block[addr1]) begin //if master is already connected to slave, system wont grant access to config
							approved[vip] <= 0;
							block[addr1] <= 1;
							vip <= ~vip;
						end
					end
						//else
							//approved[vip] <= 0;
					else begin
						if(~block[addr1]) begin
							block[addr1] <= 1;
							approved[0] <= 1;
							end
						if(~block[addr2]) begin
							block[addr2] <= 1;
							approved[1] <= 1;
							end
						end
					end
				else if(req1) begin
					if(ncw[addr1] != 0 & ~block[addr1]) begin
						approved[0] <= 1;
						block[addr1] <= 1;
						end
					else if (~block[addr1]) begin
						approved[0] <= 1;
						block[addr1] <= 1;
						end
					end
					//else
						//approved <= 0;
				else if(req2) begin
					if(ncw[addr2] != 1 & ~block[addr2]) begin
						approved[1] <= 1;
						block[addr2] <= 1;
						end
					else if (~block[addr2]) begin
						approved[1] <= 1;
						block[addr2] <= 1;
						end
					end
					//else
						//approved[1] <= 0;
			end
			LOAD: begin
				if(approved[0]) begin
					//inaddr <= 0;
					outaddr <= addr1;
					approved[0] <= 0;
					ncw[addr1] <= 0;
					end
				else if(approved[1]) begin
					//inaddr <= 1;
					outaddr <= addr2;
					approved[1] <= 0;
					ncw[addr2] <= 1;
				end
			end
			CNFG: begin
				outaddr <= 1'bZ;	
			end
			default: begin
				outaddr <= 1'bZ;
			end
		endcase
		
		if(ack1 & block[0])
			block[0] <= 0;
		if(ack2 & block[1])	
			block[1] <= 0;
		end
	
end

always @(negedge clk or negedge reset) begin
	if(~reset)
		inaddr <= 1'bZ;
	else
		case(state)
			LOAD: begin
				if(approved[0])
					inaddr <= 0;
				else if(approved[1])
					inaddr <= 1;
			end
			default:
				inaddr <= 1'bZ;
		endcase
end

always @(posedge clk)
begin
	if(~reset)
		state <= IDLE;
	else
		state <= nextstate;
end


endmodule