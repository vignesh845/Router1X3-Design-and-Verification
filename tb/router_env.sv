class router_env extends uvm_env;
`uvm_component_utils(router_env)

router_src_agt_top sagt_top;
router_dst_agt_top dagt_top;

router_virtual_sequencer v_sequencer;

router_scoreboard sb;
router_env_config m_cfg;

function new(string name="router_env",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))


`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config")

if(m_cfg.has_sagent)
begin
	
	sagt_top=router_src_agt_top::type_id::create("sagt_top",this);
end


if(m_cfg.has_dagent)
begin
	dagt_top=router_dst_agt_top::type_id::create("dagt_top",this);
end
	
if(m_cfg.has_virtual_sequencer)
begin
	v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);
end
if(m_cfg.has_scoreboard)
begin


	sb=router_scoreboard::type_id::create("sb",this);

 end

endfunction




function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("connect_phase","env connect phase",UVM_LOW)

if(m_cfg.has_virtual_sequencer)
begin
	if(m_cfg.has_sagent)
		foreach(sagt_top.agnth[i])
		begin
		//	`uvm_info("connect_phase","env connect phase",UVM_LOW)
			v_sequencer.src_seqrh[i] = sagt_top.agnth[i].sequencer;
		end
	if(m_cfg.has_dagent)
		foreach(dagt_top.agnth[i])
		begin
			v_sequencer.dst_seqrh[i]=dagt_top.agnth[i].seqh;
		end
	if(m_cfg.has_scoreboard)
	begin
		if(m_cfg.has_sagent)
		begin
    			for(int i=0;i<m_cfg.no_of_src_agent;i++)
	//foreach(sagt_top.agnth[i])
		//	foreach(m_cfg.src_config[i])
     				sagt_top.agnth[i].monitor.monitor_port.connect(sb.fifo_src.analysis_export);
		end
		if(m_cfg.has_dagent)
		begin
   				for(int i=0;i<m_cfg.no_of_dst_agent;i++)
//foreach(dagt_top.agnth[i])
		//	foreach(m_cfg.dst_config[i])
      				dagt_top.agnth[i].monh.monitor_port.connect(sb.fifo_dst[i].analysis_export);
		end
	end


end
endfunction
endclass





