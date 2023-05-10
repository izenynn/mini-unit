# mini-unit

## Info

A simple unit test framework for C in C.

## Usage

This project aims to keep unit testing simple, so its pretty easy to use.

First, create a test `.c` file, for unit testing I don't like to have the test files in a `tests/` directory, I prefer to put them next to the respective `.c` so I have both files at hand easily.

Usually a name it `*_test.c`, so for the `foo.c` file I would create `foo_test.c`.

First include the library:
```c
#include "miniunit.h"
// ... other includes
```
*Note: don't forget to compile with `-I./MINI_UNIT_DIR`*

Then, add a `TEST_MAIN` and make sure you call the `END()` macro at the end:
```c
#include "miniunit.h"

TEST_MAIN {
    END();
}
```

Now, you can add `TEST_CASE`s and `ASSERT`s inside them, and call them from `TEST_MAIN` using `RUN_TEST`:
```c
#include "miniunit.h"

TEST_CASE(foo) {
    int bar = 42;
    ASSERT(bar == 42, "bar is not 42!");
}

TEST_MAIN {
    RUN_TEST(foo);
    END();
}
```

Of course you can scale this all you want, you can call multiple `ASSERTS` in one `TEST_CASE`, do more `TEST_CASE`s, and since this is just C with macros, you can do whatever you want.

Just renember to call the `TEST_CASE`s using `RUN_TEST`, and to call `END()` at the end.

*For a complete usage example, you can check my `libasm` project [here](https://github.com/izenynn/libasm), in which I use `mini-unit` to test the functions of the library.*

## Automating your tests

For unit testing I don't like to have the test files in a `tests/` folder, I prefer to put them next to the respective `.c` so I have both files at hand easily.

Now you would probably want to add some `test` rule to your Makefile, here is a quick example:
For a complete and more *beautiful* example, you can check my `libasm` project `Makefile` [here](https://github.com/izenynn/libasm), in which I use `mini-unit` to test the functions of the library.

```Makefile
CC = gcc
CFLAGS = -Wall -Werror -Wextra
SRC = $(wildcard src/*.c)
TEST_SRC = $(wildcard src/*_test.c)
OBJ = $(SRC:.c=.o)
TEST_OBJ = $(TEST_SRC:.c=.o)
TEST_BIN = $(patsubst src/%,tests/%,$(TEST_SRC:.c=.test))

all: $(OBJ)

test: $(TEST_BIN)
	@total=0; success=0; failure=0; \
	for test in $^; do \
		./$$test; \
		exit_code=$$?; \
		if [ $$exit_code -eq 0 ]; then \
			success=$$((success+1)); \
		else \
			failure=$$((failure+1)); \
		fi; \
		total=$$((total+1)); \
	done; \
	echo "Total tests: $$total"; \
	echo "Successful tests: $$success"; \
	echo "Failed tests: $$failure"

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

tests/%_test.test: src/%_test.o $(filter-out %_test.o, $(OBJ))
	@mkdir -p tests
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) $(TEST_OBJ)
	rm -rf tests

.PHONY: all clean test
.SECONDARY: $(TEST_OBJ)
```

For a complete and more *beautiful* example, you can check my `libasm` project `Makefile` [here](https://github.com/izenynn/libasm), in which I use `mini-unit` to test the functions of the library.

##

[![forthebadge](https://forthebadge.com/images/badges/made-with-c.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/makes-people-smile.svg)](https://forthebadge.com)
