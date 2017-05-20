# ReasonNativeProject

Installation of [`Reason`](http://facebook.github.io/reason/) project for native compilation development.

[More info on the workflow](http://facebook.github.io/reason/nativeWorkflow.html).

[![Build Status](https://travis-ci.org/reasonml/ReasonNativeProject.svg?branch=master)](https://travis-ci.org/reasonml/ReasonNativeProject)

## Install

Clone the repo and install the dependencies:

```sh
git clone https://github.com/reasonml/ReasonNativeProject.git
cd ReasonNativeProject
opam update # get the latest opam packages data. Skip this optionally
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

The built output is in `_build` but the final binary is symlinked `_build/src/index.native -> index.native`.

## Developing Your Project

`ReasonNativeProject` is meant to be the starting point of your own project. You'll want to make use of existing libraries in your app, so browse the growing set of `opam` packages in the [opam repository](http://opam.ocaml.org/packages/).

##### Add Another Dependency

While developing you can simply modify the `_tags` file which is what `rebuild uses to figure out what you depend on. See inside that file for more instructions.

##### Releasing

Before publishing onto all you'll need to do is run `make release` to generate all of the files necessary for opam. Then you can follow the steps [here](https://opam.ocaml.org/doc/Packaging.html#GettingafullOPAMpackage).

If you've added extra opam dependencies you'll need to update the package.json under `opam > dependencies`. You can see all of the possible fields you can tweak on the [opam_of_packagejson](https://github.com/bsansouci/opam_of_packagejson) github.

Finally For your editor to pick up the dependency and fancy autocomplete etc. make sure to add the package in your `.merlin` file:
```ocaml
PKG reason [PACKAGE]
```

### Creating Libraries

See the [OPAM instructions](https://opam.ocaml.org/doc/Packaging.html).

## Troubleshooting

In general, if something goes wrong, try upgrading your install of the project by running `opam upgrade ReasonNativeProject`, or if it failed to install and you later fixed it, `opam install ReasonNativeProject`.
