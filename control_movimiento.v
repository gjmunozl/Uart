module control_movimiento (s,clk, R_vertical_1 , R_vertical_2 , R_horizontal_1 , R_horizontal_2 , theta_manual , theta_actual , phi_manual , phi_actual, s_out_theta, s_out_phi);
  
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
	output reg [1:0] s_out_theta;
	output reg [1:0] s_out_phi;

	//inicialización 
	reg[1:0] shift_motor=2'b00;
	reg[1:0] shift_R=2'b00;
	reg [1:0] mover_theta;
	reg [1:0] mover_phi;
	reg [15:0] error=3'b101;
	reg [15:0] giro=8'b10110100;
	
	
	
	always @(posedge clk)begin
	
	
		if(s)begin
			//----------------------//MODO MANUAL//----------------------//
			if(shift_motor==2'b00)begin
				////////////////MOVER MANUALMENTE MOTOR PHI////////////////
				if(phi_actual>=(phi_manual+error)||phi_actual<=(phi_manual-error))begin 
					if(phi_actual>phi_manual) begin
						if((phi_actual-phi_manual)<=giro) begin
							mover_phi=2'b01;///movimiento horario positivo
						end else begin
							mover_phi=2'b11;///movimiento antiohorario negativo
						end
					end else begin
						if((phi_manual-phi_actual)<=giro) begin
							mover_phi=2'b11;///movimiento antihorario negativo
						end else begin
							mover_phi=2'b01;///movimiento horario positivo
						end
					end
				end else begin 
					mover_phi=2'b00;///NO mover
					shift_motor=2'b01;	
				end
				s_out_theta=mover_theta;
				////////////////MOVER MANUALMENTE MOTOR PHI////////////////
			end else begin
				////////////////MOVER MANUALMENTE MOTOR THETA////////////////
				if(theta_actual>=(theta_manual+error)||theta_actual<=(theta_manual-error))begin 
					if(theta_actual>theta_manual) begin
						mover_theta=2'b01;///movimiento horario positivo
					end else begin 
						mover_theta=2'b11;///movimiento antihorario negatiivo
					end
				end else begin 
					mover_theta=2'b00;///NO mover
					shift_motor=2'b01;
				end
				s_out_theta=mover_theta;
				////////////////MOVER MANUALMENTE MOTOR THETA////////////////
			end
			//----------------------//MODO MANUAL//----------------------//
		end else begin

			//----------------------//MODO AUTOMATICO//----------------------//
			if(shift_motor==2'b00)begin

				////////////////comparador vertical
				if ((R_vertical_1>=(R_vertical_2-error) )&& (R_vertical_1<=(R_vertical_2+error)))begin
					mover_theta=2'b00; ////El valor de las fotoresis. estan equilibradas
					shift_motor=2'b10;end 			
				else begin 
					if(R_vertical_1>R_vertical_2)begin
						mover_theta=2'b01;end  // movimiento horario  vertical					
					if(R_vertical_1<R_vertical_2)begin
						mover_theta=2'b11; end  // movimiento anti-horario  vertical
				end
				s_out_theta=mover_theta;	
				////////////////comparador vertical
			end else begin		
				////////////////comparador horizontal
				if (R_horizontal_1>=(R_horizontal_2-error) && R_horizontal_1<=(R_horizontal_2+error))begin
						mover_phi=2'b00; ////El valor de las fotoresis. estan equilibradas, el movimiento es cero.
						shift_motor=2'b00;end 
				else begin 
					if(R_horizontal_1>R_horizontal_2)begin
						mover_phi=2'b01;end  // movimiento horario  horizontalend
					if(R_horizontal_1<R_horizontal_2)begin
						mover_phi=2'b11;end   // movimiento anti-horario  horizontalend	
				end
				s_out_phi=mover_phi;
				////////////////comparador horizontal
			end
			//----------------------//MODO MANUAL//----------------------//
		end	
	end
endmodule
