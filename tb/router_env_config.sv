class router_env_config extends uvm_object;
`uvm_object_utils(router_env_config)

router_src_agent_config src_config[];
router_dst_agent_config dst_config[];
bit has_sagent =1;
bit has_dagent=1;
bit[1:0]addr;
int no_of_src_agent=1;
int no_of_dst_agent=3;
bit has_virtual_sequencer=1;
bit has_scoreboard=1;
function new(string name="router_env_config");
	super.new(name);
endfunction

endclass
