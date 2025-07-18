// TESTBENCH OF THE SIMULATOR
module FPGA_Simulator_v1_PZC_tb();


//Signals to extract the wanted signals
reg clk_tb, rst_tb;
wire hits_out_tb;
reg signed [13-1:0] offset_tb;
wire [13-1:0] energy_out_tb, event_bt_tb, event_all_tb;
wire signed [13+16+1-1:0] shaper_corrupted_tb;
wire [12-1:0] shaper_clip_tb;
wire signed [13+16+1-1:0] shaper_out_tb;
wire signed [13-1:0] pedestal_out_tb;
wire signed [17-1:0] noise_out_tb;
wire signed [13+16-1:0] pzc_out_tb;
wire signed [12+21-1:0] wiener_normal_out_tb;
wire signed [13+16+15-1:0] wiener_pzc_out_tb;



reg [31:0] cont;

initial
begin
	clk_tb <= 0;
	rst_tb <= 0;
	offset_tb <= 300; //Offset to ADC signal
	cont <= 0;
end

always #5 clk_tb <= ~clk_tb;


always @(posedge clk_tb) begin
	cont <= cont + 1'd1;

	//////// If wants to change the offset during the execution /////////
	
	//if (cont == 2**10)
	//	offset_tb <= 300;
	//if (cont == 2**14)
		//offset_tb <= 200;
	//	offset_tb <= 4095;
//	if (cont == 2**9)
//		offset_tb <= 100;
//
//	if (cont == 2**17)
//		offset_tb <= 200;
//	if (cont == 2**20)
//		offset_tb <= 300;
end




///// Block to simulater /////
FPGA_Simulator_v1_PZC sim_v1_PZC
(
	.clk(clk_tb), 
	.rst(rst_tb),
	.hits_out(hits_out_tb),
	.occupancy(1),
	.offset(offset_tb),
	.energy_out(energy_out_tb), 
	.event_bt(event_bt_tb), 
	.event_all(event_all_tb),
	.shaper_corrupted(shaper_corrupted_tb),
	.shaper_clip(shaper_clip_tb),
	.shaper_out(shaper_out_tb),
	.pedestal_out(pedestal_out_tb),
	.noise_out(noise_out_tb),
	.pzc_out(pzc_out_tb),
	.wiener_normal_out(wiener_normal_out_tb),
	.wiener_pzc_out(wiener_pzc_out_tb)
);


///////// SAVING THE SIGNALS TO TEST ///////
integer data_out1;
integer data_out2;
integer data_out3;
integer data_out4;
integer data_out5;
integer data_out6;
integer data_out7;
integer data_out8;
integer data_out9;
integer data_out10;
integer data_out11;
integer data_out12;
integer data_out13;

initial
begin
	data_out1 <= $fopen("hits_out_tb.txt");
	data_out2 <= $fopen("energy_out_tb.txt");
	data_out3 <= $fopen("event_bt_tb.txt");
	data_out4 <= $fopen("event_all_tb.txt");
	data_out5 <= $fopen("shaper_out_tb.txt");
	data_out6 <= $fopen("pzc_out_tb.txt");
	data_out7 <= $fopen("pedestal_out_tb.txt");
	data_out8 <= $fopen("shaper_corrupted_tb.txt");
	data_out9 <= $fopen("shaper_clip_tb.txt");
	data_out10 <= $fopen("noise_out_tb.txt");
	data_out11 <= $fopen("offset_tb.txt");
	data_out12 <= $fopen("wiener_normal_out_tb.txt");
	data_out13 <= $fopen("wiener_pzc_out_tb.txt");
end


always@(posedge clk_tb)
begin
	$fdisplay(data_out1, "%d", hits_out_tb);
	$fdisplay(data_out2, "%d", energy_out_tb);
	$fdisplay(data_out3, "%d", event_bt_tb);
	$fdisplay(data_out4, "%d", event_all_tb);
	$fdisplay(data_out5, "%d", shaper_out_tb);
	$fdisplay(data_out6, "%d", pzc_out_tb);
	$fdisplay(data_out7, "%d", pedestal_out_tb);
	$fdisplay(data_out8, "%d", shaper_corrupted_tb);
	$fdisplay(data_out9, "%d", shaper_clip_tb);
	$fdisplay(data_out10,"%d", noise_out_tb);
	$fdisplay(data_out11,"%d", offset_tb);
	$fdisplay(data_out12, "%d", wiener_normal_out_tb);
	$fdisplay(data_out13, "%d", wiener_pzc_out_tb);
end
//////////////////////////////////////////

endmodule