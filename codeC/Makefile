TARGET = c_wire

CC = gcc
CFLAGS = -Wall -Wextra -g


SRCDIR = ./codeC
BINDIR = ./bin
INPUTDIR = ./input
TESTDIR = ./tests
TMPDIR = ./tmp

SRCS = $(SRCDIR)/main.c $(SRCDIR)/avl.c
OBJS = $(SRCS:.c=.o)

all: $(BINDIR)/$(TARGET)

$(BINDIR):
	mkdir -p $(BINDIR)

$(BINDIR)/$(TARGET): $(OBJS) | $(BINDIR)
	$(CC) $(CFLAGS) -o $@ $^

$(SRCDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(SRCDIR)/*.o $(BINDIR)/$(TARGET)

mrproper: clean
	rm -rf $(TMPDIR)/* $(TESTDIR)/*

$(SRCDIR)/main.o: $(SRCDIR)/avl.h
$(SRCDIR)/avl.o: $(SRCDIR)/avl.h
