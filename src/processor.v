`timescale 1ns/1ps

module processor(
    input wire clk,
    input wire reset,
    input wire [7:0] opcode,
    output reg [3:0] program_counter,
    output reg [7:0] ACC,
    output reg [7:0] EXT,
    output reg CorB
);

    // Register file with 16 registers, each 8-bit
    reg [7:0] register [0:15];

    // Initialize registers
    initial begin
        register[0] = 8'h12;
        register[1] = 8'h34;
        register[2] = 8'h56;
        register[3] = 8'h78;
        register[4] = 8'h9A;
        register[5] = 8'hBC;
        register[6] = 8'hDE;
        register[7] = 8'hF0;
        register[8] = 8'h01;
        register[9] = 8'h23;
        register[10] = 8'h45;
        register[11] = 8'h67;
        register[12] = 8'h89;
        register[13] = 8'hAB;
        register[14] = 8'hCD;
        register[15] = 8'hEF;
    end

    // Control signal generation
    wire add_sub_op = (opcode[7:4] == 4'b0010); // 1 for SUB, 0 for ADD
    wire [1:0] logic_op_sel = (opcode[7:4] == 4'b0101) ? 2'b00 :
                              (opcode[7:4] == 4'b0110) ? 2'b01 :
                              (opcode[7:4] == 4'b0111) ? 2'b10 : 2'b00;

    // Module instantiations
    wire [7:0] addsub_out;
    wire addsub_cb;
    addANDsub addsub_module(
        .op_select(add_sub_op),
        .operand(register[opcode[3:0]]),
        .accumulator_in(ACC),
        .accumulator_out(addsub_out),
        .carry_borrow(addsub_cb)
    );

    wire [7:0] shift_out;
    shifter shift_module(
        .accumulator_in(ACC),
        .shift_op(opcode[3:0]),
        .accumulator_out(shift_out)
    );

    wire [7:0] logic_out;
    wire logic_cmp;
    logicalop logic_module(
        .acc_in(ACC),
        .reg_val(register[opcode[3:0]]),
        .logic_op(logic_op_sel),
        .acc_out(logic_out),
        .cmp_flag(logic_cmp)
    );

    // Main processor FSM (Finite State Machine)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            program_counter <= 4'b0000;
            ACC <= 8'b00000000;
            EXT <= 8'b00000000;
            CorB <= 1'b0;
        end else begin
            // Increment PC by default
            program_counter <= program_counter + 1;

            // Decode and execute instruction
            case (opcode[7:4])
                4'b0000: begin // NOP and shift operations
                    case (opcode[3:0])
                        4'b0000:; // NOP
                        4'b0001: ACC <= shift_out; // LSL
                        4'b0010: ACC <= shift_out; // LSR
                        4'b0011: ACC <= shift_out; // CIR
                        4'b0100: ACC <= shift_out; // CIL
                        4'b0101: ACC <= shift_out; // ASR
                        4'b0110: {CorB, ACC} <= ACC + 1; // INC
                        4'b0111: {CorB, ACC} <= ACC - 1; // DEC
                        default:;
                    endcase
                end
                4'b0001: begin // ADD
                    ACC <= addsub_out;
                    CorB <= addsub_cb;
                end
                4'b0010: begin // SUB
                    ACC <= addsub_out;
                    CorB <= addsub_cb;
                end
                4'b0011: {EXT, ACC} <= ACC * register[opcode[3:0]]; // MUL
                4'b0101: ACC <= logic_out; // AND
                4'b0110: ACC <= logic_out; // XRA (XOR)
                4'b0111: CorB <= logic_cmp; // CMP
                4'b1000: begin // Branch if C/B=1
                    if (CorB) begin
                        program_counter <= opcode[3:0];
                    end
                end
                4'b1001: ACC <= register[opcode[3:0]]; // MOV ACC, Ri
                4'b1010: register[opcode[3:0]] <= ACC; // MOV Ri, ACC
                4'b1011: program_counter <= opcode[3:0]; // Return (jump)
                4'b1111: begin // HLT
                    if (opcode[3:0] == 4'b1111) begin
                        program_counter <= program_counter; // Halt PC
                    end
                end
                default:; // Invalid opcode
            endcase
        end
    end

endmodule
