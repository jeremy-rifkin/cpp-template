#include <benchmark/benchmark.h>

#include "factorial.hpp"

static void Factorial(benchmark::State& state) {
    int values[] = {1, 0, 5, 10, 2, 7};
    std::size_t i = 0;
    for (auto _ : state) {
        benchmark::DoNotOptimize(factorial(values[i]));
        i++;
        if(i == std::size(values)) {
            i = 0;
        }
    }
}
BENCHMARK(Factorial);

BENCHMARK_MAIN();
