/**
 * Welcome to Reason.
 */
print_string "!!!!!!\n";
let msg = "Hello Reason!";
print_string msg;
print_newline ();
print_string "!!!!!!\n";
print_endline Internal.GoodValues.message;

let a = Lib.LifeTheUniverseAndEverything.answer;
Printf.printf "Answer: %d\n" a