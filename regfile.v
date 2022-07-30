`include "defines.v"

module regfile(input	wire clk,
               input wire	rst,
			   //write
               input wire	we,
               input wire[`RegAddrBus]	waddr,	//goal reg addr
               input wire[`RegBus]	wdata,	//write data
			   //read1
               input wire	re1,	//reg1 readable
               input wire[`RegAddrBus]	raddr1,//reg1 addr
               output reg[`RegBus] rdata1,//reg1 data
			   	//read2
               input wire	re2,//reg2 readable
               input wire[`RegAddrBus]	raddr2,
               output reg[`RegBus] rdata2);


	reg[`RegBus]  regs[0:`RegNum-1]; //32*32 reg
	//write
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin	//$0 can not write
				regs[waddr] <= wdata;
			end
		end
	end
	//reg1 read
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata1 <= `ZeroWord;
	  end else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `ZeroWord;
	  end else if((raddr1 == waddr) && (we == `WriteEnable) 
	  	            && (re1 == `ReadEnable)) begin
	  	  rdata1 <= wdata;
	  end else if(re1 == `ReadEnable) begin
	      rdata1 <= regs[raddr1];
	  end else begin
	      rdata1 <= `ZeroWord;
	  end
	end
	//reg2 read
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end

endmodule