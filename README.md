# LCnix

More coming soon!

LCnix is heavily work in progress, and incomplete or incorrect parts may be enabled by default. 
 It is not recommended to install any part of LCnix to your primary operating system.
An exception is that many of the programs implemented by `lc-coreutils`
 are considered to be complete and correct. 
 You can usually safely build and install those programs in isolation (see building instructions for lc-coreutils in the associated subdirectory).
 It is recommended to run the test suite provided by it before installing to a location which supersedes or replaces the system tools. 

## Licenses

The lcnix kernel (under kernel),
 is licensed under the terms of the GNU General Public License v3
  or (at your option) any later version.
 It includes code from a modified version of the rust enumset crate,
 Dual Licensed Under the terms of the MIT License and Apache v2 License.
 The original fork can be found at <https://github.com/Lymia/enumset>. 
 Additionally the common code is written in the Rust Programming Language,
  and links against both rust's libcore and the compiler-builtins crate:
  <https://crates.io/crates/compiler_builtins>. 
  Both such libraries are dual licensed under the terms of the MIT License and Apachce v2 License

 libc (et al.)
  are all licensed under the terms of the GNU Lesser General Public License v3
  or (at your option) any later version.
  It contains code (arch/x86_64/crt/crt1.S and arch/x86_64/ld/crt1.S) which was copied
   and modified from glibc. The code is provided under the license above,
   additionally, you may distribute either file under the terms of the GNU Lesser General Public License v2.1 
   or (at your option) any later version, as provided in the original license. m
  
  systemd is Copyright to its Authors or otherwise lawful copyright holders,
   and is licensed under the terms of the GNU Lesser General Public License v2.1.
   
  It has been chosen to interpret the terms of that license as permitting
  any overall work using it to be licensed under the GNU General Public License, v3
  or any later version.
  
  lccc is subject to the licenses specified in its README. 