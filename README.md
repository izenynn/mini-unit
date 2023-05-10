# mini-unit

## Contents

- [Info](#info)
- [Usage](#usage)
- [Automatic tests execution](#automatic-tests-execution)
	- [With the provided Makefile](#with-the-provided-makefile)
	- [An example of a custom Makefile](#an-example-of-a-custom-makefile)
	- [Other](#other)

## Info

A simple unit test framework for C and ASM in C.

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

## Automatic tests execution

### With the provided Makefile

For unit testing I don't like to have the test files in a `tests/` folder, I prefer to put them next to the respective `.c` so I have both files at hand easily.

If you also like to place your tests with the original file, you can use the provided `Makefile` for automating your tests, just clone this project inside your project directory:
```bash
git clone --recurse-submodules https://github.com/izenynn/mini-unit.git
```

And assuming you project structure is as follows:
```
project/
├── ...
├── include/
├── src/
├── Makefile
└── mini-unit/
    ├── Makefile
    └── ...
```

add this to your project Makefile:
```makefile
# define the necessary variables

# mini-unit location :)
TEST_DIR := mini-unit

# your test files
TEST_SRC_FILES := \
		ft_strlen_test.c	\
		ft_strcmp_test.c
# in my case I have them inside a `src/` directory
TEST_SRC := $(addprefix $(SRC_DIR)/, $(TEST_SRC_FILES))
```
```makefile
# create a test rule and make sure you are providing the necessary values
#   - `SRC`: your project src files, in my case it would be something
#            like `src/ft_strlen.c src/ft_strcmp.c ...`
#
#   - `TEST_SRC`: test sources as showed above
#
#   - `RELATIVE_PATH`: the relative path to your project from the 'mini-unit'
#                      directory location.
#
#   - `INCLUDES`: mini-unit includes your project path with -I./$(RELATIVE_PATH)
#                 but if you compile your project with -I./<some_path>,
#                 add those paths here separated with spaces.
test:
	$(MAKE) -C $(TEST_DIR) SRC='$(SRC)' TEST_SRC='$(TEST_SRC)' RELATIVE_PATH='..' INCLUDES='include'

# update your clean rule
clean:
	$(MAKE) -C $(TEST_DIR) fclean
	# ...
```

*To check a working `Makefile`, you can check my `libasm` project `Makefile` [here](https://github.com/izenynn/libasm).*

And that's all, now run `make test` and have fun! :D

### An example of a custom Makefile

If the provided `Makefile` is not an option for your project, you would probably want to add some `test` rule to your project `Makefile`, here is a quick example assuming your test files follow the `*_test.c` naming convention:

```makefile
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
	echo "============================================================"; \
	echo "test summary"; \
	echo "============================================================"; \
	echo "# TOTAL: $$total"; \
	echo "# PASS:  $$success"; \
	echo "# FAIL:  $$failure"; \
	echo "============================================================";

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

### Other

This is a pretty simple test framework, is just some `.h` file, there are tons of ways to make it work with your project, so you can just use the `.h` and implement the automatic execution of the tests in a way that fits your project! :D

##

[![forthebadge](https://forthebadge.com/images/badges/made-with-c.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/makes-people-smile.svg)](https://forthebadge.com)
