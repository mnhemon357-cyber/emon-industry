CFLAGS=-Wall -Wextra -Werror -std=c11 -O2
all: build/ringbuf
build/ringbuf: src/ringbuf.c
	@mkdir -p build && $(CC) $(CFLAGS) $< -o $@
test: all
	./build/ringbuf
