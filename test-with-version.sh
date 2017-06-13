#!/usr/bin/env bash

set -e

export OCAML_VERSION="${1}"

make clean
opam switch "${OCAML_VERSION}"
eval `opam config env`
opam update
opam install -y re
opam pin add -y ReasonNativeProject .
make run
git diff --exit-code
