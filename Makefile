#cpp projects

#dependencies



#toolchains
CXXFLAGS := -g -Wall -Isrc
LDFLAGS := 


#exectuables
SRC_DIR := src
OBJ_DIR := $(patsubst src%,obj%, $(SRC_DIR))
SRCS := $(wildcard $(addsuffix /*.cpp, $(SRC_DIR)))
OBJS := $(patsubst src/%.cpp,obj/%.o, $(SRCS))
DEPS := $(patsubst src/%.cpp,obj/%.d, $(SRCS))

MAIN_EXEC := bin/main
MAIN_SRCS := $(SRCS)
MAIN_OBJS := $(patsubst src/%.cpp,obj/%.o, $(MAIN_SRCS)) 


#targets
.PHONY: all build run clean distclean
all: run


build: $(MAIN_EXEC)

$(MAIN_EXEC): $(MAIN_OBJS)
#	@echo objs: $(MAIN_OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS)

include $(DEPS) Makefile.dep

obj/%.d: src/%.cpp
	$(CXX) $(CXXFLAGS) -MM -MT "$(patsubst src/%.cpp,obj/%.o, $<) $@" -MF "$@" $<

obj/%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

Makefile.dep:
	mkdir bin
	mkdir $(OBJ_DIR)
	touch Makefile.dep


run: build
	$(MAIN_EXEC)


clean:
	rm $(MAIN_EXEC)
	rm $(OBJS)

distclean:
	rm -R bin
	rm -R obj
	rm Makefile.dep


