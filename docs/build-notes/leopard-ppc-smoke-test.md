# Leopard PPC Smoke Test

This note records the first successful LeoRM skeleton build on the target platform.

## Target

- Mac OS X 10.5.8 Leopard
- PowerPC
- MacOSX10.5.sdk
- Xcode 3.1.4 toolchain
- Foundation.framework
- libsqlite3

## Build path

```sh
make clean
make
make smoke
```

## Result

The LeoRM source skeleton builds warning-free on Leopard / PowerPC.

The smoke test runs successfully:

```text
LeoRM smoke test OK: test.sqlite
```

## Scope proven

This confirms Milestone 0 from the V1 roadmap:

- project source skeleton exists,
- Foundation-only Objective-C code builds,
- manual memory management is used,
- a static library can be produced,
- a minimal runtime smoke test can link against LeoRM,
- no AppKit dependency is required,
- no Core Data dependency is required.

## Notes

The Makefile is intentionally a small smoke-test build path.

It is not a replacement for a future Xcode 3.1.4 project. The Xcode project should be created or finalized on the real Leopard system so that Xcode writes a native project structure.
