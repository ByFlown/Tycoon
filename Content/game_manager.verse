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
}

player_data_update< constructor>(OldStat:player_data)< transacts> := player_data {
    Cash := OldStat.Cash
    Gems := OldStat.Gems
    RebirthTokens := OldStat.RebirthTokens
    SavedButtonStruct := OldStat.SavedButtonStruct
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

        if (Agent := agent[Player], not PlayerMap[Agent]) {
            PTC : Player_Tycoon_Class = Player_Tycoon_Class{AgentOB := Agent}

            PTC.MainPlayerUIClass.Init(Player)

            option:
                set PlayerMap[Agent] = PTC
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
        OBJ := GetCreativeObjectsWithTag(game_manager_tag{})[0]
        game_manager[OBJ]
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

    GetPlayerTycoonClass< public>(Agent : agent)<decides><transacts> : Player_Tycoon_Class = {
        return GetManager[].PlayerMap[Agent]
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


<<<<<<< HEAD
    OnPlayerRemoved(PlayerLeft : agent):void =
=======
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
>>>>>>> 1166221 (Petshop prototyp)
        if (Agent := agent[PlayerLeft]):
            if (ActualPlayer := PlayerMap[Agent]):
                var TempAllPlayerMap : [agent]Player_Tycoon_Class = map{}
                for (Key -> Value : PlayerMap, Key <> Agent):
                    set TempAllPlayerMap = ConcatenateMaps(TempAllPlayerMap, map{Key => Value})

                set PlayerMap = TempAllPlayerMap