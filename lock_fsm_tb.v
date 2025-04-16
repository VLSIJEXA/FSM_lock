`timescale 1ns/1ps

module lock_fsm_tb();

// Inputs
reg clk;
reg reset;
reg a;
reg b;
reg zero;

// Output
wire lock_open;

// Instantiate the Unit Under Test (UUT)
lock_fsm uut (
    .clk(clk),
    .reset(reset),
    .a(a),
    .b(b),
    .zero(zero),
    .lock_open(lock_open)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// State names for display
task display_state;
    input [1:0] state;
    begin
        case (state)
            2'b00: $write("IDLE");
            2'b01: $write("GOT_A");
            2'b10: $write("GOT_B");
            2'b11: $write("UNLOCK");
            default: $write("UNKNOWN");
        endcase
    end
endtask

// Test procedure
initial begin
    // Initialize Inputs
    reset = 1;
    a = 0;
    b = 0;
    zero = 0;
    
    // Wait for global reset
    #20;
    reset = 0;
    
    // Test case 1: aaabaaa
    $display("\nTest case 1: aaabaaa");
    a = 1; b = 0; zero = 0; #10; // a
    a = 1; b = 0; zero = 0; #10; // a
    a = 1; b = 0; zero = 0; #10; // a
    a = 0; b = 1; zero = 0; #10; // b
    a = 1; b = 0; zero = 0; #10; // a (should unlock)
    a = 1; b = 0; zero = 0; #10; // a
    a = 1; b = 0; zero = 0; #10; // a
    
    // Test case 2: aba
    $display("\nTest case 2: aba");
    a = 1; b = 0; zero = 0; #10; // a
    a = 0; b = 1; zero = 0; #10; // b
    a = 1; b = 0; zero = 0; #10; // a (should unlock)
    
    // Test case 3: abbba
    $display("\nTest case 3: abbba");
    a = 1; b = 0; zero = 0; #10; // a
    a = 0; b = 1; zero = 0; #10; // b
    a = 0; b = 1; zero = 0; #10; // b
    a = 0; b = 1; zero = 0; #10; // b
    a = 1; b = 0; zero = 0; #10; // a (should unlock)
    
    // Test case 4: abaa
    $display("\nTest case 4: abaa");
    a = 1; b = 0; zero = 0; #10; // a
    a = 0; b = 1; zero = 0; #10; // b
    a = 1; b = 0; zero = 0; #10; // a (should unlock)
    a = 1; b = 0; zero = 0; #10; // a
    
    // Test case 5: ba
    $display("\nTest case 5: ba");
    a = 0; b = 1; zero = 0; #10; // b
    a = 1; b = 0; zero = 0; #10; // a
    
    // Test case 6: aab
    $display("\nTest case 6: aab");
    a = 1; b = 0; zero = 0; #10; // a
    a = 1; b = 0; zero = 0; #10; // a
    a = 0; b = 1; zero = 0; #10; // b
    
    // Test case 7: aab0a
    $display("\nTest case 7: aab0a");
    a = 1; b = 0; zero = 0; #10; // a
    a = 1; b = 0; zero = 0; #10; // a
    a = 0; b = 1; zero = 0; #10; // b
    a = 0; b = 0; zero = 1; #10; // 0 (hold)
    a = 1; b = 0; zero = 0; #10; // a (should unlock)
    
    // Finish simulation
    #20;
    $display("\nAll test cases completed");
    $finish;
end

// Monitor results
always @(posedge clk) begin
    $write("Time=%0t: a=%b, b=%b, zero=%b | State=", $time, a, b, zero);
    display_state(uut.current_state);
    $display(", lock_open=%b", lock_open);
end

endmodule
////////////////////////
output

000ns
Time=5000: a=0, b=0, zero=0 | State=IDLE, lock_open=0
Time=15000: a=0, b=0, zero=0 | State=IDLE, lock_open=0

Test case 1: aaabaaa
Time=25000: a=1, b=0, zero=0 | State=IDLE, lock_open=0
Time=35000: a=1, b=0, zero=0 | State=GOT_A, lock_open=0
Time=45000: a=1, b=0, zero=0 | State=GOT_A, lock_open=0
Time=55000: a=0, b=1, zero=0 | State=GOT_A, lock_open=0
Time=65000: a=1, b=0, zero=0 | State=GOT_B, lock_open=0
Time=75000: a=1, b=0, zero=0 | State=UNLOCK, lock_open=1
Time=85000: a=1, b=0, zero=0 | State=GOT_A, lock_open=0

Test case 2: aba
Time=95000: a=1, b=0, zero=0 | State=GOT_A, lock_open=0
Time=105000: a=0, b=1, zero=0 | State=GOT_A, lock_open=0
Time=115000: a=1, b=0, zero=0 | State=GOT_B, lock_open=0

Test case 3: abbba
Time=125000: a=1, b=0, zero=0 | State=UNLOCK, lock_open=1
Time=135000: a=0, b=1, zero=0 | State=GOT_A, lock_open=0
Time=145000: a=0, b=1, zero=0 | State=GOT_B, lock_open=0
Time=155000: a=0, b=1, zero=0 | State=GOT_B, lock_open=0
Time=165000: a=1, b=0, zero=0 | State=GOT_B, lock_open=0

Test case 4: abaa
Time=175000: a=1, b=0, zero=0 | State=UNLOCK, lock_open=1
Time=185000: a=0, b=1, zero=0 | State=GOT_A, lock_open=0
Time=195000: a=1, b=0, zero=0 | State=GOT_B, lock_open=0
Time=205000: a=1, b=0, zero=0 | State=UNLOCK, lock_open=1

Test case 5: ba
Time=215000: a=0, b=1, zero=0 | State=GOT_A, lock_open=0
Time=225000: a=1, b=0, zero=0 | State=GOT_B, lock_open=0

Test case 6: aab
Time=235000: a=1, b=0, zero=0 | State=UNLOCK, lock_open=1
Time=245000: a=1, b=0, zero=0 | State=GOT_A, lock_open=0
Time=255000: a=0, b=1, zero=0 | State=GOT_A, lock_open=0

Test case 7: aab0a
Time=265000: a=1, b=0, zero=0 | State=GOT_B, lock_open=0
Time=275000: a=1, b=0, zero=0 | State=UNLOCK, lock_open=1
Time=285000: a=0, b=1, zero=0 | State=GOT_A, lock_open=0
Time=295000: a=0, b=0, zero=1 | State=GOT_B, lock_open=0
Time=305000: a=1, b=0, zero=0 | State=GOT_B, lock_open=0
Time=315000: a=1, b=0, zero=0 | State=UNLOCK, lock_open=1
Time=325000: a=1, b=0, zero=0 | State=GOT_A, lock_open=0
