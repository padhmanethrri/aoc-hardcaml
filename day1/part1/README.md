# Day 1 – Part 1

This directory contains my solution for Day 1, Part 1 of the Advent of FPGA Challenge,
implemented using Hardcaml.

I chose Day 1 as a starting point because the problem has relatively simple control flow
and clearly defined input/output behavior, making it suitable for an initial translation
from a software-style solution into a hardware-oriented design.

## File Overview

- `design.ml`  
  Contains the core computation logic written using Hardcaml primitives. This file
  describes the intended hardware behavior using signals, registers, and combinational
  logic. It does not perform file I/O or printing and is written to reflect synthesizable
  design logic.

- `testbench.ml`  
  Acts as a testbench for the design. This file reads input from `input.txt`,
  instantiates the design, drives the clock, runs a cycle-accurate simulation,
  and prints the resulting output.

- `input.txt`  
  Contains the puzzle input used to test and validate the implementation.

## Development Process

Before implementing the design in Hardcaml, the problem was first analyzed to fully
understand the required computation and edge cases. The logic was reasoned about in a
software-like manner to ensure correctness before being mapped into a hardware-style
implementation.

Once the behavior was clear, the computation was structured using explicit state and
clocked updates. The dial position and count are modeled as registers, and each rotation
is applied sequentially, mirroring how the logic would behave in actual hardware.

The design and testbench were intentionally separated to follow standard hardware
development practices, where the design describes the behavior and the testbench is
responsible for driving inputs and verifying results.

## Input Handling

The puzzle input is provided through `input.txt`. Each line represents a single rotation
instruction. The testbench reads and parses this input, converts it into rotation
operations, and applies them to the design during simulation.

Using an external input file avoids hardcoding values and makes it easy to validate the
design using the full puzzle input.

## Testing / Testbench

Testing is performed using `testbench.ml`. The testbench instantiates the design,
drives the clock signal, and runs the simulation for the required number of cycles
based on the number of rotation instructions.

After the simulation completes, the final output is read from the design and printed
to the console.

When simulated using the provided testbench and puzzle input, the design produced
a final password value of **1139**.

## Design Considerations and Future Extensions

This implementation is intended as a clear and correct baseline rather than a fully
optimized hardware design. While developing the solution, several hardware-specific
considerations were kept in mind:

- **Scalability**:  
  The current design processes the input sequence sequentially, which is sufficient
  for validating correctness. For significantly larger inputs, the design could be
  extended using pipelining or parallel processing to improve throughput.

- **Efficiency**:  
  Area and performance trade-offs were not aggressively optimized in this version.
  Future refinements could include tighter bit-width selection or reducing register
  usage based on more precise bounds.

- **Architecture**:  
  The design explicitly models state using registers and clocked updates, reflecting
  a hardware-oriented approach. This structure provides a solid foundation for exploring
  FPGA-native parallelism that would not be available in a purely CPU-based solution.

- **Language Features**:  
  Hardcaml was chosen to express the design due to its strong typing and compositional
  style, which helps describe hardware behavior in a structured and maintainable way.

Physical synthesis considerations informed the design at a high level to ensure the
implementation remains synthesizable, while the work itself was focused on RTL-level
modeling and simulation.
