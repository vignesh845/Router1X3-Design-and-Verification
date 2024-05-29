class router_dst_base_seq extends uvm_sequence #(read_xtn);
`uvm_object_utils(router_dst_base_seq)
read_xtn trans;

function new(string name ="router_dst_base_seq");
	super.new(name);
endfunction

endclass

////////////////router_small_seq//////////////////////////

class router_dst_small_seq extends router_dst_base_seq;
`uvm_object_utils(router_dst_small_seq)

function new(string name="router_dst_small_seq");
	super.new(name);
endfunction

task body();
	trans=read_xtn::type_id::create("trans");
	
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {cycle inside {[1:29]};});
	finish_item(req);
endtask
endclass
/////////////router_medium_seq//////

class router_dst_medium_seq extends router_dst_base_seq;
`uvm_object_utils(router_dst_medium_seq)

function new(string name="router_dst_medium_seq");
	super.new(name);
endfunction

task body();
	trans=read_xtn::type_id::create("trans");
	
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {cycle inside {[1:29]};});
	finish_item(req);
endtask
endclass


////////////router_big_seq/////////
class router_dst_big_seq extends router_dst_base_seq;
`uvm_object_utils(router_dst_big_seq)

function new(string name="router_dst_big_seq");
	super.new(name);
endfunction

task body();
	trans=read_xtn::type_id::create("trans");
	
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {cycle inside {[1:29]};});
	finish_item(req);
endtask
endclass
///////////////////////////
class router_dst_random_seq extends router_dst_base_seq;
`uvm_object_utils(router_dst_random_seq)

function new(string name="router_dst_random_seq");
	super.new(name);
endfunction

task body();
	trans=read_xtn::type_id::create("trans");
	
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {cycle inside {[1:29]};});
	finish_item(req);
endtask
endclass
