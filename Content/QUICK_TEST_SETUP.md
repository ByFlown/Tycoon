# Quick Test Setup - Minimal Tycoon

Since we're having compilation issues with the complex system, let's test with a minimal setup first.

## Step 1: Test Basic Claim Plot

### What to Check in Console (F1)
When you walk into the claim plot volume, you should see:

1. `"PlayerTriesToBuyButton called with button: Claim"`
2. `"Player found for agent"`  
3. `"Claim Plot Button Clicked!"`
4. `"ClaimPlotFunction called"`
5. `"No current owner - proceeding with claim"`
6. `"GetPlayerTycoonClass called for agent"`
7. Either:
   - `"Found existing player tycoon class in map"` (if working)
   - OR `"Creating new player tycoon class entry"` → `"Successfully created player tycoon class"` (auto-creation)
8. `"Got player tycoon class"`  
9. `"Player not already owner - claiming now"`
10. `"Plot successfully claimed! OwnerOfTycoon set to Agent"`

## Step 2: Expected Behavior

After successful claim:
- **Claim button should disappear** (`ClaimPlotButton.Hide()` is called)
- **OwnerOfTycoon should be set** to your agent
- **UI should appear** showing 0 cash, 0 gems, 0 rebirth tokens

## Step 3: Test Money Generation

Once plot is claimed, try hitting the crate (if you have CratePropMani set up):
- Should see `"Agent Good"`
- Cash should increase by `CrateAddMoneyAmount` 
- UI should update to show new cash amount

## Step 4: Troubleshooting by Debug Message

### If you see "Failed to get manager":
- **game_manager device** is not placed in level or not working
- Try **restarting UEFN** completely

### If you see "Failed to get player tycoon class from GameManager":
- This should be fixed now with auto-creation
- If still happening, there's a deeper Verse effect issue

### If you see "Player is already owner of another tycoon":  
- Player state wasn't reset from previous test
- **Restart the game session**

### If claim button doesn't respond at all:
- **ClaimPlotVolume** not properly assigned
- **Volume doesn't surround** where you're walking
- **Handler1 subscription** not working

## Step 5: Minimal UEFN Setup

For this test, you only need:

**In your level:**
1. **game_manager** device (placed anywhere)
2. **Tycoon_Manager** device (placed in tycoon area)
3. **Claim button prop** (any prop)
4. **Claim volume** (volume_device around button)

**In Tycoon_Manager properties:**
- **ClaimPlotVolume**: Set to your volume
- **ClaimPlotButton**: Set to your claim prop
- Leave everything else as default for now

**Test sequence:**
1. Build/compile project
2. Launch in UEFN
3. Walk into claim volume  
4. Press F1 to see console output
5. Check if claim works

Let me know what debug messages you see and we can fix any remaining issues step by step!