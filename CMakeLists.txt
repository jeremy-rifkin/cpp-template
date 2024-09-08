cmake_minimum_required(VERSION 3.15)

include(cmake/PreventInSourceBuilds.cmake)

project(
  projectname
  LANGUAGES C CXX
)

include(cmake/ProjectIsTopLevel.cmake)
include(cmake/NinjaColor.cmake)
include(cmake/Ccache.cmake)

# --------- Dependencies ---------

find_package(fmt REQUIRED)
find_package(spdlog REQUIRED)
find_package(lyra REQUIRED)
find_package(cpptrace REQUIRED)
find_package(libassert REQUIRED)

# --------- Presets ---------

set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG -march=native")
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG -march=native")

# TODO: Trace/gprof presets

# --------- Options ---------

set(
  COMMON_LIBS
  fmt::fmt
  spdlog::spdlog
  cpptrace::cpptrace
  libassert::assert
  bfg::lyra
)

set(
  WARNING_FLAGS
  $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wextra -Werror=return-type -Wundef>
  $<$<CXX_COMPILER_ID:GNU>:-Wuseless-cast -Wmaybe-uninitialized>
  $<$<CXX_COMPILER_ID:MSVC>:/W4 /permissive->
)

set(
  FLAGS
  -g
)

set(STD cxx_std_23)

set(
  DEFINITIONS
  SPDLOG_FMT_EXTERNAL
)

# --------- Binary/Library Creation ---------

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

include(CheckIPOSupported)
check_ipo_supported(RESULT HAS_LTO)
if(HAS_LTO)
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
endif()

function(apply_settings TARGET)
  target_link_libraries(${TARGET} PUBLIC ${COMMON_LIBS})
  target_compile_definitions(${TARGET} PUBLIC ${DEFINITIONS})
  target_compile_options(${TARGET} PUBLIC ${WARNING_FLAGS} ${FLAGS})
  target_compile_features(${TARGET} PUBLIC ${STD})
  target_include_directories(${TARGET} PUBLIC ${PROJECT_SOURCE_DIR}/src)
endfunction()

function(binary TARGET)
  cmake_parse_arguments(BINARY "" "" "SOURCES;LIBS;FLAGS;DEFS" ${ARGN})
  add_library(${TARGET}_OBJ OBJECT ${BINARY_SOURCES})
  apply_settings(${TARGET}_OBJ)
  add_executable(${TARGET} main.cpp)
  apply_settings(${TARGET})
  target_link_libraries(${TARGET} PUBLIC ${TARGET}_OBJ ${BINARY_LIBS})
  target_compile_definitions(${TARGET} PUBLIC ${BINARY_DEFS})
  target_compile_options(${TARGET} PUBLIC ${BINARY_FLAGS})
endfunction()

function(library TARGET)
  cmake_parse_arguments(LIBRARY "" "" "SOURCES;LIBS;FLAGS;DEFS" ${ARGN})
  add_library(${TARGET} STATIC ${LIBRARY_SOURCES})
  apply_settings(${TARGET})
  target_link_libraries(${TARGET} PUBLIC ${LIBRARY_LIBS})
  target_compile_definitions(${TARGET} PUBLIC ${LIBRARY_DEFS})
  target_compile_options(${TARGET} PUBLIC ${LIBRARY_FLAGS})
endfunction()

enable_testing()

add_subdirectory(src)
add_subdirectory(test)
add_subdirectory(benchmark)
