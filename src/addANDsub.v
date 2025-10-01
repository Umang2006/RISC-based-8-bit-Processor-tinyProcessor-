`timescale 1ns/1ps

// Arithmetic Module (Combines ADD and SUB)
module addANDsub (
    input wire op_select,       // 0 = ADD, 1 = SUB
    input wire [7:0] operand,   // Register value
    input wire [7:0] accumulator_in, // Accumulator input
    output reg [7:0] accumulator_out, // Accumulator output
    output reg carry_borrow   // Carry/Borrow flag
);

    always @(*) begin
        if (op_select == 1'b0) begin
            // ADD operation
            {carry_borrow, accumulator_out} = accumulator_in + operand;
        end else begin
            // SUB operation
            {carry_borrow, accumulator_out} = accumulator_in - operand;
        end
    end

endmodule
