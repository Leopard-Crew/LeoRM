# LeoRM Leopard PPC HeaderDoc Build

This note records the first successful warning-free HeaderDoc build for LeoRM on the target platform.

## Target

- Mac OS X 10.5.8 Leopard
- PowerPC
- Xcode 3.1.4 toolchain
- Apple HeaderDoc tools
- Foundation.framework
- libsqlite3

## Build path

```sh
make apidocs
````

## Result

HeaderDoc generation completes successfully on Leopard / PowerPC.

The generated documentation is written to:

```text
Build/HeaderDoc/raw
```

The generated HTML documentation is a build artifact and is not committed to the repository.

It belongs in release archives, not in `main`.

## Scope proven

This confirms the API-culture requirement for LeoRM:

- public headers contain HeaderDoc-style API documentation,
    
- the API documentation can be generated on the target platform,
    
- HeaderDoc warnings are treated as release-blocking,
    
- private SQLite internals are kept out of the public HeaderDoc API surface,
    
- generated documentation remains reproducible from source.
    

## Release meaning

This build note supports the `v0.1.1-api-culture` release line.  

