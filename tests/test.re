
let res = Internal.Something.calculate 4;
let main () => {
  if (Internal.Something.calculate 4 != 8) {
    print_endline "Test failure!!";
    exit 1;
  } else {
    print_endline "Tests passed";
    exit 0;
  }
};

main();