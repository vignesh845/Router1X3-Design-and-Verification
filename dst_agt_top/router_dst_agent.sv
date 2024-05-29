class router_dst_agent extends uvm_agent;
`uvm_component_utils(router_dst_agent);
router_dst_driver drvh;
router_dst_monitor monh;
router_dst_sequencer seqh;
router_dst_agent_config m_cfg;


function new(string name="router_dst_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
`uvm_fatal("TB CONFIG","cannot get() m_cfg from uvm_config")
	super.build_phase(phase);
monh =router_dst_monitor::type_id::create("monh",this);
if(m_cfg.is_active== UVM_ACTIVE)
begin
	drvh = router_dst_driver::type_id::create("drvh",this);
	seqh=router_dst_sequencer::type_id::create("seqh",this);
end
endfunction


function void connect_phase(uvm_phase phase);
if(m_cfg.is_active == UVM_ACTIVE)
	begin
		drvh.seq_item_port.connect(seqh.seq_item_export);
	end
endfunction

endclass

