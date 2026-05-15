# LeoRM V1 Leopard PPC Smoke Test

This note records the first complete LeoRM V1 storage-brick smoke test on the target platform.

## Target

- Mac OS X 10.5.8 Leopard
- PowerPC
- MacOSX10.5.sdk
- Xcode 3.1.4 toolchain
- Foundation.framework
- libsqlite3
- manual memory management

## Build path

```sh
make clean
make
make smoke
````

## Result

The LeoRM V1 core builds warning-free on Leopard / PowerPC.

The complete smoke-test suite runs successfully:

```text
LeoRM smoke test OK: test.sqlite
LeoRM error bridge OK: no such table: table_that_does_not_exist
LeoRM statement smoke test OK
LeoRM query smoke test OK
LeoRM transaction smoke test OK
LeoRM metadata smoke test OK
LeoRM migration smoke test OK
LeoRM repository smoke test OK
LeoRM NotesStore example OK
```

## Scope proven

This confirms the V1 roadmap up to the neutral integration example:

- SQLite errors are mapped to NSError.
    
- Databases can be opened and closed explicitly.
    
- Prepared statements support bound values.
    
- Query result rows can be read through Foundation values.
    
- Transactions support commit, rollback, and active-state checks.
    
- Metadata and schema versions are stored in `lrm_metadata`.
    
- Ordered migrations can be applied safely.
    
- Repository helpers support DAO-style access.
    
- A neutral NotesStore example can be built above LeoRM without adding domain logic to LeoRM itself.
    

## Doctrine confirmed

LeoRM remains:

- small,
    
- explicit,
    
- SQLite-honest,
    
- Foundation-shaped,
    
- Leopard-native,
    
- domain-neutral.  
    

