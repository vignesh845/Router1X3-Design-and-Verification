class router_src_monitor extends uvm_monitor;
`uvm_component_utils(router_src_monitor)
virtual src_if.SMON_MP vif;
uvm_analysis_port#(write_xtn)monitor_port;

router_src_agent_config m_cfg;
write_xtn mon_data;
///////////////////////////////////////new constructor//////////////////////////////////////
function new(string name = "router_src_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction
///////////////////////////////////////////build_phase//////////////////////////////
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
	`uvm_fatal("TB CONFIG","cannot get() m_cfg from uvm_config")

endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
	vif=m_cfg.vif;
endfunction

//////////////////////////////run_phase/////////////////////////////////////////////////////////
task run_phase(uvm_phase phase);
	forever

		collect_data();


endtask
////////////////////////collect_data task///////////////////////////////////////////
task collect_data();
write_xtn mon_data;
begin


	mon_data=write_xtn::type_id::create("mon_data");

 
 
	//@(vif.smon_cb);
	while(vif.smon_cb.pkt_valid!==1)
	@(vif.smon_cb);
//	$display("mon pkt valid = %0d",vif.smon_cb.pkt_valid);
	while(vif.smon_cb.busy)
	@(vif.smon_cb);
	mon_data.header = vif.smon_cb.data_in;
	mon_data.payload_data=new[mon_data.header[7:2]];
	@(vif.smon_cb);
	foreach(mon_data.payload_data[i])
	begin
		while(vif.smon_cb.busy)
			@(vif.smon_cb);
		mon_data.payload_data[i]=vif.smon_cb.data_in;
		@(vif.smon_cb);
	end
		while(vif.smon_cb.busy)
			@(vif.smon_cb);	
		mon_data.parity=vif.smon_cb.data_in;
 `uvm_info("Router_src_MONITOR",$sformatf("printing from monitor \n %s", mon_data.sprint()),UVM_LOW) 
 $display("********************************");
		repeat(2)
		@(vif.smon_cb);
		m_cfg.mon_rcvd_xtn_count++;
//	`uvm_info("Router_src_MONITOR",$sformatf("printing from monitor \n %s", mon_data.sprint()),UVM_LOW) 


		//sending data to scoreboard using analaysis port
		monitor_port.write(mon_data);

	
//	end
end
endtask	

	
	function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: Router source Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_count), UVM_LOW)
endfunction : report_phase
	
	

endclass
