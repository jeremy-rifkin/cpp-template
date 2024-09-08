from conan import ConanFile
from conan.tools.cmake import cmake_layout

class Package(ConanFile):
    settings = "os", "arch", "compiler", "build_type"
    generators = "CMakeDeps", "CMakeToolchain"

    def requirements(self):
        # Core dependencies
        self.requires("fmt/10.2.1")
        self.requires("spdlog/1.14.1")
        self.requires("lyra/1.6.1")
        self.requires("cpptrace/0.7.0", force=True)
        self.requires("libassert/2.1.0")
        # Testing etc
        self.requires("gtest/1.14.0")
        self.requires("benchmark/1.9.0")

        # Conflicts:
        ## handle conflicts here with self.requires("package/version", override=True)

    def build_requirements(self):
        pass

    def layout(self):
        cmake_layout(self)
