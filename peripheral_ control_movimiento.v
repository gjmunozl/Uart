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
reg [1:0] SS=0;
reg [15:0] RV1=0;
reg [15:0] RV2=0;
reg [15:0] RH1=0;
reg [15:0] RH2=0;
wire[1:0] s_out_theta;
wire[1:0] s_out_phi;

reg [5:0] s;
//------------------------------------ regs and wires-------------------------------





always @(*) begin//---address_decoder--------------------------
case (addr)
4'h0:begin s = (cs && wr) ? 6'b000001 : 6'b000000 ;end //SS
4'h2:begin s = (cs && wr) ? 6'b000010 : 6'b000000 ;end //RV1
4'h4:begin s = (cs && wr) ? 6'b000011 : 6'b000000 ;end //RV2
4'h6:begin s = (cs && wr) ? 6'b000100 : 6'b000000 ;end //RH1
4'h8:begin s = (cs && wr) ? 6'b000101 : 6'b000000 ;end //RH2

4'hA:begin s = (cs && rd) ? 6'b001000 : 6'b000000 ;end //s_out_theta
4'hC:begin s = (cs && rd) ? 6'b010000 : 6'b000000 ;end //s_out_phi
default:begin s = 6'b000000 ; end
endcase
end//-----------------address_decoder--------------------------








always @(negedge clk) begin//-------------------- escritura de registros 

case(s)
6'b000001 : SS = d_in;
6'b000010 : RV1 = d_in;
6'b000011 : RV2 = d_in;
6'b000100 : RH1 = d_in;
6'b000101 : RH2 = d_in;
default:begin s = 6'b000000 ;end
endcase
end//------------------------------------------- escritura de registros 


always @(negedge clk) begin//-----------------------mux_4 :   multiplexa salidas del periferico
case (s[5:3])
3'b001: d_out = s_out_theta;
3'b010: d_out = s_out_phi;
default: d_out   = 0 ;
endcase
end//-------------------------------------mux_4


control_movimiento control_movimiento(
					.s(SS),
					.clk(clk),
					.R_vertical_1(RV1),
					.R_vertical_2(RV2),
					.R_horizontal_1(RH1),
					.R_horizontal_2(RH2),
					.s_out_theta(s_out_theta),
					.s_out_phi(s_out_phi));

endmodule
