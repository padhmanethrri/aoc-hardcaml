open Hardcaml
open Signal

(*
  Design for Day 1 Part 1.

  This file contains only the core logic of the solution.
  There is no file I/O or simulation code here — the goal
  is to describe how the hardware behaves on each rotation.
*)

(* Parse a single rotation instruction (e.g., L30 or R12) *)
let parse_rotation s =
  let dir = s.[0] in
  let amt =
    int_of_string (String.sub s 1 (String.length s - 1)) mod 100
  in
  (dir, amt)

(* Compute the next dial position after one rotation *)
let rotate pos (dir, amt) =
  let amt_s = of_int ~width:7 amt in
  let pos_ext = uresize pos 8 in
  let amt_ext = uresize amt_s 8 in
  let hundred = of_int ~width:8 100 in

  let right =
    let sum = pos_ext +: amt_ext in
    mux2 (sum >=: hundred) (sum -: hundred) sum
  in
  let left =
    let diff = pos_ext -: amt_ext in
    mux2 (pos_ext <: amt_ext) (diff +: hundred) diff
  in

  let new_pos_ext =
    if dir = 'R' then right else left
  in
  uresize new_pos_ext 7

(* Build the sequential circuit that processes all rotations *)
let build rotations =
  let clk = input "clk" 1 in
  let spec = Reg_spec.create ~clock:clk () in

  (* current dial position and count of zero hits *)
  let pos = ref (of_int ~width:7 50) in
  let count = ref (of_int ~width:32 0) in

  List.iter
    (fun rot ->
      let next_pos = reg spec (rotate !pos rot) in

      (* increment count only if rotation ends at zero *)
      let hit_zero =
        Signal.(next_pos ==: of_int ~width:7 0)
      in
      let next_count =
        reg spec (mux2 hit_zero (!count +:. 1) !count)
      in

      pos := next_pos;
      count := next_count
    )
    rotations;

  output "result" !count
