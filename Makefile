build:
	ocamlbuild -package topkg pkg/build.native
	./build.native build

release:
	git add package.json opam
	git commit -m "Version $(version)"
	git tag -a $(version) -m "Version $(version)."
	# Push first the objects, then the tag.
	git push "git@github.com:reasonml/ReasonProject.git"
	git push "git@github.com:reasonml/ReasonProject.git" tag $(version)

clean:
	ocamlbuild -clean

.PHONY: build release
