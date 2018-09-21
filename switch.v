module switch (conf_en, load_en, in_add, inadd, out_sel, reset);

input in_add;
input conf_en, load_en, out_sel, reset;
output inadd;

reg load_inadd_reg;
reg inadd;

wire conf_en, load_enable;

assign load_enable = load_en & out_sel;

always @(posedge load_enable or negedge reset)
begin
	if (~reset)
		load_inadd_reg = 0;
	else
		load_inadd_reg = in_add;
end

always @(posedge conf_en or negedge reset)
begin
	if (~reset)
		inadd = 0;
	else
		inadd = load_inadd_reg;
end

endmodule