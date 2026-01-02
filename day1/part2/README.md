# Day 1 – Part 2

This directory contains my solution for Day 1, Part 2 of the Advent of FPGA Challenge,
implemented using Hardcaml.

Part 2 builds directly on Part 1, but changes the counting rule in a way that requires
tracking events that occur during a rotation rather than only checking the final state.

## What Changed from Part 1

In Part 1, the count was incremented only when a rotation ended with the dial pointing
at position 0.

In Part 2, every time the dial points at 0 must be counted, including occurrences during
a rotation. This means that a single instruction can contribute multiple counts,
especially when the rotation amount is large or causes the dial to wrap around multiple
times.

As a result, the solution needs to reason about intermediate events during movement,
not just the final dial position.

## File Overview

- `design.ml`  
  Contains the hardware design logic. The design does not perform any parsing or file
  access. Instead, it receives the number of zero-hits for each instruction and
  accumulates the total count using clocked registers.

- `testbench.ml`  
  Handles input parsing, simulation, and verification. The testbench reads the puzzle
  input, computes how many times each rotation causes the dial to hit zero, drives those
  values into the design, and runs a cycle-accurate simulation.

- `input.txt`  
  Contains the puzzle input used to validate the implementation.

## Design Approach

The overall structure of the design remains similar to Part 1, with explicit state
modeled using registers and updates occurring on clock edges.

However, instead of checking only whether a rotation ends at position 0, the logic now
computes how many times position 0 is reached during each rotation. This allows the
design to correctly handle cases where the dial wraps around multiple times within a
single instruction.

Separating the event-counting logic (handled in the testbench) from the accumulation
logic (handled in the design) keeps the hardware portion simple and focused, while still
matching the problem specification.

## Input Handling

The input format is unchanged from Part 1. Each instruction is read from `input.txt`,
parsed by the testbench, and applied sequentially during simulation.

Keeping the same input interface makes it easy to compare the behavior of Part 1 and
Part 2 and ensures that the additional complexity is isolated to the counting logic.

## Testing / Testbench

Testing is performed using `testbench.ml`. For each instruction, the testbench:
1. Computes the number of times the dial hits zero
2. Drives this value into the design as an input
3. Advances the simulation by one clock cycle

After all instructions are processed, the final count is read from the design output
and printed to the console.

When simulated using the provided testbench and full puzzle input, the design produced
a final password value of **6684**.

## Design Considerations and Future Extensions

This implementation focuses on correctness and clear hardware modeling rather than
aggressive optimization.

- **Scalability**:  
  The logic correctly handles large rotation values that may cause multiple wraparounds.
  For higher throughput, the approach could be extended toward more parallel or
  streaming designs.

- **Efficiency**:  
  Bit-widths and register usage were chosen conservatively. These could be tightened
  further with more detailed bounds analysis.

- **Architecture**:  
  The explicit separation between event detection and state accumulation reflects a
  hardware-oriented design style and provides a clean foundation for future extensions.

Physical synthesis considerations informed the design at a high level to ensure the
implementation remains synthesizable, while the work itself was focused on RTL-level
modeling and simulation.
