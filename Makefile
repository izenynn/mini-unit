# **************************************************************************** #
#                                   COMPILER                                   #
# **************************************************************************** #

RM = rm -rf
MKDIR = mkdir -p

CC = gcc
CPPFLAGS =
CFLAGS = -Wall -Wextra -Werror -Wpedantic -Wshadow -O2

CFLAGS += $(addprefix -I./, $(RELATIVE_PATH)/$(INCLUDES))

# **************************************************************************** #
#                                    DIRS                                      #
# **************************************************************************** #

OBJ_DIR = obj
TEST_DIR = tests

# **************************************************************************** #
#                                   SOURCES                                    #
# **************************************************************************** #

OBJ = $(addprefix $(OBJ_DIR)/, $(SRC:.c=.o))

TEST_OBJ = $(addprefix $(OBJ_DIR)/, $(TEST_SRC:.c=.o))

TEST_BIN = $(addprefix $(TEST_DIR)/, $(TEST_SRC:%_test.c=%.test))
	
SRC = $(addprefix $(RELATIVE_PATH)/, $(SRC))

# **************************************************************************** #
#                                    RULES                                     #
# **************************************************************************** #

SILENT := all
PHONY := all
all: test

SILENT += test
PHONY += test
test: $(TEST_BIN)
	total=0; passs=0; fail=0; \
	echo; \
	for test in $^; do \
		./$$test; \
		exit_code=$$?; \
		if [ $$exit_code -eq 0 ]; then \
			pass=$$((pass+1)); \
		else \
			fail=$$((fail+1)); \
		fi; \
		total=$$((total+1)); \
	done; \
	echo "============================================================"; \
	echo "test summary"; \
	echo "============================================================"; \
	echo "# TOTAL: $$total"; \
	echo "# PASS:  $$pass"; \
	echo "# FAIL:  $$fail"; \
	echo "============================================================";

$(OBJ_DIR)/%.o: $(RELATIVE_PATH)/%.c
	@$(MKDIR) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(TEST_DIR)/%.test: %_test.o $(filter-out %_test.o, $(OBJ))
	@$(MKDIR) $(dir $@)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

PHONY += clean
clean:
	$(RM) $(OBJ_DIR)

PHONY += fclean
fclean: clean
	$(RM) $(TEST_DIR)

.SECONDARY: $(TEST_OBJ)

.SILENT: $(SILENT)
.PHONY: $(PHONY)
