`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:05:39 11/25/2015 
// Design Name: 
// Module Name:    Mainn 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Mainn(
    input start,
	 input clk,
	 output  [1:0] s_out_theta_pos,
	output  [1:0] s_out_theta_neg,
	output  [1:0] s_out_phi_pos,
	output  [1:0] s_out_phi_neg
    );
reg [15:0]R_vertical_1;
	reg [15:0]R_vertical_2;
	reg [15:0]R_horizontal_1;
	reg [15:0]R_horizontal_2;
	reg [15:0]theta_manual;
	reg [15:0]phi_manual;
	reg [1:0]s;
reg[15:0]phi_actual;
	reg [15:0]theta_actual;
	
always @ (*) begin

if (start) begin
	R_vertical_1 = 20;
	R_vertical_2=30;
	R_horizontal_1=5;
	R_horizontal_2=15;
	theta_manual=3;
	phi_manual=4;
	s=0;
	phi_actual=2;
	theta_actual=5;
	end
	else begin
	R_vertical_1 = 0;
	R_vertical_2= 0;
	R_horizontal_1=0;
	R_horizontal_2=0;
	theta_manual=0;
	phi_manual=0;
	s=0;
	phi_actual=0;
	theta_actual=0;
	
	end
end

control_movimiento instance_name (
    .s(s), 
    .clk(clk), 
    .R_vertical_1(R_vertical_1), 
    .R_vertical_2(R_vertical_2), 
    .R_horizontal_1(R_horizontal_1), 
    .R_horizontal_2(R_horizontal_2), 
    .theta_manual(theta_manual), 
    .theta_actual(theta_actual), 
    .phi_manual(phi_manual), 
    .phi_actual(phi_actual), 
    .s_out_theta_pos(s_out_theta_pos), 
    .s_out_theta_neg(s_out_theta_neg), 
    .s_out_phi_pos(s_out_phi_pos), 
    .s_out_phi_neg(s_out_phi_neg)
    );
endmodule
