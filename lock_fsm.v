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
    input reset,
    input a,
    input b,
    input zero,
    output reg lock_open
);

// State encoding
parameter IDLE   = 2'b00;
parameter GOT_A  = 2'b01;
parameter GOT_B  = 2'b10;
parameter UNLOCK = 2'b11;

reg [1:0] current_state, next_state;

// State register
always @(posedge clk or posedge reset) begin
    if (reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state logic
always @(*) begin
    next_state = current_state; // default: stay in current state
    
    case (current_state)
        IDLE: begin
            if (a & ~b & ~zero)
                next_state = GOT_A;
            else if ((b | (~a & ~b)) & ~zero)
                next_state = IDLE;
        end

        GOT_A: begin
            if (a & ~b & ~zero)
                next_state = GOT_A;
            else if ((b | (~a & ~b)) & ~zero)
                next_state = GOT_B;
        end

        GOT_B: begin
            if (a & ~b & ~zero)
                next_state = UNLOCK;
            else if ((b | (~a & ~b)) & ~zero)
                next_state = GOT_B;
        end

        UNLOCK: begin
            if (a & ~b & ~zero)
                next_state = GOT_A;
            else if (~zero)
                next_state = IDLE;
        end
        
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk or posedge reset) begin
    if (reset)
        lock_open <= 1'b0;
    else
        lock_open <= (current_state == GOT_B) & (a & ~b & ~zero);
end

endmodule
/////////////
