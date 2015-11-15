  
module control_movimiento (s,clk, R_vertical_1 , R_vertical_2 , R_horizontal_1 , R_horizontal_2 , teta_manual , teta_actual , fi_manual , fi_actual, s_out_teta, s_out_fi);
  
  
	input [1:0]s; //////////interruptor modo manual/automatico
	input clk;
	////////////////////entradas de la fotoresistencias.
	input [15:0]R_vertical_1;
	input [15:0]R_vertical_2;
	input [15:0]R_horizontal_1;
	input [15:0]R_horizontal_2;
	///////////////////entradas de posición manual
	input [15:0]teta_manual;
	input [15:0]fi_manual;
	///////////////////entradas de posición actual	
	input [15:0]fi_actual;
	input [15:0]teta_actual;
	
	//////////////////Salida para motores en eje teta y fi
	output reg [1:0] s_out_teta;
	output reg [1:0] s_out_fi;

	//inicialización 
	reg[1:0] shift_motor=2'b00;
	reg[1:0] shift_R=2'b00;
	reg [1:0] mover=2'b00;
	reg [15:0]error=0000000000000101;
	
	
	
	always @(posedge clk)begin

		////////////////MODO AUTOMATICO///////////////////////
		if(shift_R==2'b00)begin

		////////////////comparador vertical
			if ((R_vertical_1>=(R_vertical_2-error) )&& (R_vertical_1<=(R_vertical_2+error)))begin
				mover=2'b00; ////El valor de las fotoresis. estan equilibradas
				shift_R=2'b10;
				shift_motor=2'b10;
			end else begin 
				if(R_vertical_1>R_vertical_2)begin
					mover=2'b10;  // movimiento horario  vertical				
				end
				if(R_vertical_1<R_vertical_2)begin
					mover=2'b11;   // movimiento anti-horario  vertical
				end
			end		

		///////////////////////////////////////

		end else begin
			///////////////comparador horizontal
			if (R_horizontal_1>=(R_horizontal_2-error) && R_horizontal_1<=(R_horizontal_1+error))begin
					mover=2'b00; ////El valor de las fotoresis. estan equilibradas, el movimiento es cero.
					shift_R=2'b00;
					shift_motor=2'b00;
			end else begin 
				if(R_horizontal_1>R_horizontal_2)begin
					mover=2'b01;  // movimiento horario  horizontal
				end
				if(R_horizontal_1<R_horizontal_2)begin
					mover=2'b10;   // movimiento anti-horario  horizontal
				end
			end
	
		  /////////////////////////////////////
		end
	////////////////MODO AUTOMATICO///////////////////////
		case(shift_motor)
			2'b00: begin s_out_teta=mover; end
			2'b10: begin s_out_fi=mover; end
			default: begin mover=2'b00; end		
		endcase
	end
	
		
endmodule

