# Interactive Systems Implementation Guide

## Overview
This document outlines the five new interactive systems added to the Tycoon Manager, each with customizable prices and unique gameplay mechanics.

## 1. Multiplier Activation Button

### Purpose
Provides temporary income multipliers that can be purchased and activated by players.

### Configuration Properties
- `MultiplierButtonName`: Unique identifier for the button
- `MultiplierButtonProp`: The 3D prop players interact with
- `MultiplierButtonVolume`: Volume trigger for interaction
- `MultiplierButtonPrice`: Cost to purchase this multiplier system
- `MultiplierValue`: Multiplier strength (e.g., 2.0 = double income)
- `MultiplierDuration`: How long the multiplier lasts in seconds

### How It Works
1. Player purchases the multiplier button system
2. Once owned, interacting with the button activates the multiplier
3. All income sources (droppers, crates) are multiplied for the duration
4. Multipliers stack with dance floor and pet bonuses

### Setup Instructions
1. Add `MultiplierButtonClass` entries to the `MultiplierButtons` array
2. Place the prop and volume in your level
3. Set desired price, multiplier value, and duration
4. The system handles purchase validation and activation automatically

## 2. Dance Floor with Fortnite Dancing

### Purpose
Doubles player income while they remain on the dance floor and are dancing.

### Configuration Properties
- `DanceFloorName`: Unique identifier
- `DanceFloorProp`: The dance floor 3D asset
- `DanceFloorVolume`: Area that triggers dance mode
- `DanceFloorPrice`: Cost to purchase the dance floor
- `DanceEmoteDevice`: Emote device that triggers Fortnite dances

### How It Works
1. Player purchases the dance floor
2. Entering the volume activates 2x income multiplier
3. Automatically triggers Fortnite dancing emotes
4. Bonus deactivates when player leaves the area
5. Stacks with other multipliers (pets, temporary multipliers)

### Setup Instructions
1. Add `DanceFloorClass` entries to the `DanceFloors` array
2. Place dance floor prop and volume trigger
3. Configure an `emote_device` for automatic dancing
4. Set purchase price as desired

## 3. Jump and Run Course

### Purpose
Obstacle course that rewards players with random bonuses upon completion.

### Configuration Properties
- `JumpAndRunName`: Unique identifier
- `StartButtonProp` & `StartButtonVolume`: Course entrance
- `EndButtonProp` & `EndButtonVolume`: Course completion area
- `JumpAndRunPrice`: Cost to build the course

### Rewards System
Players receive one of three random rewards:
1. **1.5x Multiplier** (30 seconds) - Moderate income boost
2. **Weapon Reward** - Placeholder for weapon spawner integration
3. **2x Multiplier** (60 seconds) - Strong income boost for longer duration

### How It Works
1. Player purchases the jump and run course
2. Interacting with start button begins the course
3. Player must navigate to the end button
4. Completion triggers random reward selection
5. System tracks players currently in the course

### Setup Instructions
1. Add `JumpAndRunClass` entries to the `JumpAndRuns` array
2. Design your obstacle course between start and end points
3. Place start and end buttons with volume triggers
4. Set purchase price for the course construction

## 4. Lucky Wheel

### Purpose
Gambling mechanic where players spend currency for random premium rewards.

### Configuration Properties
- `LuckyWheelName`: Unique identifier
- `LuckyWheelProp`: The spinning wheel 3D asset
- `LuckyWheelVolume`: Interaction area
- `LuckyWheelPrice`: Cost to purchase the wheel
- `SpinCost`: Price per spin (separate from purchase cost)

### Reward Types
Each spin gives one of three outcomes:
1. **Rebirth Token** - Rare progression currency
2. **2x Income** (60 seconds) - Temporary multiplier
3. **Random Pet** - Gives a random pet from the available collection

### How It Works
1. Player purchases the lucky wheel system
2. Each interaction costs the spin amount (default: 100 cash)
3. Wheel animates with spinning rotation
4. Random reward is granted based on RNG
5. Visual feedback through prop animation

### Setup Instructions
1. Add `LuckyWheelClass` entries to the `LuckyWheels` array
2. Place wheel prop and interaction volume
3. Set both purchase price and per-spin cost
4. Wheel will automatically animate when spun

## 5. Pet Purchaser System

### Purpose
Allows players to buy pets that provide permanent passive income bonuses.

### Configuration Properties
- `PetShopName`: Unique identifier
- `PetShopProp`: Shop building/interface prop
- `PetShopVolume`: Interaction area
- `PetShopPrice`: Cost to build the pet shop

### Available Pets (Default Configuration)
1. **SpeedDog** - 1,000 cash - 5% income boost
2. **LuckyBird** - 2,500 cash - 10% income boost
3. **GoldCat** - 5,000 cash - 15% income boost
4. **DiamondDragon** - 15,000 cash - 25% income boost

### How It Works
1. Player purchases the pet shop building
2. Interacting with shop shows available pets and prices
3. Each pet provides a permanent passive income multiplier
4. Only one pet can be active at a time
5. Pet bonuses stack with temporary multipliers and dance floor

### Setup Instructions
1. Add `PetShopClass` entries to the `PetShops` array
2. Customize `AvailablePets` array for different pets/prices/bonuses
3. Place shop prop and interaction volume
4. Players can purchase multiple pets but only activate one

## System Integration

### Currency Integration
All systems are fully integrated with the existing three-currency system:
- **Cash**: Primary currency for all purchases and costs
- **Gems**: Can be earned from some random rewards
- **Rebirth Tokens**: Special reward from lucky wheel

### Multiplier Stacking
The system supports stacking multiple bonuses:
```
Final Income = Base Income × Base Multiplier × Dance Multiplier × Pet Multiplier
```

### Persistence
- Pet ownership persists across sessions
- Active pet selection persists
- Purchased interactive systems remain available
- Temporary multipliers reset on session end

### Performance Considerations
- All systems use efficient event subscription patterns
- Animation systems use proper debouncing
- Random number generation is optimized for gameplay
- Volume triggers are optimized for multi-player scenarios

## Developer Notes

### Extending the Systems
- Add new pets by extending the `AvailablePets` array
- Modify reward probabilities in random generation functions
- Create additional multiplier types by extending the base classes
- All systems support multiple instances per tycoon

### Integration with Existing Code
- Uses existing `game_manager` for currency operations
- Follows established animation patterns from the original system
- Maintains compatibility with save/load functionality
- Respects ownership validation from base tycoon system

### Future Enhancements
- Add visual UI menus for pet selection
- Implement weapon spawner integration for jump and run rewards
- Add more dance floor animations and effects
- Create premium wheel variants with better rewards
- Add pet visual representations in the game world