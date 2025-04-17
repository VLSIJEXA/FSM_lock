`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 08:45:57 PM
// Design Name: 
// Module Name: lock_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module lock_fsm (
    input clk,
    input rst,
    input [1:0] in,     // input: 00 = '0', 01 = 'a', 10 = 'b'
    output reg out
);

    parameter IDLE   = 2'b00;
    parameter GOT_A  = 2'b01;
    parameter GOT_B  = 2'b10;
    parameter UNLOCK = 2'b11;

    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 0;
        else
            out <= (next_state == UNLOCK);
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                case (in)
                    2'b01: next_state = GOT_A;  // 'a'
                    default: next_state = IDLE; // '0' or 'b'
                endcase
            end

            GOT_A: begin
                case (in)
                    2'b10: next_state = GOT_B;  // 'b'
                    2'b01: next_state = GOT_A;  // multiple 'a'
                    default: next_state = GOT_A; // '0'
                endcase
            end

            GOT_B: begin
                case (in)
                    2'b01: next_state = UNLOCK; // 'a' after 'ab'
                    2'b10: next_state = GOT_B;  // more 'b'
                    default: next_state = GOT_B;
                endcase
            end

            UNLOCK: begin
                next_state = IDLE; // back to IDLE after unlock
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
