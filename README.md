# FSM_lock
Need to design an FSM-based lock in Verilog. The lock opens with sequences like aabbba, aba, aaaaba, or a0bb0a.aabaa,aabbbbaa 'a' and 'b' can repeat, but after 'b', 'a' appears once to open the lock. '0' means stay in the same state. but these state aab,baa,a0ab,b0a lock not open .
Problem Statement:
Design a Finite State Machine (FSM) in Verilog that detects a specific unlock pattern based on three input signals:

a: high (1) when button A is pressed

b: high (1) when button B is pressed

zero: high (1) when no button is pressed (idle cycle)

Only one of these signals is high at any given time.

Unlock Pattern:
The FSM should unlock when the following pattern is detected in sequence:

One or more presses of A

Followed by one or more presses of B

Followed by a single press of A immediately after the B presses

The FSM should assert the output lock_open = 1 for one clock cycle only at the moment the sequence completes.

Behavior Rules:
Any invalid input (e.g., pressing A and B at the same time) should reset the FSM back to the initial state.

The FSM should remain in its current state when zero = 1 (no input).

After unlocking, the FSM should reset to the initial state and be ready to detect a new sequence.

The FSM should support multiple unlocks over time (i.e., re-enter the unlock state whenever the sequence is correctly repeated).
