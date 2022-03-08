# ZapDragon LLVM
**ZLLVM** is a flavor of LLVM for x86 with minimal 
support for ARM, AArch64, and Native (x86) targets.
It is built with "Thin" Link Time Optimization and 
Profile-Guided Optimization (profiled specifically 
for building the ZapPi Kernel). The scripts to update 
and build ZapDragon are heavily based on/inspired by 
Debian's tools for creating 
[LLVM Snapshots](https://salsa.debian.org/pkg-llvm-team/llvm-toolchain.git).

**Projects enabled**
* [clang](https://clang.llvm.org/)
* [lld](https://lld.llvm.org/)
* [polly](https://polly.llvm.org/)

**Runtimes enabled** (used by default)
* [compiler-rt](https://compiler-rt.llvm.org/)
* [libc++](https://libcxx.llvm.org/)
* [libc++abi](https://libcxxabi.llvm.org/)
* [libunwind](https://github.com/llvm/llvm-project/tree/main/libunwind)

## Build
The kernel source for ZapPi Kernel is required to 
run the tests for PGO. It is recommended to clone it 
alongside this repo, although it can be configured by 
the `KERNEL_DIR` parameter.

Clone the repository:
```
git clone https://github.com/notcarbide/zllvm.git
```

Pull and patch the LLVM source:
```
cd zllvm && sh zap/pullsrc.sh
```

Start the build:
```
zap/pgo
```

Note that options can be configured via passing the 
parameter after zap/pgo, ex:
```
zap/pgo KERNEL_DIR=/my/kernel/dir KERNEL_BRANCH=example ARM_CRT=no
```

The separate zap/arm-crt script can be used to cross 
compile the compiler-rt runtime for ARM and AArch64, 
although it has [requirements](https://llvm.org/docs/HowToCrossCompileBuiltinsOnArm.html#prerequisites)
and will need to be configured to the local build env. 
All of the variables that might require modifying should 
be noted within the `zap/arm-crt` file. Can be disabled 
via the ARM_CRT parameter (see above).
