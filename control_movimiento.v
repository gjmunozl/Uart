`timescale 1ns / 1ps

module control_movimiento (s,clk, R_vertical_1 , R_vertical_2 , R_horizontal_1 , R_horizontal_2 , theta_manual , theta_actual , phi_manual , phi_actual, s_out_theta_pos, s_out_theta_neg, s_out_phi_pos, s_out_phi_neg);
  
	input clk;
	////////////////////entradas de la fotoresistencias.
	input [15:0]R_vertical_1;
	input [15:0]R_vertical_2;
	input [15:0]R_horizontal_1;
	input [15:0]R_horizontal_2;
	
	///////////////////entradas de posición manual
	input [15:0]theta_manual;
	input [15:0]phi_manual;
	input [1:0]s; //////////interruptor modo manual/automatico
	
	///////////////////entradas de posición actual	
	input [15:0]phi_actual;
	input [15:0]theta_actual;
	
	//////////////////Salida para motores en eje theta y phi
	output reg [1:0] s_out_theta_pos;
	output reg [1:0] s_out_theta_neg;
	output reg [1:0] s_out_phi_pos;
	output reg [1:0] s_out_phi_neg;

	//inicialización 
	reg[1:0] shift_motor=2'b00;
	reg[1:0] shift_R=2'b00;
	reg [15:0] error=3'b101;
	reg [15:0] giro=8'b10110100;
	
	always @(posedge clk)begin
	
	
		if(s!=1)begin
		//----------------------//MODO AUTOMATICO//----------------------//	
			if(shift_motor==2'b00)begin
			
				////////////////mover automaticamente motor theta
				
				//NO mover motor phi
				s_out_phi_pos=2'b00;
				s_out_phi_neg=2'b00;
	
				if ((R_vertical_1>=(R_vertical_2-error) )&& (R_vertical_1<=(R_vertical_2+error)))begin
					//NO mover motor theta
					s_out_theta_neg=2'b00;
					s_out_theta_pos=2'b00;
					shift_motor=2'b10;
				end else begin 
					if(R_vertical_1>R_vertical_2)begin
						s_out_theta_pos=2'b01; // movimiento horario vertical
					end
					if(R_vertical_1<R_vertical_2)begin
						s_out_theta_neg=2'b01; // movimiento anti-horario vertical
					end	
				end
				////////////////mover automaticamente motor theta
				
			end else begin		
			
				////////////////mover automaticamente motor phi

				//NO mover motor theta
				s_out_theta_pos=2'b00;
				s_out_theta_neg=2'b00;
				
				if (R_horizontal_1>=(R_horizontal_2-error) && R_horizontal_1<=(R_horizontal_2+error))begin
						//NO mover motor phi
						s_out_phi_pos=2'b00;
						s_out_phi_neg=2'b00;
						shift_motor=2'b00; 
				end else begin 
					if(R_horizontal_1>R_horizontal_2)begin
						s_out_phi_pos=2'b01; // movimiento horario  horizontal
					end	
					if(R_horizontal_1<R_horizontal_2)begin
						s_out_phi_neg=2'b01; // movimiento anti-horario horizontal
					end	
				end
				////////////////mover automaticamente motor phi
			end
		//----------------------//MODO AUTOMATICO//----------------------//	
		end else begin
		//----------------------//MODO MANUAL//----------------------//
			
			if(shift_motor==2'b00)begin
				
				////////////////mover manualmente motor phi
				
				//NO mover motor theta
				s_out_theta_pos=2'b00;
				s_out_theta_neg=2'b00;
					
				if(phi_actual>=(phi_manual+error)||phi_actual<=(phi_manual-error))begin 	
					if(phi_actual>phi_manual) begin
						if((phi_actual-phi_manual)<=giro) begin
							s_out_phi_pos=2'b01;	// movimiento horario horizontal
							s_out_phi_neg=2'b00;
						end else begin
							s_out_phi_pos=2'b00;
							s_out_phi_neg=2'b01; // movimiento anti-horario horizontal
						end	
					end else begin
						if((phi_manual-phi_actual)<=giro) begin
							s_out_phi_pos=2'b00;
							s_out_phi_neg=2'b01; // movimiento anti-horario horizontal
						end else begin
							s_out_phi_pos=2'b01; // movimiento horario horizontal
							s_out_phi_neg=2'b00;
						end
					end
				end else begin 
					shift_motor=2'b01;
					//NO mover motor phi
					s_out_phi_pos=2'b00;
					s_out_phi_neg=2'b00;
				end
				////////////////mover manualmente motor phi
			end else begin
				
				////////////////mover manualmente motor theta
				
				//NO mover motor phi
				s_out_phi_pos=2'b00;
				s_out_phi_neg=2'b00;
				
				if(theta_actual>=(theta_manual+error)||theta_actual<=(theta_manual-error))begin 
					if(theta_actual>theta_manual) begin
						s_out_theta_pos=2'b01; // movimiento horario vertical
						s_out_theta_neg=2'b00; 
					end else begin 
						s_out_theta_pos=2'b00;
						s_out_theta_neg=2'b01; // movimiento antihorario vertical
					end	
				end else begin 
					shift_motor=2'b01;
					//NO mover motor theta
					s_out_theta_pos=2'b00;
					s_out_theta_neg=2'b00;
				end
				////////////////mover manualmente motor theta
			end
		//----------------------//MODO MANUAL//----------------------//
		end	
	end
endmodule
