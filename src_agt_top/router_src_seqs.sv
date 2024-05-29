class router_base_seq extends uvm_sequence #(write_xtn);  
	`uvm_object_utils(router_base_seq) 

bit[1:0]addr;
    extern function new(string name ="router_base_seq");
	
endclass

//-----------------  constructor new method  -------------------//
function router_base_seq::new(string name ="router_base_seq");
	super.new(name);
endfunction
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class router_small_seq extends router_base_seq;
`uvm_object_utils(router_small_seq)
bit[1:0]addr;
extern function new(string name = "router_small_seq");
extern task body ();
 
endclass


function router_small_seq::new(string name="router_small_seq");
super.new(name);
endfunction  


task router_small_seq::body();
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal("addr","cannot get the config addr from uvm_config_db") 
//	repeat(10)
	begin
	req=write_xtn::type_id::create("req");
	//repeat(10)
	start_item(req);
	assert(req.randomize with {header[7:2] inside {[1:15]} && header[1:0]==addr;});
        finish_item(req);
	end
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class router_medium_seq extends router_base_seq;
`uvm_object_utils(router_medium_seq)

extern function new(string name ="router_medium_seq");
extern task body();

endclass

function router_medium_seq::new(string name ="router_medium_seq");
	super.new(name);
endfunction


task router_medium_seq::body();
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal("addr","cannot get the config addr from uvm_config_db") 



	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {header[7:2] inside {[16:30]} && header[1:0]==addr;})
        finish_item(req);
endtask
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class router_big_seq extends router_base_seq;
`uvm_object_utils(router_big_seq)
extern function new(string name ="router_big_seq");
extern task body();

endclass

function router_big_seq::new(string name ="router_big_seq");
	super.new(name);
endfunction


task router_big_seq::body();
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal("addr","cannot get the config addr from uvm_config_db") 



	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {header[7:2] inside {[37:63]} && header[1:0]==addr;})
        finish_item(req);
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class router_random_seq extends router_base_seq;
`uvm_object_utils(router_random_seq)
extern function new(string name ="router_random_seq");
extern task body();

endclass

function router_random_seq::new(string name ="router_random_seq");
	super.new(name);
endfunction


task router_random_seq::body();
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal("addr","cannot get the config addr from uvm_config_db") 




	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {header[1:0]==addr;})
        finish_item(req);
endtask
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
