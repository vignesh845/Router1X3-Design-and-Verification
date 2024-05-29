interface src_if(input bit clock);
	logic resetn;
	logic pkt_valid;
	logic[7:0]data_in;
	logic busy;
	logic error;

clocking sdrv_cb@(posedge clock);
	default input #1 output#1;
	output resetn;
	output pkt_valid;
	output data_in;
	input busy;
	input error;
endclocking

clocking smon_cb@(posedge clock);
	default input #1 output#1;
	input resetn;
	input pkt_valid;
	input data_in;
	input busy;
	input error;
endclocking


modport SDRV_MP(clocking sdrv_cb);
modport SMON_MP(clocking smon_cb);

endinterface
