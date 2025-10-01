`timescale 1ns/1ps

// Logical Operations Module
module logicalop (
    input wire [7:0] acc_in,
    input wire [7:0] reg_val,
    input wire [1:0] logic_op,
    output reg [7:0] acc_out,
    output reg cmp_flag
);

    always @(*) begin
        acc_out = acc_in; // Default
        cmp_flag = 0;     // Default

        case (logic_op)
            2'b00: acc_out = acc_in & reg_val;              // AND
            2'b01: acc_out = acc_in ^ reg_val;              // XOR
            2'b10: cmp_flag = (acc_in < reg_val) ? 1'b1: 1'b0; // CMP
            default:; // No operation
        endcase
    end

endmodule
