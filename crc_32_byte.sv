/*
	crc_32_byte U0
	(
		.clk(),
		.rst_n(),
		.data_in(),
		.crc_en(),
		.clr(),
		.crc_out(),
		.crc_ready()
	);
*/

module crc_32_byte
import crc_32_byte_constants_and_functions ::*;
(
	input wire clk,
	input wire rst_n,
	
	input wire [7:0] data_in,
	input wire crc_en,
	input wire clr,
	
	output logic [31:0] crc_out,
	output logic crc_ready
);

	logic [31:0] crc_reg = CRC_INITIAL_VALUE;
	logic [31:0] crc_next = CRC_INITIAL_VALUE;
	
	logic [31:0] crc_out_reg = 32'd0;
	logic [31:0] crc_out_next = 32'd0;
	
	logic crc_ready_reg = 1'b0;
	logic crc_ready_next = 1'b0;
	
	assign crc_out = crc_out_reg;
	assign crc_ready = crc_ready_reg;
	
	always_comb begin
		crc_next = crc_reg;
		crc_out_next = crc_out_reg;
		crc_ready_next = crc_ready_reg;
		
		if(clr == 1'b1) begin
			crc_next = CRC_INITIAL_VALUE;
			crc_out_next = 32'd0;
			crc_ready_next = 1'b0;
		end else begin
			if(crc_en == 1'b1) begin
				crc_next = crc_next ^ {revers_byts(data_in), 24'd0};
				for(int i = 0; i < 8; i++) begin
					if(crc_next[31] == 1'b1) begin
						crc_next = {crc_next[30:0], 1'b0} ^ CRC_POLY;
					end else begin
						crc_next = {crc_next[30:0], 1'b0};
					end
				end
				crc_out_next = not_reverse_4_byts(crc_next);
				crc_ready_next = 1'b1;
			end
		end
	end
	
	always_ff@(posedge clk or negedge rst_n) begin
		if(rst_n == 1'b0) begin
			crc_reg <= CRC_INITIAL_VALUE;
			crc_out_reg <= 32'd0;
			crc_ready_reg <= 1'b0;
		end else begin
			crc_reg <= crc_next;
			crc_out_reg <= crc_out_next;
			crc_ready_reg <= crc_ready_next;
		end
	end
endmodule 