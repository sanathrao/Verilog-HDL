module fifo_ram(input [7:0] data_in,	 	//8 bit input data
		input clk,rst,rd,wr,		//rd and wr represents the read and write operation respectively
		output empty,full,		//Empty and Full state indicator
		output reg [3:0] fifo_cnt,	//4 bit counter
		output reg [7:0] data_out);	//8 bit output data 
	
	reg [7:0] fifo_ram[0:7];		//8 locations --> each containing 8 bits
	reg [2:0] rd_ptr,wr_ptr; 		//Pointers pointing to the read and write location
	assign empty = (fifo_cnt==4'b0000);
	assign full  = (fifo_cnt==4'b1000);

	always@(posedge clk)
	begin: write 				//Write operation is possible ONLY when RAM is NOT FULL
	
	if(wr && !full)				//Whenever write pin is asserted and when the fifo is NOT full
	   fifo_ram[wr_ptr] <= data_in;
	else if(wr && rd)			//When both pin is asserted
	   fifo_ram[wr_ptr] <= data_in;	
	end

	always@(posedge clk)
	begin: read				//Read operation is possible ONLY when RAM is NOT EMPTY

	if(rd && !empty)			//Whenever read pin is asserted and when the fifo is NOT EMPTY
	   data_out <= fifo_ram[rd_ptr];
	else if(rd && wr)			//When both the pins are asserted
	   data_out <= fifo_ram[rd_ptr];
	end
		
	//POINTER block

	always@(posedge clk)
	begin: pointer

	if(!rst)				//If reset is 0, the SYSTEM if off
	begin					//Pointers pointing to 0
	   wr_ptr <= 1'b0;
	   rd_ptr <= 1'b0;
	end

	else					//SYSTEM ON
	begin
	   wr_ptr <= ((wr && !full)|(wr && rd)) ? wr_ptr+1:wr_ptr;	//Write pin is asserted and the RAM is not full, increment pointer, else if RAM is full dont increment
	  
	   rd_ptr <= ((rd && !empty)|(rd && wr)) ? rd_ptr+1:rd_ptr;	//Read pin is asserted and the RAM is empty, increment pointer, else dont increment 
	end

	end

	always@(posedge clk)
	begin: count

	if(!rst)
	fifo_cnt <= 0;

	else
	begin

	case({wr,rd})
	2'b00: fifo_cnt <= fifo_cnt;					//No operation
	2'b01: fifo_cnt <= (fifo_cnt==0)?0:fifo_cnt-1;			//Read=1, if counter is 0, it indicates RAM is empty
	2'b10: fifo_cnt <= (fifo_cnt==8)?8:fifo_cnt+1;			//Write=1, if counter is 8, it indicates the RAM is FULL
	2'b11: fifo_cnt <= fifo_cnt;					//Both pins are asserted, No operation
	default: fifo_cnt <= fifo_cnt;
	endcase

	end
	end

	endmodule 		   
		
	
	
	
