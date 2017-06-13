/**
 * Welcome to Reason.
 */
print_string "!!!!!!\n";
let msg = "Hello Reason!";
print_string msg;
print_newline ();
print_string "!!!!!!\n";
print_endline Internal_lib.M2.z;

let a = Reason_native_lib.M1.answer;
Printf.printf "Answer: %d\n" a