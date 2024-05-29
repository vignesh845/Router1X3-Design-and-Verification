module top;

import router_pkg::*;
import uvm_pkg::*;

bit clock;
initial
begin
	forever
		#10 clock=~clock;
end


src_if in(clock);
dst_if in0(clock);
dst_if in1(clock);
dst_if in2(clock);


router_top DUV(.clock(clock),.resetn(in.resetn),.pkt_valid(in.pkt_valid),.data_in(in.data_in),.err(in.error),.busy(in.busy),.read_enb_0(in0.read_enb),.read_enb_1(in1.read_enb),.read_enb_2(in2.read_enb),.vld_out_0(in0.valid_out),.vld_out_1(in1.valid_out),.vld_out_2(in2.valid_out),.data_out_0(in0.data_out),.data_out_1(in1.data_out),.data_out_2(in2.data_out));

initial
begin
	uvm_config_db #(virtual src_if)::set(null,"*","vif",in);
	uvm_config_db #(virtual dst_if)::set(null,"*","vif_0",in0);
	uvm_config_db #(virtual dst_if)::set(null,"*","vif_1",in1);
	uvm_config_db #(virtual dst_if)::set(null,"*","vif_2",in2);

	run_test();
end
endmodule

	
