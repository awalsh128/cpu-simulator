######################################################################## 
# file       : CPU Simulator Makefile
# author     : Andrew Walsh (alwalsh)
########################################################################

SHELL=/bin/bash

EXE = cpusim

CC = gcc
CFLAGS = -g -Wall -pedantic -lm --std=gnu99
CSOURCES = main.c signal.c gate.c gatedriver.c alu.c memory.c mux.c \
			rcadder.c regfileaccess.c control.c assembler.c loader.c
CHEADERS = signal.h gate.h gatedriver.h alu.h memory.h mux.h rcadder.h \
			regfileaccess.h control.h assembler.h loader.h
COBJECTS = ${CSOURCES:.c=.o} 
SCCFILES = ${CSOURCES} ${CHEADERS} Makefile README test.asm
DEPSFILE = Makefile.deps
MEMCHECK = valgrind --leak-check=full --track-origins=yes
NODEPS = backup spotless clean memcheck

all: ${EXE}

${EXE}: ${COBJECTS}
	${CC} ${CFLAGS} -o $@ ${COBJECTS}

deps: ${CSOURCES}
	${CC} -E -MM ${CSOURCES} > ${DEPSFILE}

${DEPSFILE}: 
	@ touch ${DEPSFILE}
	${MAKE} --no-print-directory deps

backup:
	tar -cvf cpu-simulator.tar ${SCCFILES}

check: all splint memcheck

spotless: clean
	rm -f ${EXE}

clean:
	rm -fr ${DEPSFILE} ${COBJECTS}

memcheck:
	${MEMCHECK} ./${EXE} ${DATAFILE}

ifeq "${filter ${NODEPS}, ${MAKECMDGOALS}}" ""
include ${DEPSFILE}
endif
