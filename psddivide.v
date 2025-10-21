//-----
//  FEUP / M.EEC - Digital Systems Design 2024/2025
//
// Your names:
//    Tweety the Bird
//    Silvester the Cat
//
//-----

module psddivide
   (
	input             clock,		//master clock
	input             reset,		//synch reset, active high
	input             start,		//start a new division
	input             stop,			//load output registers
	input      [31:0] dividend,		// dividend
	input      [31:0] divisor,		// divisor
	output reg [31:0] quotient,		// quotient
	output reg [31:0] rest			// rest
	); 

// ADD YOUR CODE HERE
reg [31:0] rdivisor;
reg [63:0] rdiv;



wire[32:0] mux1_output;
wire[32:0] mux3_output;
wire[30:0] mux2_output;
wire[32:0] prest;

always @(posedge clock)		//rdivisor register
begin

if(reset)
  rdivisor <= 32'b0;
else if(start)
 rdivisor <= divisor[31:0];

end

always @(posedge clock)		//rdiv register
begin
if(reset)
rdiv <= 64'b0;
else 
rdiv[63:31] <= mux1_output[32:0];
rdiv[30:0] <= mux2_output[30:0];
end




assign prest = rdiv[63:31] - {1'b0, rdivisor[31:0]};			





assign mux3_output = (prest[32]==1) ?rdiv[62:30]:({prest[31:0],rdiv[30]});			//mux 3
assign mux1_output = (start==1) ?({32'd0, dividend[31]}):mux3_output;			//mux 1
assign mux2_output = (start==1) ?dividend[30:0]:({rdiv[29:0],~prest[32]});		//mux 2

always @(posedge clock)				//rest register
begin
if(reset)
 rest <= 32'b0;
 else if(stop)
 rest<= rdiv[63:32];

end


always @(posedge clock)				//quotient register
begin
if(reset)
 quotient <= 32'b0;
 else if(stop)
 quotient<= rdiv[31:0];

end




endmodule
