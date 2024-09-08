A basic C++ template for a project using CMake, ninja, and conan.

Philosophy: It should be as easy as `make build`.

To build and set everything up, run `make build`. This automatically handles a python virtual environment, installing
conan, installing packages, configuring cmake, and building. To produce a release build, run `make release`. To test,
run `make test`. To get rid of everything, run `make clean`. Run `make` to see a list of all commands.

In case of conan dependency conflicts, the conan dependency graph is rendered to `build/conangraph.html`.

`-g` is used always, both in debug and release.

Other notes:
- `ccache` is used if available
- Internal project libraries will use LTO
