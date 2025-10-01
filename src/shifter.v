`timescale 1ns/1ps

// Shift/Rotate Module
module shifter (
    input wire [7:0] accumulator_in,
    input wire [3:0] shift_op,
    output reg [7:0] accumulator_out
);

    always @(*) begin
        case (shift_op)
            4'b0001: accumulator_out = accumulator_in << 1;                   // LSL
            4'b0010: accumulator_out = accumulator_in >> 1;                   // LSR
            4'b0011: accumulator_out = {accumulator_in[0], accumulator_in[7:1]}; // CIR
            4'b0100: accumulator_out = {accumulator_in[6:0], accumulator_in[7]}; // CIL
            4'b0101: accumulator_out = {accumulator_in[7], accumulator_in[7:1]}; // ASR
            default: accumulator_out = accumulator_in; // No operation
        endcase
    end

endmodule
