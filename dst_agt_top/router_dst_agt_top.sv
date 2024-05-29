class router_dst_agt_top extends uvm_env;
	
	`uvm_component_utils(router_dst_agt_top)
        router_dst_agent agnth[];
	router_env_config m_cfg;


function new(string name = "router_dst_agt_top" , uvm_component parent);
	super.new(name,parent);
endfunction

    
//-----------------  build() phase method  -------------------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db.Have you set it?")
agnth=new[m_cfg.no_of_dst_agent];
foreach(agnth[i])
begin
	agnth[i]=router_dst_agent::type_id::create($sformatf("agnth[%0d]",i),this);

	uvm_config_db #(router_dst_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"router_dst_agent_config",m_cfg.dst_config[i]);
end
endfunction
endclass

