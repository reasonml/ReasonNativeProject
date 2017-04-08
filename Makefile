# topkg (https://github.com/dbuenzli/topkg) is a small native packager for your lib
# http://erratique.ch/software/topkg/doc/Topkg.html#basics
build:
	cp pkg/META.in pkg/META
	ocamlbuild -package topkg pkg/build.native
	./build.native build

# some boilerplate to publish a new version to GitHub
release:
	git add package.json opam
	git commit -m "Version $(version)"
	git tag -a $(version) -m "Version $(version)."
	git push "git@github.com:reasonml/ReasonNativeProject.git"
	git push "git@github.com:reasonml/ReasonNativeProject.git" tag $(version)

clean:
	ocamlbuild -clean

.PHONY: build release
