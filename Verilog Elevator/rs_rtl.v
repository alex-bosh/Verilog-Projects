`timescale 1ns / 1ns
// Name: Alex Boshnakov
// Date: 11/10/21
// This file is a part of the elevator verilog project. Its purpose is to store the call values of each
// floor. This module is instantiated three times in the elevator_test module, one for each floor.

module rs_rtl (sn,rn,q,qn); // Beginning of module rs_rtl
input sn,rn; // sn and rn are the two inputs.
// The button status (pushed or released) is passed to sn
// The reset status is passed to rn
output q,qn; // q and qn are the two outputs.
assign /*#10*/ q=~(sn&qn); // Assign statement for q. This is where the call status is stored
assign /*#10*/ qn=~(rn&q); // Assign statement for qn. This variable isn't used at all in the project.
// The delays are commented out as they aren't needed in Verilog.
endmodule // End of module rs_rtl
