# **************************************************************************** #
#                                   COMPILER                                   #
# **************************************************************************** #

RM = rm -rf
MKDIR = mkdir -p

AS = nasm
ASFLAGS = -f macho64

CC = gcc
CPPFLAGS =
CFLAGS = -Wall -Wextra -Werror -Wpedantic -Wshadow -O2

CFLAGS += -I./ $(addprefix -I./, $(RELATIVE_PATH)/$(INCLUDES))

# **************************************************************************** #
#                                    DIRS                                      #
# **************************************************************************** #

OBJ_DIR = obj
TEST_DIR = tests

# **************************************************************************** #
#                                   SOURCES                                    #
# **************************************************************************** #

OBJ := $(addprefix $(OBJ_DIR)/, $(patsubst %.s,%.o,$(patsubst %.c,%.o,$(SRC))))

TEST_OBJ := $(addprefix $(OBJ_DIR)/, $(TEST_SRC:.c=.o))

TEST_BIN := $(addprefix $(TEST_DIR)/, $(TEST_SRC:%_test.c=%.test))
	
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

$(TEST_DIR)/%.test: $(OBJ_DIR)/%_test.o $(filter-out %_test.o, $(OBJ))
	@$(MKDIR) $(dir $@)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

$(OBJ_DIR)/%.o: $(RELATIVE_PATH)/%.s
	@$(MKDIR) $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(RELATIVE_PATH)/%.c
	@$(MKDIR) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

PHONY += clean
clean:
	$(RM) $(OBJ_DIR)

PHONY += fclean
fclean: clean
	$(RM) $(TEST_DIR)

.SECONDARY: $(OBJ) $(TEST_OBJ)

.SILENT: $(SILENT)
.PHONY: $(PHONY)
