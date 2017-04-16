# ReasonNativeProject

Installation of [`Reason`](http://facebook.github.io/reason/) project for native compilation development.

[More info on the workflow](http://facebook.github.io/reason/nativeWorkflow.html).

[![Build Status](https://travis-ci.org/reasonml/ReasonNativeProject.svg?branch=master)](https://travis-ci.org/reasonml/ReasonNativeProject)

## Install

Clone the repo and install the dependencies:

```sh
git clone https://github.com/reasonml/ReasonNativeProject.git
cd ReasonNativeProject
# opam will read into the `opam` file and add the other dependencies
opam pin add -y ReasonNativeProject .
```

### Build

There are a couple of built-in commands in the `Makefile`.

```sh
make build    # build/rebuild your files
make clean    # clean the compiled artifacts
```

A single test file `./src/test.re` is included. Make a simple change to it and
then run the commands above to see it effect the output.

The built output is in `_build`. Try running it with `_build/src/test.native`.

## Developing Your Project

`ReasonNativeProject` is meant to be the starting point of your own project. You'll
want to make use of existing libraries in your app, so browse the growing set
of `opam` packages in the [opam repository](http://opam.ocaml.org/packages/).

##### Add Another Dependency

Edit your `opam` file so that you depend on a particular opam package and range
of versions.

In addition you may have to tweak the buildstep to recognize the dependency, by changing `build.ml` within the `pkg` folder. and add the following for you dependency:
```ocaml
...
OS.Cmd.run @@ Cmd.(
  ocamlbuild % "-use-ocamlfind"
              %% (v "-I" % "src")
              %% (v "-pkg" % "[PACKAGE]") (* <---- only change is this line*)
              %% of_list files)
...
```

Finally For your editor to pick up the dependency and fancy autocomplete etc. make sure to add the package in your `.merlin` file:
```ocaml
PKG topkg reason [PACKAGE]
```

### Creating Libraries

See the [OPAM instructions](https://opam.ocaml.org/doc/Packaging.html).

## Troubleshooting

In general, if something goes wrong, try upgrading your install of the project
by running `opam upgrade ReasonNativeProject`, or if it failed to install and you
later fixed it, `opam install ReasonNativeProject`.
