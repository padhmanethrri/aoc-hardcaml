
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
open Hardcaml
open Signal
(* ========= Puzzle input ========= *)
let puzzle_input = read_input "input.txt"
(* ========= Parse rotation ========= *)
let parse_rotation s =
  let dir = s.[0] in
  let amt =
    int_of_string (String.sub s 1 (String.length s - 1)) mod 100
  in
  (dir, amt)
(* ========= Rotation logic ========= *)
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
(* ========= Build circuit ========= *)
let build () =
  let clk = input "clk" 1 in
  let spec = Reg_spec.create ~clock:clk () in
  (* registers *)
  let pos = ref (of_int ~width:7 50) in
  let count = ref (of_int ~width:32 0) in
  List.iter
    (fun rot ->
      let next_pos = reg spec (rotate !pos rot) in

      let hit_zero =
        Signal.(next_pos ==: of_int ~width:7 0)
      in
      let next_count =
        reg spec (mux2 hit_zero (!count +:. 1) !count)
      in
      pos := next_pos;
      count := next_count
    )
    (List.map parse_rotation puzzle_input);
  output "result" !count
(* ========= Simulation ========= *)
let () =
  let circuit =
    Circuit.create_exn
      ~name:"day1"
      [ build () ]
  in
  let sim = Cyclesim.create circuit in
  let clk = Cyclesim.in_port sim "clk" in
  let cycles = List.length puzzle_input + 1 in
  for _ = 1 to cycles do
    clk := Bits.vdd; Cyclesim.cycle sim;
    clk := Bits.gnd; Cyclesim.cycle sim;
  done;
  let result = Cyclesim.out_port sim "result" in
  Printf.printf "Day 1 password = %d\n" (Bits.to_int !result)
