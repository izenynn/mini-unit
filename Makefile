# **************************************************************************** #
#                                   COMPILER                                   #
# **************************************************************************** #

IS_CPP ?= false

RM = rm -rf
MKDIR = mkdir -p

AS = nasm
ASFLAGS = -f macho64

CC ?= gcc
CXX ?= g++

CFLAGS ?= -Wall -Wextra -Werror -Wpedantic -Wshadow
CXXFLAGS ?= -Wall -Wextra -Werror -Wpedantic -Wshadow

COMMON_FLAGS += -I./ -I./$(RELATIVE_PATH) $(addprefix -I./, $(RELATIVE_PATH)/$(INCLUDES))
COMMON_FLAGS += -DRELATIVE_PATH="\"$(RELATIVE_PATH)\""

CFLAGS += $(COMMON_FLAGS)
CXXFLAGS += $(COMMON_FLAGS)

# **************************************************************************** #
#                                    DIRS                                      #
# **************************************************************************** #

OBJ_DIR = obj
TEST_DIR = tests

# **************************************************************************** #
#                                   SOURCES                                    #
# **************************************************************************** #

OBJ := $(addprefix $(OBJ_DIR)/, $(foreach ext,s c cpp, $(SRC:%.$(ext)=%.o)))

TEST_OBJ := $(addprefix $(OBJ_DIR)/, $(foreach ext,c cpp, $(TEST_SRC:%.$(ext)=%.o)))

TEST_BIN := $(addprefix $(TEST_DIR)/, $(foreach ext,c cpp, $(TEST_SRC:%_test.$(ext)=%.test)))
	
# **************************************************************************** #
#                                    RULES                                     #
# **************************************************************************** #

SILENT := all
PHONY := all
all: check

SILENT += check
PHONY += check
check: $(TEST_BIN)
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
	echo; \
	echo "=================================================="; \
	echo "test summary"; \
	echo "=================================================="; \
	echo "# TOTAL: $$total"; \
	echo "# PASS:  $$pass"; \
	echo "# FAIL:  $$fail"; \
	echo "=================================================="; \
	echo;

$(TEST_DIR)/%.test: $(OBJ_DIR)/%_test.o $(filter-out %_test.o, $(OBJ))
	@$(MKDIR) $(dir $@)
ifeq ($(IS_CPP), true)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)
else
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)
endif

$(OBJ_DIR)/%.o: $(RELATIVE_PATH)/%.s
	@$(MKDIR) $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(RELATIVE_PATH)/%.c
	@$(MKDIR) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(RELATIVE_PATH)/%.cpp
	@$(MKDIR) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

PHONY += clean
clean:
	$(RM) $(OBJ_DIR)

PHONY += fclean
fclean: clean
	$(RM) $(TEST_DIR)

.SECONDARY: $(OBJ) $(TEST_OBJ)

.SILENT: $(SILENT)
.PHONY: $(PHONY)
