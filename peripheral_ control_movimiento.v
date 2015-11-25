module peripheral_control_movimiento(clk , rst , d_in , cs , addr , rd , wr, d_out );

  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0]d_out;


//------------------------------------ regs and wires-------------------------------
reg [1:0] sma=0;
reg [15:0] RV1=0;
reg [15:0] RV2=0;
reg [15:0] RH1=0;
reg [15:0] RH2=0;
reg [15:0] tetha_m=0;
reg [15:0] tetha_a=0;
reg [15:0] phi_m=0;
reg [15:0] phi_a=0;
wire[1:0] s_out_theta_p;
wire[1:0] s_out_phi_p;
wire[1:0] s_out_theta_n;
wire[1:0] s_out_phi_n;

reg [5:0] s;
//------------------------------------ regs and wires-------------------------------





always @(*) begin//---address_decoder--------------------------
case (addr)
4'h0:begin s = (cs && wr) ? 6'b000001 : 6'b000000 ;end //SS
4'h2:begin s = (cs && wr) ? 6'b000010 : 6'b000000 ;end //RV1
4'h4:begin s = (cs && wr) ? 6'b000011 : 6'b000000 ;end //RV2
4'h6:begin s = (cs && wr) ? 6'b000100 : 6'b000000 ;end //RH1
4'h8:begin s = (cs && wr) ? 6'b000101 : 6'b000000 ;end //RH2
4'hA:begin s = (cs && wr) ? 6'b000110 : 6'b000000 ;end //theta_m
4'hC:begin s = (cs && wr) ? 6'b000111 : 6'b000000 ;end //theta_a
4'hE:begin s = (cs && wr) ? 6'b001000 : 6'b000000 ;end //phi_m
4'h10:begin s = (cs && wr) ? 6'b001001 : 6'b000000 ;end //phi_a


4'h12:begin s = (cs && rd) ? 6'b001010 : 6'b000000 ;end //s_out_theta_p
4'h16:begin s = (cs && rd) ? 6'b001011 : 6'b000000 ;end //s_out_theta_n
4'h14:begin s = (cs && rd) ? 6'b001100 : 6'b000000 ;end //s_out_phi_p
4'h18:begin s = (cs && rd) ? 6'b001101 : 6'b000000 ;end //s_out_phi_n
default:begin s = 6'b000000 ; end
endcase
end//-----------------address_decoder--------------------------








always @(negedge clk) begin//-------------------- escritura de registros 
sma = (s == 6'b000001) ? d_in : sma;
RV1 = (s == 6'b000010) ? d_in : RV1;
RV2 = (s == 6'b000011 ) ? d_in : RV2;
RH1 = (s == 6'b000100 ) ? d_in : RH1;
RH2 = (s == 6'b000101  ) ? d_in : RH2;
theta_m = (s == 6'b000110 ) ? d_in : theta_m;
theta_a = (s == 6'b000111 ) ? d_in : theta_a;
phi_m = (s == 6'b001000 ) ? d_in : phi_m;
phi_a = (s == 6'b001001 ) ? d_in : phi_a;
end//------------------------------------------- escritura de registros 


always @(negedge clk) begin//-----------------------mux_4 :   multiplexa salidas del periferico
case (s)
6'b001010 : d_out = s_out_theta_p;
6'b001011 : d_out = s_out_theta_n;
6'b001100 : d_out = s_out_phi_p;
6'b001101 : d_out = s_out_phi_n;;
default: d_out   = 0 ;
endcase
end//-------------------------------------mux_4


control_movimiento control_movimiento(
					.s(sma),
					.clk(clk),
					.R_vertical_1(RV1),
					.R_vertical_2(RV2),
					.R_horizontal_1(RH1),
					.R_horizontal_2(RH2),
					.theta_actual(theta_a),
					.theta_manual(theta_m),
					.phi_manual(phi_m),
					.phi_actual(phi_a),
					.s_out_theta_pos(s_out_theta_p),
					.s_out_theta_neg(s_out_theta_n),					
					.s_out_phi_pos(s_out_phi_p),
					.s_out_phi_neg(s_out_phi_n));

endmodule
