# ReasonNativeProject (esy mode)

[`Reason`](http://reasonml.github.io/) native project using
[`esy`](https://github.com/esy-ocaml/esy).

- `esy` is like `yarn` but for native packages.
- `esy` lets you develop in a sandbox, so it doesn't conflict with your global
  environment.
- `esy` makes native development rapid.

This project demonstrates:

- Building a native executable.
- Building an standard native library which can be used by any other Reason/OCaml
  application.

[![Build Status](https://travis-ci.org/reasonml/ReasonNativeProject.svg?branch=master)](https://travis-ci.org/reasonml/ReasonNativeProject)

## Building `ReasonNativeProject`:

- **Install `esy` globally**
```
npm install -g esy
```

- **Clone this repo**

```sh
git clone https://github.com/reasonml/ReasonNativeProject.git
cd ReasonNativeProject
git checkout -b DEV origin/esyport
```

- **Use `esy` to install dependencies and build everything**
```sh
esy install  # Like npm install, downloads sources.
esy build    # Build dependencies and ReasonNativeProject.
```

> The first time you build this project, it might take a few minutes. The next
> time you build this or any similar project, `esy` will make sure it builds
> very quickly by sharing build artifacts across all projects.

### Run The Result:

`esy` creates a symlink to the final location where the build result was
installed (`_install`) where you can see everything produced by this project's
build.

Run the binary `reason-native-bin`:
```sh
./_install/bin/reason-native-bin
```

Look at the shared libraries:
```sh
ls ./_install/lib/reason-native-project/
```

### That's It (mostly)!

That covers the main workflow for building and testing an example Reason Native
Project with `esy`. The rest of this `README` shows what's going on under the
hood, and how to extend the project, or how to speed things up.

### Running Commands In Your Sandbox:

`esy build` builds the current directory project and stores all of its
artifacts in `node_modules/.cache/`. Locally building with `esy build` won't
"install" your projects globally - the build is entirely contained in this
project's sandbox, which is located in `node_modules/.cache/`.

`esy` let's you easily run commands within that sandbox as if you had installed
this project globally. After running `esy build`, you can run `esy my command`,
which will run `my command` from the perspective of a user who installed your
project and all its dependencies globally. For example, instead of running
`./_install/bin/reason-native-bin`, you can run `esy reason-native-bin` because
if someone installed your project globally, they'd have immediate access to
`reason-native-bin`.

Try some of the following commands to see how `esy` creates an isolated build
environment that is protected from your global environment.


```sh
esy echo "hello"
esy ocamlfind list
esy sh -c 'echo $PATH'
esy which ocamlopt
```

### Debugging The Build Environment:

If something is going wrong in your build, you can run `esy build-shell` and
enter a shell that closely resembles the environment your project is built
within.

### Make Changes And Rebuild:

Make some code changes, and simply rebuild as you did previously to test that
they compile.

```sh
esy build
```

### How This Project Is Built:

As you can see in the `package.json`, this project's `esy build` is configured
to run `make build` and then `make install`.

`make build` invokes the build system `jbuilder` which is listed as a project
dependency. `make install` will "install" into the `cur__install` location
which is setup by `esy` (that's where that `_install` symlink points to).  When
developing your project with `esy build`, `cur__install` points to the sandbox
in `node_modules/.cache`, but `cur__install` will point to "real" install
locations during a "real install".

### Faster Rebuilds:

`esy build` is reliable, and very fast for large projects, but for more rapid
rebuilds, you can run your project's individual build commands prefixed with
"`esy`":

After you've ran `esy build` at least once, you can then run the following
commands in this particular project:

```sh
esy make build    # build/rebuild your files
esy make install  # install into esy install location.
esy make clean    # clean the compiled artifacts
```

Other projects might have different build commands, but this example project
uses a `Makefile` with `make build` and `make clean`, and `make install`.

> Temporary Bug: Before running these faster incremental rebuild commands,
> you'll have to delete the symlink `_build` that `esy` created when you ran
> `esy build`.

### Npm Releases Made `esy`.

`esy` has the ability to create prebuilt binary packages which can be installed
with `npm` or `yarn` - consumers of these releases don't need to have `esy`
installed.

```sh
esy release bin
```

That will create a directory at `./_release/your-platform` you can upload to an
`npm` package, or push to a `git` tag of your choosing. This release is built
for your platform, and you will need to create a separate release for any other
platforms you wish to support.


### Inside The `package.json` File:

`esy` projects must include a `package.json` with some special configuration.
Let's examine the interesting parts of this project's `package.json`:

##### Build and Install Commands:

- Native `esy` packages must have a field called `"esy"` which must include a
  `"build"` field. The `"build"` field tells `esy` how the package should be
  built, and installed. Note: `esy` isn't a build system, it simply _invokes_
  the build system of your choice. Almost all of your `Makefile` driven
  packages will have the exact same config as this project.
- The `"buildsInSource"` field tells `esy` that this package builds its
  artifacts inside the source tree. `esy` uses this information to speed up
  caching.

```json
{
  ...
  "esy": {
    "build": [
      [ "make", "build" ],
      [ "sh", "-c", "(opam-installer --prefix=$cur__install || true)" ]
    ],
    "buildsInSource": true
  },
  ...
}
```

##### Native Dependencies:

This project demonstrates how `esy` allows depending on native packages that
are hosted on `opam`. The `@opam-alpha` prefix tells `esy install` to
dynamically fetch these dependencies from the official `opam` service. There is
no mirror involved - it's pulling from `opam` directly. Once someone pushes a
package to `opam`, you have immediate access to it from your `package.json` -
no one needs to convert it to `esy`.

```json
{
  ...
  "dependencies": {
    "substs": "esy-ocaml/substs",
    "opam-installer-bin": "esy-ocaml/opam-installer-bin",
    "@opam-alpha/jbuilder": "*",
    "@opam-alpha/reason": "1.13.*",
    "@opam-alpha/re": "*"
  },
  ...
}
```

##### Depending On The Native Compiler:

`peerDependencies` and `devDependencies` are standard `npm`/`yarn` concepts.
They happen to be very useful for specifying compiler version requirements.
(Notice how we did not specify the version of the compiler in the standard
`dependencies` field above). This is how you should specify a dependency on a
native compiler.

- `peerDependencies` specifies your acceptable range of compiler versions.
- `devDependencies` specifies the version that should be used if building your
  project for distribution or release.


```json
{
  ...
  "peerDependencies": {
    "ocaml": " >= 4.2.0  < 4.5.0"
  },
  "devDependencies": {
    "ocaml": "esy-ocaml/ocaml#4.2.3+esy"
  }
}
```


### Creating Libraries

See the [OPAM instructions](https://opam.ocaml.org/doc/Packaging.html).

## Troubleshooting

In general, if something goes wrong, try upgrading your install of the project
by running `opam upgrade ReasonNativeProject`, or if it failed to install and you
later fixed it, `opam install ReasonNativeProject`.
