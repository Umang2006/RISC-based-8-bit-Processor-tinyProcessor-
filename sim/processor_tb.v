`timescale 1ns / 1ps

module processor_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [7:0] opcode;

    // Outputs
    wire [3:0] program_counter;
    wire [7:0] ACC;
    wire [7:0] EXT;
    wire CorB;

    // Instantiate the Unit Under Test (UUT)
    processor uut (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .program_counter(program_counter),
        .ACC(ACC),
        .EXT(EXT),
        .CorB(CorB)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize Inputs
        reset = 1;
        opcode = 8'b00000000; // NOP
        #20;
        reset = 0;

        // Test 1: Basic Arithmetic Operations
        $display("\nTest 1: Basic Arithmetic Operations");
        opcode = 8'b10010001; // MOV ACC, R1 (R1=8'h34)
        #10;
        opcode = 8'b00010101; // ADD R5 (R5=8'hBC)
        #10;
        opcode = 8'b00100010; // SUB R2 (R2=8'h56)
        #10;

        // Test 2: Multiplication
        $display("\nTest 2: Multiplication");
        opcode = 8'b10010011; // MOV ACC, R3 (R3=8'h78)
        #10;
        opcode = 8'b00110100; // MUL R4 (R4=8'h9A)
        #10;

        // Test 3: Shift Operations
        $display("\nTest 3: Shift Operations");
        opcode = 8'b10010110; // MOV ACC, R6 (R6=8'hDE)
        #10;
        opcode = 8'b00000001; // LSL
        #10;
        opcode = 8'b00000010; // LSR
        #10;
        opcode = 8'b00000101; // ASR
        #10;

        // Test 4: Logical Operations
        $display("\nTest 4: Logical Operations");
        opcode = 8'b10010111; // MOV ACC, R7 (R7=8'hF0)
        #10;
        opcode = 8'b01011000; // AND R8 (R8=8'h01)
        #10;
        opcode = 8'b01101001; // XRA R9 (R9=8'h23)
        #10;

        // Test 5: Comparison and Branching
        $display("\nTest 5: Comparison and Branching");
        opcode = 8'b10011010; // MOV ACC, R10 (R10=8'h45)
        #10;
        opcode = 8'b01111011; // CMP R11 (R11=8'h67)
        #10;
        opcode = 8'b10000010; // Br to address 2
        #10;

        // Test 6: Move Operations
        $display("\nTest 6: Move Operations");
        opcode = 8'b10011100; // MOV ACC, R12 (R12=8'h89)
        #10;
        opcode = 8'b10101101; // MOV R13, ACC
        #10;
        
        // Test 7: Increment/Decrement
        $display("\nTest 7: Increment/Decrement");
        opcode = 8'b00000110; // INC
        #10;
        opcode = 8'b00000111; // DEC
        #10;

        // Test 8: Halt Instruction
        $display("\nTest 8: Halt Instruction");
        opcode = 8'b11111111; // HLT
        #10;
        // Check if PC stops incrementing
        #10; 

        $display("\nAll tests completed at time %0t", $time);
        $finish;
    end

    // Monitor changes for debugging
    initial begin
        $monitor("Time=%0t: PC=%d, Opcode=%b, ACC=%h, EXT=%h, C/B=%b",
                 $time, program_counter, opcode, ACC, EXT, CorB);
    end

endmodule
