// ADC SIMULATION
module clip_shaper
#( 
	parameter BITS_IN = 34, //Bits of input
	parameter BITS_OUT = 12, //Bits of output
	parameter G_SAIDA_LOG = 10 //Bits of gain of the input (2 ^ G_SAIDA_LOG)
)
(
	// Clock and reset signals
	input  clk, rst,
	// Input signal
	input  signed [BITS_IN-1:0] in,
	// Offset to ADC
	input  signed [BITS_IN-1:0] offset,
	// Output of ADC
	output reg [BITS_OUT-1:0] out = 0
);

// Adding the offset (adjusting the gain)
wire signed [BITS_IN-1:0] in_offset = (in + (offset <<< G_SAIDA_LOG)) >>> 10;




	always@(posedge clk or posedge rst) begin
		if(rst) begin
			out <= 0;
		end
		else begin
			//Negative voltages
			if (in_offset < 0)
				out <= 0;
			else
				//Voltages higher than the ADC limit
				if (in_offset > 4095)
					out <= 4095;
				else
					out <= in_offset;
		end
	end
	
endmodule
