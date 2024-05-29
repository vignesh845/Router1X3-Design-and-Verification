class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);
`uvm_object_utils(router_vbase_seq)
router_base_seq base_seq;
router_dst_base_seq  dst_base_seq;

router_small_seq small_seq;
router_dst_small_seq dst_small_seq;

router_medium_seq medium_seq;
router_dst_medium_seq dst_medium_seq;


router_big_seq big_seq;
router_dst_big_seq dst_big_seq;


router_random_seq random_seq;
router_env_config m_cfg;

router_src_sequencer src_seqrh[];
router_dst_sequencer dst_seqrh[];

router_virtual_sequencer vsqrh;

function new(string name ="router_vbase_seq");
	super.new(name);
endfunction

task body();
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	if(m_cfg.has_sagent)	
	src_seqrh = new[m_cfg.no_of_src_agent];

	
	if(m_cfg.has_dagent)
	dst_seqrh = new[m_cfg.no_of_dst_agent];
	
 //`uvm_info("body","virtual_seq body task",UVM_LOW) 
  assert($cast(vsqrh,m_sequencer)) 
  else
	begin
		`uvm_error("BODY", "Error in $cast of virtual sequencer")
	end
	foreach(src_seqrh[i])
		src_seqrh[i] = vsqrh.src_seqrh[i];
	foreach(dst_seqrh[i])
		dst_seqrh[i] = vsqrh.dst_seqrh[i];

endtask
endclass

////////////////////////////////////////////////////////
class router_small_pkt extends router_vbase_seq;
`uvm_object_utils(router_small_pkt)
router_small_seq small_seq;
router_dst_small_seq dst_small_seq;
bit[1:0]addr;
function new(string name="router_small_pkt");
super.new(name);
endfunction

task body();
super.body();

if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_full_name(),"cannot get addr from uvm_config")

	if(m_cfg.has_sagent)
	begin
	small_seq= router_small_seq::type_id::create("small_seq");
	end
	if(m_cfg.has_dagent)
	begin
		dst_small_seq = router_dst_small_seq::type_id::create("dst_small_seq");
	end
	fork
	begin
		for (int i=0 ; i < m_cfg.no_of_src_agent; i++)
          
	       		 small_seq.start(src_seqrh[i]);

        end	
	begin
		/*for(int j=0;j<m_cfg.no_of_dst_agent;j++)
			begin*/
		if(addr==2'b00)
			dst_small_seq.start(dst_seqrh[0]);
		if(addr==2'b01)
			dst_small_seq.start(dst_seqrh[1]);
		if(addr==2'b10)
			dst_small_seq.start(dst_seqrh[2]);

	//	end
	end
	join

			

		
		

 endtask
endclass
////////////////////////////////////////////////////////////////////////////
class router_medium_pkt extends router_vbase_seq;
`uvm_object_utils(router_medium_pkt)
router_medium_seq medium_seq;
router_dst_medium_seq dst_medium_seq;
bit[1:0]addr;
function new(string name="router_medium_pkt");
super.new(name);
endfunction

task body();
super.body();

if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_full_name(),"cannot get addr from uvm_config")

	if(m_cfg.has_sagent)
	begin
	medium_seq= router_medium_seq::type_id::create("medium_seq");
	end
	if(m_cfg.has_dagent)
	begin
		dst_medium_seq = router_dst_medium_seq::type_id::create("dst_medium_seq");
	end
	fork
	begin
		for (int i=0 ; i < m_cfg.no_of_src_agent; i++)
          
	       		 medium_seq.start(src_seqrh[i]);

        end	
	begin
		/*for(int j=0;j<m_cfg.no_of_dst_agent;j++)
			begin*/
		if(addr==2'b00)
			dst_medium_seq.start(dst_seqrh[0]);
		if(addr==2'b01)
			dst_medium_seq.start(dst_seqrh[1]);
		if(addr==2'b10)
			dst_medium_seq.start(dst_seqrh[2]);

	//	end
	end
	join

			

		
		

 endtask
endclass

/////////////////////////////////////////////////////////////////////////
class router_big_pkt extends router_vbase_seq;
`uvm_object_utils(router_big_pkt)
router_big_seq big_seq;
//router_dst_medium_seq dst_medium_seq;
router_dst_big_seq dst_big_seq;

bit[1:0]addr;
function new(string name="router_big_pkt");
super.new(name);
endfunction

task body();
super.body();

if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_full_name(),"cannot get addr from uvm_config")

	if(m_cfg.has_sagent)
	begin
	big_seq= router_big_seq::type_id::create("big_seq");
	end
	if(m_cfg.has_dagent)
	begin
		dst_big_seq = router_dst_big_seq::type_id::create("dst_big_seq");
	end
	fork
	begin
		for (int i=0 ; i < m_cfg.no_of_src_agent; i++)
          
	       		 big_seq.start(src_seqrh[i]);

        end	
	begin
		/*for(int j=0;j<m_cfg.no_of_dst_agent;j++)
			begin*/
		if(addr==2'b00)
			dst_big_seq.start(dst_seqrh[0]);
		if(addr==2'b01)
			dst_big_seq.start(dst_seqrh[1]);
		if(addr==2'b10)
			dst_big_seq.start(dst_seqrh[2]);

	//	end
	end
	join

			

		
		

 endtask
endclass


///////////////////////////////////////////////////////////////////

class router_random_pkt extends router_vbase_seq;
`uvm_object_utils(router_random_pkt)
router_random_seq random_seq;
//router_dst_random_seq dst_random_seq;
router_dst_random_seq dst_random_seq;

bit[1:0]addr;
function new(string name="router_random_pkt");
super.new(name);
endfunction

task body();
super.body();

if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_full_name(),"cannot get addr from uvm_config")

	if(m_cfg.has_sagent)
	begin
	random_seq= router_random_seq::type_id::create("random_seq");
	end
	if(m_cfg.has_dagent)
	begin
		dst_random_seq = router_dst_random_seq::type_id::create("dst_random_seq");
	end
	fork
	begin
		for (int i=0 ; i < m_cfg.no_of_src_agent; i++)
          
	       		 random_seq.start(src_seqrh[i]);

        end	
	begin
		/*for(int j=0;j<m_cfg.no_of_dst_agent;j++)
			begin*/
		if(addr==2'b00)
			dst_random_seq.start(dst_seqrh[0]);
		if(addr==2'b01)
			dst_random_seq.start(dst_seqrh[1]);
		if(addr==2'b10)
			dst_random_seq.start(dst_seqrh[2]);

	//	end
	end
	join

			

		
		

 endtask
endclass


