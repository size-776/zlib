# 20260924 zlib makefile

include ../EasyLib/EasyMake.mk

INCPATH= -I ../ #-I../sqlite3 -I../zlib 

ifeq ($(DETECTED_OS),Linux)
INCPATH += -I../openssl3/openssl-minimal/linux-x86_64/Debug/include
endif

ifeq ($(DETECTED_OS),Apple)
INCPATH += -I../openssl/build/clang_macos_x86_Debug/include
endif

EXTRALIBS=

SRCS= adler32.c compress.c crc32.c gzio.c uncompr.c deflate.c trees.c \
       zutil.c inflate.c infblock.c inftrees.c infcodes.c infutil.c inffast.c

OBJS = $(addprefix $(OUTPATH)/, $(notdir $(SRCS:.c=.o)))

DEPS = $(OBJS:.o=.d)

all: lib
#all: lib test

lib: ./$(OUTPATH)/libz.a

test: ./$(OUTPATH)/minigzip

clean:
	$(RM) ./$(OUTPATH)/libz.a ./$(OUTPATH)/*.o ./$(OUTPATH)/minigzip

./$(OUTPATH)/libz.a: $(OBJS)		
	$(AR) $(ARFLAGS)$(OUTPATH)/libz.a $(OBJS)
	$(MKDIR) ../lib/$(OUTPATH)
	$(CP) $(OUTPATH)/libz.a ../lib/$(OUTPATH)

# Regola per i file .c
$(OUTPATH)/%.o: %.c
	$(MKDIR) $(OUTPATH)
	$(CC) $(CFLAGS) $(INCPATH) $< $(OF)$@

./$(OUTPATH)/minigzip: minigzip.c ./$(OUTPATH)/libz.a
	$(CC) $(CFLAGS) $(INCPATH) -c minigzip.c -o ./$(OUTPATH)/minigzip.o
	$(CC) $(LFLAGS) ./$(OUTPATH)/minigzip.o ./$(OUTPATH)/libz.a -o ./$(OUTPATH)/minigzip
	chmod +x $(OUTPATH)/minigzip

-include $(DEPS)
