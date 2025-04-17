`timescale 1ns / 1ps
module tb_lock_fsm;
    reg clk, rst;
    reg [1:0] in;
    wire out;

    lock_fsm uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Task to apply input and display result
    task apply_input;
        input [1:0] val;
        input [31:0] t;
        begin
            in = val;
            #10;
            $display("Time=%0d | in=%b | out=%b", t, val, out);
        end
    endtask

    initial begin
        $display("=== Test case 1: aaabaaa ===");
        rst = 1; in = 2'b00; #10; rst = 0;
        apply_input(2'b01, 20000); // a
        apply_input(2'b01, 30000); // a
        apply_input(2'b01, 40000); // a
        apply_input(2'b10, 50000); // b
        apply_input(2'b01, 60000); // a -> unlock
        apply_input(2'b01, 70000); // a
        apply_input(2'b01, 80000); // a

        $display("\n=== Test case 2: aba ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b01, 90000);  // a
        apply_input(2'b10, 100000); // b
        apply_input(2'b01, 110000); // a -> unlock

        $display("\n=== Test case 3: abbba ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b01, 120000); // a
        apply_input(2'b10, 130000); // b
        apply_input(2'b10, 140000); // b
        apply_input(2'b10, 150000); // b
        apply_input(2'b01, 160000); // a -> unlock

        $display("\n=== Test case 4: abaa ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b01, 170000); // a
        apply_input(2'b10, 180000); // b
        apply_input(2'b01, 190000); // a -> unlock
        apply_input(2'b01, 200000); // a

        $display("\n=== Test case 5: ba ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b10, 210000); // b (invalid start)
        apply_input(2'b01, 220000); // a (should NOT unlock)

        $display("\n=== Test case 6: aab ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b01, 230000); // a
        apply_input(2'b01, 240000); // a
        apply_input(2'b10, 250000); // b (no unlock yet)

        $display("\n=== Test case 7: aab0a ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b01, 260000); // a
        apply_input(2'b01, 270000); // a
        apply_input(2'b10, 280000); // b
        apply_input(2'b00, 290000); // 0
        apply_input(2'b01, 300000); // a -> unlock

        $display("\n=== Test case 8: aaabbbbaa ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b01, 310000); // a
        apply_input(2'b01, 320000); // a
        apply_input(2'b01, 330000); // a
        apply_input(2'b10, 340000); // b
        apply_input(2'b10, 350000); // b
        apply_input(2'b10, 360000); // b
        apply_input(2'b10, 370000); // b
        apply_input(2'b01, 380000); // a -> unlock
        apply_input(2'b01, 390000); // a

        $display("\n=== Test case 9: 0a0b0a0 ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b00, 400000); // 0
        apply_input(2'b01, 410000); // a
        apply_input(2'b00, 420000); // 0
        apply_input(2'b10, 430000); // b
        apply_input(2'b00, 440000); // 0
        apply_input(2'b01, 450000); // a -> unlock
        apply_input(2'b00, 460000); // 0

        $display("\n=== Test case 10: bba ===");
        rst = 1; #10; rst = 0;
        apply_input(2'b10, 470000); // b
        apply_input(2'b10, 480000); // b
        apply_input(2'b01, 490000); // a (should NOT unlock)

        $finish;
    end

endmodule

////////////////////////
output

=== Test case 1: aaabaaa ===
Time=20000 | in=01 | out=0
Time=30000 | in=01 | out=0
Time=40000 | in=01 | out=0
Time=50000 | in=10 | out=0
Time=60000 | in=01 | out=1
Time=70000 | in=01 | out=0
Time=80000 | in=01 | out=0

=== Test case 2: aba ===
Time=90000 | in=01 | out=0
Time=100000 | in=10 | out=0
Time=110000 | in=01 | out=1

=== Test case 3: abbba ===
Time=120000 | in=01 | out=0
Time=130000 | in=10 | out=0
Time=140000 | in=10 | out=0
Time=150000 | in=10 | out=0
Time=160000 | in=01 | out=1

=== Test case 4: abaa ===
Time=170000 | in=01 | out=0
Time=180000 | in=10 | out=0
Time=190000 | in=01 | out=1
Time=200000 | in=01 | out=0

=== Test case 5: ba ===
Time=210000 | in=10 | out=0
Time=220000 | in=01 | out=0

=== Test case 6: aab ===
Time=230000 | in=01 | out=0
Time=240000 | in=01 | out=0
Time=250000 | in=10 | out=0

=== Test case 7: aab0a ===
Time=260000 | in=01 | out=0
Time=270000 | in=01 | out=0
Time=280000 | in=10 | out=0
Time=290000 | in=00 | out=0
Time=300000 | in=01 | out=1

=== Test case 8: aaabbbbaa ===
Time=310000 | in=01 | out=0
Time=320000 | in=01 | out=0
Time=330000 | in=01 | out=0
Time=340000 | in=10 | out=0
Time=350000 | in=10 | out=0
Time=360000 | in=10 | out=0
Time=370000 | in=10 | out=0
Time=380000 | in=01 | out=1
Time=390000 | in=01 | out=0

=== Test case 9: 0a0b0a0 ===
Time=400000 | in=00 | out=0
Time=410000 | in=01 | out=0
Time=420000 | in=00 | out=0
Time=430000 | in=10 | out=0
Time=440000 | in=00 | out=0
Time=450000 | in=01 | out=1
Time=460000 | in=00 | out=0

=== Test case 10: bba ===
Time=470000 | in=10 | out=0
Time=480000 | in=10 | out=0
Time=490000 | in=01 | out=0
