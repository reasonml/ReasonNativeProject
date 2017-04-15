# This example project uses rebuild, which is a simple wrapper around
# ocamlbuild.
# Docs: https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc

build:
	rebuild -use-ocamlfind src/index.native

# some boilerplate to publish a new version to GitHub
release:
	git add package.json opam
	git commit -m "Version $(version)"
	git tag -a $(version) -m "Version $(version)."
	git push "git@github.com:reasonml/ReasonNativeProject.git"
	git push "git@github.com:reasonml/ReasonNativeProject.git" tag $(version)

clean:
	rm -rf _build
	rm index.native

.PHONY: build release
