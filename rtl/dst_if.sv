interface dst_if(input bit clock);
	logic [7:0]data_out;
	logic read_enb;
	logic valid_out;

clocking dst_drv_cb@(posedge clock);
	default input#1 output #1;
	output read_enb;
	input valid_out;
endclocking

clocking dst_mon_cb@(posedge clock);
	default input #1 output #1;
	input read_enb;
	input data_out;
	input valid_out;
endclocking

modport DST_DRV_MP(clocking dst_drv_cb);
modport DST_MON_MP(clocking dst_mon_cb);
endinterface
