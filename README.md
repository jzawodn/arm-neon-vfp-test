arm-neon-vfp-test
=================

Simple test code to benchmark the VFP floating point or NEON units of
ARM processors.

I found some code online when researching how to compile code to take
advantage of the NEON units that some ARM processors have built-in.  The
code was in a thread on the BeagleBoard discussion board here:

https://groups.google.com/forum/#!searchin/beagleboard/neon/beagleboard/o6eMqw8oq4I/UIRR1aYMGXMJ

I am just republishing it here on github to make it easier for other
folks to find and work with.

The basic idea is that it runs some basic multiplication and division in
a tight loop.  Once complete, the test program outputs the answer and
some timing information (measure in loops per millisecond).

```
./default 2.200002 2.200001 5
ans = 9.705820 1373 loop/msec
```

The Makefile supplies the 3 starting values as seen on the first line,
and the test program emits the second line.

Usage
-----

On an ARM system with a C compile and standard toolchain, you can just
type `make -i` and it'll compile and run.  It will attempt to build the
same code as 5 different binaries that differ only in their compile-time
flags:

   * hard
   * soft
   * softfp-vfp
   * softfp-neon
   * default

On most platforms you won't be able to build all of them.  In any case,
once built, the Makefile will then run each of them.

Example: Raspberry PI
---------------------

Example: BeagleBone Black
-------------------------

Example: Gumstix SandSTORM COM
------------------------------

```
$ make -i
cc test.c -mfloat-abi=hard -O9 -std=c99 -march=armv7-a -mfpu=neon -o hard
/usr/bin/ld: error: /tmp/cc4GAeku.o uses VFP register arguments, hard does not
/usr/bin/ld: failed to merge target specific data of file /tmp/cc4GAeku.o
collect2: ld returned 1 exit status
make: [hard] Error 1 (ignored)
cc test.c -mfloat-abi=soft -O9 -std=c99 -march=armv7-a -mfpu=neon -o soft
cc test.c -mfloat-abi=softfp -O9 -std=c99 -march=armv7-a -mfpu=vfpv3-d16 -o softfp-vfp
cc test.c -mfloat-abi=softfp -O9 -std=c99 -march=armv7-a -mfpu=neon -o softfp-neon
./soft 2.200002 2.200001 5
ans = 9.705820 1371 loop/msec
./softfp-vfp 2.200002 2.200001 5
ans = 9.705820 9973 loop/msec
./softfp-neon 2.200002 2.200001 5
ans = 9.705820 9955 loop/msec
./hard 2.200002 2.200001 5
make: ./hard: Command not found
make: [all] Error 127 (ignored)
./default 2.200002 2.200001 5
ans = 9.705820 1373 loop/msec
```

