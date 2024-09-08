#include "factorial.hpp"

#include <libassert/assert.hpp>

int factorial(int n) {
    ASSERT(n >= 0);
    if(n == 0) return 1;
    return n * factorial(n - 1);
}
