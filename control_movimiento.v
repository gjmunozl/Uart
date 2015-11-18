module control_movimiento (s,clk, R_vertical_1 , R_vertical_2 , R_horizontal_1 , R_horizontal_2 , /*theta_manual , theta_actual , phi_manual , phi_actual,*/ s_out_theta, s_out_phi);


input [1:0]s;//--------------interruptor modo manual/automatico
input clk;

input [15:0]R_vertical_1;//----------------entradas de la fotoresistencias.
input [15:0]R_vertical_2;
input [15:0]R_horizontal_1;
input [15:0]R_horizontal_2;//--------------entradas de la fotoresistencias.

/*
input [15:0]theta_manual;//--------------entradas de posición manual
input [15:0]phi_manual;//--------------entradas de posición actual	

input [15:0]phi_actual;//--------------entradas de posición manual
input [15:0]theta_actual;//--------------entradas de posición actual	
*/

output reg [1:0] s_out_theta;//--------------Salida para motores en eje teta y fi
output reg [1:0] s_out_phi;//--------------Salida para motores en eje teta y fi

//inicialización 
reg[1:0] shift_motor=2'b00;
reg[1:0] shift_R=2'b00;
reg [1:0] mover_teta;
reg [1:0] mover_fi;
reg [15:0]error=3'b101;



always @(posedge clk)begin

	////////////////MODO AUTOMATICO///////////////////////
	if(shift_motor==2'b00)begin

	////////////////comparador vertical
		if ((R_vertical_1>=(R_vertical_2-error) )&& (R_vertical_1<=(R_vertical_2+error)))begin
			mover_teta=2'b00; ////El valor de las fotoresis. estan equilibradas
			shift_motor=2'b10;
			
		end else begin 
			if(R_vertical_1>R_vertical_2)begin
				mover_teta=2'b01;  // movimiento horario  vertical				
			end
			if(R_vertical_1<R_vertical_2)begin
				mover_teta=2'b11;   // movimiento anti-horario  vertical
			end
		end 
		s_out_theta=mover_teta;
	///////////////////////////////////////

	end else begin
		///////////////comparador horizontal
		if (R_horizontal_1>=(R_horizontal_2-error) && R_horizontal_1<=(R_horizontal_2+error))begin
				mover_fi=2'b00; ////El valor de las fotoresis. estan equilibradas, el movimiento es cero.
				shift_motor=2'b00;
		end else begin 
			if(R_horizontal_1>R_horizontal_2)begin
				mover_fi=2'b01;  // movimiento horario  horizontal
			end
			if(R_horizontal_1<R_horizontal_2)begin
				mover_fi=2'b11;   // movimiento anti-horario  horizontal
			end
		end
		s_out_phi=mover_fi;
	  /////////////////////////////////////
	end
////////////////MODO AUTOMATICO///////////////////////
	
	
	end
	
		


/*


//MODOD MANUAL

always @(posedge clk)  //movimento en el eje teta o vertical
  begin
	if(init2)begin
		if(theta_actual>=(teta_d+error)||theta_actual<=(teta_d-error))
			begin s_out_theta=0;end
		else 
			begin t=theta_actual - teta_d;end
		if(t>0)
		begin d1=theta_actual-teta_d;                 
		      d2=360-theta_actual+teta_d;end
		else 
		begin d1=theta_actual+360-teta_d;
		      d2=theta_actual-teta_d;end
		if(d1>d2)
		begin s_out_theta =2'b01;end
		else
		begin s_out_theta =2'b10;end

	
	
	end

  end


always @(posedge clk)  //movimento en el eje fi o horizontal
	if(init2 && teta_d==theta_actual)begin
		if(phi_actual>=(fi_d+error)||phi_actual<=(fi_d-error)
			begin s_out_phi=0;end
		else 
			begin t2=phi_actual - fi_d;end
		if(t>0)
		begin d_1=phi_actual-fi_d;
		      d_2=fi_d-phi_actual+360;end
		else 
		begin d1=phi_actual+360-fi_d;
		      d2=fi_d+phi_actual;end
		if(d1>d2)
		begin s_out_phi =2'b01;end
		else
		begin s_out_phi =2'b10;end

	
	
	end

  end



*/


endmodule
