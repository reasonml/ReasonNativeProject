# ExampleProject

[![Build Status](https://travis-ci.org/reasonml/ExampleProject.svg?branch=master)](https://travis-ci.org/reasonml/ExampleProject)

## Reason via `npm`

Example project using Reason as an `npm` dependency. Use this as a template to
quickly start a new project, or just try out `Reason`.

## Get Started:

```sh
git clone https://github.com/reasonml/ExampleProject.git
cd ExampleProject
npm install
npm start
```

## Make Changes And Rebuild :
```sh
npm run reasonBuild
npm run clean  # Clean if you need to!
```

If you are running as `root` already (you probably aren't) then invoke `npm
install --unsafe-perm` instead.

## Included Top Level

The top level `rtop` is built in to the sandbox:

```sh
# Opens `rtop` from the sandbox.
npm run top
```

## Editor Support

All of the IDE support, including error highlighting, autocomplete, and
syntax is included inside of the sandbox.

```sh
# Opens your `$EDITOR` with all the right tools in your `$PATH`
npm run editor
```

To make your editor load the IDE support from the sandbox:

- Make sure your `$EDITOR` variable is set if not already.
  - `export EDITOR=vim`, or `export EDITOR=atom`
- Configure your `EDITOR` to load the `Reason` plugins. See the instructions
  for [Atom](http://facebook.github.io/reason/tools.html#merlin-atom) and
  [Vim](https://github.com/facebook/reason/tree/master/editorSupport/VimReason).

> Note: If you use `atom`, and already have `opam` installed, then there's a
known issue where `atom` has problems loading, but you can fix it easily
by commenting out any part in your `bashrc` that sources opam environments.
We will come up with a long term solution at some point.


## Making It Your Project
`ExampleProject` is meant to be the starting point of your own project.

##### Add Another Dependency

**Option `1`:** Install a dependency into the project sandbox, and use `--save`
so that your `package.json` is updated.

```sh
npm install --save @opam-alpha/cstruct
```

**Option `2`:** Edit the `package.json` manually to include your new dependency and run `npm install`.

> Note: Sometimes options `1` and `2` above fail because some *other* dependency that is
rebuilt as a result of the `install` was not designed to build in an idempotent manner.
In that case, just add the new dependency to your `package.json` `"dependencies"`,
`rm -r node_modules`, and then run `npm install`. This installs from a clean slate.

### What's happening
- `npm install` will download and install all your dependencies, and run the
  `postinstall` steps for all of those dependencies, and then finally the
  `postinstall` script step of this project.
- `npm start` will run the script located in the `start` field of the
  `scripts` section of the `package.json` file here. The `start` script simply
  runs the binary that was built in the `postinstall` step.
- No, really - all you need is `npm` (> `3.0`). All of the compiler infrastructure
  has been organized into `npm` packages, and will be compiled on your host
  inside of the `./node_modules` directory. No `PATH`s are poluted. No global
  environment variables destroyed. No trace is left on your system. If you
  delete the `./node_modules` directory, you're back to exactly where you
  started.


### Add Your Own Scripts
- `npm` allows `scripts` to be specified in your project's `package.json`.
  These `scripts` are a named set of commands.
- A few scripts have special meaning, such as the `postinstall` script. The
  `postinstall` script is how your project compiles itself. It is guaranteed
  that the `postinstall` script executes any time you run `npm install` in this
  package, or any time another package installs you as a dependency. You're
  also guaranteed that your `postinstall` script is executed *after* all of
  your dependencies' `postinstall` scripts.
- You can add new named scripts in the `package.json` `scripts` field. Once
  added, you can then run them via `npm run scriptName` from within the project
  root.
- `eval $(dependencyEnv)` is commonly used in these `scripts`. The `eval`
  manages the environment, and ensures that important
  binaries (such as `refmt`) are in the `PATH`. `dependencyEnv` ensures that
  the environment is augmented only for the duration of that `script` running,
  and only in ways that you or your immediate dependencies decide. When
  the entire purpose of developer tools is to generate a binary (such as a
  compiler) to be included in your `PATH`, or produce a library whose path
  should be specified in an special environment variable, it's almost like the
  environment variable is the public API of that package. `dependencyEnv`
  allows your script to see the environment variables that your immediate
  dependencies wanted to publish as their public API. You can learn how
  packages can publish environment variables in the [dependency-env
  repo](https://github.com/npm-ml/dependency-env).


### How to turn this project into a library

- To turn this example project into a library that other people can depend on
  via `npm`... (coming soon).
  

### Debugging a Failed Dependency Install

When `npm install` fails to install one of your dependencies successfully, it's
typically because a `postinstall` step of a package has failed. Read
the logs to determine which one is failing. `npm` will delete the directory
of the failed package so it won't be in `node_modules`, but it's in the cache, so you
can usually install it explicitly, and debug the installation. Suppose the
`@opam-alpha/qcheck` package failed to install. Let's recreate the failure so
we can debug it.

Let's see what an `npm install` for this package *would* install. The `--dry-run`
flag avoids actually installing anything.

```sh
npm install --dry-run @opam-alpha/qcheck 
```

In my project, it says it would only need to install the following packages.
That's because all of the other ones must have already been installed in
`node_modules`.

Output:
```sh
test@1.0.0 /Users/jwalke/Desktop/tmp
└─┬ @opam-alpha/qcheck@0.4.0 
  └── qcheck-actual@0.4.0  (git://github.com/npm-opam/qcheck.git#85bd0e35bec2987b301fa26235b97c1e344462df)
```
(Note: Sometimes it won't traverse `git` dependencies to find all the potentially installed
package. That's okay).

So we want to install that now, but *without* executing the install scripts so we
pass the `--ignore-scripts` flag. Without that flag, it would fail when running
the scripts again, and then remove the package again!

```sh
npm install --ignore-scripts @opam-alpha/qcheck@0.4.0
```

This will just install the source code, and let us know what it actually installed.

Ouput:
```
test@1.0.0 /Users/jwalke/Desktop/tmp
└─┬ @opam-alpha/qcheck@0.4.0 
  └── qcheck-actual@0.4.0  (git://github.com/npm-opam/qcheck.git#85bd0e35bec2987b301fa26235b97c1e344462df)
```

Now, make sure `npm` didn't do something weird with installing new versions of package
that didn't show up in the dry run, and make sure it installed things
as flat as possible in `node_modules`, as opposed to nesting `node_modules`
for compiled ocaml packages inside of other `node_modules`. Ideally, everything
is a flat list inside the `ExampleProject/node_modules` directory.

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


## Troubleshooting:
- Check to make sure everything is installed correctly. There's a `script`
  already setup that will help you test the location of where `Reason` has been
  compiled into.

- If something goes wrong, try deleting the local `node_modules` directory that
  was installed, and then try reinstalling using `npm install -f`.

```
npm run whereisocamlmerlin
```

## TODO:

- This also installs sandboxed IDE support for Vim/Atom/Emacs. We need to
  upgrade all of the plugins to automatically search for IDE plugins inside of
  the `./node_modules` directory.
