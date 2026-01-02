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
  Acts as a testbench for the design. This file reads input from `input.txt`, instantiates
  the design, drives the clock, runs a cycle-accurate simulation, and prints the resulting
  output. It is used to validate correctness before further hardware refinement.

- `input.txt`  
  Contains the puzzle input used to test and validate the implementation.

## Development Process

Before implementing the design in Hardcaml, the problem was carefully analyzed to
understand the required computation and edge cases. The logic was first reasoned about
in a software-like manner to ensure correctness and remove ambiguity.

Once the behavior was clear, the computation was structured so it could be expressed
using hardware-style dataflow. State such as position and counters is modeled explicitly
using registers, and updates occur on clock cycles, reflecting how the design would
behave in real hardware.

The design and testbench were intentionally separated to follow standard hardware
development practices, where the design describes behavior and the testbench is
responsible for verification.

## Input Handling

The puzzle input is provided through `input.txt`. Each line represents an operation
specified by the problem. The testbench reads this file, parses the input, and applies
the corresponding operations to the design during simulation.

Using an external input file allows the logic to be validated without relying on
hardcoded values and makes it easier to test different input scenarios.

## Testing / Testbench

Testing is performed using `testbench.ml`. The testbench instantiates the design,
drives the clock signal, and runs the simulation for the required number of cycles
based on the length of the input sequence.

After simulation completes, the final result is read from the design output and
printed to the console. This setup serves as a simple but effective testbench to
validate functional correctness before considering further optimization.

## Design Considerations and Future Extensions

This implementation is intended as a clear and correct baseline rather than a fully
optimized hardware design. While developing the solution, several hardware-specific
considerations were kept in mind:

- **Scalability**:  
  The current design processes the input sequence sequentially, which is sufficient
  for validating correctness. For significantly larger inputs, the design could be
  extended to use pipelining or parallel processing to improve throughput.

- **Efficiency**:  
  Area and performance trade-offs were not aggressively optimized in this version.
  Future refinements could include tighter bit-width selection or reducing register
  usage based on more precise bounds.

- **Architecture**:  
  The design explicitly models state using registers and clocked updates, reflecting
  a hardware-oriented approach. This structure provides a foundation for exploring
  FPGA-native parallelism that would not be available in a purely CPU-based solution.

- **Language Features**:  
  Hardcaml was chosen to express the design due to its strong typing and compositional
  style, which help describe hardware behavior more structurally than traditional
  Verilog for this kind of problem.

Physical synthesis and ASIC flows were not explored for this baseline implementation,
but the design is written with synthesizability and realistic resource usage in mind.
