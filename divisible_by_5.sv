// Moore FSM to determine divisibility by 5
module divisible_by_5 (
    input  logic clk,          // Clock signal
    input  logic rst_n,        // Active-low reset
    input  logic serial_i,     // Serial bit input
    output logic divisible_by_5_o  // Output: 1 if divisible by 5, else 0
);

    // Define states using an enumerated type
    typedef enum logic [2:0] {
        REMAINDER_0,  // State representing remainder = 0 (divisible by 5)
        REMAINDER_1,  // Remainder = 1
        REMAINDER_2,  // Remainder = 2
        REMAINDER_3,  // Remainder = 3
        REMAINDER_4   // Remainder = 4
    } state_t;

    // State registers
    state_t state_d, state_q = REMAINDER_0;

    // Output logic: Only `REMAINDER_0` means the number is divisible by 5
    assign divisible_by_5_o = (state_q == REMAINDER_0);

    // Combinational logic for next state transitions
    always_comb begin
        state_d = state_q; // Default state to prevent latches

        if (serial_i) begin
            // Transition when input bit = 1 (binary left shift with +1)
            case (state_q)
                REMAINDER_0: state_d = REMAINDER_1;
                REMAINDER_1: state_d = REMAINDER_3;
                REMAINDER_2: state_d = REMAINDER_0;
                REMAINDER_3: state_d = REMAINDER_2;
                REMAINDER_4: state_d = REMAINDER_4;
                default:      state_d = REMAINDER_0;  // Safety default
            endcase
        end else begin
            // Transition when input bit = 0 (binary left shift with +0)
            case (state_q)
                REMAINDER_0: state_d = REMAINDER_0;
                REMAINDER_1: state_d = REMAINDER_2;
                REMAINDER_2: state_d = REMAINDER_4;
                REMAINDER_3: state_d = REMAINDER_1;
                REMAINDER_4: state_d = REMAINDER_3;
                default:      state_d = REMAINDER_0;  // Safety default
            endcase
        end
    end

    // Sequential logic: Update state on clock edge
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state_q <= REMAINDER_0;  // Reset to initial state
        else
            state_q <= state_d;  // Update state
    end

endmodule
