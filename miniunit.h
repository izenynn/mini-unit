#ifndef MINIUNIT_MINIUNIT_H_
#define MINIUNIT_MINIUNIT_H_

#include "colors.h"

#include <string.h>
#include <stdio.h>
#include <stdbool.h>

static struct {
  unsigned int total_tests;
  unsigned int passed_tests;
  unsigned int failed_tests;
  bool current_test_success;
} test_stats = { 0, 0, 0, true };

// TODO print RUN_TEST name
#define ASSERT(test, message) do { \
    if (!(test)) { \
      printf(C_RED "FAIL:" C_OFF " %s\n", message); \
      test_stats.current_test_success = false; \
    } \
  } while (0)

#define RUN_TEST(test) do { \
    ++test_stats.total_tests; \
    test_stats.current_test_success = true; \
    test(); \
    if (test_stats.current_test_success) { \
      ++test_stats.passed_tests; \
    } else { \
      ++test_stats.failed_tests; \
    } \
  } while (0)

#define WIDTH (int)50
// we'll substract:
// - the __FILE__ len
// - 2 for the spaces on the sides
// - 2 for the "ok/ko" text

#define END() do { \
  int file_width = strlen(__FILE__) >= WIDTH - 4 \
      ? WIDTH - 4 \
      : strlen(__FILE__); \
  int dots_width = strlen(__FILE__) >= WIDTH - 4 \
      ? 0 \
      : WIDTH - strlen(__FILE__) - 4; \
  printf( \
      "%.*s %.*s", \
      file_width, \
      __FILE__, \
      dots_width, \
      ".................................................."); \
  if (test_stats.failed_tests == 0) { \
    printf(" " C_GREEN "ok" C_OFF); \
  } else { \
    printf(" " C_RED "ko" C_OFF); \
  } \
  printf( \
      "     (" C_GREEN "%d" C_OFF "/" C_RED "%d" C_OFF ")\n", \
      test_stats.passed_tests, \
      test_stats.failed_tests); \
  return ((test_stats.failed_tests == 0) ? 0 : 1); \
} while (0)

#define TEST_CASE(test) \
  void test(void)

#define TEST_MAIN \
  int main(void)

#endif // MINIUNIT_MINIUNIT_H_
