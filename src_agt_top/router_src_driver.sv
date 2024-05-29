class router_src_driver extends uvm_driver #(write_xtn);
`uvm_component_utils(router_src_driver)
virtual src_if.SDRV_MP vif;
router_src_agent_config m_cfg;
write_xtn xtn;

function new(string name = "router_src_driver",uvm_component parent);
	super.new(name,parent);
endfunction


//build_phase
function void build_phase(uvm_phase phase);
if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
	`uvm_fatal("TB CONFIG","cannot get() m_cfg from uvm_config")
	super.build_phase(phase);
xtn=write_xtn::type_id::create("xtn");
endfunction

//connect_phase
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	@(vif.sdrv_cb);
		vif.sdrv_cb.resetn <=0;
	@(vif.sdrv_cb);
		vif.sdrv_cb.resetn <=1;

forever
begin
                seq_item_port.get_next_item(req);
//	`uvm_info("driver","get req",UVM_LOW)
	          send_to_dut(req);
	//	$display("send to duv");
			               
		 seq_item_port.item_done();
                end
   endtask

task send_to_dut(write_xtn xtn);
 //`uvm_info("Router_src_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 

	@(vif.sdrv_cb)
	while(vif.sdrv_cb.busy)
		@(vif.sdrv_cb);
	vif.sdrv_cb.pkt_valid<=1;
//	$display("pkt valid = %0d",vif.sdrv_cb.pkt_valid);
	vif.sdrv_cb.data_in<=xtn.header;
	@(vif.sdrv_cb);
		foreach(xtn.payload_data[i])
		begin
			while(vif.sdrv_cb.busy)
				@(vif.sdrv_cb);
			vif.sdrv_cb.data_in<=xtn.payload_data[i];
				@(vif.sdrv_cb);
	end
			while(vif.sdrv_cb.busy)
				@(vif.sdrv_cb);
			vif.sdrv_cb.pkt_valid<=0;
			vif.sdrv_cb.data_in<=xtn.parity;
 `uvm_info("Router_src_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 

			repeat(3)
				@(vif.sdrv_cb);
			m_cfg.drv_data_sent_count++;
endtask

function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: Router source driver sent %0d transactions", m_cfg.drv_data_sent_count), UVM_LOW)
  endfunction



endclass
