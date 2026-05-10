# LeoCatKit Scope

LeoCatKit is the shared media catalog brick for Leopard-Crew media applications.

It describes manageable media objects without deciding whether they are radio stations, podcast episodes, videos, or audiobooks.

LeoCatKit is not a player, not a stream engine, not a database engine, and not an application domain.

## Guiding Sentence

LeoRM stores records.

LeoCatKit organizes media.

LeoMediaKit plays media.

The applications give the media its domain meaning.

## Position in the Media Stack

```text
SQLite
  ↑
LeoRM
  ↑
LeoCatKit
  ↑
Applications:
  - LeoRadio
  - LeoCast
  - LeoTube
  - LeoLibrary

Parallel playback path:

Applications
  ↓
LeoMediaKit
  ↓
LeoStream
````

LeoCatKit sits between application domain objects and storage.

It may use LeoRM for persistence helpers, migrations, and SQLite access.

LeoCatKit must not depend on LeoMediaKit, LeoStream, LeoRadio, LeoCast, LeoTube, or LeoLibrary.

## Purpose

LeoCatKit provides a small, explicit vocabulary for media catalog management:

- catalog items
    
- media resources
    
- collections
    
- tags
    
- artwork references
    
- playback progress
    
- play history
    
- source provenance
    
- external identifiers
    

It exists to prevent every media application from rebuilding the same catalog logic.

## V1 Responsibilities

LeoCatKit V1 may define:

- `LCKItem`
    
- `LCKResource`
    
- `LCKCollection`
    
- `LCKTag`
    
- `LCKArtwork`
    
- `LCKProgress`
    
- `LCKHistoryEntry`
    
- `LCKSource`
    
- `LCKExternalID`
    
- neutral catalog persistence mapping
    
- basic validation rules
    
- basic schema ownership rules
    

LeoCatKit V1 should prove the model boundary, not build a complete media management platform.

## Non-Goals

LeoCatKit must not implement:

- audio or video playback
    
- stream transport
    
- buffering
    
- codec detection
    
- HTTP client behavior
    
- podcast subscription logic
    
- radio station directory logic
    
- YouTube or Invidious logic
    
- audiobook chapter semantics
    
- application UI policy
    
- user interface widgets
    
- VLC or QuickTime wrappers
    
- a general ORM
    
- a general database browser
    

## Domain Boundary

LeoCatKit may know that an item is a cataloged media object.

It must not decide what that object means in a specific application.

Examples:

```text
LeoRadio knows:    This item is a radio station.
LeoCast knows:     This item is a podcast episode.
LeoTube knows:     This item is a video.
LeoLibrary knows:  This item is an audiobook.
LeoCatKit knows:   This item is cataloged media.
```

## Storage Boundary

LeoCatKit may define schemas and storage mappings.

LeoCatKit must not expose raw SQLite calls as its public application-facing API.

Storage work should be routed through LeoRM or through explicit LeoCatKit store classes built on LeoRM.

Allowed public concepts:

```text
LCKItem
LCKResource
LCKCollection
LCKTag
LCKArtwork
LCKProgress
LCKCatalogStore
```

Avoid public leakage of raw storage mechanisms:

```text
sqlite3 *
sqlite3_stmt *
raw SQL strings as application API
```

Raw SQL may exist internally, but it must remain explicit, documented, and testable.

## Dependency Rules

Allowed:

```text
LeoCatKit -> LeoRM
Applications -> LeoCatKit
Applications -> LeoMediaKit
```

Forbidden:

```text
LeoCatKit -> LeoMediaKit
LeoCatKit -> LeoStream
LeoCatKit -> LeoRadio
LeoCatKit -> LeoCast
LeoCatKit -> LeoTube
LeoCatKit -> LeoLibrary
```

## Extraction Rule

Do not add features speculatively.

A LeoCatKit feature is justified when at least two independent media applications need the same catalog behavior.

Until then, domain-specific behavior stays in the application.

## Naming

Public Objective-C symbols should use the `LCK` prefix.

Examples:

```text
LCKItem
LCKResource
LCKCatalogStore
LCKProgress
```

The repository name is LeoCatKit.

The code prefix is `LCK`.

## First Version Lock

V1 is successful when an application can:

1. create a neutral catalog item,
    
2. attach one or more resources,
    
3. assign tags or collections,
    
4. store progress or history,
    
5. persist the catalog through LeoRM,
    
6. keep all domain meaning outside LeoCatKit.
    

No brick should pretend to be the whole system.