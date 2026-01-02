open Hardcaml

(*
  Testbench for Day 1 Part 1.

  This file is responsible for running the design.
  It reads the puzzle input, instantiates the circuit,
  drives the clock, and prints the final result.
*)

(* Read all lines from the input file *)
let read_input filename =
  let ic = open_in filename in
  let rec loop acc =
    try
      let line = input_line ic in
      loop (line :: acc)
    with End_of_file ->
      close_in ic;
      List.rev acc
  in
  loop []

let puzzle_input = read_input "input.txt"

let () =
  (* parse input into rotation instructions *)
  let rotations =
    List.map Design.parse_rotation puzzle_input
  in

  (* build the circuit from the design *)
  let circuit =
    Circuit.create_exn
      ~name:"day1"
      [ Design.build rotations ]
  in

  let sim = Cyclesim.create circuit in
  let clk = Cyclesim.in_port sim "clk" in

  (* run the simulation for enough cycles *)
  let cycles = List.length rotations + 1 in
  for _ = 1 to cycles do
    clk := Bits.vdd;
    Cyclesim.cycle sim;
    clk := Bits.gnd;
    Cyclesim.cycle sim;
  done;

  (* read and print the final output *)
  let result = Cyclesim.out_port sim "result" in
  Printf.printf "Day 1 password = %d\n"
    (Bits.to_int !result)
