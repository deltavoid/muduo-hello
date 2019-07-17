#cpp projects

#dependencies

MUDUO_DIRECTORY ?= /home/zqy/WorkSpace/Muduo/build/release-install-cpp11
#MUDUO_DIRECTORY ?= $(HOME)/build/install
MUDUO_INCLUDE = $(MUDUO_DIRECTORY)/include
MUDUO_LIBRARY = $(MUDUO_DIRECTORY)/lib

#toolchains
#CXXFLAGS := -g -Wall -Isrc
#LDFLAGS := 
CXXFLAGS = -std=c++11 -g -O0 \
       -Wall -Wextra -Werror \
	   -Wconversion -Wno-unused-parameter \
	   -Wold-style-cast -Woverloaded-virtual \
	   -Wpointer-arith -Wshadow -Wwrite-strings \
	   -march=native -rdynamic \
	   -I$(MUDUO_INCLUDE)

LDFLAGS = -L$(MUDUO_LIBRARY) -lmuduo_net -lmuduo_base -lpthread -lrt


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


