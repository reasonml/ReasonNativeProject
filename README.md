# ReasonProject

Installation of [`Reason`](http://facebook.github.io/reason/) project and
development environments via `opam`.

> Requirements: `opam`

`ReasonProject` installs the `Reason` toolchain into your global opam directory
using `opam`.  `ReasonProject` can therefore be used as a template for new
projects, but can also be used to install the toolchain [into the global
environment](#reasonproject-editor-support).  `ReasonProject` includes: the
compiler toolchain, the source formatter, REPL, and IDE support for popular
editors.

> A sandboxed environment models dependencies and builds them into a local
> directory so that it works reliably for anyone. Installing tools into your
> global environment is simply a matter of sourcing the sandboxed environment
> in your `.bashrc`. It's easy to make sandboxed local environments global, and
> very hard to do the reverse, so `ReasonProject` starts with local
> environments.


[![Build Status](https://travis-ci.org/reasonml/ReasonProject.svg?branch=master)](https://travis-ci.org/reasonml/ReasonProject)

## Install

Install by cloning the repo and running the following commands. These commands
install all dependencies.

```sh
git clone https://github.com/reasonml/ReasonProject.git
cd ReasonProject
opam pin add -y ReasonProject .
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


### REPL

The `rtop` REPL is built into Reason. The command `rtop` starts the REPL.


## Editor Support

#### Prepare Your Editor

All of the IDE plugins, including integration with error highlighting,
autocomplete, and syntax highlighting are included inside of the built project.

Configure your `EDITOR` to load the `Reason` plugins from your instance of
`ReasonProject`. See the instructions for
[Atom](http://facebook.github.io/reason/tools.html#merlin-atom) and
[Vim](https://github.com/facebook/reason/tree/master/editorSupport/VimReason).

#### IDE support included.

The editor config above mostly exists to load the *actual* editor support, from
the `ReasonProject` build. The only thing we need is to make sure the `PATH`
contains all the important stuff from `ReasonProject`'s build.  There are two
approaches: one continues to avoid global variables (as we've done so far), and
the other doesn't.


## Developing Your Project

### Making It Yours

`ReasonProject` is meant to be the starting point of your own project. You'll
want to make use of existing libraries in your app, so browse the growing set
of `opam` packages in the [opam repository](http://opam.ocaml.org/packages/).


##### Add Another Dependency

Edit your `opam` file so that you depend on a particular opam package and range
of versions.


### Multiple Projects

You can have multiple clones/forks/builds of `ReasonProject` - one for each of
your projects. When you make changes, you can share the project easily with
anyone else because you are modelling all dependencies via `opam`.


### Creating Libraries

`ReasonProject` sets up your environment for building an application. We
haven't yet mentioned how to then share your work with other people *as* an
`opam` dependency itself. More coming soon.


## Troubleshooting

In general, if something goes wrong, try upgrading your install of the project
by running `opam upgrade ReasonProject`, or if it failed to install and you
later fixed it, `opam install ReasonProject`.
