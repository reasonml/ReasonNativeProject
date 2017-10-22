build:
	# jbuilder requires at least a dummy opam file.
	touch reason-native-project.opam
	jbuilder build -p reason-native-project -j 4

run: build
	./_build/install/default/bin/reason-native-bin

install: build
	jbuilder install --prefix=$$cur__install

test:
	jbuilder runtest

# some boilerplate to publish a new version to GitHub
release:
	git add package.json opam
	git commit -m "Version $(version)"
	git tag -a $(version) -m "Version $(version)."
	git push "git@github.com:reasonml/ReasonNativeProject.git"
	git push "git@github.com:reasonml/ReasonNativeProject.git" tag $(version)

clean:
	rm -rf _install _build *.install *.opam

.PHONY: build release test
