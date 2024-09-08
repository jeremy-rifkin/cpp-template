find_package(benchmark REQUIRED)

add_custom_target(all_benchmarks)
function(benchmark TARGET)
  cmake_parse_arguments(BENCH "" "" "SOURCES;LIBS;FLAGS;DEFS" ${ARGN})
  add_executable(${TARGET}_bench EXCLUDE_FROM_ALL ${BENCH_SOURCES})
  apply_settings(${TARGET}_bench)
  target_link_libraries(${TARGET}_bench PUBLIC ${BENCH_LIBS} benchmark::benchmark_main)
  target_compile_definitions(${TARGET}_bench PUBLIC ${BENCH_DEFS})
  target_compile_options(${TARGET}_bench PUBLIC ${BENCH_FLAGS})
  add_dependencies(all_benchmarks ${TARGET}_bench)
endfunction()

benchmark(
  factorial
  SOURCES
  factorial.cpp
  LIBS
  main_OBJ
)
