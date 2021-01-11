// -----------------------------------------------------------------------------
// File Name : inout_D.v
// Author    : Andrzej Wojciechowski (AAWO)
// Based on  : Greg Hilton - https://stackoverflow.com/questions/47820470/how-to-model-bidirectional-transport-delay
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none

module inout_D #(
   parameter INERTIAL   = 0,
   parameter TRANSPORT  = 10
)(
   inout wire a,
   inout wire b
);

wire a2b, b2a;

inoutA #(
   .INERTIAL(INERTIAL),
   .TRANSPORT(TRANSPORT))
inoutA (
   .a(a),
   .a2b(a2b)
);

inoutB #(
   .INERTIAL(INERTIAL),
   .TRANSPORT(TRANSPORT))
inoutB (
   .b(b),
   .b2a(b2a)
);

assign (weak0, weak1) a = b2a;
assign (weak0, weak1) b = a2b;

endmodule


/////////////////////////////////////////////////////////////////////////////


module inoutA #(
   parameter INERTIAL   = 0,
   parameter TRANSPORT  = 10
)(
   inout  wire a,
   output reg  a2b
);

reg [23:0] a_strength;

always @(a) begin
   $sformat(a_strength, "%v", a);
   a2b <= (a_strength[23:16] == "S") ? a : 1'bz;
end

specify
   specparam   DELAY = TRANSPORT + INERTIAL;

   (a => a2b) =  DELAY;
endspecify

endmodule


/////////////////////////////////////////////////////////////////////////////


module inoutB #(
   parameter INERTIAL   = 0,
   parameter TRANSPORT  = 10
)(
   inout  wire b,
   output reg  b2a
);

reg [23:0] b_strength;

always @(b) begin
   $sformat(b_strength, "%v", b);
   b2a <= (b_strength[23:16] == "S") ? b : 1'bz;
end

specify
   specparam   DELAY = TRANSPORT + INERTIAL;

   (b => b2a) =  DELAY;
endspecify

endmodule