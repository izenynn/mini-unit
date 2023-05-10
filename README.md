# mini-unit

## Info

A simple unit test framework for C in C.

## Usage

For unit testing I don't like to have the test files in a `tests/` folder, I prefer to put them next to the respective `.c` so I have both files at hand easily.

So, I usually add the following to my `Makefile`, take it as a reference for your own needs:

```Makefile
# ... CC, CFLAGS, RM, MKDIR, ...

SRC_DIR := src
OBJ_DIR := obj
TEST_DIR := tests

SRC_FILES := # ...
TEST_SRC_FILES := # ...

OBJ_FILES := $(SRC:.c=.o)
TEST_OBJ_FILES = $(TEST_SRC:.c:.o)

SRC := $(addprefix $(SRC_DIR)/, $(SRC_FILES))
OBJ := $(addprefix $(OBJ_DIR)/, $(OBJ_FILES))
TEST_SRC := $(addprefix $(TEST_DIR)/, $(TEST_SRC_FILES))
TEST_OBJ := $(addprefix $(OBJ_DIR)/, $(TEST_OBJ_FILES))

TEST_BIN = $(patsubst $(SRC_DIR)/%,$(TEST_DIR)/%,$(TEST_SRC:.c=.test))

# ...

test: $(TEST_BIN)
    for test in $^; do ./$$test; done

$(TEST_DIR)/%_test.test: $(OBJ_DIR)/%_test.o $(OBJ) | $(TEST_DIR)
    $(CC) $(CFLAGS) -o $@ $^

$(TEST_DIR):
    $(MKDIR) $@

clean:
    $(RM) $(OBJ_DIR) $(TEST_DIR)
    # ...

.PHONY: test #...
```

##

[![forthebadge](https://forthebadge.com/images/badges/made-with-c.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/makes-people-smile.svg)](https://forthebadge.com)
