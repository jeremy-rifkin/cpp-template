#include "factorial.hpp"

#include <cstdlib>

#include <spdlog/spdlog.h>
#include <fmt/format.h>
#include <lyra/lyra.hpp>
#include <cpptrace/cpptrace.hpp>
#include <cpptrace/from_current.hpp>

void entry(int argc, char** argv) {
    int n = 0;
    bool show_help = false;
    auto cli = lyra::help(show_help)
                | lyra::opt(n, "n")["-n"]["--num"]("What number?").required();
    if(auto result = cli.parse({argc, argv}); !result || show_help) {
        std::cout<<cli<<std::endl;
        std::exit(0);
    }
    fmt::println("Factorial: {}", factorial(n));
}

int main(int argc, char** argv) {
    CPPTRACE_TRY {
        entry(argc, argv);
    } CPPTRACE_CATCH(const std::exception& e) {
        spdlog::error("Exception occurred: {}", e.what());
        cpptrace::from_current_exception().print();
    }
}
