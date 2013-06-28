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


Example: BeagleBone Black
-------------------------

This run was perfromed on a [http://beagleboard.org/Products/BeagleBone%20Black](BeagleBone Black).

```
$ make -i
cc test.c -mfloat-abi=hard -O9 -std=c99 -march=armv7-a -mfpu=neon -o hard
cc test.c -mfloat-abi=soft -O9 -std=c99 -march=armv7-a -mfpu=neon -o soft
cc test.c -mfloat-abi=softfp -O9 -std=c99 -march=armv7-a -mfpu=vfpv3-d16 -o softfp-vfp
cc test.c -mfloat-abi=softfp -O9 -std=c99 -march=armv7-a -mfpu=neon -o softfp-neon
./soft 2.200002 2.200001 5
ans = 9.705820 1765 loop/msec
./softfp-vfp 2.200002 2.200001 5
ans = 9.705820 13776 loop/msec
./softfp-neon 2.200002 2.200001 5
ans = 9.705820 13771 loop/msec
./hard 2.200002 2.200001 5
ans = 9.705820 13767 loop/msec
./default 2.200002 2.200001 5
ans = 9.705820 13782 loop/msec
```

As you can see, all of the variations built and the *soft* version was
slow (not surprising), whlie all the others were quite fast.  The
difference is roughly a factor of 8.

Example: Gumstix SandSTORM COM
------------------------------

This run was performed on a [https://www.gumstix.com/store/product_info.php?products_id=279](Gumstix SandSTORM COM).

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
As you can see, the ARM processor on the SandSTORM doesn't have hard
floating point support, so that compilation fails.  But the other four
work.

Interestingly, the timing for the *softfp-vfp* and *softfp-neon* are
essentially identical.  Similarly, the timing for *default* and *soft*
are the same.

Example: Raspberry PI
---------------------

This run was performed on a first generation [http://www.raspberrypi.org/](Raspberry PI).

```
$ make -i
cc test.c -mfloat-abi=hard -O9 -std=c99 -march=armv7-a -mfpu=neon -o hard
cc test.c -mfloat-abi=soft -O9 -std=c99 -march=armv7-a -mfpu=neon -o soft
/usr/bin/ld: error: soft uses VFP register arguments, /tmp/ccrhwWtN.o does not
/usr/bin/ld: failed to merge target specific data of file /tmp/ccrhwWtN.o
collect2: ld returned 1 exit status
make: [soft] Error 1 (ignored)
cc test.c -mfloat-abi=softfp -O9 -std=c99 -march=armv7-a -mfpu=vfpv3-d16 -o softfp-vfp
/usr/bin/ld: error: softfp-vfp uses VFP register arguments, /tmp/ccguM7sh.o does not
/usr/bin/ld: failed to merge target specific data of file /tmp/ccguM7sh.o
collect2: ld returned 1 exit status
make: [softfp-vfp] Error 1 (ignored)
cc test.c -mfloat-abi=softfp -O9 -std=c99 -march=armv7-a -mfpu=neon -o softfp-neon
/usr/bin/ld: error: softfp-neon uses VFP register arguments, /tmp/cc378hRF.o does not
/usr/bin/ld: failed to merge target specific data of file /tmp/cc378hRF.o
collect2: ld returned 1 exit status
make: [softfp-neon] Error 1 (ignored)
cc test.c -O9 -std=c99 -march=armv7-a -o default
./soft 2.200002 2.200001 5
make: ./soft: Command not found
make: [all] Error 127 (ignored)
./softfp-vfp 2.200002 2.200001 5
make: ./softfp-vfp: Command not found
make: [all] Error 127 (ignored)
./softfp-neon 2.200002 2.200001 5
make: ./softfp-neon: Command not found
make: [all] Error 127 (ignored)
./hard 2.200002 2.200001 5
make: *** [all] Illegal instruction
./default 2.200002 2.200001 5
make: *** [all] Illegal instruction
```
As you can see, the PI is setup for hardware floating point, so only the
*default* and *hard* binaries built.  However, both failed to run and
generated an **Illegal instruction** exception.

