module peripheral_control_movimiento_TB;

  
  
   reg  start;  
   reg clk;
   reg rst;
   reg [15:0]d_in;
   reg cs;
   reg [3:0]addr;
   reg rd;
   reg wr;
   wire [15:0]d_out;



  peripheral_control_movimiento  uut (.clk(clk), 
				         .rst(rst), 
					 .d_in(d_in), 
					 .cs(cs), 
					 .addr(addr), 
					 .rd(rd), 
					 .wr(wr), 
					 .d_out(d_out));

//inicialización 


parameter PERIOD          = 20;
parameter real DUTY_CYCLE = 0.5;
parameter OFFSET          = 0;
reg [20:0] i;
event reset_trigger;


   initial begin  // Initialize Inputs
      clk = 0; rst = 1; start=0; d_in = 16'd0000; addr = 16'h7300; cs=1; rd=0; wr=1; 
   end


 initial  begin  // Process for clk
     #OFFSET;
     forever
       begin
         clk = 1'b0;
         #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
         #(PERIOD*DUTY_CYCLE);
       end
   end


////////////////////////////////////////////////////////////////////////////////7
    initial begin // Reset the system, Start the image capture process
      forever begin 
        @ (reset_trigger);
        @ (posedge clk);
        start = 0;
        @ (posedge clk);
        start = 1;

       for(i=0; i<2; i=i+1) begin
         @ (posedge clk);
       end
          start = 0;				// stimulus here


 for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
	d_in = 16'd0;		//SS
	addr = 16'h7300;
	cs=1; rd=0; wr=1;



       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
	d_in = 16'd0024;	//RV1
	addr = 16'h7302;
	cs=1; rd=0; wr=1;


       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0015;	//RV2
	addr = 16'h7304;
	cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0011;	//RH1
	addr = 16'h7306;
	cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0010;	//RH2
	addr = 16'h7308;
	cs=1; rd=0; wr=1;


for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0010;	//thetha m
	addr = 16'h730A;
	cs=1; rd=0; wr=1;



for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0016;	//thetha a
	addr = 16'h730C;
	cs=1; rd=0; wr=1;


for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0015;	//PHI_M
	addr = 16'h730E;
	cs=1; rd=0; wr=1;


for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0010;	//PHI_A
	addr = 16'h7310;
	cs=1; rd=0; wr=1;



      end
   end
	
///////////////////////////////////////////////////////////////////////////////////////

   initial begin: TEST_CASE
     $dumpfile("peripheral_control_movimiento_TB.vcd");
    $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*200) $finish;
   end

endmodule
