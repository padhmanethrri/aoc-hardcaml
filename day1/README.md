# Day 1

This directory contains my solutions for Day 1 of the Advent of FPGA Challenge,
implemented using Hardcaml.

Day 1 was chosen as a starting point because it has a clear sequential structure
and well-defined input/output behavior, making it suitable for an initial hardware-
oriented implementation.

## Overview

The Day 1 problem involves simulating a rotating dial with wraparound behavior.
A sequence of rotation instructions is applied starting from an initial position,
and a count is maintained based on when the dial reaches position 0.

The two parts differ in how this counting is performed.

- **Part 1** counts only when a rotation ends with the dial pointing at 0.
- **Part 2** counts every time the dial points at 0, including intermediate
  occurrences during a rotation.

## Directory Structure

- `part1/`  
  Contains the Part 1 solution, including the design logic, testbench, puzzle input,
  and detailed documentation.

- `part2/`  
  Contains the Part 2 solution, which builds on Part 1 and extends the logic to handle
  intermediate zero-crossings during rotations.

Each part is implemented with a clear separation between design (hardware behavior)
and testbench (input handling and simulation).

## Testing

Both parts are validated using cycle-accurate testbenches that read the full puzzle
input from `input.txt`, drive the designs cycle by cycle, and print the final result.

- Part 1 simulation produces a password value of **1139**.
- Part 2 simulation produces a password value of **6684**.

## Notes

The focus of these implementations is on correctness, clarity, and hardware-style
modeling rather than aggressive optimization. The structure used for Day 1 provides
a solid foundation for extending the approach to more complex problems in later days.
