package crc_32_byte_constants_and_functions;
	localparam [31:0] CRC_POLY = 32'h04c11db7;
	localparam [31:0] CRC_INITIAL_VALUE = 32'hffffffff;
	
	//for always_comb only
	function logic [7:0] revers_byts(logic [7:0] data_to_revers = 8'd0);
		for(int i = 0; i < 8; i++) begin
			revers_byts[i] = data_to_revers[7-i];
		end
	endfunction
	
	function logic [31:0] not_reverse_4_byts(logic [31:0] data_to_revers_and_not = 32'd0);
		begin
			for (int i = 0; i < 32; i = i + 1) begin
				not_reverse_4_byts[i] = ~data_to_revers_and_not[31-i];
			end
		end
	endfunction
endpackage 