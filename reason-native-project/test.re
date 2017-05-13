/**
 * Welcome to Reason.
 */
print_string "!!!!!!\n";
let msg = "Hello Reason!";
print_string msg;
print_newline ();
print_string "!!!!!!\n";

let a = Reason_native_lib.M1.answer;
Printf.printf "Answer: %d\n" a