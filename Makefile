# if your compiler doesn't support hard then use 'make -i'
# or comment out hard stuff here

HARD=-mfloat-abi=hard
# unimp -mapcs-float, needs gcc 4.5
SOFT=-mfloat-abi=soft
SOFTFP=-mfloat-abi=softfp
NEON=-mfpu=neon
VFP=-mfpu=vfpv3-d16
COMMON=-O9 -std=c99 -march=armv7-a

ARGS=2.200002 2.200001 5

all: hard soft softfp-vfp softfp-neon default
	./soft $(ARGS)
	./softfp-vfp $(ARGS)
	./softfp-neon $(ARGS)
	./hard $(ARGS)
	./default $(ARGS)

hard: test.c Makefile
	cc test.c $(HARD) $(COMMON) $(NEON) -o hard

soft: test.c Makefile
	cc test.c $(SOFT) $(COMMON) $(NEON) -o soft

softfp-vfp: test.c Makefile
	cc test.c $(SOFTFP) $(COMMON) $(VFP) -o softfp-vfp

softfp-neon: test.c Makefile
	cc test.c $(SOFTFP) $(COMMON) $(NEON) -o softfp-neon

default: test.c Makefile
	cc test.c $(COMMON) -o default
