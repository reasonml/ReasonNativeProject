# ReasonProject

Installation of [`Reason`](http://facebook.github.io/reason/) project and
development environments via `npm`.

> Requirements: `npm` (currently tested on Mac, Linux, and Windows Linux subsystem).

`ReasonProject` installs the `Reason` toolchain into a local directory using
`npm`.  `ReasonProject` can therefore be used as a template for new projects,
but can also be used to install the toolchain [into the global
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

Install by cloning the repo and running `npm install`. This installs all
dependencies locally into the `ReasonProject` directory.

```sh
git clone https://github.com/reasonml/ReasonProject.git
cd ReasonProject
npm install
```

> Note: Disable any `ocaml` global compilers you have in your `PATH`. If you already
have an ocaml compiler installed via `opam`, disable the line in your `~/.bashrc`
that sources the `opam` environment. You may even want to uninstall any `ocaml`
compilers that you installed via `brew`. (We are working on a fix to this problem).

## Project Commands

Once built, `ReasonProject` generates an *environment* that you can temporarily
load when executing commands. The environment contains an enhanced `PATH`
containing binaries built by your dependencies, but this environment isn't
loaded into your global path. Some `npm run` commands have been setup to allow
you to run some basic tasks, as well as any custom command, all within the
project environment.



### Run, Change, Rebuild

There are a couple of built in commands declared in `package.json` that you can
execute via `npm run`. For example: `"npm run start"`, `"npm run reasonBuild"`
and `"npm run clean"`. You can also [add your
own](#reasonproject-developing-your-project-add-your-own-scripts) named scripts
which give you a nicer alias like `npm run myScriptName`.


```sh
npm run reasonBuild  # Rebuilds after changing
npm run start        # Runs the compiled app
npm run clean        # Clean if you need to!
```

A single test file `./src/Test.re` is included. Make a simple change to it and
then run the commands above to see it effect the output.


### REPL

The `rtop` REPL is built into the sandbox. The command `npm run top` starts the
REPL.

```sh
# Opens `rtop` from the sandbox.
npm run top
```


### Custom Commands

To do anything beyond those basic, preconfigured commands, you just prefix your
command with `npm run env --`. You should pass the *actual* command you want to
run after `--`.

```sh
# By default nothing is found!
which refmt

 > Not Found!

# Prefix with "npm run env --" and it finds it!
npm run env -- which refmt

 > ~/ReasonProject/node_modules/reason/_build/ocamlfind/bin/refmt
```

If this becomes tedious, you can [add your
own](#reasonproject-developing-your-project-add-your-own-scripts) named scripts
so that you can do `npm run yourScriptName` instead.

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

##### Avoiding Global Paths

You can continue to develop entirely in the isolated sandbox without polluting
global environment variables, by opening your editor within the sandbox
environment:

```sh
npm run env -- vim
npm run env -- atom
npm run env -- mvim
```

Because you've [prepared your
editor](#reasonproject-get-started-editor-support)
to load editor support from the environment, `npm run env -- yourEditor`
ensures that your editor will find the editor support in your environment
variables.

> Note: If you use `atom`, and already have `opam` installed, then there's a
> known issue where `atom` has problems loading, but you can fix it easily by
> commenting out any part in your `bashrc` that sources opam environments.  We
> will come up with a long term solution at some point.

##### Using Global Paths

Pure sandboxed based development doesn't always work for certain workflows.
(prefixing *all* commands with `npm run` may not work well). In that case, you
can easily inject your successfully built project's environment into the global
`PATH`, by putting the following in your `.bashrc`:

```sh
# In your .bashrc
pushd ~/pathTo/ReasonProject/ && \
  eval $(~/pathTo/ReasonProject/node_modules/.bin/dependencyEnv) && \
  popd
```


## Developing Your Project

### Making It Yours
`ReasonProject` is meant to be the starting point of your own project. You'll want
to make use of existing libraries in your app, so 
browse the growing set of `opam` packages ported to `npm` under
[`opam-alpha`](https://www.npmjs.com/~opam-alpha#packages). If there's something
that hasn't yet been ported from `opam`, make a pull request to
[this repo](https://github.com/yunxing/opam-npm/) and the package will automatically
be ported (as soon as the daemon picks it up).

##### Add Another Dependency

**Option `1`:** Install a dependency into the project sandbox, and use `--save`
so that your `package.json` is updated.

```sh
npm install --save @opam-alpha/cstruct
```

**Option `2`:** Edit the `package.json` manually to include your new dependency and run `npm install`.

> Note: Sometimes options `1` and `2` above fail because some *other*
> dependency that is rebuilt as a result of the `install` was not designed to
> build in an idempotent manner.  In that case, just add the new dependency to
> your `package.json` `"dependencies"`, `rm -r node_modules`, and then run `npm
> install`. This installs from a clean slate.


> Note: `opam-alpha` is "alpha" - we may move to a new namespace `opam-beta`
> once we apply the lessons we've learned from `opam-alpha`. All the should
> exist as they are, but a next generation `opam-beta` universe on `npm` would
> have everything `opam-alpha` has (and then some). The work to upgrade your
> projects will likely be minimal.


This merely adds and builds the dependency. It doesn't mean your build system
will know to link to it. Accomplishing that is build system dependent, but if
using the example build system (`rebuild`, which is based on `ocamlbuild`), you
can get an idea for the options by doing `npm run buildHelp`. Typically you
need to configure the `reasonBuild` entry in `package.json` to add the `-pkg
dependencyPackage`. Consult your dependency's docs.

### Add Your Own Scripts

`npm` allows `scripts` to be specified in your project's `package.json`.  These
`scripts` are a named set of commands. A few scripts have special meaning, such
as the `postinstall` script.

> The `postinstall` script is how your project compiles itself. It is
> guaranteed that the `postinstall` script executes any time you run `npm
> install` in this package, or any time another package installs you as a
> dependency. You're also guaranteed that your `postinstall` script is executed
> *after* all of your dependencies' `postinstall` scripts.

You can add new named scripts in the `package.json` `scripts` field. Once
added, you can then run them via `npm run scriptName` from within the project
root.

###### Making Sure Your Scripts See The Environment

`eval $(dependencyEnv)` is commonly used in these `scripts`. This `eval`
statement augments the environment for the duration of the named script, which
ensures that important binaries (such as `refmt`) are in the `PATH`.

> When the entire purpose of developer tools is to generate a binary (such as a
> compiler) to be included in your `PATH`, or produce a library whose path
> should be specified in an special environment variable, it's almost like the
> environment variable is the public API of that package.  `dependencyEnv`
> allows your script to see the environment variables that your immediate
> dependencies wanted to publish as their public API. You can learn how
> packages can publish environment variables in the [dependency-env
> repo](https://github.com/npm-ml/dependency-env).

### Multiple Projects

You can have multiple clones/forks/builds of `ReasonProject` - one for each of
your projects. When you make changes, you can share the project easily with
anyone else because you are modelling all dependencies via `package.json`. If
also [using the global
environment](#reasonproject-editor-support), you may want to
designate one special `ReasonProject`, that is only used for augmenting the
global path.


### Creating Libraries

`ReasonProject` sets up your environment for building an application. We
haven't yet mentioned how to then share your work with other people *as* an
`npm` dependency itself. More coming soon.


## Troubleshooting

In general, if something goes wrong, try deleting the local `node_modules`
directory that was installed, and then try reinstalling using `npm install -f`
(to avoid using a stale cache). Then if that doesn't work, follow the following
steps to debug your specific failed dependency.

Also, remember to disable any system ocaml compilers that you have in your PATH.
For example, if you installed an OCaml compiler via opam, comment out the line in
your `~/.bashrc` or `~/.bash_profile` that source the opam environment,
and then open a new shell.

> Note: We will soon make it impossible for these kinds of conflicts to occur.

#### Debugging Failed Dependencies

When `npm install` fails to install one of your dependencies, it's typically
because a `postinstall` step of a package has failed. Read the logs to
determine which one is failing. `npm` will delete the directory of the failed
package so the failed install won't be in `node_modules`, but you can
usually try to reinstall it explicitly, and debug the installation. Suppose the
`@opam-alpha/qcheck` package failed to install. Let's recreate the failure so
we can debug it.

#####Do a dry run:
Let's see what an `npm install` for this package *would* install. The `--dry-run`
flag avoids actually installing anything.

```sh
npm install --dry-run @opam-alpha/qcheck 
```

In my project, it says it would only need to install the following packages.
That's because all of the other ones must have already been installed in
`node_modules`.

```sh
# Output
test@1.0.0 /Users/jwalke/Desktop/tmp
└─┬ @opam-alpha/qcheck@0.4.0 
  └── qcheck-actual@0.4.0 (git://github.com/npm-opam/qcheck.git)
```
> Note: Sometimes it won't traverse `git` dependencies to find all the potentially installed
package. That's okay.

###### Install Source Without Building
So we want to install that now, but *without* executing the install scripts so we
pass the `--ignore-scripts` flag. Without that flag, it would fail when running
the scripts again, and then remove the package again!

```sh
npm install --ignore-scripts @opam-alpha/qcheck@0.4.0
```

This will just install the source code, and let us know what it actually installed.

###### Try The Build Manually, In Place
Now, make sure `npm` didn't do something weird with installing new versions of package
that didn't show up in the dry run, and make sure it installed things
as flat as possible in `node_modules`, as opposed to nesting `node_modules`
for compiled ocaml packages inside of other `node_modules`. Ideally, everything
is a flat list inside the `ReasonProject/node_modules` directory.

`cd` into the package that was failing to build correctly (it was actually the `qcheck-actual` package
in our case). Run the build command in `package.json`'s `postinstall` field by doing `npm run postinstall`.

```sh
cd node_modules/qcheck-actual
npm run postinstall
```

Now the package should fail as it did when you tried to install your top level project,
but without removing the packages, so you can debug the issue, fix it, then try rebuilding
again. Usually you need to reconfigure the problematic package, or fix the build script.
Fix it, and push an update for the package.

Finally, once you've pushed a fix to the package for the issue, `rm`
the entire project's `node_modules` directory and re-run `npm install`
from the top again. This just makes sure you've got everything
nice and clean as if you installed it for the first time.


```
npm run whereisocamlmerlin
```
