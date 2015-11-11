  
  
  module control_movimiento (s,clk,A,B,C,D , teta_d , teta_actual , fi_d , fi_actual , d1, d_1,d2,d_2,done,S_out_teta,S_out_fi);
  
  
  input s;
  input clk;
  input [15:0]A;
  input [15:0]B;
  input [15:0]C;
  input [15:0]D;
  input [15:0]teta_d;
  input [15:0]teta_actual;
  input [15:0]fi_d;
  input [15:0]fi_actual;


  output [1:0]S_out_teta;
  output [1:0]S_out_fi;


//inicialización 

   wire init=0;

   reg s=0;
   reg t=0;
   reg t1=0;

          
always @(posedge clk)  //selector entre manual y automatico
case(s) 


1'b0:begin  // Primer caso init entra a automatico


//MODO AUTOMATICO
always @(posedge clk)   //comparador variables horizontales AUTOMÁTICO
  begin
	if(init1)begin
	    if (A>=(B+error)||A<=(B-error)) 
		begin   S_out_fi=0;end	    
	    else if(A<B)
		begin    S_out_fi=2'b01;end   //movimiesto motor hacia a izquierda
	    else if(A>B)
		begin    S_out_fi=2'b10;end   //movimiesto motor hacia a derecha
       end
  end

always @(posedge clk) //comparación variables verticales AUTOMÁTICO
  begin
	if(init1)begin
	    if (C>=(D+error)||C<=(D-error) 
		begin    S_out_fi=0;end
	    else if(C<D)
		begin    S_out_teta=2'b01;end   //movimiesto motor hacia a izquierda 
	   else if(C>D )
		begin    S_out_teta=2'b10;end   //movimiesto motor hacia a derecha
	end
  end
end



2'b01:begin //entra a segundo caso init manual

//MODOD MANUAL


always @(posedge clk)  //movimento en el eje teta o vertical
  begin
	if(init2)begin
		if(teta_actual>=(teta_d+error)||teta_actual<=(teta_d-error)
			begin s_out_teta=0;end
		else 
			begin t=teta_actual - teta_d;end
		if(t>0)
		begin d1=teta_actual-teta_d;
		      d2=360-teta_actual+teta_d;end
		else 
		begin d1=teta_actual+360-teta_d;
		      d2=teta_actual-teta_d;end
		if(d1>d2)
		begin s_out_teta =2'b01;end
		else
		begin s_out_teta =2'b10;end

	
	
	end

  end


always @(posedge clk)  //movimento en el eje fi o horizontal
	if(init2 && teta_d==teta_actual)begin
		if(fi_actual>=(fi_d+error)||fi_actual<=(fi_d-error)
			begin s_out_fi=0;end
		else 
			begin t2=fi_actual - fi_d;end
		if(t>0)
		begin d_1=fi_actual-fi_d;
		      d_2=fi_d-fi_actual+360;end
		else 
		begin d1=fi_actual+360-fi_d;
		      d2=fi_d+fi_actual;end
		if(d1>d2)
		begin s_out_fi =2'b01;end
		else
		begin s_out_fi =2'b10;end

	
	
	end

  end
end





endmodule
