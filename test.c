#include "miniunit.h"

TEST_CASE(test01) {
  int result = 4;
  ASSERT(result > 5, "test01 failed!");
  // add more asserts if needed...
}

TEST_CASE(test02) {
  int result = 4;
  ASSERT(result == 4, "test01 failed!");
  ASSERT(result > 0, "test01 failed!");
  // add more asserts if needed...
}

TEST_MAIN {
  RUN_TEST(test01);
  RUN_TEST(test02);

  END(); // TODO this should return
}
