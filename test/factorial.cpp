#include <libassert/assert-gtest.hpp>

#include "factorial.hpp"

TEST(Factorial, Basic) {
    ASSERT(factorial(0) == 1);
    ASSERT(factorial(1) == 1);
    ASSERT(factorial(4) == 24);
    ASSERT(factorial(5) == 120);
}
