class router_base_test extends uvm_test;
`uvm_component_utils(router_base_test)

router_env envh;
router_env_config m_cfg;

router_src_agent_config scfg[];
router_dst_agent_config dcfg[];

bit has_dagent=1;
bit has_sagent=1;
int no_of_dst_agent=3;
int no_of_src_agent=1;
bit has_scoreboard=1;

function new(string name="router_base_test",uvm_component parent);
	super.new(name,parent);
endfunction




function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("TEST", " In BUILD_PHASE of TEST class", UVM_LOW)
m_cfg=router_env_config::type_id::create("m_cfg",this);

if(m_cfg.has_sagent)
	m_cfg.src_config=new[m_cfg.no_of_src_agent];
if(m_cfg.has_dagent)
	m_cfg.dst_config=new[m_cfg.no_of_dst_agent];
	config_router();
uvm_config_db #(router_env_config)::set(this,"*","router_env_config",m_cfg);
	super.build();
envh =  router_env::type_id::create("envh",this);
endfunction



function void config_router();
if(m_cfg.has_sagent)
begin
	scfg=new[m_cfg.no_of_src_agent];
foreach(scfg[i])
begin
	scfg[i]=router_src_agent_config::type_id::create($sformatf("scfg[%0d]",i));
//if(!uvm_config_db #(virtual src_if)::get(this,"",$sformatf("vif_%0d",i),wcfg[i].vif))
if(!uvm_config_db #(virtual src_if)::get(this,"","vif",scfg[i].vif))

`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
					scfg[i].is_active = UVM_ACTIVE;
					
					m_cfg.src_config[i] = scfg[i];
                
                end
end

 if (has_dagent) 
		begin
           
            dcfg = new[no_of_dst_agent];

			foreach(dcfg[i])
				begin
					dcfg[i]=router_dst_agent_config::type_id::create($sformatf("dcfg[%0d]", i));
					if(!uvm_config_db #(virtual dst_if)::get(this,"", $sformatf("vif_%0d",i),dcfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
					dcfg[i].is_active = UVM_ACTIVE;
					m_cfg.dst_config[i] = dcfg[i];
                
                end
        end
	
    m_cfg.has_dagent = has_dagent;
    m_cfg.has_sagent = has_sagent;
	m_cfg.no_of_dst_agent=no_of_dst_agent;
    m_cfg.no_of_src_agent=no_of_src_agent;
	m_cfg.has_scoreboard=has_scoreboard;
endfunction
endclass
///////////////////////////////////router_small_pkt////////////
class router_small_pkt_test extends router_base_test;
`uvm_component_utils(router_small_pkt_test)
router_small_pkt small_pkt;
bit[1:0]addr;
function new(string name = "router_small_pkt_test" , uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 small_pkt=router_small_pkt::type_id::create("small_pkt");

endfunction

task run_phase(uvm_phase phase);
	//raise objection
//repeat(2)
    phase.raise_objection(this);
	repeat(2)
	begin
		addr={$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
	
	//start the sequence wrt virtual sequencer
`uvm_info("test", "started vseq onto vseqr", UVM_LOW)
    small_pkt.start(envh.v_sequencer);
	//drop objection
    
	end
	phase.drop_objection(this);
endtask  
function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology;
endfunction


endclass 

///////////////////////////////////////////////////////////////////////////////
class router_medium_pkt_test extends router_base_test;
`uvm_component_utils(router_medium_pkt_test)
router_medium_pkt medium_pkt;
bit[1:0]addr;
function new(string name = "router_medium_pkt_test" , uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 medium_pkt=router_medium_pkt::type_id::create("medium_pkt");

endfunction

task run_phase(uvm_phase phase);
	//raise objection
//repeat(2)
    phase.raise_objection(this);
	repeat(2)
	begin
		addr={$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
	
	//start the sequence wrt virtual sequencer
`uvm_info("test", "started vseq onto vseqr", UVM_LOW)
    medium_pkt.start(envh.v_sequencer);
	//drop objection
	end
    phase.drop_objection(this);
endtask 

function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology;
endfunction

endclass  

////////////////////////////////////////////////////////////////////////////////////////
class router_big_pkt_test extends router_base_test;
`uvm_component_utils(router_big_pkt_test)
router_big_pkt big_pkt;
bit[1:0]addr;
function new(string name = "router_big_pkt_test" , uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 big_pkt=router_big_pkt::type_id::create("big_pkt");

endfunction

task run_phase(uvm_phase phase);
	//raise objection
    phase.raise_objection(this);
	repeat(3)
	begin
		addr={$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
	
	//start the sequence wrt virtual sequencer
`uvm_info("test", "started vseq onto vseqr", UVM_LOW)
    big_pkt.start(envh.v_sequencer);
	//drop objection
	end
    phase.drop_objection(this);

endtask  
function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology;
endfunction

endclass 
//////////////////////////////////////////////////////////////////////////////////////////////////
class router_random_pkt_test extends router_base_test;
`uvm_component_utils(router_random_pkt_test)
router_random_pkt random_pkt;
bit[1:0]addr;
function new(string name = "router_random_pkt_test" , uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 random_pkt=router_random_pkt::type_id::create("random_pkt");

endfunction

task run_phase(uvm_phase phase);
	//raise objection
    phase.raise_objection(this);
	repeat(3)
	begin
		addr={$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
	
	//start the sequence wrt virtual sequencer
`uvm_info("test", "started vseq onto vseqr", UVM_LOW)
    random_pkt.start(envh.v_sequencer);
	//drop objection
	end
    phase.drop_objection(this);
	
endtask   






function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology;
endfunction

endclass


