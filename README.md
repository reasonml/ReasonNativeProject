# ReasonNativeProject

Installation of [`Reason`](http://facebook.github.io/reason/) project for native compilation development.

[More info on the workflow](http://facebook.github.io/reason/nativeWorkflow.html).

**Requirements**: [OPAM](https://opam.ocaml.org), the OCaml package manager.

`ReasonNativeProject` installs the `Reason` toolchain into your global opam directory
using `opam`. `ReasonNativeProject` can therefore be used as a template for new
projects, but can also be used to install the toolchain [into the global
environment](#reasonNativeproject-editor-support).  `ReasonNativeProject` includes: the
compiler toolchain, the source formatter, REPL, and IDE support for popular
editors.

[![Build Status](https://travis-ci.org/reasonml/ReasonNativeProject.svg?branch=master)](https://travis-ci.org/reasonml/ReasonNativeProject)

## Install

Install by cloning the repo and running the following commands. These commands
install all dependencies.

```sh
git clone https://github.com/reasonml/ReasonNativeProject.git
cd ReasonNativeProject
opam pin add -y ReasonNativeProject .
```

### Run, Change, Rebuild

There are a couple of built-in commands in the `Makefile`.

```sh
make build    # Rebuilds after changing
make clean    # Clean if you need to!
```

A single test file `./src/Test.re` is included. Make a simple change to it and
then run the commands above to see it effect the output.

The binary output will be in the project root directory -- to run it, type
`./Test.byte`!

## Developing Your Project

`ReasonNativeProject` is meant to be the starting point of your own project. You'll
want to make use of existing libraries in your app, so browse the growing set
of `opam` packages in the [opam repository](http://opam.ocaml.org/packages/).

##### Add Another Dependency

Edit your `opam` file so that you depend on a particular opam package and range
of versions.

### Creating Libraries

See the [OPAM instructions](https://opam.ocaml.org/doc/Packaging.html).

## Troubleshooting

In general, if something goes wrong, try upgrading your install of the project
by running `opam upgrade ReasonNativeProject`, or if it failed to install and you
later fixed it, `opam install ReasonNativeProject`.
