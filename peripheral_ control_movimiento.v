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
//------------------------------------ regs and wires-------------------------------





always @(*) begin//---address_decoder--------------------------
case (addr)
4'h0:begin s = (cs && wr) ? 6'b000001 : 6'b000000 ;end //SS
4'h2:begin s = (cs && wr) ? 6'b000010 : 6'b000000 ;end //RV1
4'h4:begin s = (cs && wr) ? 6'b000011 : 6'b000000 ;end //RV2
4'h6:begin s = (cs && wr) ? 6'b000100 : 6'b000000 ;end //RH1
4'h8:begin s = (cs && wr) ? 6'b000101 : 6'b000000 ;end //RH2


default:begin s = 6'b000000 ; end
endcase
end//-----------------address_decoder--------------------------
endmodule
