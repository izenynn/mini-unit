#ifndef MINIUNIT_MINIUNIT_H_
#define MINIUNIT_MINIUNIT_H_

#include <string.h>
#include <stdio.h>
#include <stdbool.h>

#define C_OFF   "\033[0m"
#define C_GREEN "\033[0;32m"
#define C_RED   "\033[0;31m"

static struct {
  unsigned int  total_tests;
  unsigned int  passed_tests;
  unsigned int  failed_tests;
  bool          current_test_success;
  const char*   current_test_name;
} test_stats = { 0, 0, 0, true, NULL };

#define ASSERT(test, message) do { \
    if (!(test)) { \
      printf( \
          C_RED "FAIL" C_OFF ": %s: %s\n", \
          test_stats.current_test_name, \
          message); \
      test_stats.current_test_success = false; \
    } \
  } while (0)

#define RUN_TEST(test) do { \
    ++test_stats.total_tests; \
    test_stats.current_test_success = true; \
    test_stats.current_test_name = #test; \
    test(); \
    if (test_stats.current_test_success) { \
      ++test_stats.passed_tests; \
    } else { \
      ++test_stats.failed_tests; \
    } \
  } while (0)


// for the actual width we'll substract:
// - the __FILE__ len
// - 2 for the spaces on the sides
// - 2 for the "ok/ko" text
#define WIDTH (int)50
#define END() do { \
  int file_width = (int)strlen(__FILE__) >= WIDTH - 4 \
      ? WIDTH - 4 \
      : (int)strlen(__FILE__); \
  int dots_width = (int)strlen(__FILE__) >= WIDTH - 4 \
      ? 0 \
      : WIDTH - (int)strlen(__FILE__) - 4; \
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
  static void test(void)

#define TEST_MAIN \
  int main(void)

#endif // MINIUNIT_MINIUNIT_H_
