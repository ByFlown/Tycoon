using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags } 

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

player_data := class< final>< persistable>{
    Cash : int = 0
    Gems : int = 0
    RebirthTokens : int = 0

    SavedButtonStruct : []int = array{}
    
    # New systems data
    MoneyMultiplier : float = 1.0
    MultiplierEndTime : float = 0.0
    PermanentMultiplier : float = 1.0
    DanceFloorActive : logic = false
    OwnedPets : []string = array{}
    ActivePet : string = ""
}

player_data_update< constructor>(OldStat:player_data)< transacts> := player_data {
    Cash := OldStat.Cash
    Gems := OldStat.Gems
    RebirthTokens := OldStat.RebirthTokens
    SavedButtonStruct := OldStat.SavedButtonStruct
    MoneyMultiplier := OldStat.MoneyMultiplier
    MultiplierEndTime := OldStat.MultiplierEndTime
    PermanentMultiplier := OldStat.PermanentMultiplier
    DanceFloorActive := OldStat.DanceFloorActive
    OwnedPets := OldStat.OwnedPets
    ActivePet := OldStat.ActivePet
}


var Data:weak_map(player, player_data) = map{}

game_manager_tag := class(tag){}

# A Verse-authored creative device that can be placed in a level
game_manager := class(creative_device):

    var PlayerMap : [agent]Player_Tycoon_Class = map{}

    @editable TycoonSaves : logic = true

    @editable PropAnimationInsteadOfTeleport_PossiblyGlitch_ : logic = false

    # Runs when the device is started in a running game
    OnBegin< override>()< suspends>:void=
        # TODO: Replace this with your code
        for (Player : GetPlayspace().GetPlayers()) {
            OnPlayerSpawned(Player)
        }

        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerSpawned)

        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

    OnPlayerSpawned(Player : player) : void = {
        if (not Data[Player]) {
            if (set Data[Player] = player_data{}) {}
        }

        if (Agent := agent[Player]) {
            if (ExistingPTC := PlayerMap[Agent]) {
                Print("OnPlayerSpawned: Agent found, PlayerMap already has entry")
            } else {
                Print("OnPlayerSpawned: Agent found, no PlayerMap entry - creating new PTC")
                PTC : Player_Tycoon_Class = Player_Tycoon_Class{AgentOB := Agent}

                PTC.MainPlayerUIClass.Init(Player)

                if (set PlayerMap[Agent] = PTC) {
                    Print("OnPlayerSpawned: Successfully stored PTC in PlayerMap - size now: " + ToString(PlayerMap.Length))
                } else {
                    Print("OnPlayerSpawned: Failed to store PTC in PlayerMap")
                }
            }
        }

        if (TycoonSaves = false) {
            if (PlayerData := Data[Player]) {

                if:
                    OldData := Data[Player]

                    set Data[Player] = player_data {
                        player_data_update< constructor>(OldData)
                        SavedButtonStruct := array{}
                    }
                then:
                    Print("Player data has been reset")
                    
                if:
                    OldData := Data[Player]
    
                    set Data[Player] = player_data{
                        player_data_update< constructor>(OldData)
                        Cash := 0
                        Gems := 0
                        RebirthTokens := 0
                    }
                then:
            }     
        }
    }

    GetManager()< decides>< transacts>:game_manager = {
        # Simple fallback since GetCreativeObjectsWithTag is deprecated
        # In practice, this should be called on the actual game_manager instance
        Self
    }

    GetCurrentCash< public>(Player : player)<decides><transacts> : int = {
        return Data[Player].Cash
    }

    GetCurrentGems< public>(Player : player)<decides><transacts> : int = {
        return Data[Player].Gems
    }

    GetCurrentRebirthTokens< public>(Player : player)<decides><transacts> : int = {
        return Data[Player].RebirthTokens
    }

    GetPlayerTycoonClass< public>(Agent : agent) : Player_Tycoon_Class = {
        Print("GetPlayerTycoonClass called for agent - PlayerMap size: " + ToString(PlayerMap.Length))
        
        # Return existing instance if it exists
        if (ExistingPTC := PlayerMap[Agent]) {
            Print("Returning existing player tycoon class")
            return ExistingPTC
        }
        
        # Create new instance only if none exists
        Print("Creating new player tycoon class entry - Agent not found in PlayerMap")
        NewPTC : Player_Tycoon_Class = Player_Tycoon_Class{AgentOB := Agent}
        if (Player := player[Agent]) {
            NewPTC.MainPlayerUIClass.Init(Player)
        }
        
        # Store in PlayerMap for future use
        if (set PlayerMap[Agent] = NewPTC) {
            Print("Successfully stored new PTC in PlayerMap")
        } else {
            Print("Failed to store PTC in PlayerMap")
        }
        
        Print("Successfully created player tycoon class - new PlayerMap size: " + ToString(PlayerMap.Length))
        NewPTC
    }

    AddToCash< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Cash := OldData.Cash + Amount 
                }
            then:
        }   
    }

    RemoveFromCash< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Cash := OldData.Cash - Amount 
                }
            then:
        }
    }

    AddToGems< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Gems := OldData.Gems + Amount 
                }
            then:
        }   
    }

    RemoveFromGems< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Gems := OldData.Gems - Amount 
                }
            then:
        }
    }

    AddToRebirthTokens< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    RebirthTokens := OldData.RebirthTokens + Amount 
                }
            then:
        }   
    }

    RemoveFromRebirthTokens< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    RebirthTokens := OldData.RebirthTokens - Amount 
                }
            then:
        }
    }

    AddToTycoonArray< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    SavedButtonStruct := OldData.SavedButtonStruct + array{Amount} 
                }
            then:
                Print("Key should be saved to player value {Amount}")
                for (Key : OldData.SavedButtonStruct) {
                    Print("Key: {Key}")
                }
        }   
    }

    GetCurrentTycoonArray< public>(Player : player)< decides>< transacts> : []int = {
        return Data[Player].SavedButtonStruct
    }

    RebirthPlayer< public>(Player : player) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Cash := 0
                    Gems := 0
                    RebirthTokens := OldData.RebirthTokens + 1
                    SavedButtonStruct := array{}
                }
            then:
                Print("Player has been reborn and received 1 rebirth token!")
        }   
    }


    # Multiplier System Functions
    GetCurrentMultiplier< public>(Player : player) : float = {
        if (PlayerData := Data[Player]) {
            CurrentTime := GetSimulationElapsedTime()
            var TotalMultiplier : float = PlayerData.PermanentMultiplier
            
            # Add temporary multiplier if active
            if (PlayerData.MultiplierEndTime > CurrentTime) {
                set TotalMultiplier = TotalMultiplier * PlayerData.MoneyMultiplier
            }
            
            return TotalMultiplier
        }
        return 1.0
    }

    SetMoneyMultiplier< public>(Player : player, Multiplier : float, DurationSeconds : float) : void = {
        if (PlayerData := Data[Player]) {
            CurrentTime := GetSimulationElapsedTime()
            if:
                OldData := Data[Player]
                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    MoneyMultiplier := Multiplier
                    MultiplierEndTime := CurrentTime + DurationSeconds
                }
            then:
                Print("Temporary money multiplier set to {Multiplier}x for {DurationSeconds} seconds")
        }
    }

    SetPermanentMultiplier< public>(Player : player, Multiplier : float) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]
                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    PermanentMultiplier := PlayerData.PermanentMultiplier * Multiplier
                }
            then:
                Print("Permanent multiplier increased by {Multiplier}x. Total permanent multiplier: {PlayerData.PermanentMultiplier * Multiplier}x")
        }
    }

    GetPermanentMultiplier< public>(Player : player) : float = {
        if (PlayerData := Data[Player]) {
            return PlayerData.PermanentMultiplier
        }
        return 1.0
    }

    # Dance Floor System Functions
    SetDanceFloorActive< public>(Player : player, Active : logic) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]
                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    DanceFloorActive := Active
                }
            then:
        }
    }

    GetDanceFloorActive< public>(Player : player) : logic = {
        if (PlayerData := Data[Player]) {
            return PlayerData.DanceFloorActive
        }
        return false
    }

    # Pet System Functions
    AddPet< public>(Player : player, PetName : string) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]
                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    OwnedPets := OldData.OwnedPets + array{PetName}
                }
            then:
                Print("Pet {PetName} added to player collection")
        }
    }

    SetActivePet< public>(Player : player, PetName : string) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]
                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    ActivePet := PetName
                }
            then:
                Print("Active pet set to {PetName}")
        }
    }

    GetActivePet< public>(Player : player) : string = {
        if (PlayerData := Data[Player]) {
            return PlayerData.ActivePet
        }
        return ""
    }

    GetOwnedPets< public>(Player : player) : []string = {
        if (PlayerData := Data[Player]) {
            return PlayerData.OwnedPets
        }
        return array{}
    }

    GetPetBoostMultiplier< public>(Player : player) : float = {
        ActivePet := GetActivePet(Player)
        if (ActivePet = "SpeedDog") { return 1.05 }
        if (ActivePet = "LuckyBird") { return 1.10 }
        if (ActivePet = "GoldCat") { return 1.15 }
        if (ActivePet = "DiamondDragon") { return 1.25 }
        return 1.0
    }

    # Enhanced AddToCash with multipliers
    AddToCashWithMultipliers< public>(Player : player, Amount : int) : void = {
        CurrentMultiplier := GetCurrentMultiplier(Player)
        PetMultiplier := GetPetBoostMultiplier(Player)
        
        if (FinalAmount := Floor[Amount * CurrentMultiplier * PetMultiplier]) {
            AddToCash(Player, FinalAmount)
            Print("AddToCashWithMultipliers: Base {Amount} * Multiplier {CurrentMultiplier} * Pet {PetMultiplier} = {FinalAmount}")
        }
    }

    # Pet spawning callback for tycoon managers
    NotifyPetSpawningRequired< public>(Player : player) : void = {
        # This will be called by tycoon managers to spawn pets when players join their tycoon
        ActivePetName := GetActivePet(Player)
        if (ActivePetName <> "") {
            Print("Player should spawn pet: {ActivePetName}")
            # The actual spawning will be handled by the tycoon manager
        }
    }

    OnPlayerRemoved(PlayerLeft : player):void =
        Print("OnPlayerRemoved called - PlayerMap size before: " + ToString(PlayerMap.Length))
        if (Agent := agent[PlayerLeft]):
            Print("OnPlayerRemoved: Agent found for leaving player")
            if (ActualPlayer := PlayerMap[Agent]):
                Print("OnPlayerRemoved: Found player in PlayerMap - removing")
                var TempAllPlayerMap : [agent]Player_Tycoon_Class = map{}
                for (Key -> Value : PlayerMap, Key <> Agent):
                    set TempAllPlayerMap = ConcatenateMaps(TempAllPlayerMap, map{Key => Value})

                set PlayerMap = TempAllPlayerMap
                Print("OnPlayerRemoved: PlayerMap rebuilt - size now: " + ToString(PlayerMap.Length))
            else:
                Print("OnPlayerRemoved: Player not found in PlayerMap")
        else:
            Print("OnPlayerRemoved: Could not get agent for leaving player")