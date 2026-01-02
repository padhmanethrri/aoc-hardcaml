(*
  Testbench for Day 1 Part 2.

  This file handles input parsing and simulation.
  It computes how many times each rotation causes
  the dial to hit zero and feeds that into the design.
*)

open Hardcaml
open Signal

module Sim =
  Cyclesim.With_interface (Design.I) (Design.O)

type dir = L | R

let parse_line (s : string) : dir * int =
  let s = String.trim s in
  let d =
    match s.[0] with
    | 'L' -> L
    | 'R' -> R
    | _ -> failwith "Invalid direction"
  in
  let n = int_of_string (String.sub s 1 (String.length s - 1)) in
  (d, n)

(* Counts how many times a rotation causes the dial to land on 0 *)
let apply_instruction pos (d, steps) =
  match d with
  | L ->
      let total = pos + steps in
      let hits = total / 100 in
      let new_pos = total mod 100 in
      (new_pos, hits)

  | R ->
      let new_pos =
        (pos - (steps mod 100) + 100) mod 100
      in
      if pos = 0 then
        (new_pos, steps / 100)
      else if steps < pos then
        (new_pos, 0)
      else
        (new_pos, 1 + (steps - pos) / 100)

let read_lines filename =
  let ic = open_in filename in
  let rec loop acc =
    match input_line ic with
    | line -> loop (line :: acc)
    | exception End_of_file ->
        close_in ic;
        List.rev acc
  in
  loop []

let () =
  let scope =
    Scope.create ~flatten_design:true ()
  in

  let sim =
    Sim.create (Design.create scope)
  in

  let i = Cyclesim.inputs sim in
  let o = Cyclesim.outputs sim in

  (* reset *)
  i.rst := Bits.vdd;
  i.zero_hits := Bits.zero 8;
  Cyclesim.cycle sim;
  i.rst := Bits.gnd;

  let input = read_lines "input.txt" in
  let pos = ref 50 in

  List.iter
    (fun line ->
      let instr = parse_line line in
      let new_pos, hits =
        apply_instruction !pos instr
      in
      pos := new_pos;
      i.zero_hits :=
        Bits.of_int ~width:8 hits;
      Cyclesim.cycle sim)
    input;

  Printf.printf "PASSWORD = %d\n"
    (Bits.to_int !(o.count))
