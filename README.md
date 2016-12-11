# ReasonProject

Reason project environment via `npm`.

- Local sandboxed `Reason` projects.
- Installation of `Reason` tools globally.

Those two features may sound completely different, but the truth is that they
are very similar, and therefore it makes sense to have `ReasonProject` handle
both.

> A sandboxed environment models dependencies and builds them into a local
> directory so that it works reliably for anyone. Installing tools into your
> global environment is simply a matter of sourcing the sandboxed environment
> in your `.bashrc`. It's easy to make sandboxed local environments global, and
> very hard to do the reverse, so `ReasonProject` starts with local
> environments.


[![Build Status](https://travis-ci.org/reasonml/ReasonProject.svg?branch=master)](https://travis-ci.org/reasonml/ReasonProject)

## Get Started:

Install by cloning the repo and running `npm install`. This installs all
dependencies locally into the `ReasonProject` directory.

```sh
git clone https://github.com/reasonml/ReasonProject.git
cd ReasonProject
npm install
```

### Run, Change, Rebuild

There are a couple of built in commands declared in `package.json` that you can
execute via `npm run`. For example: `"npm run start"`, `"npm run reasonBuild"`
and `"npm run clean"`. You can also [add your
own](#reasonproject-get-started-add-your-own-scripts) commands.


```sh
npm run start        # Runs the compiled app
npm run reasonBuild  # Rebuilds after changing
npm run clean        # Clean if you need to!
```


### REPL

The `rtop` REPL is built into the sandbox, and the command `npm run top` which
starts the REPL is predefined in `package.json`.

```sh
# Opens `rtop` from the sandbox.
npm run top
```

### Environment Commands

Once built, `ReasonProject` generates an environment that you can temporarily
load to execute commands within. The environment contains an enhanced `PATH`
that contains binaries built by your dependencies, but this environment isn't
loaded automatically. To temporarily load this environment, execute the
predefined `npm run env --` command. You should pass the *actual* command you
want to run after `--`.

```sh

  npm run env -- which refmt

> ReasonProject/node_modules/reason/_build/ocamlfind/bin/refmt 

```

The previous command would likely fail if not prefixed with `npm run env --`
because the dependencies are the ones that built `refmt` in this case.  `npm
run env` makes all the things from our dependencies available.

### Editor Support

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
known issue where `atom` has problems loading, but you can fix it easily
by commenting out any part in your `bashrc` that sources opam environments.
We will come up with a long term solution at some point.

##### Just Using Global Paths

Pure sandboxed based development doesn't always work for certain workflows.
Prefixing *all* commands with `npm run env` may not work well. In that case,
you can easily inject your successfully built project's environment into the
global `PATH`, by putting the following in your `.bashrc`:

```sh
# In your .bashrc
pushd ~/pathTo/ReasonProject/ && \
  eval $(~/pathTo/ReasonProject/node_modules/.bin/dependencyEnv) && \
  popd
```


### Multiple Projects

You can have multiple clones/forks/builds of `ReasonProject` for each of your
projects. When you make changes, you can share the project easily with anyone
else. It's common to have multiple `ReasonProject`s simultaneously. If also
using global environment variables, it's wise to also have one special
`ReasonProject`, that is only used for augmenting the global path.

### Making It Your Project
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

> Note: Sometimes options `1` and `2` above fail because some *other* dependency that is
rebuilt as a result of the `install` was not designed to build in an idempotent manner.
In that case, just add the new dependency to your `package.json` `"dependencies"`,
`rm -r node_modules`, and then run `npm install`. This installs from a clean slate.


> Note: `opam-alpha` is "alpha" - we may move to a new namespace `opam-beta`
once we apply the lessons we've learned from `opam-alpha`. All the should exist
as they are, but a next generation `opam-beta` universe on `npm` would have
everything `opam-alpha` has (and then some). The work to upgrade your projects
will likely be minimal.


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


### Creating Reusable Libraries

- To turn this example project into a library that other people can depend on
  via `npm`... (coming soon).
  

### Debugging Failed Dependencies

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
  └── qcheck-actual@0.4.0  (git://github.com/npm-opam/qcheck.git
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
  └── qcheck-actual@0.4.0  (git://github.com/npm-opam/qcheck.git
```

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
