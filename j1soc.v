module j1soc#(
              //parameter   bootram_file     = "../../firmware/hello_world/j1.mem"    // For synthesis            
              parameter   bootram_file     = "../firmware/Hello_World/j1.mem"       // For simulation         
  )(
   uart_tx, ledout,
   sys_clk_i, sys_rst_i
   );

   input sys_clk_i, sys_rst_i;//
   output uart_tx;
   output ledout;


//------------------------------------ regs and wires-------------------------------cables de coneccion entre j1 y todos los perofericos 

   wire                 j1_io_rd;//********************** J1
   wire                 j1_io_wr;//********************** J1
   wire                 [15:0] j1_io_addr;//************* J1
   reg                  [15:0] j1_io_din;//************** J1
   wire                 [15:0] j1_io_dout;//************* J1


 
   reg [1:5]cs;  // CHIP-SELECT

   wire			[15:0] mult_dout;  
   wire			[15:0] div_dout;
   wire			uart_dout;	// misma señal que uart_busy from uart.v
   wire			[15:0] dp_ram_dout;
   wire    		[15:0] control_mov_dout;

//------------------------------------ regs and wires-------------------------------


  j1 #(bootram_file)  cpu0(sys_clk_i, sys_rst_i, j1_io_din, j1_io_rd, j1_io_wr, j1_io_addr, j1_io_dout);

  peripheral_mult  per_m (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[1]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(mult_dout) );

  peripheral_div  per_d (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[2]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(div_dout));

  peripheral_uart  per_u (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[3]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(uart_dout), .uart_tx(uart_tx), .ledout(ledout));


  dpRAM_interface dpRm(.clk(sys_clk_i), .d_in(j1_io_dout), .cs(cs[4]), .addr(j1_io_addr[7:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(dp_ram_dout));


 peripheral_control_movimiento per_cm (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[5]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(control_mov_dout));

  // ============== Chip_Select (Addres decoder) ========================  // se hace con los 8 bits mas significativos de j1_io_addr
  always @*
  begin
      case (j1_io_addr[15:8])	// direcciones - chip_select
//       8'h67: cd= 5'b10000;
        8'h67: cs= 4'b1000; 		//mult
        8'h68: cs= 4'b0100;		//div
        8'h69: cs= 4'b0010;		//uart
        8'h70: cs= 4'b0001;		//spi no se sabe me imagin que Nicolas
        8'h71: cs= 4'b0001;		// puede ser  i2c oscar
        8'h72: cs= 4'b0001;		// puede ser manuel
        8'h73: cs= 5'b10000;		//Control de motores
        default: cs= 3'b000;
      endcase
  end
  // ============== Chip_Select (Addres decoder) ========================  //




  // ============== MUX ========================  // se encarga de lecturas del J1
  always @*
  begin
      case (cs)
        4'b1000: j1_io_din = mult_dout;
        4'b0100: j1_io_din = div_dout;
        4'b0010: j1_io_din = uart_dout; 
        4'b0001: j1_io_din = dp_ram_dout; 
        5'b10000: j1_io_din = control_mov_dout; 
        default: j1_io_din = 16'h0666;
      endcase
  end
 // ============== MUX ========================  // 

endmodule // top
