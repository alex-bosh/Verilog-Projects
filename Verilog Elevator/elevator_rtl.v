`timescale 1ns / 1ns
// Name: Alex Boshnakov
// Date: 11/10/21
// This file is a part of the elevator verilog project. Its purpose is to help generate an RTL
// model (Named rtl in the test module) by using FFs in an always block, and assign statements.

module elevator_rtl(CLK, D, B, P, Q, R); // Beginning of module elevator_rtl

input CLK; // A synchronous 1-bit clock named CLK is an input.
input [3:1] D, B, P; // 3-bit inputs named D, B, and P.
// D is the current state of the elevator.
// B stores the call values from each floor.
// P stores the status of each button (0 if pressed down and 1 if released).
output [3:1] Q, R; // 3-bit outputs named Q and R.
// Q is the next state of the elevator.
// R is the reset value for each floor. A 1 will reset the call.
reg [3:1] St; // A 3-bit register which stores the next state.

// Whenever the positive edge of the clock is reached, this always block is executed.
always @(posedge CLK)
	begin
	St <= Q; // The next state is assigned to the St register. No asynchronous clear function is used in this project as it is not needed.
	end

// Assign statements for the next state.
assign Q[3] = (D[3]&!D[2]&!D[1]&!B[2]&!B[1]) | (!D[3]&D[2]&D[1]&B[3]&!B[2]) | (D[3]&!D[2]&!D[1]&B[3]);
assign Q[2] = (D[3]&!D[2]&!D[1]&!B[3]&B[1]) | (D[3]&!D[2]&!D[1]&!B[3]&B[2]) | (!D[3]&!D[2]&D[1]&B[3]&!B[1]) | (!D[3]&D[2]&B[3]&B[2]&B[1]) | (!D[3]&D[2]&!D[1]&!B[3]&B[2]) | (!D[3]&D[1]&B[2]&!B[1]) | (!D[3]&D[2]&D[1]&!B[3]) | (!D[3]&D[2]&!D[1]&!B[1]);
assign Q[1] = (D[3]&!D[2]&!D[1]&!B[3]&B[1]) | (!D[3]&D[1]&!B[3]&!B[2]&!B[1]) | (D[3]&!D[2]&!D[1]&!B[3]&B[2]) | (!D[3]&D[2]&!D[1]&!B[2]&B[1]) | (!D[3]&D[2]&D[1]&B[3]&B[2]) | (!D[3]&D[2]&!D[1]&B[3]&!B[1]) | (!D[3]&D[2]&D[1]&B[2]&!B[1]) | (!D[3]&!D[2]&D[1]&B[1]);

// Assign statements for the reset values.
assign R[3] = (D[3]&!D[2]&!D[1]&B[3]&P[3]);
assign R[2] = (!D[3]&D[2]&B[3]&B[2]&B[1]&P[2]) | (!D[3]&D[2]&!D[1]&!B[3]&B[2]&P[2]) | (!D[3]&D[2]&D[1]&B[2]&!B[1]&P[2]);
assign R[1] = (!D[3]&!D[2]&D[1]&B[1]&P[1]);

endmodule // End of module elevator_rtl