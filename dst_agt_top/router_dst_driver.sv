class router_dst_driver extends uvm_driver #(read_xtn);
`uvm_component_utils(router_dst_driver)
virtual dst_if.DST_DRV_MP vif;
router_dst_agent_config m_cfg;
read_xtn drv_xtn;

function new(string name = "router_dst_driver",uvm_component parent);
	super.new(name,parent);
endfunction


//build_phase
function void build_phase(uvm_phase phase);
if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
	`uvm_fatal("TB CONFIG","cannot get() m_cfg from uvm_config")
	super.build_phase(phase);
drv_xtn=read_xtn::type_id::create("drv_xtn");
endfunction

//connect_phase
function void connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
endfunction


task run_phase(uvm_phase phase);
	super.run_phase(phase);
forever
begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done;
end
endtask


task send_to_dut(read_xtn drv_xtn);
begin
	while(vif.dst_drv_cb.valid_out!==1)
		@(vif.dst_drv_cb);
	repeat(drv_xtn.cycle)
		@(vif.dst_drv_cb);
	vif.dst_drv_cb.read_enb<=1;
	while(vif.dst_drv_cb.valid_out)
		@(vif.dst_drv_cb);
	vif.dst_drv_cb.read_enb<=0;
	@(vif.dst_drv_cb);
	`uvm_info("ROUTER_DST_DRIVER",$sformatf("printing from driver \n %s",drv_xtn.sprint()),UVM_LOW)

	//repeat(2)
	//@(vif.dst_drv_cb);
	m_cfg.drv_data_count++;

   	end
endtask

function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: ROUTER read driver sent %0d transactions", m_cfg.drv_data_count), UVM_LOW)
endfunction
endclass
