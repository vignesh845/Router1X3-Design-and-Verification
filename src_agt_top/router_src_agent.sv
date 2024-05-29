class router_src_agent extends uvm_agent;
`uvm_component_utils(router_src_agent);
router_src_driver driver;
router_src_monitor monitor;
router_src_sequencer sequencer;
router_src_agent_config m_cfg;


function new(string name="router_src_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
`uvm_fatal("TB CONFIG","cannot get() m_cfg from uvm_config")
//	super.build_phase(phase);
monitor =router_src_monitor::type_id::create("monitor",this);
if(m_cfg.is_active== UVM_ACTIVE)
begin
	driver = router_src_driver::type_id::create("driver",this);
	sequencer=router_src_sequencer::type_id::create("sequencer",this);
end
endfunction

function void connect_phase(uvm_phase phase);
if(m_cfg.is_active == UVM_ACTIVE)
	begin
		driver.seq_item_port.connect(sequencer.seq_item_export);
	end
endfunction

endclass

