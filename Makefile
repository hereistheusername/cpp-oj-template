TARGET?=main
INPUT=example${num}
EXPECTATION=example${num}

CXX:=g++
LD:=g++
LDFLAGS:=
CXXFLAGS:= -Wall -Wextra -g -std=c++20 

BUILDDIR:=build
INPUTDIR:=inputs
OUTPUTDIR:=outputs# folder to store expected outputs
SRCDIR:=src

SRCEXT:=.cpp
OBJEXT:=.o

ifneq ($(wildcard $(SRCDIR)),)
SRCS=$(shell find $(SRCDIR) -type f -name '$(TARGET)$(SRCEXT)' )
endif
ifdef SRCS
OBJS=$(shell echo $(SRCS) | sed -e s/$(SRCDIR)/$(BUILDDIR)/g -e s/$(SRCEXT)/$(OBJEXT)/g) 
endif

all: run

.PHONY: init

init: | $(BUILDDIR) $(SRCDIR) $(INPUTDIR) $(OUTPUTDIR)
	@make mktpl
	@make mkcompjson

mktpl: | $(SRCDIR)
	@echo "Generating src/main.cpp ..."
	@echo "#include <algorithm>"															 > $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <array>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <cassert>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <cfloat>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <cmath>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <cstddef>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <cstdint>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <cstdio>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <cstring>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <deque>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <forward_list>"															>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <functional>"															>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <ios>"																	>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <iterator>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <numeric>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <iostream>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <list>"																	>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <map>"																	>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <stack>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <stdexcept>"															>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <string>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <queue>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <string_view>"															>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <unordered_map>"														>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <utility>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <variant>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <vector>"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "#include <bit> "																	>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo ""																				>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo ""																				>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "static int32_t t{1};"															>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo ""																				>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "inline void solve() {"															>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "    // TODO: code here"															>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "}"																				>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo ""																				>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "int main() {"																	>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "    std::ios_base::sync_with_stdio(false);"										>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "    std::cin.tie(nullptr);"														>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "    // cout.tie(nullptr);       /* cout is tied to nullptr by default. */"		>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "    cin >> t;"																	>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "    for (; t-- > 0; ) {"															>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "        "																		>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "        solve();"																>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "    }"																			>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "    return 0;"																	>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "}"																				>> $(SRCDIR)/$(TARGET)$(SRCEXT)
	@echo "Done."

mkcompjson: $(BUILDDIR)
	@echo "Generating build/compile_commands.json ..."
	@echo "[\n{"																												 > $(BUILDDIR)/compile_commands.json
	@echo '  "directory": "$(realpath $(BUILDDIR))",'																			>> $(BUILDDIR)/compile_commands.json
	@echo '  "command": "$(realpath $(CXX)) $(CXXFLAGS) -o $(realpath $(BUILDDIR))/$(TARGET)$(OBJEXT) -c $(realpath $(SRCS))",'	>> $(BUILDDIR)/compile_commands.json
	@echo '  "file": "$(realpath $(SRCS))",'																					>> $(BUILDDIR)/compile_commands.json
	@echo '  "output": "$(realpath $(BUILDDIR))/$(TARGET)$(SRCEXT)"'															>> $(BUILDDIR)/compile_commands.json
	@echo "}\n]"																												>> $(BUILDDIR)/compile_commands.json
	@echo "Done."


# create pair of test case
# usage: make mkex [num=(a number)]
mkex: | $(INPUTDIR) $(OUTPUTDIR)
	@echo "Please enter input and enter EOF or ctrl-D to escape:"
	@cat << EOF > ./$(INPUTDIR)/$(INPUT)
	@while read line; do \
		if [ "$$line" = "EOF" ]; then \
			break; \
		fi; \
		echo "$$line" >> ./$(INPUTDIR)/$(INPUT); \
	done

	@echo "Please enter expected output and enter EOF or ctrl-D to escape:"
	@cat << EOF > ./$(OUTPUTDIR)/$(INPUT)
	@while read line; do \
		if [ "$$line" = "EOF" ]; then \
			break; \
		fi; \
		echo "$$line" >> ./$(OUTPUTDIR)/$(INPUT); \
	done
	@echo "Record example done."

test: mkex diff

diff:
	@make run | diff --ignore-blank-lines --side-by-side $(OUTPUTDIR)/$(EXPECTATION) - || true
	@echo "Diff done."

run: $(TARGET)
	@./$(BUILDDIR)/$(TARGET) < ./$(INPUTDIR)/$(INPUT)


$(TARGET): $(OBJS)
	@$(LD) $(LDFLAGS) -L$(BUILDDIR) -o $(BUILDDIR)/$@ $^

$(OBJS): $(BUILDDIR)/%$(OBJEXT) : $(SRCDIR)/%$(SRCEXT) | $(BUILDDIR)
	@$(CXX) $(CXXFLAGS) -o $@ -c $?

$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

$(INPUTDIR):
	@mkdir -p $(INPUTDIR)

$(OUTPUTDIR):
	@mkdir -p $(OUTPUTDIR)

$(SRCDIR):
	@mkdir -p $(SRCDIR)
