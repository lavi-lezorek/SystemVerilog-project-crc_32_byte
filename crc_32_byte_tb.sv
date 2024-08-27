module crc_32_byte_tb
import crc_32_byte_constants_and_functions ::*;
();
	logic clk = 1'b0;
	logic rst_n = 1'b1;
	
	logic [7:0] data_in = 8'd0;
	logic crc_en = 1'b0;
	logic clr = 1'b0;
	
	logic [31:0] crc_out;
	logic crc_ready;
	
	crc_32_byte uo
	(
		.*
	);
	
	localparam [31:0] ARP_FCS = 32'h96484937;
	logic [5:0] cnt = 6'd0;
	
	logic [479:0] arp = 480'h00_11_22_33_44_55_AA_BB_CC_DD_EE_FF_08_06_00_01_08_00_06_04_00_02_AA_BB_CC_DD_EE_FF_C0_A8_01_01_00_11_22_33_44_55_C0_A8_01_64_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
	
	always begin
		#8ps clk = ~clk;
	end
	
	always_ff@(posedge clk) begin
		if(cnt == 6'd61) begin
			if(crc_out == ARP_FCS) begin
				$display("the crc calculation is correct");
			end else begin
				$display("the crc calculation is NOT correct");
			end
		end else if(cnt == 6'd60) begin
			crc_en <= 1'b0;
			data_in <= 8'd8;
			cnt <= cnt + 6'd1;
		end else begin
			crc_en <= 1'b1;
			data_in <= arp[479-:8];
			arp <= arp << 8;
			cnt <= cnt + 6'd1;
		end
	end
	
endmodule 