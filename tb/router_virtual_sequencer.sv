class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
`uvm_component_utils(router_virtual_sequencer)

router_src_sequencer src_seqrh[];
router_dst_sequencer dst_seqrh[];

router_env_config m_cfg;

function new(string name="router_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal("TB CONFIG","Cannot get() m_cfg from uvm_config")
super.build_phase(phase);

src_seqrh=new[m_cfg.no_of_src_agent];
dst_seqrh=new[m_cfg.no_of_dst_agent];
endfunction
endclass
