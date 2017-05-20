# This example project uses rebuild, which is a simple wrapper around
# ocamlbuild.
# Docs: https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc

all: byte library

byte:
	rebuild -use-ocamlfind src/ReasonNativeProject.byte

build:
	rebuild -use-ocamlfind src/ReasonNativeProject.cma
	rebuild -use-ocamlfind src/ReasonNativeProject.cmxa

# some boilerplate to publish a new version to GitHub
release:
	opam_of_packagejson.exe -gen-meta -gen-opam -gen-install package.json
	git add package.json opam
	git commit -m "Version $(version)"
	git tag -a $(version) -m "Version $(version)."
	git push "git@github.com:reasonml/ReasonNativeProject.git"
	git push "git@github.com:reasonml/ReasonNativeProject.git" tag $(version)

clean:
	rm -rf _build ReasonNativeProject.byte

.PHONY: build release
