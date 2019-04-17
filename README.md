# !DEPRECATED! Use [hello-reason](https://github.com/esy-ocaml/hello-reason) instead

Original README below:

# ReasonNativeProject


[`Reason`](http://reasonml.github.io/) project for native compilation:

[More info on the workflow](https://reasonml.github.io/guide/native).

[![Build Status](https://travis-ci.org/reasonml/ReasonNativeProject.svg?branch=master)](https://travis-ci.org/reasonml/ReasonNativeProject)

## Develop With OPAM

**Build**:

Clone the repo and run these commands from within the project:

```sh
opam update # get the latest opam packages data. Skip this optionally
# opam will read into the `opam` file and add the other dependencies
opam install reason
opam install merlin
opam install re
make build    # build/rebuild your files
```

**Run**:

```sh
./_build/install/default/bin/reason-native-bin
```

**Develop**:
- Make sure you have `merlin` globally installed (via opam, *not*
  `reason-cli`!)
- [See the ReasonML
  docs](https://reasonml.github.io/docs/en/editor-plugins.html) about setting
  up your editor. Just remember to *not* install `reason-cli` when using
  `opam`.



## Preliminary Esy Support
You may alternatively use [`esy`](http://esy.sh/) to build and develop this
project. (`esy` is like "npm for native"). This is preferable for people who
want to build native Reason projects using existing opam packages, but with a
more familiar and sandboxed workflow. This is experimental and not stable yet.
Please report any issues to [the esy repo](https://github.com/esy/esy).

**Build**:

```sh
npm install -g esy@latest
esy install
esy build
```

**Run**:

Use `esy x` ("esy execute") command to run the binary.

```sh
esy x reason-native-bin
```

**Develop**:

- [See the ReasonML
  docs](https://reasonml.github.io/docs/en/editor-plugins.html) about setting
  up your editor.
- Start your editor from the root of this project via `esy vim` or `esy atom`
  etc. (Note VSCode has special `esy` support so that you don't need to start
  it this way from the command line).
- Add dependencies by adding entries to the `package.json`, running `esy
  install` then `esy build`.


## Developing Your Project
The entrypoint of this project is the `./bin/test.re` file. Make a simple
change to it and then rerun the build.

`ReasonNativeProject` is meant to be the starting point of your own project. You'll
want to make use of existing libraries in your app, so browse the growing set
of `opam` packages in the [opam repository](http://opam.ocaml.org/packages/).


## Troubleshooting

In general, if something goes wrong, try upgrading your install of the project
by running `opam upgrade ReasonNativeProject`, or if it failed to install and you
later fixed it, `opam install ReasonNativeProject`.
