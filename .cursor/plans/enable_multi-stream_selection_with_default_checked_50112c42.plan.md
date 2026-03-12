---
name: Enable multi-stream selection with default checked
overview: Modify XDF Streamer to enable checking multiple streams and make all valid streams checked by default when an XDF file is loaded.
todos:
  - id: "1"
    content: Change default check state from Unchecked to Checked for valid streams in on_pushButtonLoad_clicked()
    status: completed
  - id: "2"
    content: Set stream_ready = true after loading if valid streams exist
    status: completed
  - id: "3"
    content: Verify on_treeWidgetXDF_itemClicked() properly handles multiple checked streams
    status: completed
---

# Enable Multi-Stream Selection with Default Checked State

## Current Behavior

- When an XDF file is loaded, streams are added to the tree widget with `Qt::Unchecked` state (line 336 in `xdfstreamer.cpp`)
- The streaming code already supports multiple checked streams (lines 420-432 loop through all items)
- The `stream_ready` flag is only set to `true` when a user manually clicks to check a stream

## Changes Required

### 1. Set All Valid Streams to Checked by Default

**File**: `XdfStreamer/xdfstreamer.cpp`

- **Location**: `on_pushButtonLoad_clicked()` function, around line 336
- **Change**: Modify `item->setCheckState(0, Qt::Unchecked)` to `item->setCheckState(0, Qt::Checked)` for valid (non-string) streams
- **Note**: String streams should remain unchecked/disabled as they're not supported for streaming

### 2. Set stream_ready Flag When Loading

**File**: `XdfStreamer/xdfstreamer.cpp`

- **Location**: `on_pushButtonLoad_clicked()` function, after populating the tree widget
- **Change**: After the loop that creates tree items (after line 370), check if any valid streams exist and set `stream_ready = true` if so
- This ensures the "Stream" button is enabled immediately after loading if there are valid streams

### 3. Update Item Click Handler for Multiple Streams

**File**: `XdfStreamer/xdfstreamer.cpp`

- **Location**: `on_treeWidgetXDF_itemClicked()` function (lines 464-486)
- **Change**: The current logic already supports multiple streams (it loops through all items), but we should ensure it properly handles the case when all streams are checked by default
- The function already sets `stream_ready = true` if any valid checked stream exists, which is correct behavior

## Implementation Details

The code already supports multiple stream selection in the streaming logic (lines 420-432). The main changes are:

1. Default state: Change from unchecked to checked for valid streams
2. Initial state: Set `stream_ready = true` after loading if valid streams exist
3. No changes needed to the streaming loop - it already handles multiple checked streams correctly

## Files to Modify

- `XdfStreamer/xdfstreamer.cpp` - Update `on_pushButtonLoad_clicked()` to check streams by default and set `stream_ready` flag