# LeoCatKit Schema Map

This document sketches the first SQLite-oriented schema map for LeoCatKit.

The schema is not final API.

It is a reference for explicit persistence work through LeoRM.

## Principles

The schema must be:

- explicit
- inspectable
- migration-friendly
- usable on Mac OS X 10.5.8 Leopard
- compatible with SQLite 3.4.0 constraints where practical
- friendly to SQLeoS inspection
- free of application-domain assumptions

## Tables

```text
lck_items
lck_resources
lck_collections
lck_collection_items
lck_tags
lck_item_tags
lck_artwork
lck_progress
lck_history
lck_sources
lck_external_ids
lck_meta
````

## lck_meta

Stores schema metadata.

```sql
CREATE TABLE lck_meta (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
```

Required keys:

```text
schema_name
schema_version
created_by
created_at
updated_at
```

## lck_items

```sql
CREATE TABLE lck_items (
    uuid TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    subtitle TEXT,
    summary TEXT,
    sort_title TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    last_used_at TEXT,
    favorite INTEGER NOT NULL DEFAULT 0,
    archived INTEGER NOT NULL DEFAULT 0,
    rating INTEGER,
    primary_artwork_uuid TEXT,
    primary_resource_uuid TEXT,
    source_uuid TEXT
);
```

## lck_resources

```sql
CREATE TABLE lck_resources (
    uuid TEXT PRIMARY KEY,
    item_uuid TEXT NOT NULL,
    kind TEXT NOT NULL,
    url TEXT,
    local_path TEXT,
    mime_type TEXT,
    codec_hint TEXT,
    duration_seconds REAL,
    byte_size INTEGER,
    checksum TEXT,
    is_primary INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

## lck_collections

```sql
CREATE TABLE lck_collections (
    uuid TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    summary TEXT,
    kind TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

## lck_collection_items

```sql
CREATE TABLE lck_collection_items (
    collection_uuid TEXT NOT NULL,
    item_uuid TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    added_at TEXT NOT NULL,
    PRIMARY KEY (collection_uuid, item_uuid)
);
```

## lck_tags

```sql
CREATE TABLE lck_tags (
    uuid TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    normalized_name TEXT NOT NULL,
    source_uuid TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

## lck_item_tags

```sql
CREATE TABLE lck_item_tags (
    item_uuid TEXT NOT NULL,
    tag_uuid TEXT NOT NULL,
    added_at TEXT NOT NULL,
    PRIMARY KEY (item_uuid, tag_uuid)
);
```

## lck_artwork

```sql
CREATE TABLE lck_artwork (
    uuid TEXT PRIMARY KEY,
    item_uuid TEXT,
    collection_uuid TEXT,
    url TEXT,
    local_path TEXT,
    mime_type TEXT,
    width INTEGER,
    height INTEGER,
    checksum TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

## lck_progress

```sql
CREATE TABLE lck_progress (
    uuid TEXT PRIMARY KEY,
    item_uuid TEXT NOT NULL,
    resource_uuid TEXT,
    position_seconds REAL NOT NULL DEFAULT 0,
    duration_seconds REAL,
    completed INTEGER NOT NULL DEFAULT 0,
    completed_at TEXT,
    updated_at TEXT NOT NULL
);
```

## lck_history

```sql
CREATE TABLE lck_history (
    uuid TEXT PRIMARY KEY,
    item_uuid TEXT NOT NULL,
    resource_uuid TEXT,
    event_kind TEXT NOT NULL,
    event_at TEXT NOT NULL,
    position_seconds REAL,
    duration_seconds REAL,
    context TEXT
);
```

## lck_sources

```sql
CREATE TABLE lck_sources (
    uuid TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    kind TEXT NOT NULL,
    url TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

## lck_external_ids

```sql
CREATE TABLE lck_external_ids (
    uuid TEXT PRIMARY KEY,
    item_uuid TEXT NOT NULL,
    system_name TEXT NOT NULL,
    external_id TEXT NOT NULL,
    external_url TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

## Suggested Indexes

```sql
CREATE INDEX idx_lck_items_title ON lck_items(title);
CREATE INDEX idx_lck_items_sort_title ON lck_items(sort_title);
CREATE INDEX idx_lck_items_favorite ON lck_items(favorite);
CREATE INDEX idx_lck_resources_item_uuid ON lck_resources(item_uuid);
CREATE INDEX idx_lck_resources_kind ON lck_resources(kind);
CREATE INDEX idx_lck_collection_items_item_uuid ON lck_collection_items(item_uuid);
CREATE INDEX idx_lck_tags_normalized_name ON lck_tags(normalized_name);
CREATE INDEX idx_lck_item_tags_tag_uuid ON lck_item_tags(tag_uuid);
CREATE INDEX idx_lck_progress_item_uuid ON lck_progress(item_uuid);
CREATE INDEX idx_lck_history_item_uuid ON lck_history(item_uuid);
CREATE INDEX idx_lck_external_ids_item_uuid ON lck_external_ids(item_uuid);
CREATE INDEX idx_lck_external_ids_system_external ON lck_external_ids(system_name, external_id);
```

## Migration Rule

Schema changes must be explicit.

A migration must state:

```text
from_version
to_version
reason
SQL changes
rollback expectations
data preservation notes
```

LeoRM should execute migrations transactionally where possible.

SQLeoS should be able to inspect the schema version and run integrity checks.

## Domain Extension Rule

Applications may create their own domain tables.

Examples:

```text
LeoRadio:
  lr_stations

LeoCast:
  lc_feeds
  lc_episodes

LeoTube:
  lt_videos

LeoLibrary:
  ll_audiobooks
```

Domain tables may reference `lck_items.uuid`.

LeoCatKit must not absorb those domain tables.

