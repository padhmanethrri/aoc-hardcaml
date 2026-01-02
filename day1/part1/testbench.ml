(*
  Testbench for Day 1 Part 1.

  This file reads input from input.txt, prepares the stimulus,
  instantiates the design, runs a cycle-accurate simulation,
  and prints the observed output.
*)

open Hardcaml

(* ===== Read input.txt into string list ===== *)
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

(* ========= Puzzle input ========= *)
let puzzle_input = read_input "input.txt"

let () =
  let rotations =
    List.map Design.parse_rotation puzzle_input
  in

  let circuit =
    Circuit.create_exn
      ~name:"day1"
      [ Design.build rotations ]
  in

  let sim = Cyclesim.create circuit in
  let clk = Cyclesim.in_port sim "clk" in

  let cycles = List.length rotations + 1 in
  for _ = 1 to cycles do
    clk := Bits.vdd; Cyclesim.cycle sim;
    clk := Bits.gnd; Cyclesim.cycle sim;
  done;

  let result = Cyclesim.out_port sim "result" in
  Printf.printf "Day 1 password = %d\n"
    (Bits.to_int !result)
