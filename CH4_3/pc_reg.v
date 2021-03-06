`include "defines.v"

module pc_reg(
    input  wire              clock,
	input  wire              reset,

	input  wire[`StopAllBus] stop_all,

	output reg[`AddressBus]  program_counter,
	output reg               chip_enable
);

    always @ (posedge clock) begin
		if (reset == `ResetEnable) begin
			chip_enable <= `ChipDisable;
		end else begin
			chip_enable <= `ChipEnable;
		end
	end
	 
	always @ (posedge clock) begin
		if (chip_enable == `ChipDisable) begin
			program_counter <= 32'h00000000;
	end else if (stop_all[0] == `NoStop) begin
			program_counter <= program_counter + 4'h4;
		end
	end

endmodule