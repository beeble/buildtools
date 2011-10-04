# --- Fetch and extract each package ---

setphase "FETCH BINUTILS"
wget $WFLAGS http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.bz2
tar -xf binutils-${BINUTILS_VER}.tar.bz2

setphase "FETCH GCC"
wget $WFLAGS http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-core-${GCC_VER}.tar.gz
tar -xf gcc-core-${GCC_VER}.tar.gz
wget $WFLAGS http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-g++-${GCC_VER}.tar.gz
tar -xf gcc-g++-${GCC_VER}.tar.gz
wget $WFLAGS http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-fortran-${GCC_VER}.tar.gz
tar -xf gcc-fortran-${GCC_VER}.tar.gz

setphase "FETCH GMP"
wget $WFLAGS http://ftp.gnu.org/gnu/gmp/gmp-${GMP_VER}.tar.gz
tar -xf gmp-${GMP_VER}.tar.gz

setphase "FETCH MPFR"
wget $WFLAGS http://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VER}.tar.gz
tar -xf mpfr-${MPFR_VER}.tar.gz

setphase "FETCH MPC"
wget $WFLAGS http://www.multiprecision.org/mpc/download/mpc-${MPC_VER}.tar.gz
tar -xf mpc-${MPC_VER}.tar.gz

setphase "FETCH NEWLIB"
wget $WFLAGS ftp://sources.redhat.com/pub/newlib/newlib-${NEWLIB_VER}.tar.gz
tar -xf newlib-${NEWLIB_VER}.tar.gz

if [ $EXTRAS -eq 1 ]; then
setphase "FETCH PPL"
wget $WFLAGS ftp://ftp.cs.unipr.it/pub/ppl/releases/${PPL_VER}/ppl-${PPL_VER}.tar.bz2
tar -xf ppl-${PPL_VER}.tar.bz2

setphase "FETCH CLooG"
wget $WFLAGS http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-${CLOOG_VER}.tar.gz -O cloog-${CLOOG_VER}.tar.gz
tar -xf cloog-${CLOOG_VER}.tar.gz
fi

# --- Patch and push new code into each package ---

# Fix patches with osname
#PERLCMD="s/{{OSNAME}}/${OSNAME}/g"
#perl -pi -e $PERLCMD *.patch
#perl -pi -e $PERLCMD gcc-files/gcc/config/os.h

# diff -rupN


setphase "PATCH BINUTILS"
patch -p0 -d binutils-${BINUTILS_VER} < ../binutils.patch || exit
cp ../binutils-files/ld/emulparams/os_x86_64.sh binutils-${BINUTILS_VER}/ld/emulparams/${OSNAME}_x86_64.sh

setphase "PATCH GMP"
patch -p1 -d gmp-${GMP_VER} < ../gmp.patch || exit

setphase "PATCH MPFR"
patch -p0 -d mpfr-${MPFR_VER} < ../mpfr.patch || exit

setphase "PATCH MPC"
patch -p0 -d mpc-${MPC_VER} < ../mpc.patch || exit

if [ $EXTRAS -eq 1 ]; then
setphase "PATCH PPL"
patch -p0 -d ppl-${PPL_VER} < ../ppl.patch || exit

setphase "PATCH CLOOG"
patch -p0 -d cloog-${CLOOG_VER} < ../cloog.patch || exit
fi

setphase "PATCH GCC"
patch -p0 -d gcc-${GCC_VER} < ../gcc.patch || exit
cp ../gcc-files/gcc/config/os.h gcc-${GCC_VER}/gcc/config/${OSNAME}.h

setphase "PATCH NEWLIB"
patch -p0 -d newlib-${NEWLIB_VER} < ../newlib.patch || exit
mkdir -p newlib-${NEWLIB_VER}/newlib/libc/sys/${OSNAME}
cp -r ../newlib-files/* newlib-${NEWLIB_VER}/newlib/libc/sys/${OSNAME}/.
cp ../newlib-files/vanilla-syscalls.c newlib-${NEWLIB_VER}/newlib/libc/sys/${OSNAME}/syscalls.c
