// Quartus Prime Verilog Template
// True Dual Port RAM with single clock

//VERIFY: RESOURCE MAPPING, should see only 2MK10 blocks
//

module bram
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=10)	//16 data width for 16 bit words, 2^10 = 1024 address locations
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input wire we_a, we_b, clk,		//write enable a/b and clk
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];	//from 0-511 is first ram and 512-1023 represents 2nd
	
	// FOR QUESTA SIMULATION ONLY
	initial begin
		$readmemh("song.hex", ram);
	end

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;	//write
			q_a <= data_a;	
		end
		else begin
			q_a <= ram[addr_a];		//read
		end 
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (we_b) 
		begin
			ram[addr_b] <= data_b;	//write
			q_b <= data_b;
		end
		else begin
			q_b <= ram[addr_b];	//read
		end 
	end

endmodule
