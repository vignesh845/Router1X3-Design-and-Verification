module router_fifo(input clock,resetn,soft_reset,write_enb,read_enb,lfd_state,
input[7:0]data_in,output full,empty,output reg [7:0]data_out);
reg [3:0]wr_ptr,rd_ptr;
reg lfd;
reg [6:0]count;
integer i;

reg [8:0]mem[15:0]; //fifo of size 16x9
//for lfd_state(load first data byte)
always@(posedge clock)
begin
	if(!resetn)
		lfd<=0;
	else if(soft_reset)
		lfd<=0;
	else
		lfd<=lfd_state;
end
//for write_operation
always@(posedge clock)
begin
	if(!resetn || soft_reset)
		for(i=0;i<16;i=i+1)
		begin
		{mem[i],wr_ptr}<=0;

		end
	else if(write_enb && !full)
	begin

	mem[wr_ptr]<={lfd,data_in};
	wr_ptr<=wr_ptr+1;
	end
end
//for read operation
always@(posedge clock)
begin
	if(!resetn)
	begin
		{data_out,rd_ptr}<=0;
//rd_ptr<=0;
	end
	else if(soft_reset)
	begin
		data_out<=8'bz;
		rd_ptr<=0;
	end
	else if(read_enb && !empty)
	begin
//data_out<=mem[rd_ptr[3:0]][7:0];
	data_out<=mem[rd_ptr];
	rd_ptr<=rd_ptr+1;
	end
end
//for counter operation
always@(posedge clock)
begin
	if(!resetn)
		count<=0;
	else if(soft_reset)
		count<=0;
	else if(read_enb && !empty)
	begin
	if(mem[rd_ptr[3:0]][8]==1'b1)
//count<=mem[rd_ptr[3:0]][7:2]+1'b1;
		count<=mem[0][7:2]+1'b1;
	else if(count!=0)
		count<=count-1'b1;
end
end
assign full=(wr_ptr==4'd15 && rd_ptr==4'd0) ? 1'b1 : 1'b0;
assign empty=(wr_ptr==rd_ptr) ? 1'b1 : 1'b0;
endmodule

/*module router_fifo(input clock,resetn,soft_reset,write_enb,read_enb,lfd_state,input[7:0]data_in,output full,empty,output reg [7:0]data_out);
reg [3:0]wr_ptr,rd_ptr;
reg lfd;
reg [6:0]count;
integer i;
//reg [8:0]mem[0:15];
reg [8:0]mem[15:0];   //fifo of size 16x9

//for lfd_state(load first data byte)
always@(posedge clock)
begin
	if(!resetn)
		lfd<=0;
	else if(soft_reset)
		lfd<=0;
	else
		lfd<=lfd_state;
end

//for write_operation

always@(posedge clock)
begin
	if(!resetn || soft_reset)
		for(i=0;i<16;i=i+1)
		begin
			{mem[i],wr_ptr}<=0;
			//wr_ptr<=0;
		end
		//else if(soft_reset)
		//for(i=0;i<16;i=i+1)
		//begin
		//	mem[i]<=0;
		//	wr_ptr<=0;
		//end
		else if(write_enb && !full)
		begin
			//{mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={lfd,data_in};
			mem[wr_ptr]<={lfd,data_in};
			wr_ptr<=wr_ptr+1;
		end
end

//for read operation

always@(posedge clock)
begin
	if(!resetn) //|| soft_reset)
	begin
		{data_out,rd_ptr}<=0;
		//rd_ptr<=0;
	end
	else if(soft_reset)
	begin
		data_out<=8'bz;
		rd_ptr<=0;
	end
	else if(read_enb && !empty)
	begin
		//data_out<=mem[rd_ptr[3:0]][7:0];
		data_out<=mem[rd_ptr];
		rd_ptr<=rd_ptr+1;
	end
end

//for counter operation

always@(posedge clock)
begin
	if(!resetn)
		count<=0;
	else if(soft_reset)
		count<=0;
	else if(read_enb && !empty)
	begin
		if(mem[rd_ptr[3:0]][8]==1'b1)
			//count<=mem[rd_ptr[3:0]][7:2]+1'b1;
			count<=mem[0][7:2]+1'b1;
		else if(count!=0)
			count<=count-1'b1;
	end
end

assign full=(wr_ptr==4'd15 && rd_ptr==4'd0) ? 1'b1 : 1'b0;
assign empty=(wr_ptr==rd_ptr) ? 1'b1 : 1'b0;
endmodule*/






