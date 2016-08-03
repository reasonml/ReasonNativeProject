# ExampleProject

## Reason via `npm`

Example project using Reason as an `npm` dependency.

> Note: This example will be rapidly changing. It is not officially supported
> yet. Always reclone the repo each time you try it out (rebasing is not
> sufficient).

## Get Started:

```
git clone https://github.com/reasonml/ExampleProject.git
cd ExampleProject
npm install
npm run test
```


### What's happening
- `npm install` will download and install all your dependencies, and run the
  `postinstall` steps for all of those dependencies, and then finally the
  `postinstall` script step of this project.
- `npm run test` will run the script located in the `test` field of the
  `scripts` section of the `package.json` file here. The `test` script simply
  runs the binary that was built in the `postinstall` step.
- No, really - all you need is `npm` (> `3.0`). All of the compiler infrastructure
  has been organized into `npm` packages, and will be compiled on your host
  inside of the `./node_modules` directory. No `PATH`s are poluted. No global
  environment variables destroyed. No trace is left on your system. If you
  delete the `./node_modules` directory, you're back to exactly where you
  started.


### How to customize
- To change how this project is built, change the `postinstall` script. You're
  guaranteed that the `postinstall` script executes *after* all of your
  dependencies' `postinstall` steps.
- You can add new scripts in the `package.json` `scripts` field. Name them
  whatever you want.  Once added, you can then do `npm run scriptName` from
  within the project root.
- `dependency-env` is used to create sandboxed environment variables that are
  only temporarily modified while running `scripts`. Your dependencies export
  environment variables (or augment the `PATH` variable) with locations to
  their binaries. That is why inside of every script, you'll see `.
  dependencyEnv && rest-of-the-command`. `. dependencyEnv` sources (via the
  `.`) a file that will set up all your environment variables for the duration
  of running the rest of the command.

### Recompiling
- To recompile this package (but not your dependencies), remove the local build
  artifacts for this package (usually just the `_build` directory) and then run
  `npm run postinstall`.

### How to turn this project into a library

- To turn this example project into a library that other people can depend on
  via `npm`... (coming soon).

### Troubleshooting:
- Check to make sure everything is installed correctly. There's a `script`
  already setup that will help you test the location of where `Reason` has been
  compiled into.

```
npm run whereisreason
```

### TODO:

- This also installs sandboxed IDE support for Vim/Atom/Emacs. We need to
  upgrade all of the plugins to automatically search for IDE plugins inside of
  the `./node_modules` directory.

