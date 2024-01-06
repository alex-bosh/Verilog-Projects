`timescale 1ns / 1ns
// Name: Alex Boshnakov
// Date: 11/10/21
// This file is a part of elevator verilog project. It is the test or 'driver' file of the project.
// Its purpose is set everything up, create the dump file, and the output layout.


module elevator_test; // Beginning of module elevator_test

reg [3:1] B = 3'b000; // 3-bit register for the three buttons. Button 3 is the MSB, button 2 is the middle bit, and button 1 is the LSB.
reg [3:1] res = 3'b111; // 3-bit register for the reset values. If the MSB is 0, the call on floor 3 will be reset. If the middle bit is 0, the call on floor 2 will be reset. If the LSB is 0, the call on floor 1 will be reset.
reg clk = 0; // Declaration of the clock used in this project.
wire [3:1] Q, R; // 3-bit wires that store the output values from the elevator_rtl module. Q stores the next floor of the elevator and R stores the reset values.

reg [3:1] D = 3'b100; // 3-bit register for the current floor of the elevator. It will start at the 3rd floor by default.
reg [3:1] btn = 3'b111; // 3-bit register which inverts the values of B for output purposes. (B is active low in this project)

// This always block generates a clock period of 50 ns for the clk register.
always
	begin
	# 50 clk = ~clk; // Every 50 nanoseconds, the clk register inverts its value.
	end

// This always block assigns the next floor of the elevator to the current floor of the elevator.
always @ (posedge clk)
	begin
	# 50 D = Q; // 50 nanoseconds after posedge clk is reached, the next state will be assigned to the current state.
	end

// This always block assigns the inverted values of R to the res register. This is done so that it will be compatible with the RS Latches.
always @ (posedge clk)
	begin
	# 50 res = ~R; // 50 nanoseconds after posedge clk is reached, the inverted values of R will be assigned to res, which will be passed to the RS Latches.
	end
	
// This always block assigns the inverted values of B to the btn register. This is so that whenever a button is pressed, the output will show a 1. When it is released, the output will show a 0.
always @ (posedge clk)
	begin
	# 50 btn = ~B; // 50 nanoseconds after posedgle clk is reached, the inverted values of B will be assigned to btn, which is to be used for output purposes only.
	end

// The simulation block
initial
	begin
	// Every 100 nanoseconds here, an input pattern for the three buttons will be generated.
	// B[1] is the first floor button. B[2] is the second floor button. B[3] is the third floor button.
	// If any of these equal 0, that means the button has been pressed. Once it is 1, the button has been
	// released. The buttons were all pushed down initially.
	#100 B[1] = 1; B[2] = 1; B[3] = 1; // Here, all of the buttons are released at the same time.
	#100
	#100
	#100 // During this time, no buttons are pressed.
	#100
	#100
	#100
	#100
	#100 B[3] = 0; // Button 3 is pressed.
	#100
	#100
	#100
	#100
	#100 B[2] = 0; // Button 2 is pressed.
	#100 B[3] = 1; // Button 3 is released.
	#100 B[2] = 1; // Button 2 is released.
	#100
	#100 B[3] = 0; B[1] = 0; // Buttons 1 and 3 are pressed at the same time.
	#100 B[3] = 1; B[1] = 1; // Buttons 1 and 3 are released at the same time.
	#100
	#100
	#100
	#100
	#100
	#100 $finish(2); // This line marks the end of the simulation.
	end

initial
	begin
	// This section generates the verilog dump file, which will be used for gtkwave.
	$dumpfile("elevator.vcd"); // The name of the dump file to be created.
	$dumpvars(0,elevator_test); // So that the variables can be included.
	// The next 9 lines display a summary of the simulation that will be ran. Will be visible above the header.
	#5 $display("SIMULATION: Elevator starts at floor 3. All 3 buttons are pushed. Button 3 is cleared once it is released.");
	#5 $display("Elevator resets button 2 at state 010 (floor 2 going down). It resets here instead of 011 because it has to");
	#5 $display("go to floor 1 right after. The elevator then clears button 1 and waits on the 1st floor until button 3 is");
	#5 $display("pressed. It goes up to floor 3 and waits for the button to be released in order to clear it. While waiting,");
	#5 $display("button 2 is pressed. The elevator's priority is to clear button 3 first before going to floor 2. If the only");
	#5 $display("call is currently from floor 2, the elevator will clear the call on the first floor #2 state it reaches. The");
	#5 $display("call is cleared in state 011 (floor 2 going up). After this, buttons 1 and 3 are pressed at the same time.");
	#5 $display("Since the elevator is in state 011 (floor 2 going up), it will clear the button on floor 3 first before going");
	#5 $display("down to floor 1 to clear the button there. END OF SIMULATION");
	// The line below creates header labels for better readability.	
	#5 $display("                   FLOOR 1            FLOOR 2            FLOOR 3                  ELEVATOR POSITION");
	// The line below creates the header of the output, with formatting.	
	#10 $display("At time %5s  %4s  %4s  %4s  %5s  %4s  %4s  %5s  %4s  %4s  %6s  %4s  %4s  %5s %4s %4s","t","R[1]","B[1]","C[1]","R[2]","B[2]","C[2]","R[3]","B[3]","C[3]","Q[3]","Q[2]","Q[1]","Q[3]*","Q[2]*","Q[1]*");
	end


always @ (posedge clk)
	begin

	// The line below prints all signals listed when the clock becomes 1, with formatting.
	#40 $strobe("        %5t  %4b  %4b  %4b  %5b  %4b  %4b  %5b  %4b  %4b  %6b  %4b  %4b  %5b  %4b  %4b",$time,R[1],btn[1],q,R[2],btn[2],q2,R[3],btn[3],q3,D[3],D[2],D[1],Q[3],Q[2],Q[1]);
			
	end

rs_rtl floor1 (.sn(B[1]),.rn(res[1]),.q(q),.qn(qn)); // An RS Latch model. Used to hold the call for when the button on the first floor is pressed.
rs_rtl floor2 (.sn(B[2]),.rn(res[2]),.q(q2),.qn(qn2)); // An RS Latch model. Used to hold the call for when the button on the second floor is pressed.
rs_rtl floor3 (.sn(B[3]),.rn(res[3]),.q(q3),.qn(qn3)); // An RS Latch model. Used to hold the call for when the button on the third floor is pressed.

elevator_rtl rtl (CLK, D, {q3,q2,q}, B, Q, R); // RTL model of the elevator is instantiated with the name rtl.

endmodule // End of module elevator_test