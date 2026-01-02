# Advent of FPGA Challenge – Hardcaml Solutions

This repository contains my solutions for the Advent of FPGA Challenge, implemented
using Hardcaml, an OCaml-based hardware description language.

The goal of this work is to explore how algorithmic problems from Advent of Code can
be translated into hardware-oriented designs with explicit state, clocked behavior,
and realistic I/O modeling.

## Motivation

Advent of Code problems are typically solved in a software context, but they also
provide an interesting opportunity to think about architecture, state, and dataflow
from a hardware perspective.

Hardcaml was chosen for this project because it allows hardware designs to be expressed
in a structured and compositional way, while still remaining close to synthesizable
RTL concepts such as registers, signals, and clocked updates.

## Repository Structure

Solutions are organized by day, with each day further divided into parts following
the Advent of Code problem structure.

Each part contains:
- `design.ml` – hardware design logic
- `testbench.ml` – input handling and simulation
- `input.txt` – puzzle input
- `README.md` – explanation of the approach and design decisions

The design and testbench are intentionally separated to reflect standard hardware
development practices.

## Current Status

- **Day 1**  
  - Part 1 and Part 2 completed and documented
  - Both parts validated using cycle-accurate simulation with the full puzzle input

Additional days may be added following the same structure.

## How to Run

Each part includes a testbench that can be used to simulate the design locally.
The testbench reads the puzzle input from `input.txt`, drives the design cycle by
cycle, and prints the final result.

No FPGA synthesis or physical implementation is required for this challenge.

## Notes

The focus of this repository is on clarity, correctness, and hardware-style modeling
rather than aggressive performance optimization. All designs are written to be
synthesizable and structured in a way that allows future exploration of scalability,
parallelism, and architectural trade-offs.

All code in this repository represents original work, and each design can be explained
and reasoned about at the RTL level.
