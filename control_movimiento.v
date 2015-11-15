  
  
 
module control_movimiento (s,clk, R_vertical_1, R_vertical_2, R_horizontal_1, R_horizontal_2, teta_manual, teta_actual, fi_manual, fi_actual, s_out_teta, s_out_fi);


	 
	input clk;

	////////////////////entradas de la fotoresistencias.
	input [15:0]R_vertical_1;
	input [15:0]R_vertical_2;
	input [15:0]R_horizontal_1;
	input [15:0]R_horizontal_2;

	///////////////////entradas de posicion manual
	input [15:0]teta_manual;
	input [15:0]fi_manual;
	input s;		//interruptor modo manual/automatico

	///////////////////entradas de posicion actual	
	input [15:0]fi_actual;
	input [15:0]teta_actual;
	
	//////////////////Salida para motores en eje teta y fi
	output [1:0]s_out_teta;
	output [1:0]s_out_fi;

	//inicializacion 
	reg[2:0] shift_motor;
	reg[1:0] mover;
	reg error=1;
	
	always @(posedge clk)begin
		
		////////////////////comparador resistencias vertical
		
		if ((R_vertical_1>=(R_vertical_2-error)) && (R_vertical_1<=(R_vertical_1+error)))begin
			mover=2'b00; ////El valor de las fotoresis. estan equilibradas, el movimiento es cero.
		end else begin 
			if(R_vertical_1>R_vertical_2)begin
				mover=2'b01;  // movimiento horario  vertical
			end
			if(R_vertical_1<R_vertical_2)begin
				mover=2'b11;   // movimiento anti-horario  vertical
			end
		end
		////////////////////comparador resistencias vertical
		
		
		
		////////////////////comparador resistencias horizontal
		if (R_horizontal_1>=(R_horizontal_2-error) && R_horizontal_1<=(R_horizontal_1+error))begin
			mover=2'b00; ////El valor de las fotoresis. estan equilibradas, el movimiento es cero.
		end else begin 
			if(R_horizontal_1>R_horizontal_2)begin
				mover=2'b01;  // movimiento horario  horizontal
			end
			if(R_horizontal_1<R_horizontal_2)begin
				mover=2'b11;   // movimiento anti-horario  horizontal
			end
		end		
		////////////////////comparador resistencias horizontal
	end
