module router_syn(input clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,input[1:0]data_in,output reg[2:0]write_enb,output vld_out_0,vld_out_1,vld_out_2,output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);

reg[1:0]temp;
reg[5:0]count_0,count_1,count_2;

//detecting address

always@(posedge clock)
begin
 if(!resetn)
  temp<=0;
 else if(detect_add)
  temp<=data_in;
 else
  temp<=temp;
end

//to indicate fifo full

always@(*)
begin
 case(temp)
  2'b00:fifo_full=full_0;
  2'b01:fifo_full=full_1;
  2'b10:fifo_full=full_2;
  default:fifo_full=0;
 endcase
end

assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

//for enabling write

always@(*)
begin
 if(write_enb_reg)
 begin
  case(temp)
   2'b00:write_enb=3'b001;
   2'b01:write_enb=3'b010;
   2'b10:write_enb=3'b100;
   default:write_enb=3'b000;
  endcase
 end
 else
  write_enb=0;
end

always@(posedge clock)
begin
 if(!resetn)
 begin
  count_0<=0;
  soft_reset_0<=0;
 end
 else if(vld_out_0)
 begin
         if(!read_enb_0 && count_0==5'd29)
  begin
   soft_reset_0<=1;
   count_0<=0;
  end
  else
  begin
   soft_reset_0<=0;
   count_0<=count_0+1'b1;
  end
 end
end


//for count_1

always@(posedge clock)
begin
 if(!resetn)
 begin
  count_1<=0;
  soft_reset_1<=0;
 end
 else if(vld_out_1)
 begin
         if(!read_enb_1 && count_1==5'd29)
  begin
    soft_reset_1<=1;
    count_1<=0;
  end
  else
  begin
   count_1<=count_1+1'b1;
   soft_reset_1<=0;
  end
 end
end


//for count_2

always@(posedge clock)
begin
 if(!resetn)
 begin
  count_2<=0;
  soft_reset_2<=0;
 end
 else if(vld_out_2)
 begin
         if(!read_enb_2 && count_2==5'd29)
  begin
    soft_reset_2<=1;
    count_2<=0;
  end
  else
  begin
   count_2<=count_2+1'b1;
   soft_reset_2<=0;
  end
 end
end

endmodule


/*module router_sync(input clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,input[1:0]data_in,output reg[2:0]write_enb,output vld_out_0,vld_out_1,vld_out_2,output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);

reg[1:0]temp;
reg[5:0]count_0,count_1,count_2;

//detecting address

always@(posedge clock)
begin
	if(!resetn)
		temp<=0;
	else if(detect_add)
		temp<=data_in;
	else
		temp<=temp;
end

//to indicate fifo full

always@(*)
begin
	case(temp)
		2'b00:fifo_full=full_0;
		2'b01:fifo_full=full_1;
		2'b10:fifo_full=full_2;
		default:fifo_full=0;
	endcase
end

assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

//for enabling write

always@(*)
begin
	if(write_enb_reg)
	begin
		case(temp)
			2'b00:write_enb=3'b001;
			2'b01:write_enb=3'b010;
			2'b10:write_enb=3'b100;
			default:write_enb=3'b000;
		endcase
	end
	else
		write_enb=0;
end*/

//for counting lets start writing
//for count_0

/*always@(posedge clock)
begin
	if(!resetn)
	begin
		count_0<=0;
		soft_reset_0<=0;
	end
	else if(vld_out_0)
	begin
	       	if(!read_enb_0)
		begin
			if(count_0==5'd29)
			begin
				soft_reset_0<=1;
				count_0<=0;
			end
			else
			begin
				soft_reset_0<=0;
				count_0<=count_0+1'b1;
			end
		end
		else
		begin
			soft_reset_0<=0;
			count_0<=0;
		end
	end
end*/

/*always@(posedge clock)		//uncmomment
begin
	if(!resetn)
	begin
		count_0<=0;
		soft_reset_0<=0;
	end
	else if(vld_out_0)
	begin
	       	if(!read_enb_0 && count_0==5'd29)
		begin
			soft_reset_0<=1;
			count_0<=0;
		end
		else
		begin
			soft_reset_0<=0;
			count_0<=count_0+1'b1;
		end
	end
end


//for count_1

always@(posedge clock)
begin
	if(!resetn)
	begin
		count_1<=0;
		soft_reset_1<=0;
	end
	else if(vld_out_1)
	begin
	       	if(!read_enb_1 && count_1==5'd29)
		begin
				soft_reset_1<=1;
				count_1<=0;
		end
		else
		begin
			count_1<=count_1+1'b1;
			soft_reset_1<=0;
		end
	end
end


//for count_2

always@(posedge clock)
begin
	if(!resetn)
	begin
		count_2<=0;
		soft_reset_2<=0;
	end
	else if(vld_out_2)
	begin
	       	if(!read_enb_2 && count_2==5'd29)
		begin
				soft_reset_2<=1;
				count_2<=0;
		end
		else
		begin
			count_2<=count_2+1'b1;
			soft_reset_2<=0;
		end
	end
end

endmodule*/


