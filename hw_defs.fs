( Hardware port assignments )

h# FF00 constant mult_a  \ no cambiar estos tres
h# FF02 constant mult_b  \ hacen parte de otras
h# FF04 constant mult_p  \ definiciones

\ memory map multiplier:
h# 6700 constant multi_a	
h# 6702 constant multi_b
h# 6704 constant multi_init
h# 6706 constant multi_done
h# 6708 constant multi_pp_high
h# 670A constant multi_pp_low


\ memory map divider:
h# 6800 constant div_a		
h# 6802 constant div_b
h# 6804 constant div_init
h# 6806 constant div_done
h# 6808 constant div_c


\ memory map uart:
h# 6900 constant uart_busy    \ para lectura de uart (uart_busy)
h# 6902 constant uart_data    \ escritura de datos que van a la uart
h# 6904 constant led     \ led-independiente , se lo deja dentro del mapa de memoria de la uart

\ memory map control_movimiento: 
h# 7300 constant sma
h# 7302 constant RV1		
h# 7304 constant RV2
h# 7306 constant RH1
h# 7308 constant RH2
h# 730A constant theta_m
h# 730C constant theta_a
h# 730E constant phi_m
h# 7310 constant phi_a
h# 7312 constant s_out_theta_p
h# 7314 constant s_out_theta_n
h# 7316 constant s_out_phi_p
h# 7318 constant s_out_phi_n
