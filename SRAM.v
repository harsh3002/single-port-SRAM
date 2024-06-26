
`timescale 1ns/1ns

module sram
#(parameter WIDTH=8,
  parameter DEPTH=8,
  parameter ADDR_WIDTH=$clog2(DEPTH))(
output reg [WIDTH-1:0] data_out,
input [WIDTH-1:0] data_in,
input clk,
input chip_sel,
input read_ena,
input write_ena,
input [ADDR_WIDTH-1:0] address);

reg [WIDTH-1:0] mem [0:DEPTH-1];

//Write Operation
always@(posedge clk) begin
	
	if( chip_sel & write_ena & !read_ena) 
		mem[address]<=data_in;
end

//Read Operation
always@(posedge clk) begin
	if(chip_sel  &	read_ena  &  !write_ena)
		data_out<= mem[address];
	else 
		data_out<=0;
end

endmodule 


module sram_tb
#(parameter WIDTH=8,
  parameter DEPTH=8,
  parameter ADDR_WIDTH=$clog2(DEPTH))();

wire [WIDTH-1:0] data_out_tb;
reg [WIDTH-1:0] data_in_tb;
reg clk_tb;
reg chip_sel_tb;
reg read_ena_tb;
reg write_ena_tb;
reg [ADDR_WIDTH-1:0] address_tb;


sram dut(
.data_out(data_out_tb),
.data_in(data_in_tb),
.clk(clk_tb),
.chip_sel(chip_sel_tb),
.read_ena(read_ena_tb),
.write_ena(write_ena_tb),
.address(address_tb));



initial begin
	clk_tb=1'b0;
	forever #5 clk_tb=~clk_tb;
end

initial begin
chip_sel_tb<=0;
#5 chip_sel_tb<=1;

end

initial begin
#5 read_ena_tb<=0; write_ena_tb<=0; data_in_tb<=0; address_tb<=0;
#10 read_ena_tb<=0; write_ena_tb<=1; data_in_tb<=8'b10101010; address_tb<=3'b100;
#10 read_ena_tb<=1; write_ena_tb<=1; data_in_tb<=0; address_tb<=3'b100;
#10 read_ena_tb<=1; write_ena_tb<=0; data_in_tb<=8'b00100101; address_tb<=3'b110;
#10 read_ena_tb<=0; write_ena_tb<=1; data_in_tb<=8'b00100101; address_tb<=3'b110;
#10 read_ena_tb<=1; write_ena_tb<=0; data_in_tb<=0; address_tb<=3'b110;
#10 read_ena_tb<=0; write_ena_tb<=1; data_in_tb<=8'b11111111; address_tb<=3'b001;
#10 read_ena_tb<=1; write_ena_tb<=0; data_in_tb<=0; address_tb<=3'b001;
#10 read_ena_tb<=1; write_ena_tb<=0; data_in_tb<=0; address_tb<=3'b010;
#10 read_ena_tb<=0; write_ena_tb<=1; data_in_tb<=8'b11011010; address_tb<=3'b010;
#10 read_ena_tb<=1; write_ena_tb<=0; data_in_tb<=0; address_tb<=3'b010;

end


endmodule 
