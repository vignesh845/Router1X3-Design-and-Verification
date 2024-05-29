class read_xtn extends uvm_sequence_item;
`uvm_object_utils(read_xtn)
//properties
bit [7:0]header;
bit [7:0]payload_data[];
bit[7:0]parity;
rand bit[4:0]cycle;
function new(string name="read_xtn");
	super.new(name);
endfunction
//methods

function void do_print (uvm_printer printer);
       super.do_print(printer);

        //                  srting name             bitstream value     size    radix for printing
        printer.print_field( "header",		this.header,		 8,	 UVM_DEC);

        foreach(payload_data[i])
                printer.print_field($sformatf("payload_data[%0d]",i),this.payload_data[i],8,UVM_DEC);
       
	 printer.print_field( "parity",this.parity,8,UVM_DEC);
	printer.print_field("cycle",this.cycle,5,UVM_DEC);
endfunction:do_print





endclass

