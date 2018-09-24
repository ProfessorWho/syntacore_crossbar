`timescale 100ps/1ps

module testbench_basic();

reg clk, reset;

reg t_req, t_cmd;
reg [31:0] t_addr, t_wdata;


top test_top(
	.clk(clk),
	.reset(reset),
	.t_req(t_req),
	.t_cmd(t_cmd),
	.t_wdata(t_wdata),
	.t_addr(t_addr));

initial                                                
begin                                                  
  clk = 0;
  reset = 1;
  #10 reset = ~reset;
  #10
  t_req = 1;
  t_addr = 1342;
  t_wdata = 9105;
  t_cmd = 1;
end                                                    

always 
  #5 clk = ~clk; 
  
endmodule