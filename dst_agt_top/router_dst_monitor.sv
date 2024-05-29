class router_dst_monitor extends uvm_monitor;
`uvm_component_utils(router_dst_monitor)
virtual dst_if.DST_MON_MP vif;
router_dst_agent_config m_cfg;
uvm_analysis_port#(read_xtn)monitor_port;

function new(string name="router_dst_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction

function void build_phase(uvm_phase phase);
if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
`uvm_fatal("TB CONFIG","cannot get() m_cfg from uvm_config")
	super.build_phase(phase);
endfunction

function void connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
forever
	collect_data();
endtask

task collect_data();
read_xtn mon_data;
begin
	mon_data=read_xtn::type_id::create("mon_data");
	while(vif.dst_mon_cb.read_enb!==1)
		@(vif.dst_mon_cb);
	@(vif.dst_mon_cb);
	mon_data.header=vif.dst_mon_cb.data_out;
	mon_data.payload_data=new[mon_data.header[7:2]];
	@(vif.dst_mon_cb);
	foreach(mon_data.payload_data[i])
	begin
		mon_data.payload_data[i]=vif.dst_mon_cb.data_out;
		@(vif.dst_mon_cb);
	end
	
	mon_data.parity=vif.dst_mon_cb.data_out;
	 `uvm_info("ROUTER_DST_MONITOR",$sformatf("printing from monitor \n %s",mon_data.sprint()),UVM_LOW)
	//sending packet to scoreboard
	monitor_port.write(mon_data);
	repeat(2)
		@(vif.dst_mon_cb);
		m_cfg.mon_rcvd_xtn_count++;
end
endtask

function void report_phase(uvm_phase phase);
`uvm_info(get_type_name(), $sformatf("Report: Router source Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_count), UVM_LOW)
endfunction 

endclass
	

		
	


