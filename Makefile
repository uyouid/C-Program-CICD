# ===== 設定 =====
CC := gcc
CXX := g++

CFLAGS := -Wall -Wextra -Werror -I./src
CXXFLAGS := -Wall -Wextra -Werror -I./src

# CppUTest
LDLIBS := -lCppUTest -lCppUTestExt

SRC_DIR := src
TEST_DIR := test
BUILD_DIR := build
BIN_DIR := bin

APP := $(BIN_DIR)/app
TEST := $(BIN_DIR)/test_runner

# ===== ソース =====
SRC_C := $(wildcard $(SRC_DIR)/*.c)
TEST_CPP := $(wildcard $(TEST_DIR)/*.cpp)

# main.cはテストから除外
SRC_C_NO_MAIN := $(filter-out $(SRC_DIR)/main.c, $(SRC_C))

# ===== オブジェクト =====
APP_OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRC_C))
TEST_OBJS := \
  $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRC_C_NO_MAIN)) \
  $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(TEST_CPP))

# ===== format files =====
FORMAT_FILES := $(shell find $(SRC_DIR) $(TEST_DIR) -type f \( -name '*.c' -o -name '*.cpp' -o -name '*.h' \))

# ===== デフォルト =====
all: $(APP)

# ===== アプリ =====
$(APP): $(APP_OBJS) | $(BIN_DIR)
	$(CC) $(APP_OBJS) -o $@

# ===== テスト =====
test: $(TEST)
	./$(TEST)

$(TEST): $(TEST_OBJS) | $(BIN_DIR)
	$(CXX) $(TEST_OBJS) -o $@ $(LDLIBS)

# ===== コンパイル =====
$(BUILD_DIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# ===== ディレクトリ =====
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# ===== clang-format =====
format:
	@echo "Formatting source files..."
	@if [ -n "$(FORMAT_FILES)" ]; then \
		clang-format -i $(FORMAT_FILES); \
	fi

# ===== クリーン =====
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

rebuild: clean all

# ===== 依存関係 =====
CFLAGS += -MMD -MP
CXXFLAGS += -MMD -MP
-include $(APP_OBJS:.o=.d)
-include $(TEST_OBJS:.o=.d)

.PHONY: all test clean rebuild format
