open Hardcaml
open Signal

(*
  Design for Day 1 Part 2.

  This module represents the hardware side of the solution.
  It does not know about files or parsing. It only receives
  the number of times the dial hits zero for each step and
  accumulates the total count across clock cycles.
*)

module I = struct
  type 'a t =
    { clk       : 'a
    ; rst       : 'a
    ; zero_hits : 'a [@bits 8]
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t =
    { count : 'a [@bits 32] }
  [@@deriving hardcaml]
end

let create (_ : Scope.t) (i : _ I.t) =
  let spec =
    Reg_spec.create ~clock:i.clk ~clear:i.rst ()
  in

  let count =
    reg_fb spec ~width:32
      ~f:(fun c ->
        c +: uresize i.zero_hits 32)
  in

  { O.count }
