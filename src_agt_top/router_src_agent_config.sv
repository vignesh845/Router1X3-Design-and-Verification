class router_src_agent_config extends uvm_object;
`uvm_object_utils(router_src_agent_config)

virtual src_if vif;
uvm_active_passive_enum is_active = UVM_ACTIVE;
static int drv_data_sent_count=0;
static int mon_rcvd_xtn_count=0;

function new(string name ="router_src_agent_config");
	super.new(name);
endfunction
endclass
