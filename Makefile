build:
	jbuilder build

run: build
	./_build/install/default/bin/reason-native-bin

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
	rm -rf _build *.install

.PHONY: build release test
