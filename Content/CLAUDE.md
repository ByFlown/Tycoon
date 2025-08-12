# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a UEFN (Unreal Editor for Fortnite) tycoon game built with Verse. The system implements a multi-player tycoon experience where players claim plots, purchase upgrades, and generate automated income through multiple currencies.

## Core Architecture

### Three-Layer System Design
- **Game Manager** (`game_manager.verse`): Handles persistent player data, currency management, and cross-session saves
- **Tycoon Manager** (`Tycoon_Manager.verse`): Controls individual tycoon instances, purchases, animations, and gameplay mechanics  
- **UI Manager** (`UIManager.verse`): Manages real-time currency display and player interface

### Multi-Currency Economy
The system uses three currencies with distinct purposes:
- **Cash**: Primary purchasing currency (white display)
- **Gems**: Premium rewards currency (green display)  
- **Rebirth Tokens**: Rare progression currency (gold display)

All currencies persist across sessions and use the same abbreviation system (K/M/B).

### Data Flow Pattern
1. Player interactions trigger volume events in `Tycoon_Manager`
2. Purchase validation checks ownership and currency via `game_manager`
3. Successful purchases update persistent data and trigger UI updates
4. Visual feedback through prop animations and currency displays

## Key Systems

### Ownership Model
- Single tycoon ownership per player enforced by `OwnerOfTycoon` agent tracking
- Plot claiming through volume interaction with "Claim" button
- Auto-reset when owner disconnects, returning tycoon to claimable state

### Purchase Chain System
The `ButtonStruct` array defines sequential unlocking:
- Each button has price, currency rewards, props to unlock, and next buttons to reveal
- Z-axis movement (±500 units) used for show/hide mechanics
- Animation vs teleportation controlled by `PropAnimationInsteadOfTeleport_PossiblyGlitch_` setting

### Income Generation
Droppers use keyframe animation system:
- `StartPoint` to `EndPoint` movement with configurable timing
- Multi-currency generation (cash + gems) per cycle
- Animation state management prevents overlapping cycles

### Save System
Persistent data via `player_data` class:
- `SavedButtonStruct` array tracks purchased items by index
- `BringAllSavedItems()` restores tycoon state on plot claim
- Toggle via `TycoonSaves` boolean in game manager

## Development Guidelines

### Working with Currencies
- Always update all three currencies simultaneously via `UpdateAllCurrencies()`
- Use `GetManager[]` pattern to access singleton game manager instance
- Currency operations are transactional - use proper `<decides><transacts>` annotations

### Animation System
- Keyframe deltas use `DeltaLocation`, `DeltaRotation`, `DeltaScale` properties
- Await `MovementCompleteEvent` to sequence animations properly
- `spawn{}` blocks for concurrent animations, direct calls for sequential

### Configuration Pattern
All gameplay values exposed via `@editable` properties:
- Button prices, rewards, and unlock chains
- Dropper rates, timing, and currency generation
- Global settings like save system and animation preferences

### Asset Integration
3D assets in `/objects/` directory with Materials, StaticMeshes, and Textures subdirectories. UI textures in `/VerseUIImages/` for currency icons.

## Project Structure

```
Content/
├── Tycoon_Manager.verse     # Main tycoon gameplay logic
├── game_manager.verse       # Player data and currency management  
├── UIManager.verse          # Currency display and UI
├── objects/                 # 3D assets (25+ prop categories)
├── VerseUIImages/          # UI textures and icons
└── S5STAR.umap             # Main game level
```

## Configuration Files

- `S5STAR.uefnproject`: Project settings with 16-player matchmaking support
- `CURRENCY_SYSTEM_CHANGES.md`: Documents recent multi-currency enhancement implementation