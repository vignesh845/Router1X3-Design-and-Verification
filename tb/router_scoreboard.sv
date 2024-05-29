class router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(router_scoreboard)


uvm_tlm_analysis_fifo#(read_xtn) fifo_dst[]; 
uvm_tlm_analysis_fifo #(write_xtn) fifo_src;

router_env_config m_cfg;

write_xtn src_xtn;
write_xtn src_cov_data;

read_xtn dst_xtn;
read_xtn dst_cov_data;
 int data_verified_count;

//source coverage

covergroup router_fcov1;
	option.per_instance=1; //gives detailed coverage

	HEADER: coverpoint src_cov_data.header[1:0]{
							bins fifo0 ={2'b00};
							bins fifo1 ={2'b01};
							bins fifo2={2'b10};}

	PAYLOAD_SIZE : coverpoint src_cov_data.header[7:2]{
							bins small_packet={[1:15]};				
							bins medium_packet={[16:30]};
							bins big_packet ={[31:63]};}

//	BAD_PKT : coverpoint src_cov_data.err {bins bad_pkt ={1};}

	HEADER_X_PAYLOAD_SIZE : cross HEADER,PAYLOAD_SIZE;
endgroup

covergroup router_fcov2;
	option.per_instance=1; //gives detailed coverage

	HEADER: coverpoint dst_cov_data.header[1:0]{
							bins fifo0 ={2'b00};
							bins fifo1 ={2'b01};
							bins fifo2={2'b10};}

	PAYLOAD_SIZE : coverpoint dst_cov_data.header[7:2]{
							bins small_packet={[1:15]};				
							bins medium_packet={[16:30]};
							bins big_packet ={[31:63]};}


	HEADER_X_PAYLOAD_SIZE : cross HEADER,PAYLOAD_SIZE;
endgroup


function new(string name="router_scoreboard",uvm_component parent);
	super.new(name,parent);
	router_fcov1=new();
	router_fcov2=new();
	
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get m_cfg from uvm_config")
	fifo_src = new("fifo_src",this);
	fifo_dst=new[m_cfg.no_of_dst_agent];
       // fifo_dst = new[e_cfg.no_of_dst_agent];
        foreach(fifo_dst[i])
                fifo_dst[i] = new($sformatf("fifo_dst[%0d]",i),this);
	src_xtn = write_xtn::type_id::create("src_xtn");
	dst_xtn=read_xtn::type_id::create("dst_xtn");
endfunction


//source coverage

/*covergroup router_fcov1;
	option.per_instance=1; //gives detailed coverage

	HEADER: coverpoint src_cov_data.header[1:0]{
							bins fifo0 ={2'b00};
							bins fifo1 ={2'b01};
							bins fifo2={2'b10};}

	PAYLOAD_SIZE : coverpoint src_cov_data.header[7:2]{
							bins small_packet={[1:15]};				
							bins medium_packet={[16:30]};
							bins big_packet ={[31:63]};}

	BAD_PKT : coverpoint src_cov_data.err {bins bad_pkt ={1};}

	HEADER_X_PAYLOAD_SIZE : cross HEADER,PAYLOAD_SIZE,BAD_PKT;
endgroup

covergroup router_fcov2;
	option.per_instance=1; //gives detailed coverage

	HEADER: coverpoint dst_cov_data.header[1:0]{
							bins fifo0 ={2'b00};
							bins fifo1 ={2'b01};
							bins fifo2={2'b10};}

	PAYLOAD_SIZE : coverpoint dst_cov_data.header[7:2]{
							bins small_packet={[1:15]};				
							bins medium_packet={[16:30]};
							bins big_packet ={[31:63]};}


	HEADER_X_PAYLOAD_SIZE : cross HEADER,PAYLOAD_SIZE;
endgroup*/


task run_phase(uvm_phase phase);
	fork
		//getting data from src monitor
		//begin
		forever
		begin
			fifo_src.get(src_xtn);
			`uvm_info(get_type_name(),"data received from monitor ",UVM_LOW);
			src_xtn.print();
			src_cov_data=src_xtn;
			router_fcov1.sample();
		end
	//	end
		
		//getting data from dst monitor
	//	begin
	//	forever
	//	begin
			fork
				//fifo0
			begin
				fifo_dst[0].get(dst_xtn);
				`uvm_info(get_type_name(),"data received from dst monitor",UVM_LOW);
				dst_xtn.print();
				check_data(dst_xtn,src_xtn);
				dst_cov_data=dst_xtn;
				router_fcov2.sample();
			end
				
			begin
				fifo_dst[1].get(dst_xtn);
				`uvm_info(get_type_name(),"data received from dst monitor",UVM_LOW);
				dst_xtn.print();
				check_data(dst_xtn,src_xtn);
				dst_cov_data=dst_xtn;
				router_fcov2.sample();

			end
			
			begin
				fifo_dst[2].get(dst_xtn);
				`uvm_info(get_type_name(),"data received from dst monitor",UVM_LOW);
				dst_xtn.print();
				check_data(dst_xtn,src_xtn);
				dst_cov_data=dst_xtn;
				router_fcov2.sample();

			end
		join_any
		disable fork;
	join

endtask
function void check_data(read_xtn dst,write_xtn src);
begin
	if(src.header == dst.header)
		`uvm_info("SB","HEADER MATCHED SUCCESSFULLY",UVM_MEDIUM)
	else
		`uvm_info("SB","HEADER NOT MATCHED",UVM_MEDIUM)

	if(src.payload_data==dst.payload_data)
		`uvm_info("SB","PAYLOAD MATCHED SUCCESSFULLY",UVM_MEDIUM)
	else
		`uvm_info("SB","PAYLOAD NOT MATCHED",UVM_MEDIUM)


	if(src.parity==dst.parity)
		`uvm_info("SB","PARITY MATCHED SUCCESSFULLY",UVM_MEDIUM)
	else
		`uvm_info("SB","PARITY NOT MATCHED",UVM_MEDIUM)

	data_verified_count++;
end
endfunction

function void report_phase(uvm_phase phase);
	`uvm_info(get_type_name(),$sformatf("REPORT:NUmber of data verified in SB %0d",data_verified_count),UVM_LOW)

endfunction
endclass


