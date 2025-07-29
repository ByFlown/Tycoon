# UEFN Setup Guide - Basic Tycoon System

## Overview
This guide covers setting up the basic tycoon system with claim plot functionality and simple money granter buttons.

## Step 1: Place the Core Devices

### 1.1 Game Manager Device
1. In UEFN, open your level (`S5STAR.umap`)
2. Go to **Devices** panel → **Creative** → **Verse Devices**
3. Drag **"game_manager"** device into your level
4. Place it somewhere out of player reach (like underground or high up)

### 1.2 Tycoon Manager Device  
1. From **Verse Devices**, drag **"Tycoon_Manager"** device into your level
2. Place it in the center of where you want the tycoon plot to be
3. This will be the main controller for each tycoon instance

## Step 2: Set up Claim Plot System

### 2.1 Create Claim Plot Button
1. **Create a Prop**:
   - Go to **Props** → **Devices** → find a button-like prop
   - Or use any visual prop that looks like a button
   - Place it where players should claim the plot

2. **Add Volume Trigger**:
   - Go to **Devices** → **Creative** → **Volume and Trigger**
   - Drag **Volume** device into level
   - Scale it to surround your claim button prop
   - Make sure players can walk into it

### 2.2 Configure Tycoon Manager - Claim Plot
1. **Select your Tycoon_Manager device**
2. **In the Details panel, find these properties**:
   - **ClaimPlotVolume**: Set this to your volume device
   - **ClaimPlotButton**: Set this to your button prop

## Step 3: Set up Basic Money Button

### 3.1 Create Money Granter Button
1. **Create Button Prop**:
   - Place another prop where you want the money button
   - This should be INSIDE the tycoon area

2. **Create Button Volume**:
   - Add another Volume device around this money button
   - Scale appropriately

### 3.2 Create Crate System (Money Source)
1. **Crate Prop**:
   - Place a crate/chest prop in your tycoon
   - This is what players will hit to get money

2. **Prop Manipulator Device**:
   - Go to **Devices** → **Creative** → **Prop Manipulator**
   - Place it near your crate
   - This detects when players interact with the crate

### 3.3 Configure Tycoon Manager - Basic Settings
**Select your Tycoon_Manager device and set**:

**Claim Plot Section**:
- ✅ **ClaimPlotVolume**: Your claim volume
- ✅ **ClaimPlotButton**: Your claim button prop

**Crate System Section**:
- ✅ **CrateModel**: Your crate prop
- ✅ **CratePropMani**: Your prop manipulator device
- ✅ **CrateAddMoneyAmount**: `100` (or whatever amount you want)
- ✅ **CrateAddGemsAmount**: `1` 
- ✅ **CrateAddRebirthTokensAmount**: `0`

**Button Structure Array**:
1. **Expand ButtonStruct array**
2. **Click + to add new element**
3. **Set the first button**:
   - **ButtonName**: `"FirstButton"`
   - **ButtonProp**: Your money button prop
   - **ButtonVolume**: Your money button volume
   - **ButtonPrice**: `1000` (cost to buy this button)
   - **ButtonGemsReward**: `0`
   - **ButtonRebirthTokensReward**: `0`
   - **ButtonsToUnlock**: Leave empty for now
   - **PropsToUnlock**: Leave empty for now

## Step 4: Basic Testing Setup

### 4.1 Test Sequence
1. **Compile and Launch**:
   - Build your project
   - Launch in UEFN simulation

2. **Test Flow**:
   - Walk into claim plot volume → Should see "Claim" message
   - After claiming, interact with crate → Should get money
   - Walk into money button volume → Should be able to purchase if you have enough cash

### 4.2 Debug Console
- Press **F1** in game to see console output
- Look for Print statements from the Verse code:
  - `"Player?"`
  - `"Agent Good"`
  - Money amount updates

## Step 5: Configure UI System

### 5.1 Verify UI Display
The UI should automatically show:
- **Cash** (white) - top left
- **Gems** (green) - below cash  
- **Rebirth Tokens** (gold) - bottom

If UI doesn't appear, check that `game_manager` device is properly placed.

## Common Issues & Solutions

### Issue: "Claim" button doesn't work
**Solutions**:
- Check that ClaimPlotVolume is properly assigned
- Verify volume encompasses the area where players walk
- Make sure both game_manager and Tycoon_Manager are in the level

### Issue: Money button doesn't respond
**Solutions**:
- Verify ButtonVolume is assigned to the correct volume
- Check ButtonName matches exactly (case-sensitive)
- Ensure player has claimed the plot first

### Issue: Crate doesn't give money
**Solutions**:
- Check CratePropMani is assigned to prop manipulator device
- Verify prop manipulator is positioned correctly near crate
- Make sure CrateModel points to the correct prop

### Issue: UI not showing
**Solutions**:
- Verify game_manager device is placed in level
- Check that player has spawned properly
- Look for errors in console (F1)

## Next Steps

Once basic functionality works:
1. Add more buttons to ButtonStruct array
2. Set up props that unlock when buttons are purchased
3. Configure dropper systems for passive income
4. Test multiplayer functionality

## Quick Checklist

Before testing, verify you have:
- ✅ game_manager device placed
- ✅ Tycoon_Manager device placed  
- ✅ Claim plot button + volume configured
- ✅ Money button + volume configured
- ✅ Crate + prop manipulator configured
- ✅ At least one entry in ButtonStruct array
- ✅ All device references properly assigned

## File Structure Reference

Your project should have:
```
Content/
├── game_manager.verse       # Player data & currency
├── Tycoon_Manager.verse     # Main tycoon logic
├── UIManager.verse          # Currency display
└── S5STAR.umap             # Your level with devices
```