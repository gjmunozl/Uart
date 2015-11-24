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
	
	
		if(s)begin
			//----------------------//MODO MANUAL//----------------------//
			if(shift_motor==2'b00)begin
				////////////////mover manualmente motor phi
				if(phi_actual>=(phi_manual+error)||phi_actual<=(phi_manual-error))begin 
					if(phi_actual>phi_manual) begin
						if((phi_actual-phi_manual)<=giro) begin
							s_out_phi_pos=2'b01;end	// movimiento horario horizontal
						else begin
							s_out_phi_neg=2'b01;end	// movimiento anti-horario horizontal
					end else begin
						if((phi_manual-phi_actual)<=giro) begin
							s_out_phi_neg=2'b01;end	// movimiento anti-horario horizontal
						else begin
							s_out_phi_pos=2'b01;end	// movimiento horario horizontal
					end
				end else begin 
					s_out_phi_pos=2'b00;///NO mover
					s_out_phi_neg=2'b00;///NO mover
					shift_motor=2'b01;	
				end
				////////////////mover manualmente motor phi
			end else begin
				////////////////mover manualmente motor theta
				if(theta_actual>=(theta_manual+error)||theta_actual<=(theta_manual-error))begin 
					if(theta_actual>theta_manual) begin
						s_out_theta_pos=2'b01; end	// movimiento horario vertical
					else begin 
						s_out_theta_neg=2'b01; end	// movimiento anti-horario vertical
				end else begin 
					s_out_theta_neg=2'b00;///NO mover
					s_out_theta_pos=2'b00;///NO mover
					shift_motor=2'b01;
				end
				
				////////////////mover manualmente motor theta
			end
			//----------------------//MODO MANUAL//----------------------//
		end else begin

			//----------------------//MODO AUTOMATICO//----------------------//
			if(shift_motor==2'b00)begin

				////////////////comparador vertical
				if ((R_vertical_1>=(R_vertical_2-error) )&& (R_vertical_1<=(R_vertical_2+error)))begin
					//las resistencias son casi iguales
					s_out_theta_neg=2'b00;
					s_out_theta_pos=2'b00;
					shift_motor=2'b10;end 			
				else begin 
					if(R_vertical_1>R_vertical_2)begin
						s_out_theta_pos=2'b01; end	// movimiento horario vertical
					if(R_vertical_1<R_vertical_2)begin
						s_out_theta_neg=2'b01; end	// movimiento anti-horario vertical
				end
				////////////////comparador vertical
			end else begin		
				////////////////comparador horizontal
				if (R_horizontal_1>=(R_horizontal_2-error) && R_horizontal_1<=(R_horizontal_2+error))begin
						//las resistencias son casi iguales
						s_out_phi_pos=2'b00;
						s_out_phi_neg=2'b00;
						shift_motor=2'b00; end 
				else begin 
					if(R_horizontal_1>R_horizontal_2)begin
						s_out_phi_pos=2'b01; end	// movimiento horario  horizontal
					if(R_horizontal_1<R_horizontal_2)begin
						s_out_phi_neg=2'b01; end	// movimiento anti-horario horizontal
				end
				////////////////comparador horizontal
			end
			//----------------------//MODO MANUAL//----------------------//
		end	
	end
endmodule
