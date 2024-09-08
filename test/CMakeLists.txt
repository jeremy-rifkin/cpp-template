find_package(GTest REQUIRED)

add_custom_target(all_tests)
function(test TARGET)
  cmake_parse_arguments(TEST "" "" "SOURCES;LIBS;FLAGS;DEFS" ${ARGN})
  add_executable(${TARGET}_test EXCLUDE_FROM_ALL ${TEST_SOURCES})
  apply_settings(${TARGET}_test)
  target_link_libraries(${TARGET}_test PUBLIC ${TEST_LIBS} gtest::gtest)
  target_compile_definitions(${TARGET}_test PUBLIC ${TEST_DEFS})
  target_compile_options(${TARGET}_test PUBLIC ${TEST_FLAGS})
  add_test(NAME ${TARGET}_test COMMAND ${TARGET}_test)
  add_dependencies(all_tests ${TARGET}_test)
endfunction()

test(
  factorial
  SOURCES
  factorial.cpp
  LIBS
  main_OBJ
)
