# LeoCatKit Object Model

This document defines the first neutral object model for LeoCatKit.

LeoCatKit does not model radio, podcasts, videos, or audiobooks directly.

It models cataloged media objects.

## Core Objects

```text
LCKItem
  central catalog object

LCKResource
  playable, downloadable, or external media resource

LCKCollection
  group of catalog items

LCKTag
  descriptive label

LCKArtwork
  image associated with an item or collection

LCKProgress
  playback or usage progress

LCKHistoryEntry
  playback/use event

LCKSource
  provenance of imported or created catalog data

LCKExternalID
  stable identifier from an external system
````

## LCKItem

`LCKItem` represents one cataloged media object.

Examples outside LeoCatKit:

```text
Radio station
Podcast episode
YouTube video
Audiobook
Audiobook chapter
Local audio file
```

LeoCatKit does not decide which one it is.

Suggested fields:

```text
uuid
title
subtitle
summary
sortTitle
createdAt
updatedAt
lastUsedAt
favorite
archived
rating
primaryArtworkUUID
primaryResourceUUID
sourceUUID
```

## LCKResource

`LCKResource` describes where media data comes from.

A resource may point to:

```text
local file
remote URL
stream URL
download URL
cached file
feed enclosure
resolved media URL
```

Suggested fields:

```text
uuid
itemUUID
kind
url
localPath
mimeType
codecHint
durationSeconds
byteSize
checksum
isPrimary
createdAt
updatedAt
```

Resource kinds:

```text
stream
file
download
enclosure
thumbnail
webpage
unknown
```

## LCKCollection

`LCKCollection` groups items.

Examples outside LeoCatKit:

```text
radio favorites
podcast subscription folder
watch queue
audiobook series
manual playlist
```

Suggested fields:

```text
uuid
title
summary
kind
sortOrder
createdAt
updatedAt
```

Collection membership should be stored separately.

## LCKTag

`LCKTag` is a neutral descriptive label.

Examples:

```text
jazz
news
german
favorite
sci-fi
lecture
```

Suggested fields:

```text
uuid
name
normalizedName
sourceUUID
createdAt
updatedAt
```

Tag assignment should be stored separately.

## LCKArtwork

`LCKArtwork` represents an image reference.

It may be remote or cached locally.

Suggested fields:

```text
uuid
itemUUID
collectionUUID
url
localPath
mimeType
width
height
checksum
createdAt
updatedAt
```

## LCKProgress

`LCKProgress` stores progress without knowing the domain.

Examples outside LeoCatKit:

```text
episode heard position
video watch position
audiobook chapter position
```

Suggested fields:

```text
uuid
itemUUID
resourceUUID
positionSeconds
durationSeconds
completed
completedAt
updatedAt
```

For live radio streams, progress may be absent.

## LCKHistoryEntry

`LCKHistoryEntry` records usage.

Suggested fields:

```text
uuid
itemUUID
resourceUUID
eventKind
eventAt
positionSeconds
durationSeconds
context
```

Event kinds:

```text
played
stopped
completed
imported
updated
opened
```

## LCKSource

`LCKSource` records where catalog information came from.

Examples outside LeoCatKit:

```text
Radio Browser
OPML import
folder import
manual entry
Invidious instance
local metadata scan
```

Suggested fields:

```text
uuid
name
kind
url
createdAt
updatedAt
```

## LCKExternalID

`LCKExternalID` links local items to external systems.

Suggested fields:

```text
uuid
itemUUID
systemName
externalID
externalURL
createdAt
updatedAt
```

Examples:

```text
Radio Browser station UUID
Podcast episode GUID
YouTube video ID
local file inode/path fingerprint
```

## Domain Mapping Examples

```text
LeoRadioStation
  LCKItem
  LCKResource(stream)
  LCKTag
  LCKArtwork
  LCKExternalID

LeoCastEpisode
  LCKItem
  LCKResource(enclosure)
  LCKProgress
  LCKArtwork
  LCKExternalID

LeoTubeVideo
  LCKItem
  LCKResource(webpage/resolved media)
  LCKArtwork(thumbnail)
  LCKProgress
  LCKExternalID

LeoLibraryAudiobook
  LCKItem
  LCKCollection
  LCKResource(file)
  LCKProgress
  LCKArtwork
```

## Rule

LeoCatKit stores structure.

Applications provide meaning.

