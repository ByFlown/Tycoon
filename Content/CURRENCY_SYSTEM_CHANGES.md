# Currency System Enhancement Summary

## Overview
Enhanced the existing tycoon currency system by adding two new currencies alongside the existing cash system:
- **Gems**: Special premium currency with green display color
- **Rebirth Tokens**: Rare currency for progression with gold display color

## Changes Made

### 1. Core Data Structure (`game_manager.verse`)
- Added `Gems : int = 0` and `RebirthTokens : int = 0` to `player_data` class
- Updated `player_data_update` constructor to persist new currencies
- Added getter functions: `GetCurrentGems()` and `GetCurrentRebirthTokens()`
- Added management functions: `AddToGems()`, `RemoveFromGems()`, `AddToRebirthTokens()`, `RemoveFromRebirthTokens()`
- Added `RebirthPlayer()` function that resets progress and awards rebirth token

### 2. UI System (`UIManager.verse`)
- Added texture variables for gems and rebirth tokens displays
- Added text blocks with distinct colors (green for gems, gold for rebirth tokens)
- Created `UpdateGems()`, `UpdateRebirthTokens()`, and `UpdateAllCurrencies()` functions
- Updated UI layout in `AddAllCurrencyUI()` to display all three currencies vertically

### 3. Gameplay Integration (`Tycoon_Manager.verse`)
- Added `DropperGemsIncrease` property to `DropperPropClass` for gem generation
- Added `ButtonGemsReward` and `ButtonRebirthTokensReward` to `AllButtons` class
- Added `CrateAddGemsAmount` and `CrateAddRebirthTokensAmount` for crate interactions
- Updated all currency display calls to show all three currencies simultaneously

## How It Works

### Earning Currencies
1. **Cash**: Existing system (droppers, crates, etc.)
2. **Gems**: 
   - Earned from crates (default: 1 gem per interaction)
   - Can be earned from droppers (configurable per dropper)
   - Awarded from button purchases (configurable per button)
3. **Rebirth Tokens**:
   - Earned through rebirth system (resets progress, awards 1 token)
   - Can be awarded from special button purchases
   - Can be earned from crate interactions (configurable)

### UI Display
- All three currencies display vertically on the left side of screen
- Cash: White text with money icon
- Gems: Green text with money icon (placeholder)
- Rebirth Tokens: Gold text with money icon (placeholder)
- All currencies use the same number abbreviation system (K, M, B)

### Persistence
All currencies are saved with player data and persist across sessions when TycoonSaves is enabled.

## Configuration Options
Game designers can configure:
- Gem rewards per button purchase
- Rebirth token rewards per button purchase  
- Gem generation per dropper
- Gem/rebirth token rewards from crate interactions
- All existing cash-related settings remain unchanged

## Future Enhancements
- Create dedicated texture assets for gems and rebirth tokens
- Add gem/rebirth token spending mechanics
- Implement rebirth multipliers/bonuses
- Add special gem/rebirth token shops